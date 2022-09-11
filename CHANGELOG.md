# CHANGELOG

## Project `accetto/ubuntu-vnc-xfce-g3`

[Docker Hub][this-docker] - [Git Hub][this-github] - [Wiki][this-wiki] - [Discussions][this-discussions]

***

### Release 22.09

This is just a maintenance release.

- Warnings about the *README publishing not always working* problem have been added.
- Some comments have been updated.

### Release 22.04

- **noVNC** improvements

  - **noVNC** got a new optional argument, which is passed through a new environment variable **NOVNC_HEARTBEAT**
  
    - set the variable by creating the container, like `docker run -e NOVNC_HEARTBEAT=30` for the ping interval 30 seconds
    - it should prevent disconnections because of inactivity, if the container is used behind load-balancers or reverse proxies ([issue #23](https://github.com/accetto/ubuntu-vnc-xfce-g3/issues/23))

  - script `vnc_startup.rc` has been adjusted and improved
  - script `version_of.sh` has been adjusted
  - **numpy** module has been added to make the HyBi protocol faster

  - following variables related to **noVNC** has been renamed in all related files
    - `ARG_NO_VNC_PORT` renamed to `ARG_NOVNC_PORT`
    - `NO_VNC_HOME` renamed to `NOVNC_HOME`
    - `NO_VNC_PORT` renamed to `NOVNC_PORT`

### Release 22.02

- Updated components:

  - **TigerVNC** to version **1.12.0**
  - **noVNC** to version **1.3.0**
  - **websockify** to version **0.10.0**

- Added components:

  - **python3** (also added into the `verbose version sticker`)
  - **systemctl**

- Updated files:

  - `Dockerfile.xfce` (components updated and added)
  - `vnc_startup.rc` (new **noVNC** startup)
  - `version_of.sh` (**python3** included)
  - `version_sticker.sh` (**python3** included)
  - `env.rc` (handling of tags)
  - `util-readme.sh` (fixed token parsing)
  - all readme files

- Added files:

  - `local-builder-readme.md`

- Changes in building and publishing policy:

  - The images without **noVNC** will not be published on Docker Hub any more, because the size difference is now only 2MB. However, they always can be built locally.
  - The images tagged `latest` will always implement **VNC** and **noVNC**.
  - The Firefox image `latest` will not include the *Firefox plus features* now. They will be available in the Firefox image `latest-plus`.

### Release 22.01

- `Dockerfile.xfce` uses **TigerVNC** releases from **SourceForge** website

### Release 21.10

- `builder.sh` utility accepts additional parameters
- local building example updated

### Release 21.08

- `builder.sh` utility added
  - see also `local-building-example.md`

### Release 21.07

- Docker Hub has removed auto-builds from free plans since 2021-07-26, therefore
  - both GitHub Actions workflows `dockerhub-autobuild.yml` and `dockerhub-post-push.yml` have been disabled because they are not needed on free plans any more
    - just re-enable them if you are on a higher plan
  - **if you stay on the free plan**, then
    - you can still build the images locally and then push them to Docker Hub
      - pushing to Docker Hub is optional
      - just follow the added file `local-building-example.md`
    - you can publish the `readme` files to Docker Hub using the utility `util-readme.sh`
      - just follow the added file `examples-util-readme.md`
  - regularity of updates of images on Docker Hub cannot be guaranteed any more
- Other `Xfce4` related changes since the last release
  - keyboard layout explicit config added
  - `xfce4-terminal` set to unicode `utf-8` explicitly

### Release 21.05.3

- fix in script `release_of.sh`
  - because `wget` is not available on Docker Hub
- all images moved to `docker/doc/images`

### Release 21.05.2

- [Dockerfile stages diagram][this-diagram-dockerfile-stages] added
- script `release_of.sh` improved

### Release 21.05.1

- fix in `env.rc` hook script

### Release 21.05

- package **dconf-editor** has been removed

### Release 21.04

- TigerVNC from [Release Mirror on accetto/tigervnc][accetto-tigervnc-release-mirror] because **Bintray** is closing on 2021-05-01

### Release 21.03.1

- hook script `post_push` has been improved
  - environment variable `PROHIBIT_README_PUBLISHING` can be used to prevent the publishing of readme file to Docker Hub deployment repositories
  - useful for testing on Docker Hub or by building from non-default branches

### Release 21.03

- **Chromium** and **Firefox** web browsers are **image features** now
  - they are controlled by the following variables in the hook script `env.rc`:
    - `FEATURES_CHROMIUM`, `FEATURES_FIREFOX` and `FEATURES_FIREFOX_PLUS`
  - Dockerfiles `Dockerfile.xfce`, `Dockerfile.xfce.chromium`, `Dockerfile.xfce.firefox` have been merged into the file `Dockerfile.xfce`

- Both the **application user name** and the **sudo password** can be set independently from the **VNC password** now (in build-time)
  - build argument `ARG_HEADLESS_USER_NAME` sets the **application user name** and also the **home directory name**
  - build argument `ARG_SUDO_PW` sets the default application user's password, which is also the default `sudo` password

- Container startup scripts have been updated
  - startup scripts have been moved into `docker/src/xfce-startup`
  - script `set_user_permissions.sh` has been improved
    - file permissions are not set to `777` any more
    - different permissions are assigned in images built with the feature `FEATURES_USER_GROUP_OVERRIDE` (`fugo` tags)
  - script `user_generator.rc` has been improved
    - supports renaming the application user (build argument `ARG_HEADLESS_USER_NAME`)
  - script `vnc_startup.rc` has been improved
    - supports overriding VNC/noVNC parameters in run-time
  - all `version_sticker.sh` scripts have been merged into the file `docker/src/xfce-startup/version_sticker.sh`

- VNC/noVNC parameters, ports, password and DISPLAY can be overridden three ways now
  - **at image build-time** by setting the environment variables through build arguments:
    - `ARG_VNC_PW` sets the variable `VNC_PW` (VNV/noVNC password)
    - `ARG_VNC_DISPLAY` sets the variable `DISPLAY`
    - `ARG_VNC_PORT` sets the variable `VNC_PORT`
    - `ARG_VNC_RESOLUTION` sets the variable `VNC_RESOLUTION`
    - `ARG_VNC_COL_DEPTH` sets the variable `VNC_COL_DEPTH`
    - `ARG_VNC_VIEW_ONLY` set the variable `VNC_VIEW_ONLY`
    - `ARG_NO_VNC_PORT` sets the variable `NO_VNC_PORT`
  - **at container startup-time** by setting the above environment variables through the `docker run -e` options
  - **at VNC/noVNC startup-time** by setting the above environment variables through a mounted external file (see README for more information)
    - file `example-vnc-override.rc` has been added

- hook script `pre_build` has been improved
  - environment variable `PROHIBIT_BUILDING` can be used to prevent the building and publishing of the image unconditionally
  - it is useful for testing the auto-building on Docker Hub before release

- Other changes
  - Readme files significantly updated (long versions for GitHub)
  - `Mousepad` editor presets added
  - version sticker's desktop launcher got an icon
  - example files moved into `docker/src/examples`
  - embedded **readme** files introduced
    - base readme file got a desktop launcher
    - other readme files go into the application user's home directory
  - project [Discussions][this-discussions] introduced

- Updated versions:
  - Ubuntu **20.04.2**
  - Firefox **86.0**

### Release 21.02.1

- `dconf-editor` simple configuration storage system graphical editor added

### Release 21.02

- VNC password not enforced any more ([issue #6](https://github.com/accetto/ubuntu-vnc-xfce-g3/issues/6))
  - it can be disabled by `run -e VNC_PW=""`
  - readme files also updated

### Release 21.01

- **TigerVNC** switched from nightly builds (1.11.80) back to the latest release (1.11.0)

### Release 20.12.2

- **Chromium Browser** release auto-detection added

### Release 20.12.1

- Utility **util-readme.sh** for previewing and publishing README files from local computer has been added

### Release 20.12

- Initial release
  - **xfce** into [accetto/ubuntu-vnc-xfce-g3][accetto-ubuntu-vnc-xfce-g3]
  - **xfce-chromium** into [accetto/ubuntu-vnc-xfce-chromium-g3][accetto-ubuntu-vnc-xfce-chromium-g3]
  - **xfce-firefox** into [accetto/ubuntu-vnc-xfce-firefox-g3][accetto-ubuntu-vnc-xfce-firefox-g3]

***

[this-docker]: https://hub.docker.com/u/accetto/

[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/
[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki
[this-discussions]: https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[accetto-ubuntu-vnc-xfce-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-g3
[accetto-ubuntu-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3
[accetto-ubuntu-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3

[accetto-tigervnc-release-mirror]: https://github.com/accetto/tigervnc/releases
