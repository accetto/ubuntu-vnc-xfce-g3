# CHANGELOG

## Project `accetto/ubuntu-vnc-xfce-g3`

[User Guide][this-user-guide] - [Docker Hub][this-docker] - [Git Hub][this-github] - [Wiki][this-wiki] - [Discussions][this-discussions]

***

### Release 25.08

The way the `Firefox Browser` is installed has been changed, following the [official Mozilla recommendations](https://support.mozilla.org/en-US/kb/install-firefox-linux?as=u&utm_source=inproduct).
The current non-snap version is installed from the official Mozilla repository.
The previous Mozilla Team PPA repository is not used any more.

The warning `Some of Firefox's security features may offer less protection on your current operation system` should not come any more.

Note that the `Firefox Browser` in the image based on `Ubuntu 20.04` is also installed the same way.
Previously the `Firefox` version from the `Ubuntu 20.04` distribution has been used, which usually was not the current one.

Updated versions:

- `Firefox` to version **141.0.2** (in all images)

### Release 25.05.1

This is a maintenance release.

Updated versions:

- `TigerVNC` to version **1.15.0**
  - only in images based on `Ubuntu 24.04` (Noble Numbat)
  - avoid using an empty VNC password (environment variable `VNC_PW`) with this version

### Release 25.05 (G3v8)

This is the first `G3v8` release.
It fixes the badge service problem and brings some improvements in the building pipeline and utilities.
There are also updates and fixes of several [Wiki][this-wiki] pages.

The service **Badgen.net**, which was unreachable for some time already, has been replaced by the service [Shields.io][service-shields-io].

Consequently, all README files of all `accetto` [Generation 3][dashboard-dockerhub] repositories on the **Docker Hub**  had to be updated.

This is what you need to do in such case:

- Update all project files named `readme-append.template`
  - Replace the string `https://badgen.net/https/gist.` by the string `https://img.shields.io/endpoint?url=https://gist.`
  
- Use the utility script `util-readme.sh` from the project folder `/util` to generate the files `scrap-readme.md` for each repository.
The file `readme-util-readme-examples.md` describes the utility.

- Copy the content of the `scrap-readme.md` to the description page of the related repository on the **Docker Hub**.

  Note that you have to process the repositories one-by-one, because the same output file `scrap-readme.md` is overwritten each time the utility script is executed.

#### Changes in the building pipeline and utilities

- The updated hook script `post_push`, which updates the `deployment gists` on the **GitHub**, now extracts the badge values ad-hoc from the locally available images. Those can be just built locally or also pulled from the **Docker Hub**. There is no need to re-build them and to go through the `pre_build` phase just for updating the deployment gists. This change allows refreshing the gists using the "historical" data extracted from the previously published images.

- The actual gist update is implemented in the supporting hook script `util.rc`. The addition of up to 3 automatic retries has made the updating more reliable.

*Just a reminder:* Deployment gists are publicly accessible files on the **GitHub**, that contain values used for generating the badges for the README files, that are published on the **Docker Hub**.

The new functionality is available through the updated utility scripts `ci-builder.sh`, which has got the following new commands:

- `list`
- `pull`
- `update-gists`
- `helper-help`

The added hook script `helper` supports the new commands.

The updated utility `ci-builder.sh`can now accept also the Ubuntu version numbers as the blend values. For example, `24.04` instead of `latest` or `noble`, `22.04` instead of `jammy.` and `20.04` instead of `focal`.

Please check the file `readme-ci-builder.md` for more description.

The updated hook script `cache` checks if the shared `g3-cache` directory, which is defined by the environment variable `SHARED_G3_CACHE_PATH`, is reachable and writable.
The shared `g3-cache` update will be skipped otherwise.

#### Fixes

The hook script `pre_build` removes the helper images if there will be no `build` script call.
It's then, when the helper temporary file `scrap-demand-stop-building` is present.

### Release 25.04

Availability checking of the `wget` utility has been added.
The utility is used by the `cache` hook script for downloading of selected packages into the `g3-cache` folders.
It's generally not available on Windows environments by default.
You can install it or to build on an environment, where the utility is available (e.g. WSL or Linux).

The checking can be skipped by setting the environment variable `IGNORE_MISSING_WGET=1`.

The selected packages still will be downloaded into a temporary image layer, but not into the project's
`.g3-cache` folder nor the shared one, defined by the variable `SHARED_G3_CACHE_PATH`.

Other changes:

- The `ci-builder.sh` script's command `log get errors` now lists building errors and also warnings.

Updated components:

- `noVNC` to version **1.6.0**
- `websockify` to version **0.13.0**

### Release 25.03 (G3v7)

This is the first `G3v7` release, bringing an improved building pipeline.

The helper script `ci-builder.sh` can build final images significantly faster, because the temporary helper images are used as external caches.

Internally, the helper image is built by the `pre_build` hook script and then used by the `build` hook script.

The helper image is now deleted by the `build` hook script and not the `pre_build` hook script as before.

The `Dockerfiles` got a new metadata label `any.accetto.built-by="docker"`.

#### Remarks

If you would build a final image without building also the helper image (e.g. by executing `builder.sh latest build`), then there could be an error message about trying to remove the non-existing helper image.
You can safely ignore the message.

For example:

```shell
### The next line would build the helper image, but it was not executed.
#./build.sh latest pre_build

./build.sh latest build

### then somewhere near the end of the log
Removing helper image
Error response from daemon: No such image: accetto/headless-ubuntu-g3_latest-helper:latest
```

### Release 25.01

This is a maintenance release.

Updated components:

- `noVNC` to version **1.5.0**
- `websockify` to version **0.12.0**

#### Remarks about `xfce4-about`

The version of the currently running `Xfce4` can be checked by the utility `xfce4-about`.
It can be executed from the terminal window or by the start menu item `Applications/About Xfce`.

However, the utility requires the module `libGL.so.1`, which is excluded from some images, to keep them smaller.

The module can be added in running containers as follows:

```shell
sudo apt-get update
sudo install libgl1
```

### Release 24.09 (G3v6)

This is the first `G3v6` release, introducing the images based on `Ubuntu 24.04 LTS (Noble Numbat)`.
The previous version `G3v5` will still be available in this repository as the branch `archived-generation-g3v5`.

- default base of the `latest` images is now `Ubuntu 24.04 LTS (Noble Numbat)`
  - there is no `snap` included
  - `Firefox` is the latest non-snap version from the Mozilla Team PPA
  - `Chromium` is the latest non-snap version from the `Ubuntu 18.04 LTS` distribution
  - `latest` images will be doubled by the tags with the prefix `24.04`
- images based on `Ubuntu 22.04 LTS` will still be published
  - their tags will begin with the prefix `22.04`
- images based on `Ubuntu 20.04 LTS` will still be published
  - their tags will begin with the prefix `20.04`

Other changes:

- Default user `headless:headless (1000:1000)` has been changed to `headless:headless (1001:1001)`.
  - This change has been required for the images based on `Ubuntu 24.04 (Noble Numbat)`, because those already contain the user `ubuntu:ubuntu (1000:1000)`.
  - The same change has been done also in the images based on `Ubuntu 22.04 (Jammy Jellyfish)` and `Ubuntu 20.04 (Focal Fossa)` to keep them uniform.
- The directive `syntax=docker/dockerfile:experimental` has been removed from all Dockerfiles.
- The `noVNC` starting page has been updated in all images.
  - If no `noVNC Client` is selected, then the `Full Client` will start automatically in 10 seconds.
- The hook script `release_of` has been updated with the intention to report more helpful building errors.

Updated versions:

- **Ubuntu** to version **24.04**
- **jq** to version **1.7**
- **Mousepad** to version **0.6.1**
- **nano** to version **7.2**
- **Python** to version **3.12.3**

### Release 24.03 (G3v5)

This is the first `G3v5` release.

The updated script `set_user_permissions.sh`, which is part of Dockerfiles, skips the hidden files and directories now.
It generally should not have any unwanted side effects, but it may make a difference in some scenarios, hence the version increase.

### Release 23.12

This is a maintenance release.

- Updated Dockerfiles
  - file `.bashrc` is created earlier (stage `merge_stage_vnc`)
- Updated file `example-secrets.rc`
  - removed the initialization of the variables `FORCE_BUILDING` and `FORCE_PUBLISHING_BUILDER_REPO` (unset means `0`)
  - the variables are still used as before, but now they can be set individually for each building/publishing run
  
### Release 23.11

- Added file `$HOME/.bashrc` to all images.
It contains examples of custom aliases
  - `ll` - just `ls -l`
  - `cls` - clears the terminal window
  - `ps1` - sets the command prompt text

- Added more 'die-fast' error handling into the building and publishing scripts.
They exit immediately if the image building or pushing commands fail.

### Release 23.08.1

Main changes:

- hook scripts `env.rc`, `push` and `post_push` have been updated
- handling of multiple deployment tags per image has been improved and it covers also publishing into the builder repository now
  - also less image pollution by publishing
- file `readme-local-building-example.md` got a new section `Tips and examples`, containing
  - `How to deploy all images into one repository`
- fix in `ci-builder.sh` help mode
- readme files updated
- container screenshots replaced by animations

### Release 23.08

This release brings updated and significantly shortened README files, because most of the content has been moved into the new [User guide][this-user-guide].

### Release 23.07.1

This release brings some enhancements in the Dockerfiles and the script `user_generator.rc` with the aim to better support extending the images.

### Release 23.07

This release introduces a new feature `FEATURES_OVERRIDING_ENVV`, which controls the overriding or adding of environment variables at the container startup-time.
Meaning, after the container has already been created.

The feature is enabled by default.
It can be disabled by setting the variable `FEATURES_OVERRIDING_ENVV` to zero when the container is created or the image is built.
Be aware that any other value than zero, even if unset or empty, enables the feature.

If `FEATURES_OVERRIDING_ENVV=1`, then the container startup script will look for the file `$HOME/.override/.override_envv.rc` and source all the lines that begin with the string 'export ' at the first position and contain the '=' character.

The overriding file can be provided from outside the container using *bind mounts* or *volumes*.

The lines that have been actually sourced can be reported into the container's log if the startup parameter `--verbose` or `--debug` is provided.

This feature is an enhanced implementation of the previously available functionality known as **Overriding VNC/noVNC parameters at the container startup-time**.

Therefore this is a **breaking change** for the users that already use the VNC/noVNC overriding.
They need to move the content from the previous file `$HOME"/.vnc_override.rc` into the new file `$HOME/.override/.override_envv.rc`.

### Release 23.03.2

This release mitigates the problems with the edge use case, when users bind the whole `$HOME` directory to an external folder on the host computer.

Please note that I recommend to avoid doing that. If you really want to, then your best bet is using the Docker volumes. That is the only option I've found, which works across the environments. In the discussion thread [#39](https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions/39) I've described the way, how to initialize a bound `$HOME` folder, if you really want to give it a try.

Main changes:

- file `.initial_sudo_password` has been moved from the `$HOME` to the `$STARTUPDIR` folder
- file `.initial_sudo_password` is not deleted, but cleared after the container user is created
- startup scripts have been adjusted and improved
- readme files have been updated

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

### Release 23.02 (G3v4)

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

### Release 23.01 (G3v3)

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

### Release 22.11 (G3v2)

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

### Release 22.10 (G3v1)

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

[this-user-guide]: https://accetto.github.io/user-guide-g3/

[this-docker]: https://hub.docker.com/u/accetto/

[this-github]: https://github.com/accetto/ubuntu-vnc-xfce-g3/

[this-wiki]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki

[this-discussions]: https://github.com/accetto/ubuntu-vnc-xfce-g3/discussions

[this-diagram-dockerfile-stages]: https://raw.githubusercontent.com/accetto/ubuntu-vnc-xfce-g3/master/docker/doc/images/Dockerfile.xfce.png

[accetto-ubuntu-vnc-xfce-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-g3

[accetto-ubuntu-vnc-xfce-chromium-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-chromium-g3

[accetto-ubuntu-vnc-xfce-firefox-g3]: https://hub.docker.com/r/accetto/ubuntu-vnc-xfce-firefox-g3

[accetto-tigervnc-release-mirror]: https://github.com/accetto/tigervnc/releases

[service-shields-io]: https://shields.io/

[dashboard-dockerhub]: https://github.com/accetto/dashboard/blob/master/dockerhub-dashboard.md
