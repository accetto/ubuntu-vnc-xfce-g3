# Local building example

- [Local building example](#local-building-example)
  - [Introduction](#introduction)
  - [Preparation](#preparation)
    - [Ensure file attributes after cloning](#ensure-file-attributes-after-cloning)
    - [Set environment variables before building](#set-environment-variables-before-building)
  - [Building pipeline](#building-pipeline)
  - [Three ways of building images](#three-ways-of-building-images)
    - [Building and publishing sets of images](#building-and-publishing-sets-of-images)
    - [Building and publishing individual images](#building-and-publishing-individual-images)
    - [Step-by-step building and publishing](#step-by-step-building-and-publishing)
      - [Step 1: `pre_build`](#step-1-pre_build)
      - [Step 2: `build`](#step-2-build)
      - [Step 3: `push`](#step-3-push)
      - [Step 4: `post_push`](#step-4-post_push)
  - [Additional parameters](#additional-parameters)
    - [Special handling of `--target` parameter](#special-handling-of---target-parameter)
  - [Disabling default features](#disabling-default-features)
    - [Disabling `noVNC`](#disabling-novnc)
    - [Disabling `Firefox Plus`](#disabling-firefox-plus)
  - [README files for Docker Hub](#readme-files-for-docker-hub)

## Introduction

The **Docker Hub** has removed the **auto-building feature** from the free plan since 2021-07-26.

This page describes how to build the images locally and optionally also push them to the **Docker Hub**.

The **second version** (G3v2) of the building pipeline makes it really easy, even if you want to build a set of images or all of them at once.

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

## Building pipeline

The actual building pipeline consists of the following hook scripts stored in the folder `docker/hooks`:

- `pre_build`
- `build`
- `push`
- `post_push`

The hook scripts are executed exactly in that order.

The **second version** (G3v2) of the pipeline has added also the helper script `cache`, which ist stored in the same folder. It is used by the hook scripts `pre_build` and `build` and it refreshes the local `g3-cache`. It can be also executed  stand-alone.

Utilizing the local `g3-cache` brings a significant boost in the building performance and much shorter building times.

There is also the helper script `util-readme.sh`, stored in the folder `utils/`. This script can be used for preparing the `README` file for the **Docker Hub**.

## Three ways of building images

Since the **second version** (G3v2) of the building pipeline there are the following ways of building the images:

- Building sets of images by executing the helper script `ci-builder.sh`
- Building the individual images by executing the helper script `builder.sh`
- Building the individual images by executing the hook scripts step-by-step

**Remark**: You can force the building of a new persistent image in any case by setting the environment variable `FORCE_BUILDING=1`.

### Building and publishing sets of images

Building and publishing of sets of images is pretty easy. Let's say that we want to refresh the images that feature the Firefox browser. We can do that by executing the following command:

```shell
### PWD = project's root directory
./ci-builder.sh all group latest-firefox

### or also
./ci-builder.sh all group complete-firefox

### or skipping the publishing to the Docker Hub
./ci-builder.sh all-no-push family latest-firefox
```

The script `ci-builder.sh` is using the utility script `builder.sh` internally.

You can find more information and examples in the separate `readme` file, describing the utility `ci-builder.sh`.

**Remark**: The set can contain also a single image.

### Building and publishing individual images

Building and publishing of individual images is also very easy. Let's say we wan to refresh the image `accetto/ubuntu-vnc-xfce-g3:latest`. We could execute the following command:

```shell
### PWD = project's root directory
./builder.sh latest all

### alternatively with additional Docker CLI options
./builder.sh latest all --no-cache

### or skipping the publishing to the Docker Hub
./builder.sh latest all-no-push
```

The script `builder.sh` is using the individual hook scripts internally.

You can find more information and examples in the separate `readme` file, describing the utility `builder.sh`.

### Step-by-step building and publishing

The building pipeline can executed also step-by-step. The hook scripts in the folder `docker/hooks/` can be executed directly or also by using the utility script `builder.sh`.

The script `builder.sh` is using the individual hook scripts internally.

#### Step 1: `pre_build`

```shell
### PWD = project's root directory

./builder.sh latest pre_build
### or
./docker/hooks/pre_build dev latest

### alternatively with additional Docker CLI options
./builder.sh latest pre_build --no-cache
### or
./docker/hooks/pre_build dev latest --no-cache
```

This step builds the temporary helper image and creates the following temporary helper files that are used by other scripts:

- `scrap-version_sticker_current.tmp`
- `scrap-version_sticker-verbose_current.tmp`
- `scrap-version_sticker-verbose_previous.tmp`
- `scrap-demand-stop-building`

The file `scrap-demand-stop-building` is created only if the verbose version sticker hasn't changed since the last time it has been published on the builder repository's **GitHub Gist** and if the environment variable `FORCE_BUILDING` is not set to `1`. **Its presence will block** the next hook script `build` from building a new persistent image. If you want to force the image building, you can delete this file manually.

The other option is to set the environment variable `FORCE_BUILDING=1` **before** executing the `pre_build` script.

**Remark**: The temporary helper image is automatically removed by the script.

#### Step 2: `build`

```shell
### PWD = project's root directory

./builder.sh latest build
### or
./docker/hooks/build dev latest

### alternatively with additional Docker CLI options
./builder.sh latest build --no-cache
### or
./docker/hooks/build dev latest --no-cache
```

This step builds a new persistent image, named by default according the variable `BUILDER_REPO` (e.g. `headless-ubuntu-g3`).

**Remark**: Ensure that the file `scrap-demand-stop-building` is not present or the environment variable is set `FORCE_BUILDING=1`.

#### Step 3: `push`

```shell
### PWD = project's root directory

./builder.sh latest push
### or
./docker/hooks/push dev latest
```

This step creates the deployment image tag and pushes it to the deployment repository on the **Docker Hub**.

#### Step 4: `post_push`

```shell
### PWD = project's root directory

./builder.sh latest post_push
### or
./docker/hooks/post_push dev latest
```

This step updates the **GitHub Gists** belonging to the **builder repository** and the **deployment repository** and removes the temporary helper files created by the hook script `pre_build`.

## Additional parameters

Additional parameters, that come after the mandatory ones, can be passed to the hook scripts in the folder `docker/hooks`.

The individual hook scripts can use the additional parameters or ignore them.

Currently only the `build` and `pre_build` scripts actually process the additional parameters.

Both scripts insert the additional parameters just after the `docker build` part of the Docker build command line.

For example, if the additional parameters `--target stage_xfce --no-cache` are provided to the script `docker/hooks/build`, then the result Docker command line will begin like this:

```shell
docker build --target stage_xfce --no-cache -f ./docker/Dockerfile.xfce.22-04 ...
```

However, there is a special handling of the parameter `--target`.

### Special handling of `--target` parameter

The Docker `build` parameter `--target` allows processing multi-stage Dockerfiles only to a particular stage.

Therefore this parameter makes sense only by the hook script `docker/hooks/build`.

For example, this would build an image including only the stages `stage_essentials`, `stage_xserver` and `stage_xfce`:

```shell
docker build --target stage_xfce --no-cache -f ./docker/Dockerfile.xfce.22-04 ...
```

The result image tag will get the suffix `_stage_xfce`, e.g. `accetto/headless-ubuntu-g3:latest_stage_xfce`.

This is generally useful only during development and debugging.

On the other hand, the hook script `docker/hooks/pre_build` ignores and  removes the parameter `--target` with its value.

Therefore `pre_build` always process all Dockerfile stages.

For example, if the additional parameters `--target stage_xfce --no-cache` are provided to the script `docker/hooks/pre_build`, then the result Docker command line will begin like this:

```shell
docker build --no-cache -f ./docker/Dockerfile.xfce.22-04 ...
```

Note that both hook scripts always remove an orphaned `--target` parameter which comes with no value.

## Disabling default features

Some features, that are enabled by default, can be disabled via environment variables.

It allows to build even smaller images by excluding `noVNC` or `Firefox Plus features`.

### Disabling `noVNC`

If the environment variable `FEATURES_NOVNC` is explicitly set to zero (by `export FEATURES_NOVNC="0"`), then

- image will not include `noVNC`
- image tag will get the `-vnc` suffix (e.g. `latest-vnc`, `20.04-firefox-vnc` etc.)

### Disabling `Firefox Plus`

If the environment variable `FEATURES_FIREFOX_PLUS` is explicitly set to zero (by `export FEATURES_FIREFOX_PLUS="0"`) and the variable `FEATURES_FIREFOX="1"`, then

- image with Firefox will not include the *Firefox Plus features*
- image tag will get the `-default` suffix (e.g. `latest-firefox-default` or also `latest-firefox-default-vnc` etc.)

## README files for Docker Hub

Each **deployment repository** has its own `README` file for the **Docker Hub**.

The source `README` file for the **Docker Hub** is split into two parts.

The first part is called `README-dockerhub.md` and it is the actual content of the `README` file for the `Docker Hub`.

The second part is called `readme-append.template` and it contains the templates for the badge links.

The final `README` file for the **Docker Hub** can be produced by the utility script `util-readme.sh`, which is stored in the `utils/` folder.

The result file will be named `scrap-readme.md` and its content can be copy-and-pasted manually to the **README area** of the repository on the **Docker Hub**.

The utility will also check the length of the result file, because it is limited to max. 25000 characters by the **Docker Hub**.

Therefore there is always also the full-length `README` file version, which is published only on the **GitHub**.

For example, the `README` file for the repository `accetto/ubuntu-vnc-xfce-g3` can be generated by the following command:

```shell
### PWD = utils/
./util-readme.sh --repo accetto/ubuntu-vnc-xfce-g3 --context=../docker/xfce --gist <deployment-gist-ID> -- preview

### or if the environment variable 'DEPLOY_GIST_ID' has been set
./util-readme.sh --repo accetto/ubuntu-vnc-xfce-g3 --context=../docker/xfce -- preview
```
