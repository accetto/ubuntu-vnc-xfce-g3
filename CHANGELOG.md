# CHANGELOG

## Project `accetto/ubuntu-vnc-xfce-g3`

[Docker Hub][this-docker] - [Git Hub][this-github] - [Wiki][this-wiki] - [Discussions][this-discussions]

***

### Release 23.03.1

This is a maintenance release aiming to improve the scripts and documentation.

### Release 23.03

- updated with `TigerVNC 1.13.1` bugfix release
- also some updates in readme files

### Release 23.02.1

Features `NOVNC` and `FIREFOX_PLUS`, that are enabled by default, can be disabled via environment variables:

- If `FEATURES_NOVNC="0"`, then
  - image will not include `noVNC`
  - image tag will get the `-vnc` suffix (e.g. `latest-vnc`, `20.04-firefox-vnc` etc.)
- If `FEATURES_FIREFOX_PLUS="0"` and `FEATURES_FIREFOX="1"`, then
  - image with Firefox will not include the *Firefox Plus features*
  - image tag will get the `-default` suffix (e.g. `latest-firefox-default` or also `latest-firefox-default-vnc` etc.)

### Release 23.02

This is the first `G3v4` release, introducing the updated startup scripts.  The previous version `G3v3` will still be available in this repository as the branch `archived-generation-g3v3`.

- The updated startup scripts that support overriding the user ID (`id`) and group ID (`gid`) without needing the former build argument `ARG_FEATURES_USER_GROUP_OVERRIDE`, which has been removed.
- The user ID and the group ID can be overridden during the build time (`docker build`) and the run time (`docker run`).
- The `user name`, the `group name` and the `initial sudo password` can be overridden during the build time.
- The permissions of the files `/etc/passwd` and `/etc/groups` are set to the standard `644` after creating the user.
- The content of the home folder and the startup folder belongs to the created user.
- The created user gets permissions to use `sudo`. The initial `sudo` password is configurable during the build time using the build argument `ARG_SUDO_INITIAL_PW`. The password can be changed inside the container.
- The default `id:gid` has been changed from `1001:0` to `1000:1000`.

Changes in build arguments:

- removed `ARG_FEATURES_USER_GROUP_OVERRIDE` and `ARG_HOME_OWNER`
- renamed `ARG_SUDO_PW` to `ARG_SUDO_INITIAL_PW`
- added `ARG_HEADLESS_USER_ID`, `ARG_HEADLESS_USER_NAME`, `ARG_HEADLESS_USER_GROUP_ID` and `ARG_HEADLESS_USER_GROUP_NAME`

Changes in environment variables:

- removed `FEATURES_USER_GROUP_OVERRIDE`
- added `HEADLESS_USER_ID`, `HEADLESS_USER_NAME`, `HEADLESS_USER_GROUP_ID` and `HEADLESS_USER_GROUP_NAME`

Main changes in files:

- updated `Dockerfile.xfce.22-04` and `Dockerfile.xfce.20-04`
- updated `startup.sh`, `user_generator.rc` and `set_user_permissions.sh`
- updated hook scripts `env.rc`, `build`, `pre_build` and `util.rc`
- updated `ci-builder.sh`
- added `tests/test-01.sh` allows to quickly check the current permissions

Updated versions:

- **TigerVNC** to version `1.13.0`
- **noVNC** to version `1.4.0`

### Release 23.01

This is the first `G3v3` release, introducing the images based on `Ubuntu 22.04 LTS`. The previous version `G3v2` will still be available in this repository as the branch `archived-generation-g3v2`.

Changes in deployment:

- default base of the `latest` images is now `Ubuntu 22.04 LTS`
  - there is no `snap` included
  - `Firefox` is the latest non-snap version from the Mozilla Team PPA
  - `Chromium` is the latest version from the `Ubuntu 18.04 LTS` distribution
  - `latest` images will be doubled by the tags with the prefix `22.04`
- images based on `Ubuntu 20.04 LTS` will still be published
  - their tags will begin with the prefix `20.04`
- image `accetto/ubuntu-vnc-xfce-g3:latest-fugo` will not be published any more (it can still be built manually)
- image `accetto/ubuntu-vnc-xfce-firefox-g3:latest-plus`, containing the **Firefox Plus Features**, becomes the `latest` image now
  - previous `latest` image without the **Firefox Plus Features** will not be published any more (it can still be built manually)

Support of additional building parameters:

- script `builder.sh` passes the additional building parameters, that come after the mandatory ones, to the hook scripts
- script `hooks/build` can use the `--target <stage>` parameter for building particular Dockerfile stages
- script hooks/pre_build removes the `--target <stage>` parameter and always processes all Dockerfile stages
- see `readme-local-building-example.md` for more information

Other changes and improvements:

- `Dockerfiles.xfce` renamed to `Dockerfiles.xfce.20-04` and improved
- `Dockerfiles.xfce.22-04` added
- script `hooks/env.rc` updated
  - `noVNC` is always included in all images
  - Firefox **plus** features always included in Firefox images
- scripts `builder.sh` and `ci-builder.sh` have been updated
- most readme files have been updated

### Release 22.12.1

- Updated components:

  - **websockify** to version **0.11.0**

### Release 22.12

This is a maintenance release.

- README files have been updated
- Folder `examples/` has been moved up to the project's root folder
  - New example `Dockerfile.extended` shows how to use the images as the base of new images
  - New compose file `example.yml` shows how to switch to another non-root user and how to set the VNC password and resolution

### Release 22.11.1

This is a quick fix release, because `Chromium Browser` has changed its package naming pattern.

### Release 22.11 (Milestone)

This is a milestone release. It's the first release of the new building pipeline version `G3v2`. The previous version `G3v1` will still be available in this repository as the branch `archived-generation-g3v1`.

The version `G3v2` brings the following major changes:

- Significantly improved building performance by introducing a local cache (`g3-cache`).
- Auto-building on the **Docker Hub** and using of the **GitHub Actions** have been abandoned.
- The enhanced building pipeline moves towards building the images outside the **Docker Hub** and aims to support also stages with CI/CD capabilities (e.g. **GitLab**).
- The **local stage** is the default building stage. The new building pipeline has already been tested also with a local **GitLab** installation in a Docker container on a Linux machine.
- Automatic publishing of README files to the **Docker Hub** has been removed, because it hasn't work properly any more. However, the README files can be still prepared with the provided utility and then copy-and-pasted to the **Docker Hub** manually.

Added files:

- `docker/hooks/cache`
- `ci-builder.sh`
- `readme-builder.md`
- `readme-ci-builder.md`
- `readme-g3-cache.md`
- `readme-local-building-example.md`
- `utils/readme-util-readme-examples.md`

Removed files:

- `local-builder-readme.md`
- `local-building-example.md`
- `utils/example-secrets-utils.rc`
- `utils/examples-util-readme.md`
- `.github/workflows/dockerhub-autobuild.yml`
- `.github/workflows/dockerhub-post-push.yml`
- `.github/workflows/deploy-readme.sh`

Many other files have been updated, some of them significantly.

Hoverer, the changes affect only the building pipeline, not the Docker images themselves. The `Dockerfile`, apart from using the new local `g3-cache`, stays conceptually unchanged.

### Release 22.10 (Milestone)

This is the last release of the current building pipeline generation `G3v1`, which will still be available in the repository as the branch `archived-generation-g3v1`.

The next milestone release will bring some significant changes and improvements in the building pipeline (generation `G3v2`) . The changing parts marked as `DEPRECATED` will be replaced or removed.

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
