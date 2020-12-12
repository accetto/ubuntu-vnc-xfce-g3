# Headless Ubuntu/Xfce containers with VNC/noVNC

## Project `accetto/ubuntu-vnc-xfce-g3`

***

![badge-github-release][badge-github-release]
![badge-github-release-date][badge-github-release-date]
![badge-github-stars][badge-github-stars]
![badge-github-forks][badge-github-forks]
![badge-github-open-issues][badge-github-open-issues]
![badge-github-closed-issues][badge-github-closed-issues]
![badge-github-releases][badge-github-releases]
![badge-github-commits][badge-github-commits]
![badge-github-last-commit][badge-github-last-commit]

![badge-github-workflow-dockerhub-autobuild][badge-github-workflow-dockerhub-autobuild]
![badge-github-workflow-dockerhub-post-push][badge-github-workflow-dockerhub-post-push]

***

This repository contains resources for building Docker images based on [Ubuntu 20.04 LTS][docker-ubuntu] with [Xfce][xfce] desktop environment and [VNC][tigervnc]/[noVNC][novnc] servers for headless use.

The resources for the individual images and their variations (tags) are stored in the subfolders of the **master** branch. Each image has its own README file describing its features and usage.

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

#### Naming scheme

Unlike the first two generations, this one will aim to use less Docker Hub **image repositories** with more **image tags**. For example, previously there have been two Docker Hub repositories `xubuntu-vnc` and `ubuntu-vnc-novnc`. Now there will be only one Docker Hub repository `accetto/ubuntu-vnc-xfce-g3` containing tags `vnc` and `vnc-novnc`.

#### Slimmer images

New images are significantly slimmer than the previous ones. It's because that the most of the packages are installed with the `apt-get` switch `--no-install-recommends` by default. This could have consequences, so it is configurable.

#### Fewer and more flexible Dockerfiles

Image variations are build from fewer Dockerfiles. This is allowed by using *multi-stage builds* and *Buildkit*. On the other hand, flexible and configurable Dockerfiles are slightly more complex.

#### Concept of features

Flexibility in Dockerfiles is supported by introducing the concept of **features**. These are variables that control the building process. For example, the variable **FEATURES_BUILD_SLIM** controls the `--no-install-recommends` switch, the variable **FEATURES_NOVNC** controls the inclusion of *noVNC* and so on. Some other available features include, for example, the **FEATURES_SCREENSHOOTING**, **FEATURES_THUMBNAILING** and **FEATURES_USER_GROUP_OVERRIDE** variables.

#### Optional overriding of user group by `docker run`

Support for overriding the user group by `docker run` has been introduced in the second generation. Please check its documentation for more information. This feature is now controlled by the variable **FEATURES_USER_GROUP_OVERRIDE**.

#### Different use of version sticker

The concept of version sticker has been introduced in the second generation and later implemented also in the first generation. Check this [Wiki page](https://github.com/accetto/xubuntu-vnc/wiki/Version-sticker) for more information. However, the usage of the version sticker has been changed in the third generation. Previously it has been used for testing, if there are some newer packages available by following the *try-and-fail* pattern. That was sufficient for human controlled building process, but it became a problem for CI. Therefore it is used differently now. The verbose version sticker is used for minimizing image pollution. The short form of the version sticker is available as an image *label* and a *badge* in the README file. The version sticker badge is also linked with the verbose version sticker *gist*, so it is possible to check the actual image configuration even without downloading it.

#### Image metadata

The image metadata are now stored exclusively as image *labels*. The previous environment variables like **REFRESHED_AT** or **VERSION_STICKER** have been removed. Most of the labels are namespaced according the [OCI IMAGE SPEC](https://github.com/opencontainers/image-spec) recommendations. However, the `version-sticker` label is in the namespace `any.accetto` for obvious reasons.

#### Simple self-containing CI

The third generation implements a relatively simple self-containing CI by utilizing the Docker Hub builder *hooks*. The same build pipeline can be executed also manually if building locally. For example, an image can be refreshed by executing the `/hooks/pre_build` and `/hooks/build` scripts. The script `/hooks/push` will push the image to the deployment repository. The script `/hooks/post_push` will update the *gist* data and trigger the **GitHub Actions** workflow, which will publish the image's README file to Docker Hub.

#### Separated builder and deployment repositories

While there is only one GitHub repository, containing the resource for building all images, there are two kinds of repositories on Docker Hub. A single *builder repository* is used for building all images. The final images are then published into one or more *deployment repositories*. This separation allows to keep permutations by naming reasonable. Not all repositories must have the same visibility, they can be private or public as required. The same repository could be also used for building and deployment.

#### Separate README files for Docker Hub

Each deployment repository has its own README file for Docker Hub, which is published by CI workflows after the image has been pushed. The file is split into parts. The part containing the badge links is separated into a template file. The final README file is then generated by the script just before publishing. Re-publishing can be forced even if the image has not been actually refreshed. These README files are shorter, because their length is limited by Docker Hub. Therefore there are also full-length README files published only on GitHub.

#### Based on Ubuntu 20.04 LTS

The current images are based on the official [Ubuntu 20.04 LTS][docker-ubuntu] image.

#### Using TigerVNC 1.11

The images use the latest [TigerVNC 1.11.0][tigervnc] server, which has introduced some significant changes in its startup process. Actually the images implement the newer TigerVNC nightly builds, that fix or mitigate some of the issues.

#### New startup script

The startup script has been completely redesigned with the help of [argbash][argbash-doc] tool and the image [accetto/argbash-docker][accetto-docker-argbash-docker]. Several new startup switches has been added. For example, there are startup switches `--wait`, `--skip-startup`, `--tail-null`, `--tail-vnc`, `--version-sticker` and `--version-sticker-verbose`. There are also startup modifiers `--skip-vnc`, `--skip-novnc`, `--debug` and `--verbose`. Also the utility switches `--help-usage`, `--help` and `--version` are available.

***

## Issues

If you have found a problem or you just have a question, please check the [Issues][this-issues] and the [Wiki][this-wiki] first. Please do not overlook the closed issues.

If you do not find a solution, you can file a new issue. The better you describe the problem, the bigger the chance it'll be solved soon.

## Credits

Credit goes to all the countless people and companies, who contribute to open source community and make so many dreamy things real.

***

[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/
[this-changelog]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/CHANGELOG.md
[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

[accetto-github-xubuntu-vnc]: https://github.com/accetto/xubuntu-vnc/
[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/
[accetto-docker-ubuntu-vnc-xfce]: https://github.com/accetto/ubuntu-vnc-xfce
[accetto-docker-ubuntu-vnc-xfce-firefox]: https://github.com/accetto/ubuntu-vnc-xfce-firefox
[accetto-docker-ubuntu-vnc-xfce-firefox-plus]: https://github.com/accetto/ubuntu-vnc-xfce-firefox-plus
[accetto-docker-ubuntu-vnc-xfce-chromium]: https://github.com/accetto/ubuntu-vnc-xfce-chromium
[accetto-docker-argbash-docker]: https://hub.docker.com/r/accetto/argbash-docker

[docker-ubuntu]: https://hub.docker.com/_/ubuntu/

[argbash-doc]: https://argbash.readthedocs.io/en/stable/index.html
[badgen]: https://badgen.net/
[dockerhub]: https://hub.docker.com/
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

<!-- Appendix -->
