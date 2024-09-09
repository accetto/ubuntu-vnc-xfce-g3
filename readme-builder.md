# Utility `builder.sh`

- [Utility `builder.sh`](#utility-buildersh)
  - [Introduction](#introduction)
  - [Preparation](#preparation)
    - [Ensure file attributes after cloning](#ensure-file-attributes-after-cloning)
    - [Set environment variables before building](#set-environment-variables-before-building)
    - [Ensure `wget` utility](#ensure-wget-utility)
  - [Executing complete pipeline](#executing-complete-pipeline)
  - [Executing individual pipeline steps](#executing-individual-pipeline-steps)
    - [What about the 'cache' helper script](#what-about-the-cache-helper-script)
  - [Additional building parameters](#additional-building-parameters)

## Introduction

This utility script can build and publish individual images.
It can also execute the individual hook scripts of the building pipeline (`docker/hooks` folder).

Common usage pattern:

```shell
./builder.sh <blend> <cmd> [build-options]
```

The supported option values can be taken from the embedded help:

```shell
This script can:
- build and publish the individual images
- execute the individual hook scripts of the building pipeline '/docker/hooks/'
- refresh the local builder 'g3-cache'

Usage: ./builder.sh <blend> <command> [<docker-cli-options>]

blend   := (latest|noble|jammy|focal)[-chromium|-firefox]
command := (all|all-no-push)|(pre_build|build|push|post_push|cache)

The <docker-cli-options> (e.g. '--no-cache') are passed to the Docker CLI commands used internally.

The script creates a complete execution log.
```

The `<docker-cli-options>` are passed to the Docker CLI commands used internally depending on the usage mode (see below).

## Preparation

### Ensure file attributes after cloning

It may be necessary to repair the executable files attributes after cloning the repository (by `git clone`).

You can do that by executing the following commands from the project's root directory:

```shell
find . -type f -name "*.sh" -exec chmod +x '{}' \;
chmod +x docker/hooks/*
```

For example, if the files in the folder `docker/hooks` would not be executable, then you would get errors similar to this:

```shell
$ ./builder.sh latest build

==> EXECUTING @2023-03-05_16-42-57: ./builder.sh 

./builder.sh: line 84: ./docker/hooks/build: Permission denied
```

### Set environment variables before building

Open a terminal windows and change the current directory to the root of the project (where the license file is).

Make a copy of the secrets example file, modify it and then source it in the terminal:

```shell
### make a copy and then modify it
cp examples/example-secrets.rc secrets.rc

### source the secrets
source ./secrets.rc

### or also

. ./secrets.rc
```

**TIP**: If you copy a file named `secrets.rc` into the folder `docker/hooks/`, then it will be automatically sourced by the hook script `env.rc`.

Be aware that the following environment variables are mandatory and must be always set:

- `REPO_OWNER_NAME`
- `BUILDER_REPO`

Ensure that your `secrets.rc` file contains at least the lines similar to these:

```shell
export REPO_OWNER_NAME="accetto"
export BUILDER_REPO="headless-ubuntu-g3"
```

You can use your own names if you wish.

Alternatively you can modify the hook script file env.rc like this:

```shell
### original lines
declare _owner="${REPO_OWNER_NAME:?Need repo owner name}"
DOCKER_REPO="${_owner}/${BUILDER_REPO:?Need builder repo name}"

### modified lines
declare _owner="${REPO_OWNER_NAME:-accetto}"
DOCKER_REPO="${_owner}/${BUILDER_REPO:-headless-ubuntu-g3}"
```

Again, you can use your own names if you wish.

You can also use other ways to set the variables.

### Ensure `wget` utility

If you are on Windows, you can encounter the problem of missing `wget` utility.
It is used by refreshing the `g3-cache` and it's available on Linux by default.

On Windows you have generally two choices.
You can build your images inside the `WSL` environment or you can download the `wget.exe` application for Windows.
Make sure to update also the `PATH` environment variable appropriately.

## Executing complete pipeline

Building the individual images and publishing them to the **Docker Hub**:

```shell
### PWD = project's root directory

### ubuntu-vnc-xfce-g3
./builder.sh latest all

### ubuntu-vnc-xfce-chromium-g3
./builder.sh latest-chromium all

### ubuntu-vnc-xfce-firefox-g3
./builder.sh latest-firefox all
```

You can skip the publishing to the **Docker Hub** by replacing the command `all` by the command `all-no-push`:

```shell
./builder.sh latest all-no-push
```

You can also provide additional parameters for the internally used Docker `build` command.
For example:

```shell
./builder.sh latest all-no-push --no-cache

### it results in
### docker build --no-cache ...
```

The optional `<docker-cli-options>` are passed only to the `pre_build` hook script, which passes them to the internally used `docker build` command.
The `cache` hook script, however, doesn't use any Docker CLI commands.

## Executing individual pipeline steps

The building pipeline consists of the following steps, that can be executed also individually:

```shell
### this step builds the helper image and compare its verbose version sticker
### to the one from the builder repository gist
### it also refreshes the 'g3-cache' by executing the 'cache' hook script
./builder.sh latest pre_build

### this step builds a new image depending on the comparison result from the previous step
### if you want to force the building in any case, then delete the file 'scrap-demand-stop-building'
### or set the environment variable 'FORCE_BUILDING=1'
./builder.sh latest build

### this step publishes the image to the deployment repository on the Docker Hub
### there are actually more configurations possible, check the Wiki for the description
./builder.sh latest push

### this step updates the gists that store off-line data like badge endpoints
### or version stickers
### note that it will not publish the README file to the Docker Hub
./builder.sh latest post_push
```

The optional `<docker-cli-options>` are passed to the each individual hook script, which can pass them to the internally used Docker CLI command.
The `cache` hook script, however, doesn't use any Docker CLI commands.

### What about the 'cache' helper script

The `cache` hook script has been introduced in the **second version** (G3v2) of the building pipeline.
It refreshes the local `g3-cache`, which must be always placed inside the Docker build context.
The script is also used by the `pre_build` and `build` hook scripts.

The `g3-cache` and the rules for its refreshing are described separately.

The script can be also used as a quick check, if there are newer versions of the following packages that are downloaded from external sources:

- `TigerVNC`
- `noVNC`
- `websockify`
- `Chromium Browser`

The script will refresh only the packages that are required for the current build:

```shell
### this will refresh only 'TigerVNC', 'noVNC' and 'websockify'
./builder.sh latest cache
./builder.sh latest-firefox cache

### this will refresh also 'Chromium Browser'
./builder.sh latest-chromium cache
```

## Additional building parameters

The script `builder.sh` passes the additional parameters, that come after the mandatory ones, to the hook scripts in the folder `docker/hooks`.

For example:

```shell
./builder.sh latest build --target stage_xfce --no-cache
```

The additional parameters `--target stage_xfce --no-cache` will be passed to the script `docker/hooks/build`.

See the file [readme-local-building-example][this-readme-local-building-example] for more information about handling of the additional building parameters.

***

[this-readme-local-building-example]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/readme-local-building-example.md
