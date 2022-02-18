# Utility `builder.sh`

Builder command pattern:

```bash
./builder.sh <blend> <cmd> [build-options]
```

Supported values for `<cmd>`: `pre_build`, `build`, `push`, `post_push` and `all`.

Supported values for `<blend>` can be found in the hook script `env.rc`. The typical values are listed below.

Examples:

```bash
./builder.sh latest build --no-cache

### set the environment variables first, e.g. 'source secrets.rc'
./builder.sh latest all
```

## ubuntu-vnc-xfce-g3

On Docker Hub:

- [x] latest
- [x] latest-fugo

```plain
Local only:

- vnc
- vnc-fugo
```

## ubuntu-vnc-xfce-chromium-g3

On Docker Hub:

- [x] latest-chromium

```plain
Local only:

- vnc-chromium
```

## ubuntu-vnc-xfce-firefox-g3

On Docker Hub:

- [x] latest-firefox
- [x] latest-firefox-plus

```plain
Local only:

- vnc-firefox
- vnc-firefox-plus
```
