# Examples `util-readme.sh`

## Preparation

Open a terminal window and change the current directory to `utils/`.

The utility requires the `ID` of the deployment **GitHub Gist**, which you can provide as a parameter or by setting the environment variable `DEPLOY_GIST_ID`:

```shell
export DEPLOY_GIST_ID="<deployment-gist-ID>"
```

Embedded help describes the parameters:

```shell
./util-readme.sh -h
```

## Usage examples

```shell
### PWD = utils/

./util-readme.sh --repo accetto/ubuntu-vnc-xfce-g3 --context=../docker/xfce --gist <deployment-gist-ID> -- preview

./util-readme.sh --repo accetto/ubuntu-vnc-xfce-chromium-g3 --context=../docker/xfce-chromium --gist <deployment-gist-ID> -- preview

./util-readme.sh --repo accetto/ubuntu-vnc-xfce-firefox-g3 --context=../docker/xfce-firefox --gist <deployment-gist-ID> -- preview

### or if the environment variable 'DEPLOY_GIST_ID' has been set

./util-readme.sh --repo accetto/ubuntu-vnc-xfce-g3 --context=../docker/xfce -- preview

./util-readme.sh --repo accetto/ubuntu-vnc-xfce-chromium-g3 --context=../docker/xfce-chromium -- preview

./util-readme.sh --repo accetto/ubuntu-vnc-xfce-firefox-g3 --context=../docker/xfce-firefox -- preview
```

See the Wiki page ["Utility util-readme.sh"][this-wiki-utility-util-readme] for more information.

***

[this-wiki-utility-util-readme]: https://github.com/accetto/ubuntu-vnc-xfce-g3/wiki/Utility-util-readme
