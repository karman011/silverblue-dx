ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG SOURCE_IMAGE="${SOURCE_IMAGE:-silverblue}"
ARG SOURCE_ORG="${SOURCE_ORG:-fedora}"
ARG BASE_IMAGE="quay.io/${SOURCE_ORG}/fedora-${SOURCE_IMAGE}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG FEDORA_IMAGE_VERSION="${FEDORA_IMAGE_VERSION:-latest}"

FROM scratch AS ctx
COPY / /

FROM ${BASE_IMAGE}:${FEDORA_IMAGE_VERSION}-x86_64

ARG IMAGE_NAME="${IMAGE_NAME:-silverblue}"
ARG FEDORA_MAJOR_VERSION="${FEDORA_MAJOR_VERSION:-41}"
ARG FEDORA_IMAGE_VERSION="${FEDORA_RELEASE_VERSION}:-latest"

RUN --mount=type=cache,dst=/var/cache/rpm-ostree \
    --mount=type=bind,from=ctx,src=/,dst=/ctx \
    rm -f /usr/bin/chsh && \
    rm -f /usr/bin/lchsh && \
    mkdir -p /var/lib/alternatives && \
    /ctx/build.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    /ctx/clean-stage.sh \
    ostree container commit && \
    mkdir -p /var/lib && mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp