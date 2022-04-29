# Headless Ubuntu/Xfce containers with VNC/noVNC

## Project `accetto/ubuntu-vnc-xfce-g3`

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

This repository contains resources for building Docker images based on [Ubuntu 20.04 LTS][docker-ubuntu] with [Xfce][xfce] desktop environment and [VNC][tigervnc]/[noVNC][novnc] servers for headless use.

The resources for the individual images and their variations (tags) are stored in the subfolders of the **master** branch. Each image has its own README file describing its features and usage.

There are also sibling projects containing images for headless programming in `Node.js` and `Python` ([accetto/headless-coding-g3][accetto-github-headless-coding-g3]) or headless diagramming, vector drawing and bitmap image editing ([accetto/headless-drawing-g3][accetto-github-headless-drawing-g3]).

### TL;DR

There are currently resources for the following Docker images:

- [accetto/ubuntu-vnc-xfce-g3][accetto-docker-ubuntu-vnc-xfce-g3]
  - [full Readme][this-readme-image-base]
  - [Dockerfile][this-dockerfile-base] (common for all images)
  - [Dockerfile stages diagram][this-diagram-dockerfile-stages] (common for all images)
- [accetto/ubuntu-vnc-xfce-chromium-g3][accetto-docker-ubuntu-vnc-xfce-chromium-g3]
  - [full Readme][this-readme-image-chromium]
- [accetto/ubuntu-vnc-xfce-firefox-g3][accetto-docker-ubuntu-vnc-xfce-firefox-g3]
  - [full Readme][this-readme-image-firefox]

I try to keep the images slim. Consequently you can encounter missing dependencies while adding more applications yourself. You can track the missing libraries on the [Ubuntu Packages Search][ubuntu-packages-search] page and install them subsequently.

You can also try to fix it by executing the following (the default `sudo` password is **headless**):

```shell
### apt cache needs to be updated only once
sudo apt-get update

sudo apt --fix-broken install
```

The fastest way to build the images locally:

```shell
### PWD = project root
./docker/hooks/build dev latest
./docker/hooks/build dev latest-chromium
./docker/hooks/build dev latest-firefox
./docker/hooks/build dev latest-firefox-plus
./docker/hooks/build dev vnc
./docker/hooks/build dev vnc-chromium
./docker/hooks/build dev vnc-firefox
./docker/hooks/build dev vnc-firefox-plus
### and so on
```

You can also use the provided helper script `builder.sh`, which can also publish the images on Docker Hub, if you correctly set the required environment variables (see the file `example-secrets.rc`). Check the files `local-builder-readme.md` and `local-building-example.md`.

Find more in the hook script `env.rc` and in [Wiki][this-wiki].

Sharing the audio device for video with sound (only Linux and Chromium):

```shell
docker run -it -P --rm \
  --device /dev/snd:/dev/snd:rw \
  --group-add audio \
accetto/ubuntu-vnc-xfce-chromium-g3:latest
```

### Table of contents

- [Headless Ubuntu/Xfce containers with VNC/noVNC](#headless-ubuntuxfce-containers-with-vncnovnc)
  - [Project `accetto/ubuntu-vnc-xfce-g3`](#project-accettoubuntu-vnc-xfce-g3)
    - [TL;DR](#tldr)
    - [Table of contents](#table-of-contents)
    - [Image generations](#image-generations)
    - [Project goals](#project-goals)
    - [Changes and new features](#changes-and-new-features)
      - [Naming scheme](#naming-scheme)
      - [Slimmer images](#slimmer-images)
      - [Fewer and more flexible Dockerfiles](#fewer-and-more-flexible-dockerfiles)
      - [Concept of features](#concept-of-features)
      - [Overriding of container user parameters](#overriding-of-container-user-parameters)
      - [Overriding of VNC/noVNC parameters](#overriding-of-vncnovnc-parameters)
      - [Different use of version sticker](#different-use-of-version-sticker)
      - [Image metadata](#image-metadata)
      - [Simple self-containing CI](#simple-self-containing-ci)
      - [Separated builder and deployment repositories](#separated-builder-and-deployment-repositories)
      - [Separate README files for Docker Hub](#separate-readme-files-for-docker-hub)
      - [Based on Ubuntu 20.04 LTS](#based-on-ubuntu-2004-lts)
      - [Using TigerVNC 1.11](#using-tigervnc-111)
      - [New startup script](#new-startup-script)
  - [Issues, Wiki and Discussions](#issues-wiki-and-discussions)
  - [Credits](#credits)

### Image generations

This is the **third generation** (G3) of my headless images. The **second generation** (G2) contains the GitHub repositories [accetto/xubuntu-vnc][accetto-github-xubuntu-vnc] and [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc]. The **first generation** (G1) contains the GitHub repositories [accetto/ubuntu-vnc-xfce][accetto-docker-ubuntu-vnc-xfce], [accetto/ubuntu-vnc-xfce-firefox][accetto-docker-ubuntu-vnc-xfce-firefox], [accetto/ubuntu-vnc-xfce-firefox-plus][accetto-docker-ubuntu-vnc-xfce-firefox-plus] and [accetto/ubuntu-vnc-xfce-chromium][accetto-docker-ubuntu-vnc-xfce-chromium].

### Project goals

Unlike the first two generations, this one aims to support CI. One of the main project goals has been to implement a simple and cheap *self-containing* CI with minimal dependencies outside the project itself. There are only three service providers used, all available for free:

- [**GitHub**][github] hosts everything required for building the Docker images. Both public and private repositories can be used. **GitHub Gists** are used for persisting data, e.g. badge endpoints. **GitHub Actions** are also used.

- [**Docker Hub**][dockerhub] hosts the Docker images and is also used for building them. Public or private repositories can be used.

- [**Badgen.net**][badgen] is used for generating and hosting most of the badges.

None of the above service providers is really required. Images can be built locally under Linux or Windows and published elsewhere.

Building process is implemented to minimize image pollution. New images are pushed to the repositories only if something essential has changed. This could be overridden if needed.

### Changes and new features

**Hint:** More detailed information about new features can be found in [Wiki][this-wiki].

#### Naming scheme

Unlike the first two generations, this one will aim to use less Docker Hub **image repositories** with more **image tags**. For example, previously there have been two Docker Hub repositories `xubuntu-vnc` and `ubuntu-vnc-novnc`. Now there will be only one Docker Hub repository `accetto/ubuntu-vnc-xfce-g3` containing tags `vnc` and `vnc-novnc`.

#### Slimmer images

New images are significantly slimmer than the previous ones. It's because that the most of the packages are installed with the `apt-get` switch `--no-install-recommends` by default. This could have consequences, so it is configurable.

#### Fewer and more flexible Dockerfiles

Image variations are build from fewer Dockerfiles. This is allowed by using *multi-stage builds* and [Buildkit][docker-doc-build-with-buildkit]. On the other hand, flexible and configurable Dockerfiles are slightly more complex.

#### Concept of features

Flexibility in Dockerfiles is supported by introducing the concept of **features**. These are variables that control the building process. For example, the variable **FEATURES_BUILD_SLIM** controls the `--no-install-recommends` switch, the variable **FEATURES_NOVNC** controls the inclusion of *noVNC* and so on. Some other available features include, for example, the **FEATURES_SCREENSHOOTING**, **FEATURES_THUMBNAILING** and **FEATURES_USER_GROUP_OVERRIDE** variables. Also the web browsers [Chromium][chromium] and [Firefox][firefox] are defined as features controlled by the variables **FEATURES_CHROMIUM**, **FEATURES_FIREFOX** and **FEATURES_FIREFOX_PLUS**.

#### Overriding of container user parameters

Several ways of overriding the container user parameters are supported. The application user name, home directory and password can be overridden at the image build-time. The user ID can be overridden at the container startup-time.

Support for overriding the user group by `docker run` has been introduced in the second generation. This feature is now controlled by the variable **FEATURES_USER_GROUP_OVERRIDE**.

#### Overriding of VNC/noVNC parameters

Several ways of overriding the VNC/noVNC parameters are supported. The password, display, resolution, color depth, view mode and the ports can be overridden at the image build-time, the container startup-time and the VNC startup-time. Using of empty VNC/noVNC password is also supported because it is independent from the container user password.

If your session disconnects, it might be related to a network equipment (load-balancer, reverse proxy, ...) dropping the websocket session for inactivity (more info [here](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) and [here](https://nginx.org/en/docs/http/websocket.html) for nginx). In such case, try defining the **NOVNC_HEARTBEAT=XX** environment variable at startup-time, where **XX** is the number of seconds between [websocket ping/pong](https://github.com/websockets/ws/issues/977) packets.

#### Different use of version sticker

The concept of version sticker has been introduced in the second generation and later implemented also in the first generation. Check this [Wiki page](https://github.com/accetto/xubuntu-vnc/wiki/Version-sticker) for more information. However, the usage of the version sticker has been changed in the third generation. Previously it has been used for testing, if there are some newer packages available by following the *try-and-fail* pattern. That was sufficient for human controlled building process, but it became a problem for CI. Therefore it is used differently now. The verbose version sticker is used for minimizing image pollution. The short form of the version sticker is available as an image *label* and a *badge* in the README file. The version sticker badge is also linked with the verbose version sticker *gist*, so it is possible to check the actual image configuration even without downloading it.

#### Image metadata

The image metadata are now stored exclusively as image *labels*. The previous environment variables like **REFRESHED_AT** or **VERSION_STICKER** have been removed. Most of the labels are namespaced according the [OCI IMAGE SPEC](https://github.com/opencontainers/image-spec) recommendations. However, the `version-sticker` label is in the namespace `any.accetto` for obvious reasons.

#### Simple self-containing CI

The third generation implements a relatively simple self-containing CI by utilizing the Docker Hub builder *hooks*. The same build pipeline can be executed also manually if building locally. For example, an image can be refreshed by executing the `/hooks/pre_build` and `/hooks/build` scripts. The script `/hooks/push` will push the image to the deployment repository. The script `/hooks/post_push` will update the *gist* data and trigger the **GitHub Actions** workflow, which will publish the image's README file to Docker Hub.

#### Separated builder and deployment repositories

While there is only one GitHub repository, containing the resources for building all images, there are two kinds of repositories on Docker Hub. A single *builder repository* is used for building all images. The final images are then published into one or more *deployment repositories*. This separation allows to keep permutations by naming reasonable. Not all repositories must have the same visibility, they can be private or public as required. The same repository could be also used for building and deployment.

#### Separate README files for Docker Hub

Each deployment repository has its own README file for Docker Hub, which is published by CI workflows after the image has been pushed. The file is split into parts. The part containing the badge links is separated into a template file. The final README file is then generated by the script just before publishing. Re-publishing can be forced even if the image has not been actually refreshed. These README files are shorter, because their length is limited by Docker Hub. Therefore there are also full-length README files published only on GitHub.

#### Based on Ubuntu 20.04 LTS

The current images are based on the official [Ubuntu 20.04 LTS][docker-ubuntu] image.

#### Using TigerVNC 1.11

The images use the latest [TigerVNC 1.11.0][tigervnc] server, which has introduced some significant changes in its startup process. Actually the images implement the newer TigerVNC nightly builds, that fix or mitigate some of the issues.

#### New startup script

The startup script has been completely redesigned with the help of [argbash][argbash-doc] tool and the image [accetto/argbash-docker][accetto-docker-argbash-docker]. Several new startup switches has been added. For example, there are startup switches `--wait`, `--skip-startup`, `--tail-null`, `--tail-vnc`, `--version-sticker` and `--version-sticker-verbose`. There are also startup modifiers `--skip-vnc`, `--skip-novnc`, `--debug` and `--verbose`. Also the utility switches `--help-usage`, `--help` and `--version` are available.

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
[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/
[this-issues]: https://github.com/accetto/ubuntu-vnc-xfce-g3/issues
[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[this-dockerfile-base]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce

[this-readme-image-base]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce/README.md
[this-readme-image-chromium]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce-chromium/README.md
[this-readme-image-firefox]: https://github.com/accetto/ubuntu-vnc-xfce-g3/tree/master/docker/xfce-firefox

[accetto-docker-ubuntu-vnc-xfce-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-g3
[accetto-docker-ubuntu-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3

[accetto-github-xubuntu-vnc]: https://github.com/accetto/xubuntu-vnc/
[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/
[accetto-docker-ubuntu-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3

[accetto-docker-ubuntu-vnc-xfce]: https://github.com/accetto/ubuntu-vnc-xfce
[accetto-docker-ubuntu-vnc-xfce-chromium]: https://github.com/accetto/ubuntu-vnc-xfce-chromium
[accetto-docker-ubuntu-vnc-xfce-firefox]: https://github.com/accetto/ubuntu-vnc-xfce-firefox
[accetto-docker-ubuntu-vnc-xfce-firefox-plus]: https://github.com/accetto/ubuntu-vnc-xfce-firefox-plus

[accetto-docker-argbash-docker]: https://hub.docker.com/r/accetto/argbash-docker

<!-- sibling projects -->

[accetto-github-headless-coding-g3]:https://github.com/accetto/headless-coding-g3
[accetto-github-headless-drawing-g3]: https://github.com/accetto/headless-drawing-g3

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

[badge-github-workflow-dockerhub-autobuild]: https://github.com/accetto/ubuntu-vnc-xfce-g3/workflows/dockerhub-autobuild/badge.svg

[badge-github-workflow-dockerhub-post-push]: https://github.com/accetto/ubuntu-vnc-xfce-g3/workflows/dockerhub-post-push/badge.svg

[badge-github-release]: https://badgen.net/github/release/accetto/ubuntu-vnc-xfce-g3?icon=github&label=release

[badge-github-release-date]: https://img.shields.io/github/release-date/accetto/ubuntu-vnc-xfce-g3?logo=github

[badge-github-stars]: https://badgen.net/github/stars/accetto/ubuntu-vnc-xfce-g3?icon=github&label=stars

[badge-github-forks]: https://badgen.net/github/forks/accetto/ubuntu-vnc-xfce-g3?icon=github&label=forks

[badge-github-releases]: https://badgen.net/github/releases/accetto/ubuntu-vnc-xfce-g3?icon=github&label=releases

[badge-github-commits]: https://badgen.net/github/commits/accetto/ubuntu-vnc-xfce-g3?icon=github&label=commits

[badge-github-last-commit]: https://badgen.net/github/last-commit/accetto/ubuntu-vnc-xfce-g3?icon=github&label=last%20commit

[badge-github-closed-issues]: https://badgen.net/github/closed-issues/accetto/ubuntu-vnc-xfce-g3?icon=github&label=closed%20issues

[badge-github-open-issues]: https://badgen.net/github/open-issues/accetto/ubuntu-vnc-xfce-g3?icon=github&label=open%20issues
