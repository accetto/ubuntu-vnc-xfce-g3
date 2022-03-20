# syntax=docker/dockerfile:experimental

ARG BASEIMAGE=ubuntu
ARG BASETAG=20.04

ARG ARG_MERGE_STAGE_VNC_BASE=stage_vnc
ARG ARG_MERGE_STAGE_BROWSER_BASE=merge_stage_vnc
ARG ARG_FINAL_STAGE_BASE=merge_stage_browser


###############
### stage_cache
###############

FROM ${BASEIMAGE}:${BASETAG} as stage_cache

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN apt-get update


####################
### stage_essentials
####################

FROM ${BASEIMAGE}:${BASETAG} as stage_essentials

SHELL ["/bin/bash", "-c"]

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        jq \
        nano \
        psmisc \
        sudo \
        tini \
        wget


#################
### stage_xserver
#################

FROM stage_essentials as stage_xserver
ARG ARG_APT_NO_RECOMMENDS

ENV \
    FEATURES_BUILD_SLIM_XSERVER=${ARG_APT_NO_RECOMMENDS:+1} \
    NO_AT_BRIDGE=1

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        dbus-x11 \
        xauth \
        xinit \
        x11-xserver-utils \
        xdg-utils


##############
### stage_xfce
##############

FROM stage_xserver as stage_xfce
ARG ARG_APT_NO_RECOMMENDS

ENV FEATURES_BUILD_SLIM_XFCE=${ARG_APT_NO_RECOMMENDS:+1}

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        xfce4 \
        xfce4-terminal


###############
### stage_tools
###############

FROM stage_xfce as stage_tools
ARG ARG_APT_NO_RECOMMENDS
ARG ARG_FEATURES_SCREENSHOOTING
ARG ARG_FEATURES_THUMBNAILING

ENV \
    FEATURES_BUILD_SLIM_TOOLS=${ARG_APT_NO_RECOMMENDS:+1} \
    FEATURES_SCREENSHOOTING=${ARG_FEATURES_SCREENSHOOTING:+1} \
    FEATURES_THUMBNAILING=${ARG_FEATURES_THUMBNAILING:+1}

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        mousepad \
        python3 \
        systemctl \
        ${ARG_FEATURES_SCREENSHOOTING:+ristretto xfce4-screenshooter} \
        ${ARG_FEATURES_THUMBNAILING:+tumbler}


#############
### stage_vnc
#############

FROM stage_tools as stage_vnc
ARG ARG_VNC_COL_DEPTH
ARG ARG_VNC_DISPLAY
ARG ARG_VNC_PORT
ARG ARG_VNC_PW
ARG ARG_VNC_RESOLUTION
ARG ARG_VNC_VIEW_ONLY

# wget -qO- https://github.com/accetto/tigervnc/releases/download/v1.12.0-mirror/tigervnc-1.12.0.x86_64.tar.gz | tar xz --strip 1 -C / \
RUN \
    wget -qO- https://sourceforge.net/projects/tigervnc/files/stable/1.12.0/tigervnc-1.12.0.x86_64.tar.gz | tar xz --strip 1 -C / \
    && ln -s /usr/libexec/vncserver /usr/bin/vncserver \
    && sed -i 's/exec(@cmd);/print "@cmd";\nexec(@cmd);/g' /usr/libexec/vncserver

ENV \
    DISPLAY=${ARG_VNC_DISPLAY:-:1} \
    FEATURES_VNC=1 \
    VNC_COL_DEPTH=${ARG_VNC_COL_DEPTH:-24} \
    VNC_PORT=${ARG_VNC_PORT:-5901} \
    VNC_PW=${ARG_VNC_PW:-headless} \
    VNC_RESOLUTION=${ARG_VNC_RESOLUTION:-1360x768} \
    VNC_VIEW_ONLY=${ARG_VNC_VIEW_ONLY:-false}

EXPOSE ${VNC_PORT}


###############
### stage_novnc
###############

FROM stage_vnc as stage_novnc
ARG ARG_APT_NO_RECOMMENDS
ARG ARG_NOVNC_PORT

ENV \
    FEATURES_BUILD_SLIM_NOVNC=${ARG_APT_NO_RECOMMENDS:+1} \
    FEATURES_NOVNC=1 \
    NOVNC_HOME=/usr/libexec/noVNCdim \
    NOVNC_PORT=${ARG_NOVNC_PORT:-6901}

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        python3-numpy \
    && mkdir -p "${NOVNC_HOME}"/utils/websockify \
    && wget -qO- https://github.com/novnc/noVNC/archive/v1.3.0.tar.gz | tar xz --strip 1 -C "${NOVNC_HOME}" \
    && wget -qO- https://github.com/novnc/websockify/archive/v0.10.0.tar.gz | tar xz --strip 1 -C "${NOVNC_HOME}"/utils/websockify \
    && chmod +x -v "${NOVNC_HOME}"/utils/novnc_proxy

### add 'index.html' for choosing noVNC client
RUN echo -e \
"<!DOCTYPE html>\n" \
"<html>\n" \
"    <head>\n" \
"        <title>noVNC</title>\n" \
"        <meta charset=\"utf-8\"/>\n" \
"    </head>\n" \
"    <body>\n" \
"        <p><a href=\"vnc_lite.html\">noVNC Lite Client</a></p>\n" \
"        <p><a href=\"vnc.html\">noVNC Full Client</a></p>\n" \
"    </body>\n" \
"</html>" \
> "${NOVNC_HOME}"/index.html

EXPOSE ${NOVNC_PORT}


###################
### merge_stage_vnc
###################

FROM ${ARG_MERGE_STAGE_VNC_BASE} as merge_stage_vnc
ARG ARG_HEADLESS_USER_NAME
ARG ARG_HOME

ENV HOME=${ARG_HOME:-/home/${ARG_HEADLESS_USER_NAME:-headless}}

WORKDIR ${HOME}


##################
### stage_chromium
##################

FROM merge_stage_vnc as stage_chromium
ARG ARG_APT_NO_RECOMMENDS
ARG ARG_CHROMIUM_VERSION

ENV \
    FEATURES_BUILD_SLIM_CHROMIUM=${ARG_APT_NO_RECOMMENDS:+1} \
    FEATURES_CHROMIUM=1

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    CHROMIUM_VERSION="${ARG_CHROMIUM_VERSION}" \
    && wget -q "http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg_${CHROMIUM_VERSION}_amd64.deb" -P /tmp \
    && wget -q "http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-browser_${CHROMIUM_VERSION}_amd64.deb" -P /tmp \
    && wget -q "http://archive.ubuntu.com/ubuntu/pool/universe/c/chromium-browser/chromium-browser-l10n_${CHROMIUM_VERSION}_all.deb" -P /tmp \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        "/tmp/chromium-codecs-ffmpeg_${CHROMIUM_VERSION}_amd64.deb" \
        "/tmp/chromium-browser_${CHROMIUM_VERSION}_amd64.deb" \
        "/tmp/chromium-browser-l10n_${CHROMIUM_VERSION}_all.deb" \
    && rm \
        "/tmp/chromium-codecs-ffmpeg_${CHROMIUM_VERSION}_amd64.deb" \
        "/tmp/chromium-browser_${CHROMIUM_VERSION}_amd64.deb" \
        "/tmp/chromium-browser-l10n_${CHROMIUM_VERSION}_all.deb" \
    && apt-mark hold chromium-browser

COPY ./xfce-chromium/src/home/Desktop "${HOME}"/Desktop/
COPY ./xfce-chromium/src/home/readme*.md "${HOME}"/

### Chromium browser requires some presets
### Note that 'no-sandbox' flag is required, but intended for development only
RUN \
    echo \
    "CHROMIUM_FLAGS='--no-sandbox --disable-gpu --user-data-dir --window-size=${VNC_RESOLUTION%x*},${VNC_RESOLUTION#*x} --window-position=0,0'" \
    > ${HOME}/.chromium-browser.init


#################
### stage_firefox
#################

FROM merge_stage_vnc as stage_firefox
ARG ARG_APT_NO_RECOMMENDS

ENV \
    FEATURES_BUILD_SLIM_FIREFOX=${ARG_APT_NO_RECOMMENDS:+1} \
    FEATURES_FIREFOX=1

RUN \
    --mount=type=cache,target=/var/cache/apt,from=stage_cache,source=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt,from=stage_cache,source=/var/lib/apt \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${ARG_APT_NO_RECOMMENDS:+--no-install-recommends} \
        firefox

COPY ./xfce-firefox/src/home/Desktop "${HOME}"/Desktop/


### ##################
### stage_firefox_plus
### ##################

FROM stage_firefox as stage_firefox_plus

ENV FEATURES_FIREFOX_PLUS=1

COPY ./xfce-firefox/src/firefox.plus/home/Desktop "${HOME}"/Desktop/
COPY ./xfce-firefox/src/firefox.plus/resources "${HOME}"/firefox.plus/
COPY ./xfce-firefox/src/firefox.plus/resources/*.svg /usr/share/icons/hicolor/scalable/apps/
COPY ./xfce-firefox/src/firefox.plus/home/readme*.md "${HOME}"/

RUN \
    chmod +x "${HOME}"/firefox.plus/*.sh \
    && gtk-update-icon-cache -f /usr/share/icons/hicolor


#######################
### merge_stage_browser
#######################

FROM ${ARG_MERGE_STAGE_BROWSER_BASE} as merge_stage_browser


###############
### FINAL STAGE
###############

FROM ${ARG_FINAL_STAGE_BASE} as stage_final
ARG ARG_FEATURES_USER_GROUP_OVERRIDE
ARG ARG_HEADLESS_USER_NAME
ARG ARG_SUDO_PW

ENV \
    FEATURES_USER_GROUP_OVERRIDE=${ARG_FEATURES_USER_GROUP_OVERRIDE:+1} \
    FEATURES_VERSION_STICKER=1 \
    STARTUPDIR=/dockerstartup

COPY ./src/xfce-startup "${STARTUPDIR}"/

COPY ./xfce/src/home/config "${HOME}"/.config/
COPY ./xfce/src/home/Desktop "${HOME}"/Desktop/
COPY ./xfce/src/home/readme*.md "${HOME}"/

### Create the default application user (non-root, but member of the group zero)
### and allow the group zero to modify '/etc/passwd' and '/etc/group'.
### Providing the build argument ARG_SUPPORT_USER_GROUP_OVERRIDE (set to anything) allows any user
### to modify both files and makes user group overriding possible (like 'run --user x:y').
RUN \
    chmod 664 /etc/passwd /etc/group \
    && echo "${ARG_HEADLESS_USER_NAME:-headless}:x:1001:0:Default:${HOME}:/bin/bash" >> /etc/passwd \
    && adduser "${ARG_HEADLESS_USER_NAME:-headless}" sudo \
    && echo "${ARG_HEADLESS_USER_NAME:-headless}:${ARG_SUDO_PW:-${VNC_PW}}" | chpasswd \
    && ${ARG_FEATURES_USER_GROUP_OVERRIDE/*/chmod a+w /etc/passwd /etc/group} \
    && ln -s "${HOME}"/readme.md "${HOME}"/Desktop/README \
    && chmod 755 -R "${STARTUPDIR}" \
    && "${STARTUPDIR}"/set_user_permissions.sh "${STARTUPDIR}" "${HOME}"

USER 1001

ENTRYPOINT [ "/usr/bin/tini", "--", "/dockerstartup/startup.sh" ]
# ENTRYPOINT [ "/usr/bin/tini", "--", "tail", "-f", "/dev/null" ]


##################
### METADATA STAGE
##################

FROM stage_final as stage_metadata
ARG ARG_CREATED
ARG ARG_DOCKER_TAG
ARG ARG_VCS_REF
ARG ARG_VERSION_STICKER

LABEL \
    org.opencontainers.image.authors="accetto" \
    org.opencontainers.image.created="${ARG_CREATED}" \
    org.opencontainers.image.description="Headless Ubuntu/Xfce/VNC/noVNC containers with Internet browsers" \
    org.opencontainers.image.documentation="https://github.com/accetto/ubuntu-vnc-xfce-g3" \
    org.opencontainers.image.source="https://github.com/accetto/ubuntu-vnc-xfce-g3" \
    org.opencontainers.image.title="accetto/ubuntu-vnc-xfce-g3" \
    org.opencontainers.image.url="https://github.com/accetto/ubuntu-vnc-xfce-g3" \
    org.opencontainers.image.vendor="https://github.com/accetto" \
    org.opencontainers.image.version="${ARG_DOCKER_TAG}"

LABEL \
    org.label-schema.vcs-url="https://github.com/accetto/ubuntu-vnc-xfce-g3" \
    org.label-schema.vcs-ref="${ARG_VCS_REF}"

LABEL \
    any.accetto.version-sticker="${ARG_VERSION_STICKER}"
