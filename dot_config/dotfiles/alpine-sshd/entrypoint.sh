#!/bin/sh
set -eu

SSH_USER="${SSH_USER:-student}"
SSH_PASSWORD="${SSH_PASSWORD:-student}"
SSH_UID="${SSH_UID:-1000}"
SSH_GID="${SSH_GID:-1000}"
SSH_HOME="/home/${SSH_USER}"
AUTHORIZED_KEYS_FILE="${AUTHORIZED_KEYS_FILE:-}"
ENABLE_SUDO="${ENABLE_SUDO:-true}"

create_group() {
    if ! grep -q "^${SSH_USER}:" /etc/group; then
        addgroup -g "${SSH_GID}" "${SSH_USER}"
    fi
}

create_user() {
    if ! id -u "${SSH_USER}" >/dev/null 2>&1; then
        adduser -D -h "${SSH_HOME}" -s /bin/bash -G "${SSH_USER}" -u "${SSH_UID}" "${SSH_USER}"
    fi
}

set_password() {
    echo "${SSH_USER}:${SSH_PASSWORD}" | chpasswd
}

setup_sudo() {
    if [ "${ENABLE_SUDO}" = "true" ]; then
        adduser "${SSH_USER}" wheel
        printf '%%wheel ALL=(ALL) ALL\n' > /etc/sudoers.d/wheel
        chmod 440 /etc/sudoers.d/wheel
    fi
}

setup_authorized_keys() {
    if [ -n "${AUTHORIZED_KEYS_FILE}" ] && [ -f "${AUTHORIZED_KEYS_FILE}" ]; then
        mkdir -p "${SSH_HOME}/.ssh"
        cp "${AUTHORIZED_KEYS_FILE}" "${SSH_HOME}/.ssh/authorized_keys"
        chown -R "${SSH_USER}:${SSH_USER}" "${SSH_HOME}/.ssh"
        chmod 700 "${SSH_HOME}/.ssh"
        chmod 600 "${SSH_HOME}/.ssh/authorized_keys"
    fi
}

update_sshd_allowusers() {
    sed -i "s/^AllowUsers .*/AllowUsers ${SSH_USER}/" /etc/ssh/sshd_config
}

create_group
create_user
set_password
setup_sudo
setup_authorized_keys
update_sshd_allowusers

mkdir -p /var/run/sshd

exec "$@"
