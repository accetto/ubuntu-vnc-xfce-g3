# Headless Ubuntu/Xfce container with VNC/noVNC and Chromium Browser

## accetto/ubuntu-vnc-xfce-chromium-g3

[User Guide][this-user-guide] - [Docker Hub][this-docker] - [Dockerfile][this-dockerfile] - [Readme][this-readme] - [Changelog][this-changelog]

***

This GitHub project folder contains resources used by building Ubuntu images available on Docker Hub in the repository [accetto/ubuntu-vnc-xfce-chromium-g3][this-docker].

The images contain the current Chromium Browser from the `Ubuntu 18.04 LTS` distribution.
This is because the versions for `Ubuntu 20.04 LTS and 22.04 LTS` depend on `snap`, which is currently not supported in Docker containers.

The [Chromium Browser][chromium] in these images runs in the `--no-sandbox` mode.
You should be aware of the implications.
The images are intended for testing and development.

There is also a sibling project [accetto/debian-vnc-xfce-g3][accetto-github-debian-vnc-xfce-g3] containing similar images based on [Debian][docker-debian].

This [User guide][this-user-guide] describes the images and how to use them.

This is the **third generation** (G3) of my headless images.
The **second generation** (G2) contains the GitHub repository [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc].
The **first generation** (G1) contains the GitHub repository [accetto/ubuntu-vnc-xfce][accetto-github-ubuntu-vnc-xfce].

### Building images

```shell
### PWD = project root
### prepare and source the 'secrets.rc' file first (see 'example-secrets.rc')

### examples of building and publishing the individual images 
./builder.sh latest-chromium all

### just building the image, skipping the publishing and the version sticker update
./builder.sh latest-chromium build

### examples of building and publishing the images as a group
./ci-builder.sh all group latest-chromium
```

Refer to the main [README][this-readme] file for more information about the building subject.

### Getting help

If you've found a problem or you just have a question, please check the [User guide][this-user-guide], [Issues][this-issues] and [Wiki][this-wiki] first.
Please do not overlook the closed issues.

If you do not find a solution, you can file a new issue.
The better you describe the problem, the bigger the chance it'll be solved soon.

If you have a question or an idea and you don't want to open an issue, you can also use the [Discussions][this-discussions].

### Diagrams

Diagram of the multi-staged Dockerfile used for building multiple images.

The actual content of a particular image build is controlled by the *feature variables*.

![Dockerfile.xfce stages][this-diagram-dockerfile-stages]

***

[this-user-guide]: https://accetto.github.io/user-guide-g3/

[this-readme]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/README.md

[this-changelog]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/CHANGELOG.md

[this-discussions]: https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions

[this-issues]: https://github.com/accetto/ubuntu-vnc-xfce-g3/issues

[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

[this-docker]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3/

[this-dockerfile]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.22-04

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[accetto-github-debian-vnc-xfce-g3]: https://github.com/accetto/debian-vnc-xfce-g3

[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/

[accetto-github-ubuntu-vnc-xfce]: https://github.com/accetto/ubuntu-vnc-xfce

[docker-debian]: https://hub.docker.com/_/debian/

[chromium]: https://www.chromium.org/Home
