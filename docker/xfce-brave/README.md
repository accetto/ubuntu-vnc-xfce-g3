# Headless Ubuntu/Xfce container with VNC/noVNC and Brave Browser

## accetto/ubuntu-vnc-xfce-brave-g3

[User Guide][this-user-guide] - [Docker Hub][this-docker] - [Dockerfile][this-dockerfile] - [Readme][this-readme] - [Changelog][this-changelog]

***

This GitHub project folder contains resources used by building Ubuntu images available on Docker Hub in the repository [accetto/ubuntu-vnc-xfce-brave-g3][this-docker].

This [User guide][this-user-guide] describes the images and how to use them.

### Building images

```shell
### PWD = project root
### prepare and source the 'secrets.rc' file first (see 'example-secrets.rc')

### examples of building and publishing the individual images 
./builder.sh latest-brave all

### just building the image, skipping the publishing and the version sticker update
./builder.sh latest-brave build

### examples of building and publishing the images as a group
./ci-builder.sh all group latest-brave
```

Refer to the main [README][this-readme] file for more information about the building subject.

### Remarks

There is also a sibling project [accetto/debian-vnc-xfce-g3][accetto-github-debian-vnc-xfce-g3] containing similar images based on [Debian][docker-debian].

This is the **third generation** (G3) of my headless images.
The **second generation** (G2) contains the GitHub repository [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc].
The **first generation** (G1) contains the GitHub repository [accetto/ubuntu-vnc-xfce][accetto-github-ubuntu-vnc-xfce].

The images contain the current Brave Browser from the official `Brave` distribution.

The [Brave Browser][brave] in these images runs in the `--no-sandbox` mode.
You should be aware of the implications.
The images are intended for testing and development.

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

[this-docker]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-brave-g3/

[this-dockerfile]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.24-04

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[accetto-github-debian-vnc-xfce-g3]: https://github.com/accetto/debian-vnc-xfce-g3

[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/

[accetto-github-ubuntu-vnc-xfce]: https://github.com/accetto/ubuntu-vnc-xfce

[docker-debian]: https://hub.docker.com/_/debian/

<!-- [chromium]: https://www.chromium.org/Home -->
[brave]: https://www.brave.com/
