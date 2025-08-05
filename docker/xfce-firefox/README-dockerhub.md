# Headless Ubuntu/Xfce container with VNC/noVNC and Firefox browser

## accetto/ubuntu-vnc-xfce-firefox-g3

[User Guide][this-user-guide] - [GitHub][this-github] - [Dockerfile][this-dockerfile] - [Readme][this-readme-full] - [Changelog][this-changelog]

<!-- markdownlint-disable MD038 MD052 -->
![badge-github-release][badge-github-release]` `
![badge-docker-pulls][badge-docker-pulls]` `
![badge-docker-stars][badge-docker-stars]

***

This Docker Hub repository contains Docker images for headless working.

The images are based on [Ubuntu 24.04, 22.04 and 20.04 LTS][docker-ubuntu] and include [Xfce][xfce] desktop, [TigerVNC][tigervnc] server and [noVNC][novnc] client.
The popular web browser [Firefox][firefox] is also included.

This [User guide][this-user-guide] describes the images and how to use them.

The related [GitHub project][this-github] contains image generators that image users generally don’t need, unless they want to build the images themselves.

### Tags

The following image tags are regularly built and published on Docker Hub:

- `latest` (also as `24.04`) based on `Ubuntu 24.04 LTS`

    ![badge_latest_created][badge_latest_created]` `[![badge_latest_version-sticker][badge_latest_version-sticker]][link_latest_version-sticker-verbose]

- `22.04` based on `Ubuntu 22.04 LTS`

    ![badge_22-04_created][badge_22-04_created]` `[![badge_22-04_version-sticker][badge_22-04_version-sticker]][link_22-04_version-sticker-verbose]

- `20.04` based on `Ubuntu 20.04 LTS`

    ![badge_20-04_created][badge_20-04_created]` `[![badge_20-04_version-sticker][badge_20-04_version-sticker]][link_20-04_version-sticker-verbose]

<!-- markdownlint-enable MD052 -->

**Hint:** Clicking the version sticker badge reveals more information about the particular build.

### Features

The main features and components of the images in the default configuration are:

- lightweight [Xfce][xfce] desktop environment (Ubuntu distribution)
- [sudo][sudo] support
- current version of JSON processor [jq][jq]
- current version of high-performance [TigerVNC][tigervnc] server and client
- current version of [noVNC][novnc] HTML5 clients (full and lite) (TCP port **6901**)
- popular text editor [nano][nano] (Ubuntu distribution)
- lite but advanced graphical editor [mousepad][mousepad] (Ubuntu distribution)
- current version of [tini][tini] as the entry-point initial process (PID 1)
- support for overriding environment variables, VNC parameters, user and group (see [User guide][this-user-guide-using-containers])
- support of **version sticker** (see [User guide][this-user-guide-version-sticker])
- [Firefox][firefox] web browser, current non-snap version from the official Mozilla repository
- additional **Firefox plus** feature (see [User guide][this-user-guide-firefox-plus])

The following **TCP** ports are exposed by default:

- **5901** for access over **VNC** (using VNC viewer)
- **6901** for access over [noVNC][novnc] (using web browser)

![container-screenshot][this-screenshot-container]

### Remarks

There is also a similar sibling image [accetto/debian-vnc-xfce-firefox-g3][accetto-dockerhub-debian-vnc-xfce-firefox-g3] based on [Debian][docker-debian].

This is the **third generation** (G3) of my headless images.
The **second generation** (G2) contains the GitHub repository [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc].
The **first generation** (G1) contains the GitHub repository [accetto/ubuntu-vnc-xfce][accetto-github-ubuntu-vnc-xfce].

The [Firefox][firefox] installed in the images based on `Ubuntu 24.04 and 22.04 LTS` is the current non-snap version from the Mozilla Team PPA.
It's because the `Ubuntu 24.04 and 22.04 LTS` distribution contains only the `snap` version and the `snap` is currently not supported in Docker containers.

### Getting help

If you've found a problem or you just have a question, please check the [User guide][this-user-guide], [Issues][this-issues] and [Wiki][this-wiki] first.
Please do not overlook the closed issues.

If you do not find a solution, you can file a new issue.
The better you describe the problem, the bigger the chance it'll be solved soon.

If you have a question or an idea and you don't want to open an issue, you can also use the [Discussions][this-discussions].

***

[this-user-guide]: https://accetto.github.io/user-guide-g3/

[this-user-guide-version-sticker]: https://accetto.github.io/user-guide-g3/version-sticker/

[this-user-guide-using-containers]: https://accetto.github.io/user-guide-g3/using-containers/

[this-user-guide-firefox-plus]: https://accetto.github.io/user-guide-g3/firefox-plus/

[this-changelog]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/CHANGELOG.md

[this-discussions]: https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions

[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/

[this-issues]: https://github.com/accetto/ubuntu-vnc-xfce-g3/issues

[this-readme-full]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/xfce-firefox/README.md

[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

[this-dockerfile]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.24-04

[this-screenshot-container]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/animation-ubuntu-vnc-xfce-firefox-g3.gif

[accetto-dockerhub-debian-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/debian-vnc-xfce-firefox-g3

[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/

[accetto-github-ubuntu-vnc-xfce]: https://github.com/accetto/ubuntu-vnc-xfce

[docker-ubuntu]: https://hub.docker.com/_/ubuntu/
[docker-debian]: https://hub.docker.com/_/debian/

[jq]: https://stedolan.github.io/jq/
[mousepad]: https://github.com/codebrainz/mousepad
[nano]: https://www.nano-editor.org/
[novnc]: https://github.com/kanaka/noVNC
[sudo]: https://www.sudo.ws/
[tigervnc]: http://tigervnc.org
[tini]: https://github.com/krallin/tini
[xfce]: http://www.xfce.org

[firefox]: https://www.mozilla.org

[badge-github-release]: https://img.shields.io/github/v/release/accetto/ubuntu-vnc-xfce-g3

[badge-docker-pulls]: https://img.shields.io/docker/pulls/accetto/ubuntu-vnc-xfce-firefox-g3

[badge-docker-stars]: https://img.shields.io/docker/stars/accetto/ubuntu-vnc-xfce-firefox-g3

<!-- Appendix will be added by util-readme.sh -->
