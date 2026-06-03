#!/bin/bash
# driver-entrypoint — preflight before exec'ing systemd as PID 1.
#
# Runs as root inside the driver container. Performs three tasks
# before handing PID 1 to systemd:
#
#   1. Symlinks dotfiles from /opt/dotfiles into /home/kris (same
#      shape as the garden entrypoint).
#   2. Symlinks the bot's user-mode systemd unit templates from the
#      bind-mounted /home/kris/scripts/systemd/ into
#      /home/kris/.config/systemd/user/ so the user manager finds
#      them.
#   3. Ensures /home/kris is writable by the kris user; the bind
#      mount may have been created with restrictive permissions on
#      the host.
#
# After preflight, exec's "$@" (the CMD from the Dockerfile, which
# is /lib/systemd/systemd).

set -e

DOTFILES=/opt/dotfiles
HOME_DIR=/home/kris
SYSTEMD_USER_DIR="${HOME_DIR}/.config/systemd/user"
SCRIPTS_SYSTEMD_DIR="${HOME_DIR}/scripts/systemd"

# --- dotfile links ----------------------------------------------------

link_if_safe() {
    local target=$1 link_path=$2
    if [[ -L "$link_path" ]] || [[ ! -e "$link_path" ]]; then
        ln -sfn "$target" "$link_path"
    fi
}

if [[ -d "$DOTFILES" ]]; then
    link_if_safe "$DOTFILES/.bashrc"       "$HOME_DIR/.bashrc"
    link_if_safe "$DOTFILES/.bash_profile" "$HOME_DIR/.bash_profile"
    link_if_safe "$DOTFILES/.vimrc"        "$HOME_DIR/.vimrc"
    link_if_safe "$DOTFILES/.vimrc.local"  "$HOME_DIR/.vimrc.local"
    link_if_safe "$DOTFILES/vim"           "$HOME_DIR/.vim"
    link_if_safe "$DOTFILES/tmux.conf"     "$HOME_DIR/.tmux.conf"
    link_if_safe "$DOTFILES/tigrc"         "$HOME_DIR/.tigrc"
    link_if_safe "$DOTFILES/zshrc"         "$HOME_DIR/.zshrc"

    mkdir -p "$HOME_DIR/.config/git"
    link_if_safe "$DOTFILES/git/.gitconfig" "$HOME_DIR/.config/git/config"
fi

# --- systemd user-unit linkage ----------------------------------------
#
# scripts/systemd/garden-{driver,watcher}@.service are templated user
# units that the design expects to live under ~/.config/systemd/user/.
# The bind mount provides scripts/systemd/ but not the symlinks; create
# them so the user manager picks the templates up on first
# daemon-reload.

if [[ -d "$SCRIPTS_SYSTEMD_DIR" ]]; then
    mkdir -p "$SYSTEMD_USER_DIR"
    for unit_file in "$SCRIPTS_SYSTEMD_DIR"/*.service; do
        [[ -f "$unit_file" ]] || continue
        unit_name=$(basename "$unit_file")
        target_link="$SYSTEMD_USER_DIR/$unit_name"
        if [[ ! -L "$target_link" ]] && [[ ! -e "$target_link" ]]; then
            ln -sfn "$unit_file" "$target_link"
        fi
    done
fi

# --- ownership --------------------------------------------------------

# The dotfile symlinks and the systemd user-unit symlinks should be
# owned by kris. The bind mount's existing files we leave alone.
chown -h kris:kris \
    "$HOME_DIR/.bashrc" \
    "$HOME_DIR/.bash_profile" \
    "$HOME_DIR/.vimrc" \
    "$HOME_DIR/.vimrc.local" \
    "$HOME_DIR/.vim" \
    "$HOME_DIR/.tmux.conf" \
    "$HOME_DIR/.tigrc" \
    "$HOME_DIR/.zshrc" \
    "$HOME_DIR/.config/git/config" \
    2>/dev/null || true

# Ensure the systemd user-unit symlinks are owned by kris too.
if [[ -d "$SYSTEMD_USER_DIR" ]]; then
    chown -h kris:kris "$SYSTEMD_USER_DIR"/*.service 2>/dev/null || true
fi

# --- exec PID 1 -------------------------------------------------------

exec "$@"
