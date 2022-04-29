# Headless Ubuntu/Xfce container with VNC/noVNC and Chromium Browser

## accetto/ubuntu-vnc-xfce-chromium-g3

[Docker Hub][this-docker] - [Git Hub][this-github] - [Dockerfile][this-dockerfile] - [Docker Readme][this-readme-dockerhub] - [Changelog][this-changelog] - [Project Readme][this-readme-project] - [Wiki][this-wiki] - [Discussions][this-discussions]

![badge-docker-pulls][badge-docker-pulls]
![badge-docker-stars][badge-docker-stars]
![badge-github-release][badge-github-release]
![badge-github-release-date][badge-github-release-date]

This repository contains resources for building Docker images based on [Ubuntu 20.04 LTS][docker-ubuntu] with [Xfce][xfce] desktop environment, [VNC][tigervnc]/[noVNC][novnc] servers for headless use and the current [Chromium][chromium] web browser.

### TL;DR

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
./docker/hooks/build dev latest-chromium
./docker/hooks/build dev vnc-chromium
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

- [Headless Ubuntu/Xfce container with VNC/noVNC and Chromium Browser](#headless-ubuntuxfce-container-with-vncnovnc-and-chromium-browser)
  - [accetto/ubuntu-vnc-xfce-chromium-g3](#accettoubuntu-vnc-xfce-chromium-g3)
    - [TL;DR](#tldr)
    - [Table of contents](#table-of-contents)
    - [Image tags](#image-tags)
    - [Ports](#ports)
    - [Volumes](#volumes)
    - [Version sticker](#version-sticker)
  - [Using headless containers](#using-headless-containers)
    - [Overriding VNC/noVNC parameters](#overriding-vncnovnc-parameters)
  - [Container user accounts](#container-user-accounts)
    - [Overriding container user parameters](#overriding-container-user-parameters)
  - [Running containers in background (detached)](#running-containers-in-background-detached)
  - [Running containers in foreground (interactively)](#running-containers-in-foreground-interactively)
  - [Startup options and help](#startup-options-and-help)
  - [Issues, Wiki and Discussions](#issues-wiki-and-discussions)
  - [Credits](#credits)
  - [Diagrams](#diagrams)
    - [Dockerfile.xfce](#dockerfilexfce)

This is the **third generation** (G3) of my headless images. The **second generation** (G2) of similar images is contained in the GitHub repositories [accetto/xubuntu-vnc][accetto-github-xubuntu-vnc] and [accetto/xubuntu-vnc-novnc][accetto-github-xubuntu-vnc-novnc]. The **first generation** (G1) of similar images is contained in the GitHub repository [accetto/ubuntu-vnc-xfce-chromium][accetto-github-ubuntu-vnc-xfce-chromium].

More information about the image generations can be found in the [project README][this-readme-project] file and in [Wiki][this-wiki].

**Remark:** This image contains the current `Chromium Browser` version from the `Ubuntu 18.04 LTS` distribution. This is because the version for `Ubuntu 20.04 LTS` depends on `snap`, which is not working correctly in Docker at this time.

**Attention:** The [Chromium Browser][chromium] in this image runs in the `--no-sandbox` mode. You should be aware of the implications. The image is intended for testing and development.

The main features and components of the images in the default configuration are:

- utilities **ping**, **wget**, **sudo** (Ubuntu distribution)
- current version of JSON processor [jq][jq]
- light-weight [Xfce][xfce] desktop environment (Ubuntu distribution)
- current version of high-performance [TigerVNC][tigervnc] server and client
- current version of [noVNC][novnc] HTML5 clients (full and lite) (TCP port **6901**)
- popular text editor [nano][nano] (Ubuntu distribution)
- lite but advanced graphical editor [mousepad][mousepad] (Ubuntu distribution)
- current version of [tini][tini] as the entry-point initial process (PID 1)
- support for overriding both the container user account and its group
- support of **version sticker** (see below)
- current version of [Chromium Browser][chromium] open-source web browser (from the `Ubuntu 18.04 LTS` distribution)

The history of notable changes is documented in the [CHANGELOG][this-changelog].

![container-screenshot][this-screenshot-container]

### Image tags

The following image tag on Docker Hub is regularly rebuilt:

- `latest` implements VNC and noVNC

Clicking on the version sticker badge in the [README on Docker Hub][this-readme-dockerhub] reveals more information about the actual configuration of the image.

### Ports

Following **TCP** ports are exposed by default:

- **5901** is used for access over **VNC**
- **6901** is used for access over [noVNC][novnc]

These default ports and also some other parameters can be overridden several ways (see bellow).

### Volumes

The containers do not create or use any external volumes by default.

Both **named volumes** and **bind mounts** can be used. More about volumes can be found in [Docker documentation][docker-doc] (e.g. [Manage data in Docker][docker-doc-managing-data]).

### Version sticker

Version sticker serves multiple purposes that are closer described in [Wiki][this-wiki]. Note that the usage of the version sticker has changed between the generations of images.

The **short version sticker value** describes the version of the image and it is persisted in its **label** during the build-time. It is also shown as its **badge** in the README file.

The **verbose version sticker value** is used by the CI builder to decide if the image needs to be refreshed. It describes the actual configuration of the essential components of the image. It can be revealed by clicking on the version sticker badge in the README file.

The version sticker values are generated by the script `version_sticker.sh`, which is deployed into the startup directory `/dockerstartup`. The script will show a short help if executed with the argument `-h`. There is also a convenient `Version Sticker` launcher on the container desktop.

## Using headless containers

There are two ways, how to use the containers created from this image.

All containers are accessible by a VNC viewer (e.g. [TigerVNC][tigervnc] or [TightVNC][tightvnc]).

The default `VNC_PORT` value is `5901`. The default `DISPLAY` value is `:1`. The default VNC password (`VNC_PW`) is `headless`.

The containers that are created from the images built with the **noVNC feature** can be also accessed over [noVNC][noVNC] by any web browser supporting HTML5.

The default `NOVNC_PORT` value is `6901`. The noVNC password is always identical to the VNC password.

There are several ways of connecting to headless containers and the possibilities also differ between the Linux and Windows environments, but usually it is done by mapping the VNC/noVNC ports exposed by the container to some free TCP ports on its host system.

For example, the following command would map the VNC/noVNC ports `5901/6901` of the container to the TCP ports `25901/26901` on the host:

```shell
docker run -p 25901:5901 -p 26901:6901 ...
```

If the container would run on the local computer, then it would be accessible over **VNC** as `localhost:25901` and over **noVNC** as `http://localhost:26901`.

If it would run on the remote server  `mynas`, then it would be accessible over **VNC** as `mynas:25901` and over **noVNC** as `http://mynas:26901`.

The image offers two [noVNC][novnc] clients - **lite client** and **full client**. Because the connection URL differs slightly in both cases, the container provides a **simple startup page**.

The startup page offers two hyperlinks for both noVNC clients:

- **noVNC Lite Client** (`http://mynas:26901/vnc_lite.html`)
- **noVNC Full Client** (`http://mynas:26901/vnc.html`)

It is also possible to provide the password through the links:

- `http://mynas:26901/vnc_lite.html?password=headless`
- `http://mynas:26901/vnc.html?password=headless`

### Overriding VNC/noVNC parameters

The VNC/noVNC parameters are controlled by related environment variables embedded into the image.

They have the following default values:

```shell
DISPLAY=:1
NOVNC_PORT=6901
VNC_COL_DEPTH=24
VNC_PORT=5901
VNC_PW=headless
VNC_RESOLUTION=1360x768
VNC_VIEW_ONLY=false
```

These environment variables can be overridden several ways.

**At image build-time** you can embed different default values by using the following build arguments:

- `ARG_VNC_PW` sets the variable `VNC_PW` (VNV/noVNC password)
- `ARG_VNC_DISPLAY` sets the variable `DISPLAY`
- `ARG_VNC_PORT` sets the variable `VNC_PORT`
- `ARG_VNC_RESOLUTION` sets the variable `VNC_RESOLUTION`
- `ARG_VNC_COL_DEPTH` sets the variable `VNC_COL_DEPTH`
- `ARG_VNC_VIEW_ONLY` set the variable `VNC_VIEW_ONLY`
- `ARG_NOVNC_PORT` sets the variable `NOVNC_PORT`

For example:

```shell
docker build --build-arg DISPLAY=:2 --build-arg ARG_VNC_PORT=6902  ...
```

**At container startup-time** you can override the environment variable values by using the `docker run -e` option. Please note that in this case you have to use the actual environment variable names, not the build argument names (e.g. `VNC_PORT` instead of `ARG_VNC_PORT`).

For example:

```shell
docker run -e VNC_PORT=6902 ...
```

**At VNC/noVNC startup-time** you can override the environment variable values by binding an external file exporting the variables to the dedicated mounting point `${HOME}/.vnc_override.rc` (a single file, not a directory).

For example, the following command would bind the file `my_own_vnc_parameters.rc` from the directory `/home/joe` to the container:

```shell
docker run -v /home/joe/my_own_vnc_parameters.rc:/home/headless/.vnc_override.rc
```

The content of the file should be similar to the provided example file `example-vnc-override.rc`:

```shell
### only lines beginning with 'export ' (at position 1) will be imported and sourced
;export VNC_COL_DEPTH=32
;export VNC_VIEW_ONLY=true
;export VNC_PW=secret
export VNC_RESOLUTION=1024x768
export DISPLAY=:2
export VNC_PORT=5902
export NOVNC_PORT=6902
;export NOVNC_HEARTBEAT=25
```

Please note that only the lines beginning with `export` at the first position will be imported.

By providing the variable values the following rules apply:

- The value of `ARG_VNC_DISPLAY/VNC_DISPLAY` should include also the leading colon (e.g. `:1`).
- The value of `ARG_VNC_PW/VNC_PW` can be empty. It effectively disables the VNC/noVNC password.

If you want to check, what parameter values have been actually applied, then you can start the container with the parameter `--debug`.

For example:

```shell
docker run -it -P --rm accetto/ubuntu-vnc-xfce-g3:latest --debug

### output (excerpt)
VNC server started on display ':1' and TCP port '5901'
Connect via VNC viewer with 172.17.0.3:5901
noVNC started on TCP port '6901'
```

You should be aware, that overriding the VNC/noVNC parameters incorrectly could prevent the container from starting.

This feature assumes some preliminary knowledge and it is provided for advanced users that already know what they want to achieve.

For example, by default there is a relation between the `DISPLAY` and `VNC_PORT` values. Generally the convention `VNC_PORT = 5900 + DISPLAY` is followed (similarly `NOVNC_PORT = 6900 + DISPLAY`).

You may decide not to follow the conventions. This image allows you to set the parameters differently, but again, you should know, what you are doing.

Be also aware, that there are differences between the Linux and Windows environments.

If your session disconnects, it might be related to a network equipment (load-balancer, reverse proxy, ...) dropping the websocket session for inactivity (more info [here](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_read_timeout) and [here](https://nginx.org/en/docs/http/websocket.html) for nginx). In such case, try defining the **NOVNC_HEARTBEAT=XX** environment variable at startup-time, where **XX** is the number of seconds between [websocket ping/pong](https://github.com/websockets/ws/issues/977) packets.

## Container user accounts

Containers created from this image run under the **application user** (by default **headless**, **1001:0**), which is a **non-root** user account.

The default application user password is **headless**, which is also the default **sudo** password.

The application user name also defines the **home directory name**, which is by default `/home/headless`.

The user password can be changed in run-time (inside the container) by using the command `passwd`.

The `sudo` command allows user elevation, so the **application user** can install additional software in the container.

The following example shows how to install **git**:

```shell
sudo apt-get update
sudo apt-get install -y git
```

Note that the **application user account** is a member of the **root user group** (group zero), but it does not get the privileges of the **root** user automatically. Please check the Docker documentation for more information.

### Overriding container user parameters

The container user parameters are controlled by related environment variables embedded into the images.

**At image build-time** you can change the default values embedded into the image by using the following build arguments:

- The build argument `ARG_HEADLESS_USER_NAME` sets the **application user name** and the **home directory name**.

- The build argument `ARG_SUDO_PW` sets the **application user password**, which is also the **sudo password**.

For example:

```shell
docker build --build-arg ARG_HEADLESS_USER_NAME=joe --build-arg ARG_SUDO_PW=secret ...
```

Please do not confuse the application user password with the VNC password, because they both have the same value by default (**headless**).

**At container startup-time** you can override the container user ID by using the `docker run --user` option:

```shell
docker run --user 2019 ...
```

Note that only numerical ID values are supported. Please check the Docker documentation for more information.

This image allows you to override also the container user **group ID**. However, the image must be built with the build argument `ARG_SUPPORT_USER_GROUP_OVERRIDE` for such use case.

Otherwise the following command would fail:

```shell
### This will fail (Permission denied)
docker run -it -P --rm --user 2019:2000 accetto/ubuntu-vnc-xfce-g3:latest

### This will work (image has been built with ARG_SUPPORT_USER_GROUP_OVERRIDE)
docker run -it -P --rm --user 2019:2000 accetto/ubuntu-vnc-xfce-g3:latest-fugo
```

The images having the tag suffix `-fugo` (**f**eatures **u**ser **g**roup **o**verride) are built with the build argument `ARG_SUPPORT_USER_GROUP_OVERRIDE`.

Note that only numerical `ID:GID` values are supported. Please check the Docker documentation for more information.

**Remark**: The possibility to override the container user **group ID** is available also for this image, but the `fugo` tags are currently not published by default. You can set the variable `FEATURES_USER_GROUP_OVERRIDE` in the hook script `env.rc` and build them yourself.

## Running containers in background (detached)

The following container will keep running in the background and it will listen on an automatically selected TCP port on the host computer:

```shell
docker run -d -P accetto/ubuntu-vnc-xfce-chromium-g3:latest
```

The following container will listen on the host's TCP port **25901**:

```shell
docker run -d -p 25901:5901 accetto/ubuntu-vnc-xfce-chromium-g3:latest
```

The following container will create (or re-use) the local named volume **my\_Downloads** mounted as `/home/headless/Downloads`:

```shell
docker run -d -P -v my_Downloads:/home/headless/Downloads accetto/ubuntu-vnc-xfce-chromium-g3:latest
```

or using the newer syntax with **--mount** flag:

```shell
docker run -d -P --mount source=my_Downloads,target=/home/headless/Downloads accetto/ubuntu-vnc-xfce-chromium-g3:latest
```

## Running containers in foreground (interactively)

The following container can be used interactively:

```shell
docker run -it --rm accetto/ubuntu-vnc-xfce-chromium-g3:latest bash
```

The opened `bash` session can be used as usual and then closed by entering `^C` (CTRL-C):

```shell
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

headless@cf4a4e01d94b:~$ whoami
headless
headless@cf4a4e01d94b:~$ pwd
/home/headless
headless@cf4a4e01d94b:~$
```

The container will remove itself.

## Startup options and help

The image supports multiple **start-up options** and **start-up modifiers**. There also also two help modes.

The following container will print out the short help and then it will remove itself:

```shell
docker run --rm accetto/ubuntu-vnc-xfce-chromium-g3:latest --help
```

Example of the short help text:

```text
Container startup script
Usage: /dockerstartup/startup.sh [-v|--version] [-h|--help] [-H|--help-usage] [--(no-)wait] [--(no-)skip-startup] [--(no-)tail-null] [--(no-)tail-vnc] [--(no-)version-sticker] [--(no-)version-sticker-verbose] [--(no-)skip-vnc] [--(no-)skip-novnc] [--(no-)debug] [--(no-)verbose] [--] [<command-1>] ... [<command-n>] ...
        <command>: Optional command with optional arguments. It is executed during startup.
        -v, --version: Prints version
        -h, --help: Prints help
        -H, --help-usage: Extended container usage help.
        --wait, --no-wait: Default background execution mode (on by default)
        --skip-startup, --no-skip-startup: Default foreground execution mode (off by default)
        --tail-null, --no-tail-null: Alternative background execution mode (off by default)
        --tail-vnc, --no-tail-vnc: Alternative background execution mode (off by default)
        --version-sticker, --no-version-sticker: Alternative foreground execution mode (off by default)
        --version-sticker-verbose, --no-version-sticker-verbose: Alternative foreground execution mode (off by default)
        --skip-vnc, --no-skip-vnc: Startup process modifier (off by default)
        --skip-novnc, --no-skip-novnc: Startup process modifier (off by default)
        --debug, --no-debug: Startup process modifier (off by default)
        --verbose, --no-verbose: Startup process modifier (off by default)

Use '-H' or '--help-usage' for extended container usage help.
For more information visit https://github.com/accetto/ubuntu-vnc-xfce-g3
```

The following container will print out the long help and then it will remove itself:

```shell
docker run --rm accetto/ubuntu-vnc-xfce-chromium-g3:latest --help-usage
```

Example of the long help text:

```text
CONTAINER USAGE:
docker run [<docker-run-options>] accetto/<image>:<tag> [<startup-options>] [<command>]

POSITIONAL ARGUMENTS:
command
    Optional command with optional arguments.
    It will be executed during startup before going waiting, tailing or asleep.
    It is necessary to use the quotes correctly or the 'bash -c "<command>"' pattern.

STARTUP OPTIONS:

--wait, or no options, or unknown option, or empty input
    Default background execution mode.
    Starts the VNC and noVNC servers, if available, then executes the command
    and waits until the VNC server process exits or goes asleep infinitely.
    Container keeps running in the background.

--skip-startup
    Default foreground execution mode.
    Skips the startup procedure, executes the command and exits.
    Be aware that the container user generator will be also skipped.
    Container does not keep running in the background.

--tail-null
    Alternative background execution mode.
    Similar to '--wait', but tails the null device instead of going asleep.
    Container keeps running in the background.

--tail-vnc
    Alternative background execution mode.
    Similar to '--wait', but tails the VNC log instead of waiting until the VNC process exits.
    Falls back to '--tail-null' if the VNC server has not been started.
    Container keeps running in the background.

--version-sticker
    Alternative foreground execution mode.
    Prints out the version sticker info.
    The VNC server is also started by default, if available, because some applications
    need a display to report their versions correctly. It can be suppressed by providing
    also '--skip-vnc'. The '--skip-novnc' option is always enforced automatically.
    Container does not keep running in the background.

--version-sticker-verbose
    Alternative foreground execution mode.
    Similar to '--version-sticker', but prints out the verbose version sticker info and features list.
    Container does not keep running in the background.

--skip-vnc
    Startup process modifier.
    If VNC and noVNC startup should be skipped.
    It also enforces '--skip-novnc'.

--skip-novnc
    Startup process modifier.
    If noVNC startup should be skipped.
    It is also enforced by '--skip-vnc'.

--debug
    Startup process modifier.
    If additional debugging info should be displayed during startup.
    It also enforces option '--verbose'.

--verbose
    Startup process modifier.
    If startup progress messages should be displayed.
    It is also enforced by '--debug'.

--help-usage, -H
    Prints out this extended container usage help and exits.
    The rest of the input is ignored.

--help, -h
    Prints out the short startup script help and exits.
    The rest of the input is ignored.

--version, -v
    Prints out the version of the startup script and exits.
    The rest of the input is ignored.

Use '-h' or '--help' for short startup script help.
Fore more information visit https://github.com/accetto/ubuntu-vnc-xfce-g3
```

## Issues, Wiki and Discussions

If you have found a problem or you just have a question, please check the [Issues][this-issues] and the [Wiki][this-wiki] first. Please do not overlook the closed issues.

If you do not find a solution, you can file a new issue. The better you describe the problem, the bigger the chance it'll be solved soon.

If you have a question or an idea and you don't want to open an issue, you can use the [Discussions][this-discussions].

## Credits

Credit goes to all the countless people and companies, who contribute to open source community and make so many dreamy things real.

## Diagrams

### Dockerfile.xfce

![Dockerfile.xfce stages][this-diagram-dockerfile-stages]

***

<!-- GitHub project common -->

[this-changelog]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/CHANGELOG.md
[this-discussions]: https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions
[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/
[this-issues]: https://github.com/accetto/ubuntu-vnc-xfce-g3/issues
[this-readme-dockerhub]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3
[this-readme-project]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/README.md
[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

<!-- Docker image specific -->

[this-docker]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3/
[this-dockerfile]: https://github.com/accetto/ubuntu-vnc-xfce-g3/blob/master/docker/Dockerfile.xfce.chromium

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[this-screenshot-container]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/ubuntu-vnc-xfce-chromium.jpg

<!-- Previous generations -->

[accetto-github-xubuntu-vnc]: https://github.com/accetto/xubuntu-vnc/
[accetto-github-xubuntu-vnc-novnc]: https://github.com/accetto/xubuntu-vnc-novnc/
[accetto-github-ubuntu-vnc-xfce-chromium]: https://github.com/accetto/ubuntu-vnc-xfce-chromium

<!-- External links -->

[docker-ubuntu]: https://hub.docker.com/_/ubuntu/

[docker-doc]: https://docs.docker.com/
[docker-doc-managing-data]: https://docs.docker.com/storage/

[ubuntu-packages-search]: https://packages.ubuntu.com/

[jq]: https://stedolan.github.io/jq/
[mousepad]: https://github.com/codebrainz/mousepad
[nano]: https://www.nano-editor.org/
[novnc]: https://github.com/kanaka/noVNC
[tigervnc]: http://tigervnc.org
[tightvnc]: http://www.tightvnc.com
[tini]: https://github.com/krallin/tini
[xfce]: http://www.xfce.org

[chromium]: https://www.chromium.org/Home

<!-- github badges common -->

[badge-github-release]: https://badgen.net/github/release/accetto/ubuntu-vnc-xfce-g3?icon=github&label=release

[badge-github-release-date]: https://img.shields.io/github/release-date/accetto/ubuntu-vnc-xfce-g3?logo=github

<!-- docker badges specific -->

[badge-docker-pulls]: https://badgen.net/docker/pulls/accetto/ubuntu-vnc-xfce-chromium-g3?icon=docker&label=pulls

[badge-docker-stars]: https://badgen.net/docker/stars/accetto/ubuntu-vnc-xfce-chromium-g3?icon=docker&label=stars
