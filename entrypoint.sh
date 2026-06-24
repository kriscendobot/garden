#!/bin/bash
# garden-entrypoint — preflight before exec'ing systemd as PID 1.
#
# Runs as root inside the garden container. Before handing PID 1 to
# systemd it:
#   1. Symlinks dotfiles from /opt/dotfiles into /home/kris.
#   2. Prepares /home/kris/.config/systemd/user/ owned by kris, so
#      `systemctl --user enable` (run later by scripts/jobs/install-units.sh)
#      can write its default.target.wants/ links and the units survive a
#      container restart.
#   3. exec's "$@" (the CMD, /lib/systemd/systemd).
#
# Note: the garden units carry an @GARDEN_ROOT@ placeholder and must be
# RENDERED into ~/.config/systemd/user/ by scripts/jobs/install-units.sh
# (which substitutes the real path), so this entrypoint does NOT symlink
# the raw templates. Service bring-up is a deliberate operator step (after
# the hostname-uniqueness check) per CLAUDE.md § Job system, not automatic.

set -e

DOTFILES=/opt/dotfiles
HOME_DIR=/home/kris
SYSTEMD_USER_DIR="${HOME_DIR}/.config/systemd/user"

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
    chown -h kris:kris \
        "$HOME_DIR/.bashrc" "$HOME_DIR/.bash_profile" "$HOME_DIR/.vimrc" \
        "$HOME_DIR/.vimrc.local" "$HOME_DIR/.vim" "$HOME_DIR/.tmux.conf" \
        "$HOME_DIR/.tigrc" "$HOME_DIR/.zshrc" "$HOME_DIR/.config/git/config" \
        2>/dev/null || true
fi

# Prepare the user-systemd tree (must be kris-owned for `--user enable`).
mkdir -p "$SYSTEMD_USER_DIR"
chown -R kris:kris "$HOME_DIR/.config/systemd" 2>/dev/null || true

exec "$@"
