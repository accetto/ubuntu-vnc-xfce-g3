# Local building example

- [Local building example](#local-building-example)
  - [Preparation](#preparation)
  - [Building pipeline](#building-pipeline)
    - [Step 1: `pre_build`](#step-1-pre_build)
    - [Step 2: `build`](#step-2-build)
    - [Step 3: `push`](#step-3-push)
    - [Step 4: `post_push`](#step-4-post_push)
    - [Step 5: `util-readme.sh`](#step-5-util-readmesh)
    - [Steps 1-4 at once](#steps-1-4-at-once)

Docker Hub has removed auto-building from free plans since 2021-07-26.

This page describes how to execute the same building pipeline locally.

The information is extracted from the more detail description in [Wiki][this-wiki].

If you just want to build the images locally without publishing them on Docker Hub, then you can use the `one-liners` described at the beginning of the README files (`TL;DR`).

## Preparation

Open a terminal windows and change the current directory to the root of the project (where the license file is).

Then copy the secrets example file, modify the copy and source it:

```bash
### make a copy and then modify it
cp docker/src/examples/example-secrets.rc secrets.rc

### source the secrets
source ./secrets.rc
```

## Building pipeline

The full building pipeline consists of the following four hook scripts and one utility script:

- `pre_build`
- `build`
- `push`
- `post_push`
- `util-readme.sh`

The order of executing the scripts is important.

The commands in the following example would build and publish the image `accetto/ubuntu-vnc-xfce-g3:latest`.

The helper utility `builder.sh` will be used. Alternatively you can also use the hook scripts directly.

### Step 1: `pre_build`

```bash
./builder.sh latest pre_build

### optionally
./builder.sh latest pre_build --no-cache

### alternatively
./docker/hooks/pre_build dev latest
```

This step builds the temporary helper image and creates the following temporary helper files that are used by other scripts:

- `scrap-version_sticker_current.tmp`
- `scrap-version_sticker-verbose_current.tmp`
- `scrap-version_sticker-verbose_previous.tmp`
- `scrap-demand-stop-building`

The file `scrap-demand-stop-building` is created only if the verbose version sticker hasn't changed since the last time it has been published on the GitHub Gist and if the environment variable `FORCE_BUILDING` is not set to `1`. **Its presence will block** the next hook script `build` from building a new local image. If you want to force the image building, you can delete this file manually.

The other option is to set the environment variable `FORCE_BUILDING=1` **before** executing the `pre_build` script.

**Remark**: The temporary helper image is automatically removed by the script.

### Step 2: `build`

```bash
./builder.sh latest build

### optionally
./builder.sh latest build --no-cache

### alternatively
./docker/hooks/build dev latest
```

This step builds a new local image, named by default with the prefix `dev-` (e.g. `dev-ubuntu-vnc-xfce-g3`).

**Remark**: Ensure that the file `scrap-demand-stop-building` is not presents or the environment variable is set `FORCE_BUILDING=1`.

### Step 3: `push`

```bash
./builder.sh latest push

### alternatively
./docker/hooks/push dev latest
```

This step creates the final image and uploads it to Docker Hub.

The final image is actually only a new image tag without the prefix `dev-`.

**Remark**: Note that in the case of building the `latest` image actually two new tags are created (e.g. `latest` and `vnc-novnc`).

### Step 4: `post_push`

```bash
./builder.sh latest post_push

### alternatively
./docker/hooks/post_push dev latest
```

This step updates the GitHub Gists and removes the temporary helper files created by the hook script `pre_build`.

**Remark**: If this script would be executed on Docker Hub, then it would also publish the readme file. However, it doesn't work correctly by local building. Therefore it's recommended to set the environment variable `PROHIBIT_README_PUBLISHING=1`. You can do it also in the secrets file.

### Step 5: `util-readme.sh`

You have to have `curl` installed for this step.

Open an another terminal window and change into the project's sub-directory `utils`.

Copy the example secrets file, modify the copy and source it:

```bash
### copy the file and then modify it
cp example-secrets-utils.rc secrets-utils.rc

### source the secrets
source ./secrets-utils.rc
```

If you are not sure about the actual length of the `README` file for Docker Hub (max. 25000 characters), then preview it first. This step is optional.

```bash
./util-readme.sh --repo accetto/ubuntu-vnc-xfce-g3 --context=../docker/xfce -- preview
```

Then publish the `README` file to Docker Hub:

```bash
./util-readme.sh --repo accetto/ubuntu-vnc-xfce-g3 --context=../docker/xfce -- publish
```

### Steps 1-4 at once

Alternatively you can execute the whole building pipeline using the `all` command:

```bash
./builder.sh latest-nodejs all

### optionally
./builder.sh latest-nodejs all --no-cache
```

Note that you still have to execute the step 5 yourself.

***

[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki
