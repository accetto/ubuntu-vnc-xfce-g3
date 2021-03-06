# Headless Ubuntu/Xfce container with VNC/noVNC and Firefox Browser

## accetto/ubuntu-vnc-xfce-firefox-g3

[Docker Hub][this-docker] - [Git Hub][this-github] - [Dockerfile][this-dockerfile] - [Full Readme][this-readme-full] - [Changelog][this-changelog] - [Project Readme][this-readme-project] - [Wiki][this-wiki]

![badge-docker-pulls][badge-docker-pulls]
![badge-docker-stars][badge-docker-stars]
![badge-github-release][badge-github-release]
![badge-github-release-date][badge-github-release-date]

![badge_latest_created][badge_latest_created]
[![badge_latest_version-sticker][badge_latest_version-sticker]][link_latest_version-sticker-verbose]

***

**Tip:** This is the short README version for Docker Hub. There is also the [full-length README][this-readme-full] on GitHub.

**Warning** about images with Firefox

There is no single-process Firefox image in this repository and the multi-process mode is always enabled. Be aware, that multi-process requires larger shared memory (`/dev/shm`). At least 256MB is recommended. Please check the **Firefox multi-process** page in [this Wiki][that-wiki-firefox-multiprocess] for more information and the instructions, how to set the shared memory size in different scenarios.

***

This repository contains resources for building Docker images based on [Ubuntu 20.04 LTS][docker-ubuntu] with [Xfce][xfce] desktop environment, [VNC][tigervnc]/[noVNC][novnc] servers for headless use and the current [Firefox Quantum][firefox] web browser.

This is the **third generation** (G3) of my headless images. The **second generation** (G2) of similar images is contained in the GitHub repositories [accetto/xubuntu-vnc][accetto-github-xubuntu-vnc] and [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc]. The **first generation** (G1) of similar images is contained in the GitHub repositories [accetto/ubuntu-vnc-xfce-firefox][accetto-github-ubuntu-vnc-xfce-firefox] and [accetto/ubuntu-vnc-xfce-firefox-plus][accetto-github-ubuntu-vnc-xfce-firefox-plus].

More information about the image generations can be found in the [project README][this-readme-project] file and in [Wiki][this-wiki].

The main features and components of the images in the default configuration are:

- utilities **ping**, **wget**, **sudo**, **dconf-editor** (Ubuntu distribution)
- current version of JSON processor [jq][jq]
- light-weight [Xfce][xfce] desktop environment (Ubuntu distribution)
- current version of high-performance [TigerVNC][tigervnc] server and client
- current version of [noVNC][novnc] HTML5 clients (full and lite) (TCP port **6901**)
- popular text editor [nano][nano] (Ubuntu distribution)
- lite but advanced graphical editor [mousepad][mousepad] (Ubuntu distribution)
- current version of [tini][tini] as the entry-point initial process (PID 1)
- support for overriding both the container user account and its group
- support of **version sticker** (see below)
- current version of [Firefox Quantum][firefox] web browser and some additional **plus** features described below

The history of notable changes is documented in the [CHANGELOG][this-changelog].

![container-screenshot][this-screenshot-container]

### Image tags

The following image tags are regularly maintained and rebuilt:

- `latest` is identical to `vnc-novnc-plus`

    ![badge_latest_created][badge_latest_created]
    [![badge_latest_version-sticker][badge_latest_version-sticker]][link_latest_version-sticker-verbose]

- `vnc` implements only VNC

    ![badge_vnc_created][badge_vnc_created]
    [![badge_vnc_version-sticker][badge_vnc_version-sticker]][link_vnc_version-sticker-verbose]

- `vnc-novnc` implements VNC and noVNC

    ![badge_vnc-novnc_created][badge_vnc-novnc_created]
    [![badge_vnc-novnc_version-sticker][badge_vnc-novnc_version-sticker]][link_vnc-novnc_version-sticker-verbose]

- `vnc-plus` implements only VNC and Firefox plus features

    ![badge_vnc-plus_created][badge_vnc-plus_created]
    [![badge_vnc-plus_version-sticker][badge_vnc-plus_version-sticker]][link_vnc-plus_version-sticker-verbose]

- `vnc-novnc-plus` implements VNC, noVNC and Firefox plus features

    ![badge_vnc-novnc-plus_created][badge_vnc-novnc-plus_created]
    [![badge_vnc-novnc-plus_version-sticker][badge_vnc-novnc-plus_version-sticker]][link_vnc-novnc-plus_version-sticker-verbose]

Clicking on the version sticker badge reveals more information about the actual configuration of the image.

### More information

More information about these images can be found in the [full-length README][this-readme-full] file on GitHub.

***

<!-- GitHub project common -->

[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/
[this-changelog]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/CHANGELOG.md
[this-readme-full]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce-firefox/README.md
[this-readme-project]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/README.md
[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki
[this-issues]: https://github.com/accetto/ubuntu-vnc-xfce-g3/issues

[that-readme-startup-help]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce/README-dockerhub.md#startup-options-and-help

<!-- Docker image specific -->

[this-docker]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3/
[this-dockerfile]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.firefox

[this-screenshot-container]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/xfce-firefox/ubuntu-vnc-xfce-firefox-plus.jpg

<!-- Previous generations -->

[that-wiki-firefox-multiprocess]: https://github.com/accetto/xubuntu-vnc/wiki/Firefox-multiprocess

[accetto-github-xubuntu-vnc]: https://github.com/accetto/xubuntu-vnc/
[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/
[accetto-github-ubuntu-vnc-xfce-firefox]: https://github.com/accetto/ubuntu-vnc-xfce-firefox
[accetto-github-ubuntu-vnc-xfce-firefox-plus]: https://github.com/accetto/ubuntu-vnc-xfce-firefox-plus

<!-- External links -->

[docker-ubuntu]: https://hub.docker.com/_/ubuntu/

[docker-doc]: https://docs.docker.com/
[docker-doc-managing-data]: https://docs.docker.com/storage/

[jq]: https://stedolan.github.io/jq/
[mousepad]: https://github.com/codebrainz/mousepad
[nano]: https://www.nano-editor.org/
[novnc]: https://github.com/kanaka/noVNC
[tigervnc]: http://tigervnc.org
[tightvnc]: http://www.tightvnc.com
[tini]: https://github.com/krallin/tini
[xfce]: http://www.xfce.org

[firefox]: https://www.mozilla.org
[firefox-doc-preferences]: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/A_brief_guide_to_Mozilla_preferences

<!-- github badges common -->

[badge-github-release]: https://badgen.net/github/release/accetto/ubuntu-vnc-xfce-g3?icon=github&label=release

[badge-github-release-date]: https://img.shields.io/github/release-date/accetto/ubuntu-vnc-xfce-g3?logo=github

<!-- docker badges specific -->

[badge-docker-pulls]: https://badgen.net/docker/pulls/accetto/ubuntu-vnc-xfce-firefox-g3?icon=docker&label=pulls

[badge-docker-stars]: https://badgen.net/docker/stars/accetto/ubuntu-vnc-xfce-firefox-g3?icon=docker&label=stars

<!-- Appendix -->
