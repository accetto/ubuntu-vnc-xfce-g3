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

### set the environment variables first, e.g. 'source ./secrets.rc'
./builder.sh latest all
```

## ubuntu-vnc-xfce-g3

Builds for Docker Hub:

| Blend       | Deployment tag |
| ----------- | -------------- |
| latest      | latest         |
| latest-fugo | latest-fugo    |

Local builds only:

| Blend    | Deployment tag |
| -------- | -------------- |
| vnc      | vnc            |
| vnc-fugo | vnc-fugo       |

## ubuntu-vnc-xfce-chromium-g3

Builds for Docker Hub:

| Blend           | Deployment tag |
| --------------- | -------------- |
| latest-chromium | latest         |

Local builds only:

| Blend        | Deployment tag |
| ------------ | -------------- |
| vnc-chromium | vnc            |

## ubuntu-vnc-xfce-firefox-g3

Builds for Docker Hub:

| Blend               | Deployment tag |
| ------------------- | -------------- |
| latest-firefox      | latest         |
| latest-firefox-plus | latest-plus    |

Local builds only:

| Blend            | Deployment tag |
| ---------------- | -------------- |
| vnc-firefox      | vnc            |
| vnc-firefox-plus | vnc-plus       |
