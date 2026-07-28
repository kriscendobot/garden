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
#   4. Seeds the allowlisted API-key handoff in /run/environment.d for the
#      independently PAM-started lingering user manager.
#   5. exec's "$@" (the CMD, /lib/systemd/systemd).
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

# user@<uid>.service is started by PAM with a fresh environment, rather than
# inheriting PID 1's Docker environment. Seed systemd's built-in environment-d
# generator before PID 1 starts. The target is /run (a Docker tmpfs), never the
# bind-mounted home or a unit file, and the helper accepts only the two explicit
# provider keys.
/usr/local/lib/garden/seed-api-key-handoff.sh

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

# Restore the fleet's durable BOT git identity on the garden repo's local config
# (user.name/user.email), so a reset / fresh checkout / container recreation
# re-applies it with no manual `git config` step. Run as the bot user (the config
# is bot-owned) and best-effort — a failure must never block PID-1 boot. The
# journal per-host override is SKIPPED here (root must not write bot-owned journal
# state, and the producer clone may be absent this early): the tracked canonical
# default keyed on the bot login is applied now, and the starting procedure re-runs
# the full journal-aware bootstrap once the journal is reachable. See
# scripts/jobs/bootstrap-bot-identity.sh and CLAUDE.md § Host environment.
BOOTSTRAP="$HOME_DIR/scripts/jobs/bootstrap-bot-identity.sh"
if [ -x "$BOOTSTRAP" ] && getent passwd "$GARDEN_USER" >/dev/null; then
    runuser -u "$GARDEN_USER" -- \
        env GARDEN_BOOTSTRAP_SKIP_JOURNAL=1 "$BOOTSTRAP" >/dev/null 2>&1 || true
fi

# Give the bot user access to the GPU device nodes so local inference (Ollama/ROCm)
# reaches the iGPU instead of silently falling back to CPU. The nodes are owned
# root:<gpu-group>, and merely being PRESENT in the container is NOT access — the bot
# user must be a MEMBER of the owning group to open them (the gotcha documented in
# context/operations/local-inference-amd.md § Container GPU access). This is done
# HOST-ADAPTIVELY at every container start, as root before systemd (PID 1) starts —
# so the group membership is in place before the user@<uid> manager and its worker
# pool spawn, and it survives a garden reset / image rebuild / container recreation
# with NO manual step. It also ADAPTS to each host: /dev/kfd is conventionally
# video(gid 44, stable) but /dev/dri/renderD128's gid is HOST-SPECIFIC and often
# UNNAMED (e.g. 992), so we read the live gid off the node rather than hardcoding a
# `groupadd -g 992` in the Dockerfile (which would be wrong on any host whose render
# gid differs). Idempotent and best-effort: a GPU-less host simply has no nodes (a
# no-op), and any failure here must never block PID-1 boot.
#
# ensure_gpu_group <device-node> <fallback-group-name>: resolve the node's owning
# gid, ensure a NAMED group exists at that gid (creating <fallback> — or, if that
# name is already taken at a different gid, a gid-suffixed variant — when the gid is
# unnamed), then add the bot user to it if not already a member.
ensure_gpu_group() {
    local node="$1" fallback="$2" gid grp
    [ -e "$node" ] || return 0
    gid="$(stat -c %g "$node" 2>/dev/null)" || return 0
    [ -n "$gid" ] || return 0
    grp="$(getent group "$gid" 2>/dev/null | cut -d: -f1)"
    if [ -z "$grp" ]; then
        grp="$fallback"
        # Fallback name already used at a DIFFERENT gid → synthesize a unique name.
        getent group "$grp" >/dev/null 2>&1 && grp="${fallback}${gid}"
        groupadd -g "$gid" "$grp" 2>/dev/null \
            || grp="$(getent group "$gid" 2>/dev/null | cut -d: -f1)"
    fi
    [ -n "$grp" ] || return 0
    # Add the bot user before its user manager starts. garden-ollama.service runs as
    # this user, so this is the credential set that opens the GPU nodes. Keep the
    # installer-created ollama user covered too if it exists: the image must leave its
    # system unit disabled, but manual diagnostics should not silently fall back to CPU.
    local u
    for u in "$GARDEN_USER" ollama; do
        getent passwd "$u" >/dev/null 2>&1 || continue
        if ! id -nG "$u" 2>/dev/null | tr ' ' '\n' | grep -qx "$grp"; then
            usermod -aG "$grp" "$u" 2>/dev/null || true
        fi
    done
}
if getent passwd "$GARDEN_USER" >/dev/null 2>&1; then
    ensure_gpu_group /dev/kfd video || true
    ensure_gpu_group /dev/dri/renderD128 render || true
fi

exec "$@"
