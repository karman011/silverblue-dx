#!/usr/bin/bash

set -ouex pipefail

INCLUDED_PACKAGES=($(jq -r '.include[]' /tmp/packages.json | paste -d" " -))

EXCLUDED_PACKAGES=($(jq -r '.exclude[]' /tmp/packages.json | paste -d" " -))

INSTALLED_EXCLUDED_PACKAGES=()

# ensure exclusion list only contains packages already present on image
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    INSTALLED_EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# simple case to install where no packages need excluding
if [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#INSTALLED_EXCLUDED_PACKAGES[@]}" -eq 0 ]]; then
    rpm-ostree install \
        ${INCLUDED_PACKAGES[@]}

# install/excluded packages both at same time
elif [[ "${#INCLUDED_PACKAGES[@]}" -gt 0 && "${#INSTALLED_EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${INSTALLED_EXCLUDED_PACKAGES[@]} \
        $(printf -- "--install=%s " ${INCLUDED_PACKAGES[@]})
else
    echo "No packages to install."
fi

# check if any excluded packages are still present
# (this can happen if an included package pulls in a dependency)
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    INSTALLED_EXCLUDED_PACKAGES=($(rpm -qa --queryformat='%{NAME} ' ${EXCLUDED_PACKAGES[@]}))
fi

# remove any excluded packages which are still present on image
if [[ "${#INSTALLED_EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    rpm-ostree override remove \
        ${INSTALLED_EXCLUDED_PACKAGES[@]}
fi
