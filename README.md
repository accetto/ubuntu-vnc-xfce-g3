# Headless Ubuntu/Xfce containers with VNC/noVNC

## Project `accetto/ubuntu-vnc-xfce-g3`

Version: G3v4

***

[Docker Hub][this-docker] - [Changelog][this-changelog] - [Wiki][this-wiki] - [Discussions][this-discussions]

![badge-github-release][badge-github-release]
![badge-github-release-date][badge-github-release-date]
![badge-github-stars][badge-github-stars]
![badge-github-forks][badge-github-forks]
![badge-github-open-issues][badge-github-open-issues]
![badge-github-closed-issues][badge-github-closed-issues]
![badge-github-releases][badge-github-releases]
![badge-github-commits][badge-github-commits]
![badge-github-last-commit][badge-github-last-commit]

<!-- ![badge-github-workflow-dockerhub-autobuild][badge-github-workflow-dockerhub-autobuild] -->
<!-- ![badge-github-workflow-dockerhub-post-push][badge-github-workflow-dockerhub-post-push] -->

***

- [Headless Ubuntu/Xfce containers with VNC/noVNC](#headless-ubuntuxfce-containers-with-vncnovnc)
  - [Project `accetto/ubuntu-vnc-xfce-g3`](#project-accettoubuntu-vnc-xfce-g3)
    - [Introduction](#introduction)
    - [TL;DR](#tldr)
      - [Installing packages](#installing-packages)
      - [Shared memory size](#shared-memory-size)
      - [Extending images](#extending-images)
      - [Building images](#building-images)
      - [Sharing devices](#sharing-devices)
    - [Image generations](#image-generations)
    - [Project versions](#project-versions)
    - [Project goals](#project-goals)
    - [Changes and new features](#changes-and-new-features)
      - [Naming scheme](#naming-scheme)
      - [Slimmer images](#slimmer-images)
      - [Fewer and more flexible Dockerfiles](#fewer-and-more-flexible-dockerfiles)
      - [Concept of features](#concept-of-features)
      - [Faster building with `g3-cache`](#faster-building-with-g3-cache)
      - [Overriding of container user parameters](#overriding-of-container-user-parameters)
      - [Overriding of VNC/noVNC parameters](#overriding-of-vncnovnc-parameters)
      - [Different use of version sticker](#different-use-of-version-sticker)
      - [Image metadata](#image-metadata)
      - [Simple self-containing CI](#simple-self-containing-ci)
      - [Separated builder and deployment repositories](#separated-builder-and-deployment-repositories)
      - [Separate README files for Docker Hub](#separate-readme-files-for-docker-hub)
      - [New startup script](#new-startup-script)
  - [Issues, Wiki and Discussions](#issues-wiki-and-discussions)
  - [Credits](#credits)

### Introduction

This repository contains resources for building Docker images based on [Ubuntu 22.04 LTS and 20.04 LTS][docker-ubuntu] with [Xfce][xfce] desktop environment and [VNC][tigervnc]/[noVNC][novnc] servers for headless use.

The resources for the individual images and their variations (tags) are stored in the subfolders of the **master** branch. Each image has its own README file describing its features and usage.

There are also sibling projects containing images for headless programming ([accetto/headless-coding-g3][accetto-github-headless-coding-g3]) or headless diagramming, vector drawing and bitmap image editing ([accetto/headless-drawing-g3][accetto-github-headless-drawing-g3]).

### TL;DR

There are currently resources for the following Docker images:

- [accetto/ubuntu-vnc-xfce-g3][accetto-docker-ubuntu-vnc-xfce-g3]
  - [full Readme][this-readme-image-base]
  - Dockerfiles [22.04][this-dockerfile-22-04] and [20.04][this-dockerfile-20-04] (common for all images)
  - [Dockerfile stages diagram][this-diagram-dockerfile-stages] (common for all images)
- [accetto/ubuntu-vnc-xfce-chromium-g3][accetto-docker-ubuntu-vnc-xfce-chromium-g3]
  - [full Readme][this-readme-image-chromium]
- [accetto/ubuntu-vnc-xfce-firefox-g3][accetto-docker-ubuntu-vnc-xfce-firefox-g3]
  - [full Readme][this-readme-image-firefox]

#### Installing packages

I try to keep the images slim. Consequently you can sometimes encounter missing dependencies while adding more applications yourself. You can track the missing libraries on the [Ubuntu Packages Search][ubuntu-packages-search] page and install them subsequently.

You can also try to fix it by executing the following (the default `sudo` password is **headless**):

```shell
### apt cache needs to be updated only once
sudo apt-get update

sudo apt --fix-broken install
```

#### Shared memory size

Note that some applications require larger shared memory than the default 64MB. Using 256MB usually solves crashes or strange behavior.

You can check the current shared memory size by executing the following command inside the container:

```shell
df -h /dev/shm
```

The Wiki page [Firefox multi-process][that-wiki-firefox-multiprocess] describes several ways, how to increase the shared memory size.

#### Extending images

The provided example file `Dockerfile.extend` shows how to use the images as the base for your own images.

Your concrete `Dockerfile` may need more statements, but the concept should be clear.

The compose file `example.yml` shows how to switch to another non-root user and how to set the VNC password and resolution.

#### Building images

The fastest way to build the images:

```shell
### PWD = project root
### prepare and source the 'secrets.rc' file first (see 'example-secrets.rc')

### examples of building and publishing the individual images
./builder.sh latest all
./builder.sh latest-chromium all
./builder.sh latest-firefox all

### just building the images, skipping the publishing and the version sticker update
./builder.sh latest build
./builder.sh latest-chromium build
./builder.sh latest-firefox build

### examples of building and publishing the groups of images
./ci-builder.sh all group latest
./ci-builder.sh all group latest-chromium
./ci-builder.sh all group latest-firefox

### or all the images at once
./ci-builder.sh all group complete

### or skipping the publishing to the Docker Hub
./ci-builder.sh all-no-push group complete

### and so on
```

You can still execute the individual hook scripts as before (see the folder `/docker/hooks/`). However, the provided utilities `builder.sh` and `ci-builder.sh` are more convenient. Before pushing the images to the **Docker Hub** you have to prepare and source the file `secrets.rc` (see `example-secrets.rc`). The script `builder.sh` builds the individual images. The script `ci-builder.sh` can build various groups of images or all of them at once. Check the files `local-builder-readme.md`, `local-building-example.md` and [Wiki][this-wiki] for more information.

#### Sharing devices

Sharing the audio device for video with sound works only with `Chromium` and only on Linux:

```shell
docker run -it -P --rm \
  --device /dev/snd:/dev/snd:rw \
  --group-add audio \
accetto/ubuntu-vnc-xfce-chromium-g3:latest
```

Sharing the display with the host works only on Linux:

```shell
xhost +local:$(whoami)

docker run -it -P --rm \
    -e DISPLAY=${DISPLAY} \
    --device /dev/dri/card0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    accetto/ubuntu-vnc-xfce-g3:latest --skip-vnc

xhost -local:$(whoami)
```

Sharing the X11 socket with the host works only on Linux:

```shell
xhost +local:$(whoami)

docker run -it -P --rm \
    --device /dev/dri/card0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    accetto/ubuntu-vnc-xfce-g3:latest

xhost -local:$(whoami)
```

### Image generations

This is the **third generation** (G3) of my headless images. The **second generation** (G2) contains the GitHub repository [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc]. The **first generation** (G1) contains the GitHub repository [accetto/ubuntu-vnc-xfce][accetto-docker-ubuntu-vnc-xfce].

### Project versions

This file describes the **fourth version** (G3v4) of the project.

The **first version** (G3v1, or simply G3), the **second version** (G3v2, only 20.04 images) and the **third version** (G3v3, 22.04 and 20.04 images) are still available in this **GitHub** repository as the branches `archived-generation-g3v1`, `archived-generation-g3v2` and `archived-generation-g3v3`.

The version `G3v3` brings the following major changes comparing to the previous version `G3v2`:

- The updated startup scripts that support overriding the user ID (`id`) and group ID (`gid`) without needing the former build argument `ARG_FEATURES_USER_GROUP_OVERRIDE`, which has been removed.
- The user ID and the group ID can be overridden during the build time (`docker build`) and the run time (`docker run`).
- The `user name`, the `group name` and the `initial sudo password` can be overridden during the build time.
- The permissions of the files `/etc/passwd` and `/etc/groups` are set to the standard `644` after creating the user.
- The content of the home folder and the startup folder belongs to the created user.
- The created user gets permissions to use `sudo`. The initial `sudo` password is configurable during the build time using the build argument `ARG_SUDO_INITIAL_PW`. The password can be changed inside the container.
- The default `id:gid` has been changed from `1001:0` to `1000:1000`.

The version `G3v3` has brought the following major changes comparing to the previous version `G3v2`:

- The images based on `Ubuntu 22.04 LTS (jammy)` and `Ubuntu 20.04 LTS (focal)`.
- An extended, but simplified `tag` set for publishing on the **Docker Hub**.
- The improved builder scripts, including support for the `--target` building parameter

The version `G3v2` has brought the following major changes comparing to the previous version `G3v1`:

- Significantly improved building performance by introducing a local cache (`g3-cache`).
- Auto-building on the **Docker Hub** and using of the **GitHub Actions** have been abandoned.
- The enhanced building pipeline moves towards building the images outside the **Docker Hub** and aims to support also stages with CI/CD capabilities (e.g. the **GitLab**).
- The **local stage** is the default building stage now. However, the new building pipeline has already been tested also with a local **GitLab** installation in a Docker container on a Linux machine.
- Automatic publishing of README files to the **Docker Hub** has been removed, because it was not working properly any more. However, the README files for the **Docker Hub** can still be prepared with the provided utility `util-readme.sh` and then copy-and-pasted to the **Docker Hub** manually.

  The changes affect only the building pipeline, not the Docker images themselves. The `Dockerfile`, apart from using the new local `g3-cache`, stays conceptually unchanged.

### Project goals

Unlike the first two generations, this `G3` generation aims to support CI/CD.

The main project goal is to develop a **free, simple and self-containing CI/CD pipeline** for **building sets of configurable Docker images** with minimal dependencies outside the project itself.

There are indeed only three service providers used, all available for free:

- [**GitHub**][github] repository contains everything required for building the Docker images. Both public and private repositories can be used. **GitHub Gists** are used for persisting data, e.g. badge endpoints.

- [**Docker Hub**][dockerhub] hosts the repositories for the final Docker images. Public or private repositories can be used.

- [**Badgen.net**][badgen] is used for generating and hosting most of the badges.

None of the above service providers is really required. All images can be built locally under Linux or Windows and published elsewhere, if needed.

Building process is implemented to minimize image pollution. New images are pushed to the repositories only if something essential has changed. This can be overridden if needed.

### Changes and new features

**Hint:** More detailed information about new features can be found in [Wiki][this-wiki].

#### Naming scheme

Unlike the first two generations, this one will aim to use less Docker Hub **image repositories** with more **image tags**. For example, previously there have been two Docker Hub repositories `xubuntu-vnc` and `ubuntu-vnc-novnc`. Now there will be only one Docker Hub repository `accetto/ubuntu-vnc-xfce-g3`.

#### Slimmer images

New images are significantly slimmer than the previous ones. It's because that the most of the packages are installed with the `apt-get` switch `--no-install-recommends` by default. This could have consequences, so it is configurable.

#### Fewer and more flexible Dockerfiles

Image variations are build from fewer Dockerfiles. This is allowed by using *multi-stage builds* and the [Buildkit][docker-doc-build-with-buildkit]. On the other hand, flexible and configurable Dockerfiles are slightly more complex.

#### Concept of features

Flexibility in Dockerfiles is supported by introducing the concept of **features**. These are variables that control the building process. For example, the variable **FEATURES_BUILD_SLIM** controls the `--no-install-recommends` switch, the variable **FEATURES_NOVNC** controls the inclusion of `noVNC` and so on. Some other available features include, for example, the **FEATURES_SCREENSHOOTING** and **FEATURES_THUMBNAILING** variables. Also the web browsers [Chromium][chromium] and [Firefox][firefox] are defined as features controlled by the variables **FEATURES_CHROMIUM**, **FEATURES_FIREFOX** and **FEATURES_FIREFOX_PLUS**.

#### Faster building with `g3-cache`

Building performance has been significantly improved by introducing a local cache (`g3-cache`), which contains the external packages that would be otherwise downloaded by each build. Refreshing the cache is part of the building pipeline. The Dockerfiles fall back to the ad-hoc downloading if the local cache is not available.

#### Overriding of container user parameters

The user ID, user name, user group ID, user group name and the initial `sudo` password can be overridden during the build time (`docker build`). The user ID and the group ID can be overridden also in run time (`docker run`). The overridden user gets permissions for `sudo`. The `sudo` password can be changed inside the container.

#### Overriding of VNC/noVNC parameters

Several ways of overriding the VNC/noVNC parameters are supported. The password, display, resolution, color depth, view mode and the ports can be overridden at the image build-time, the container startup-time and the VNC startup-time. Using of empty VNC/noVNC password is also supported because it is independent from the container user password.

If your session disconnects, it might be related to a network equipment (load-balancer, reverse proxy, ...) dropping the websocket session for inactivity (more info [here](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) and [here](https://nginx.org/en/docs/http/websocket.html) for nginx). In such case, try defining the **NOVNC_HEARTBEAT=XX** environment variable at startup-time, where **XX** is the number of seconds between [websocket ping/pong](https://github.com/websockets/ws/issues/977) packets.

#### Different use of version sticker

The concept of version sticker has been introduced in the second generation and later implemented also in the first generation. Check this [Wiki page](https://github.com/accetto/xubuntu-vnc/wiki/Version-sticker) for more information. However, the usage of the version sticker has been changed in the third generation. Previously it has been used for testing, if there are any newer packages available by following the *try-and-fail* pattern. That was sufficient for human controlled building process, but it became a problem for CI/CD. Therefore it is used differently now. The verbose version sticker is used for minimizing image pollution. The short form of the version sticker is available as an image *label* and a *badge* in the README file. The *version sticker badge* is also linked with the *verbose version sticker gist*, so it is possible to check the actual image configuration even without downloading it.

#### Image metadata

The image metadata are now stored exclusively as image *labels*. The previous environment variables like **REFRESHED_AT** or **VERSION_STICKER** have been removed. Most of the labels are namespaced according the [OCI IMAGE SPEC](https://github.com/opencontainers/image-spec) recommendations. However, the `version-sticker` label is in the namespace `any.accetto` for obvious reasons.

#### Simple self-containing CI

The **first version** of the third generation (G3v1) implemented a relatively simple self-containing CI by utilizing the **Docker Hub** builder *hooks*. The same build pipeline could be executed also manually if building locally. For example, an image could be refreshed by executing the `/hooks/pre_build` and `/hooks/build` scripts. The script `/hooks/push` would push the image to the deployment repository. The script `/hooks/post_push` would update the *gist* data and trigger the **GitHub Actions** workflow, which would publish the image's README file to the **Docker Hub**.

However, in the middle of the year 2021 the **Docker Hub** removed the auto-building feature from the free plan. Because one of the main objectives of this project is not to depend on any paid services, I had to remove the dependency on the Docker Hub's auto-building. There has also not been any use for the **GitHub Actions** any more.

The **second version** (G3v2) of the building pipeline does not depend on the **Docker Hub**'s auto-building feature or the **GitHub Actions** any more. The original hook scripts have been enhanced and some new ones have been introduced (.e.g. `/hooks/cache`). The provided utility script `builder.sh` not only allows executing the individual hook scripts, but also implements the complete workflow for building the individual images. The another utility script `ci-builder.sh` makes use of it and adds the workflow for building sets of images. Both scripts can optionally also publish the images to the **Docker Hub**.

The **local stage** is the default for the new building pipeline. Also a local **GitLab** installation in a Docker container has already been successfully tested as a CI building stage.

#### Separated builder and deployment repositories

While there is only one GitHub repository, containing the resources for building all the images,
the **first pipeline version** (G3v1) have used two kinds of repositories on the **Docker Hub**. A single *builder repository* has been used for building all the images. The final images have then been published into one or more *deployment repositories*. This separation allowed to keep permutations by naming reasonable. Not all repositories had to have the same visibility, they could be private or public as required.

The **second pipeline version** (G3v2) does not really need the **builder repository** for building the images, because it's done outside the **Docker Hub**, which previously hosted the builder repository. However, the pipeline is still based on the original hook scripts and therefore it depends on the **builder repository** object by managing the names and tags of the images first by building and later by publishing to the **Docker Hub**.

All the images are still build in a single **building repository** and then published to one or more **deployment repositories** on the **Docker Hub**.

The **builder repository** can also server as a **secondary deployment repository** during development and testing.

#### Separate README files for Docker Hub

Each **deployment repository** has its own `README` file for the **Docker Hub**.

The **first pipeline version** (G3v1) has originally published it using the **GitHub Actions** workflows after the image has been pushed. However, some time later it has stopped working properly.

The **second pipeline version** (G3v2) does not try to publish the `README` file to the **Docker Hub** any more. However, there is still a utility script, which can prepare the `README` version for the **Docker Hub**, which can be then copy-and-pasted there manually.

The source `README` files for the **Docker Hub** are split into two parts. The part containing the badge links is separated into a **template file**. The final `README` files are then generated by the utility script. These files are usually shorter, because their length is limited by the **Docker Hub**. Therefore there are also the full-length versions, that are published only on the **GitHub**.

#### New startup script

The startup script has been completely redesigned with the help of the [argbash][argbash-doc] tool and the image [accetto/argbash-docker][accetto-docker-argbash-docker]. Several new startup switches has been added. For example, there are startup switches `--wait`, `--skip-startup`, `--tail-null`, `--tail-vnc`, `--version-sticker` and `--version-sticker-verbose`. There are also startup modifiers `--skip-vnc`, `--skip-novnc`, `--debug` and `--verbose`. Also the utility switches `--help-usage`, `--help` and `--version` are available.

***

## Issues, Wiki and Discussions

If you have found a problem or you just have a question, please check the [Issues][this-issues] and the [Wiki][this-wiki] first. Please do not overlook the closed issues.

If you do not find a solution, you can file a new issue. The better you describe the problem, the bigger the chance it'll be solved soon.

If you have a question or an idea and you don't want to open an issue, you can use the [Discussions][this-discussions].

## Credits

Credit goes to all the countless people and companies, who contribute to open source community and make so many dreamy things real.

***

[this-docker]: https://hub.docker.com/u/accetto/

[this-changelog]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/CHANGELOG.md
[this-discussions]: https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions
<!-- [this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/ -->
[this-issues]: https://github.com/accetto/ubuntu-vnc-xfce-g3/issues
[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[this-dockerfile-22-04]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.22-04
[this-dockerfile-20-04]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.20-04

[this-readme-image-base]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce/README.md
[this-readme-image-chromium]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce-chromium/README.md
[this-readme-image-firefox]: https://github.com/accetto/ubuntu-vnc-xfce-g3/tree/master/docker/xfce-firefox

[accetto-docker-ubuntu-vnc-xfce-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-g3
[accetto-docker-ubuntu-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3

[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/
[accetto-docker-ubuntu-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3

[accetto-docker-ubuntu-vnc-xfce]: https://github.com/accetto/ubuntu-vnc-xfce

[accetto-docker-argbash-docker]: https://hub.docker.com/r/accetto/argbash-docker

<!-- sibling projects -->

[accetto-github-headless-coding-g3]: https://github.com/accetto/headless-coding-g3
[accetto-github-headless-drawing-g3]: https://github.com/accetto/headless-drawing-g3

<!-- Previous generations -->

[that-wiki-firefox-multiprocess]: https://github.com/accetto/xubuntu-vnc/wiki/Firefox-multiprocess

<!-- external links -->

[docker-ubuntu]: https://hub.docker.com/_/ubuntu/

[docker-doc-build-with-buildkit]: https://docs.docker.com/develop/develop-images/build_enhancements/

[ubuntu-packages-search]: https://packages.ubuntu.com/

[argbash-doc]: https://argbash.readthedocs.io/en/stable/index.html
[badgen]: https://badgen.net/
[chromium]: https://www.chromium.org/Home
[dockerhub]: https://hub.docker.com/
[firefox]: https://www.mozilla.org
[github]: https://github.com/
[novnc]: https://github.com/kanaka/noVNC
[tigervnc]: http://tigervnc.org
[xfce]: http://www.xfce.org

<!-- github badges -->

[badge-github-release]: https://badgen.net/github/release/accetto/ubuntu-vnc-xfce-g3?icon=github&label=release

[badge-github-release-date]: https://img.shields.io/github/release-date/accetto/ubuntu-vnc-xfce-g3?logo=github

[badge-github-stars]: https://badgen.net/github/stars/accetto/ubuntu-vnc-xfce-g3?icon=github&label=stars

[badge-github-forks]: https://badgen.net/github/forks/accetto/ubuntu-vnc-xfce-g3?icon=github&label=forks

[badge-github-releases]: https://badgen.net/github/releases/accetto/ubuntu-vnc-xfce-g3?icon=github&label=releases

[badge-github-commits]: https://badgen.net/github/commits/accetto/ubuntu-vnc-xfce-g3?icon=github&label=commits

[badge-github-last-commit]: https://badgen.net/github/last-commit/accetto/ubuntu-vnc-xfce-g3?icon=github&label=last%20commit

[badge-github-closed-issues]: https://badgen.net/github/closed-issues/accetto/ubuntu-vnc-xfce-g3?icon=github&label=closed%20issues

[badge-github-open-issues]: https://badgen.net/github/open-issues/accetto/ubuntu-vnc-xfce-g3?icon=github&label=open%20issues
