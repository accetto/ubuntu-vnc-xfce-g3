# Custom `g3-cache`

- [Custom `g3-cache`](#custom-g3-cache)
  - [Introduction](#introduction)
  - [Local `g3-cache`](#local-g3-cache)
  - [Shared g3-cache](#shared-g3-cache)
  - [Helper script `cache`](#helper-script-cache)

## Introduction

The custom `g3-cache` has been introduced in the **second version** (G3v2) of the project.

The local `g3-cache` is an additional cache used by the building pipeline and it should not be confused with the **Docker builder cache** maintained by the [Docker Build][docker-doc-docker-build] itself.

The `g3-cache`stores the selected pre-downloaded packages used by the Dockerfiles, that would be otherwise repeatedly downloaded from the external sources by each build.

It results in a significantly higher performance by building sets of images or by repeated builds.

You can learn more about the concept on the Wiki page ["Concepts of `g3-cache`"][this-wiki-concepts-of-g3-cache] and about the implementation on the Wiki page ["How `g3-cache` works"][this-wiki-how-g3-cache-works].

## Local `g3-cache`

The local `g3-cache` of this project has the following **cache sections**:

- `chromium`
- `novnc`
- `tigervnc`
- `websockify`

The local `g3-cache` folder `docker/.g3-cache` is excluded from the commits into the `git` repository by the means of the `.gitignore` file.

You can delete the local `g3-cache` folder any time, because it will be re-created each time you build an image.

## Shared g3-cache

The absolute path to the root folder of the shared `g3-cache` should be set as the value of the environment variable `SHARED_G3_CACHE_PATH`.

The same shared `g3-cache` is usually used also by the sibling projects [accetto/headless-drawing-g3][accetto-github-headless-drawing-g3] and [accetto/headless-coding-g3][accetto-github-headless-coding-g3].

## Helper script `cache`

Both `g3-caches` are refreshed by the helper script `cache`, which is stored in the folder `docker/hooks/`. Therefore it's sometimes referenced as a hook script.

The script is used by the hook scripts `pre_build` and `build`. However, it can be executed also stand-alone.

**Remark**: The current implementation of the cache refreshing code is not thread safe and it is not intended for parallel building of multiple images.

***

[this-wiki-concepts-of-g3-cache]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki/Concepts-of-g3-cache
[this-wiki-how-g3-cache-works]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki/How-g3-cache-works

[accetto-github-headless-coding-g3]:https://github.com/accetto/headless-coding-g3
[accetto-github-headless-drawing-g3]: https://github.com/accetto/headless-drawing-g3

[docker-doc-docker-build]: https://docs.docker.com/develop/develop-images/build_enhancements/
