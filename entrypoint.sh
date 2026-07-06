#!/bin/bash
# garden-entrypoint — preflight before exec'ing systemd as PID 1.
#
# Runs as root inside the garden container. Before handing PID 1 to
# systemd it:
#   1. Relocates the bot user's home to the mirrored checkout path (GARDEN_HOME).
#   2. Symlinks dotfiles from /opt/dotfiles into that home.
#   3. Prepares <home>/.config/systemd/user/ owned by the bot user, so
#      `systemctl --user enable` (run later by scripts/jobs/install-units.sh)
#      can write its default.target.wants/ links and the units survive a
#      container restart.
#   4. exec's "$@" (the CMD, /lib/systemd/systemd).
#
# The bot user's name is baked into the image (ENV GARDEN_USER, = the host user)
# and read here so nothing is pinned to one account.
#
# Note: the garden units carry an @GARDEN_ROOT@ placeholder and must be
# RENDERED into ~/.config/systemd/user/ by scripts/jobs/install-units.sh
# (which substitutes the real path), so this entrypoint does NOT symlink
# the raw templates. Service bring-up is a deliberate operator step (after
# the hostname-uniqueness check) per CLAUDE.md § Job system, not automatic.

set -e

DOTFILES=/opt/dotfiles
# The bot user, baked to match the host user (Dockerfile ARG USERNAME → ENV
# GARDEN_USER). If the env is somehow absent, fall back to the first real
# (uid >= 1000) account in the image rather than a guessed literal, so we never
# target a nonexistent user and abort PID-1 boot.
GARDEN_USER="${GARDEN_USER:-$(getent passwd | awk -F: '$3>=1000 && $3<65534 {print $1; exit}')}"

# Home is MIRRORED to the checkout's host path when the launcher passes
# GARDEN_HOME (a bind mount lives at that same path). Relocate the bot user's home
# in /etc/passwd to it — no -m, since the bind mount already provides the directory
# — so $HOME, the login shell, and the systemd --user manager all agree on the
# mirrored path. Absolute paths then mean the same thing inside the container and
# on the host. Done here, as root, before systemd (PID 1) starts and while the bot
# user still has no running process. Guarded on the user existing so a misresolved
# name can never crash boot. Absent GARDEN_HOME, home stays as built.
HOME_DIR="${GARDEN_HOME:-$(getent passwd "$GARDEN_USER" | cut -d: -f6)}"
if [ -n "${GARDEN_HOME:-}" ] && getent passwd "$GARDEN_USER" >/dev/null \
   && [ "$(getent passwd "$GARDEN_USER" | cut -d: -f6)" != "$HOME_DIR" ]; then
    usermod -d "$HOME_DIR" "$GARDEN_USER"
fi
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
    chown -h "$GARDEN_USER:$GARDEN_USER" \
        "$HOME_DIR/.bashrc" "$HOME_DIR/.bash_profile" "$HOME_DIR/.vimrc" \
        "$HOME_DIR/.vimrc.local" "$HOME_DIR/.vim" "$HOME_DIR/.tmux.conf" \
        "$HOME_DIR/.tigrc" "$HOME_DIR/.zshrc" "$HOME_DIR/.config/git/config" \
        2>/dev/null || true
fi

# Prepare the user-systemd tree (must be owned by the bot user for `--user enable`).
mkdir -p "$SYSTEMD_USER_DIR"
chown -R "$GARDEN_USER:$GARDEN_USER" "$HOME_DIR/.config/systemd" 2>/dev/null || true

exec "$@"
