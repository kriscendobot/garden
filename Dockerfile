# Dockerfile — the garden container.
#
# Runs systemd as PID 1 so the garden's user-mode units in
# scripts/systemd/ (garden-gardener@N, garden-triager@<repo>,
# garden-repo-watcher, garden-reaper, garden-watchman,
# garden-gardener-scaler, garden-scheduler, garden-bulletin,
# garden-mentor) can be managed with `systemctl --user` exactly as on
# a Linux host. Adapted for Docker per the standard containerized-systemd
# recipe (privileged, writable cgroup mount, tmpfs at /run and /tmp,
# STOPSIGNAL SIGRTMIN+3 — supplied by the `garden` launcher script).
#
# Identity: runs as a unix user matching the HOST user (name + uid, via
# --build-arg USERNAME/USER_UID) and uses whatever ssh / gh credentials are
# present in the bind-mounted home. The container home is relocated at runtime
# to mirror the checkout's host path (entrypoint `usermod -d`, launcher
# GARDEN_HOME). The bot's git identity (a bot login) is the repo-local git config,
# not a separate unix user. The per-host logical name is
# the location-derived instance id (<hostname>-<basename>-<hash>), unique across
# instances and fixed at container creation via the launcher's --hostname.

FROM ubuntu:24.04

ARG NODE_MAJOR=22
ARG GO_VERSION=1.23.6
ARG DOTFILES_REPO=https://github.com/kriskowal/dotfiles.git
ARG VUNDLE_REPO=https://github.com/VundleVim/Vundle.vim.git

# The unix user is baked to match the HOST user running ./garden (name + uid),
# passed by the launcher's cmd_build. Nothing is hardcoded to one maintainer's
# account, and the launcher tags the image per-user (garden-<user>) so builds
# don't drift or collide across users. (USERNAME is first USED at the useradd
# step far below, so declaring it here does not invalidate the expensive apt /
# node / go layers; GARDEN_USER is exported as an ENV late, for the same reason.)
# Neutral defaults (never the maintainer's account); the launcher always passes
# the real host user via --build-arg, so these apply only to a bare `docker build`.
ARG USERNAME=bot
ARG USER_UID=1000

ENV DEBIAN_FRONTEND=noninteractive

# systemd + dbus + base packages.
# systemd-sysv ships the /sbin/init → systemd symlink; dbus +
# dbus-user-session + libpam-systemd are what make `systemctl --user`
# and user lingering work. The rest mirror the dev tooling.
#
# jq is a HARD RUNTIME DEPENDENCY of the fleet, not just dev tooling: the comment
# and mention source handlers pipe `gh api` output to external `jq`. Its absence
# is what caused the 2026-06-24 ~16h comment-watcher outage (a hot-installed jq
# restored service); common.sh's require_tools now also fails loudly if it is
# missing, but it must be in the image so a rebuild does not reintroduce the gap.
RUN apt-get update && apt-get install -y \
    systemd \
    systemd-sysv \
    dbus \
    dbus-user-session \
    libpam-systemd \
    build-essential \
    curl \
    git \
    git-filter-repo \
    vim \
    zsh \
    tmux \
    tig \
    less \
    openssh-client \
    ca-certificates \
    gnupg \
    unzip \
    jq \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    cmake \
    fzf \
    ripgrep \
    shellcheck \
    fasd \
    locales \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Node.js via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Go toolchain
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz \
    | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"

# Go language tooling under /opt so the bind-mounted $HOME can't mask it.
RUN mkdir -p /opt/go-tools/bin \
    && export GOPATH=/tmp/gopath GOBIN=/opt/go-tools/bin \
    && go install golang.org/x/tools/gopls@latest \
    && go install golang.org/x/tools/cmd/goimports@latest \
    && go install github.com/go-delve/delve/cmd/dlv@latest \
    && go install golang.org/x/lint/golint@latest \
    && go install honnef.co/go/tools/cmd/staticcheck@latest \
    && go install github.com/kisielk/errcheck@latest \
    && rm -rf /tmp/gopath /root/.cache/go-build
ENV PATH="/opt/go-tools/bin:${PATH}"

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Claude Code CLI — the image-side half of the direct-exec contract. The
# `garden` launcher enters with `bash -lc 'exec claude --dangerously-skip-permissions'`,
# so `claude` MUST resolve on a bare login-shell PATH. NodeSource's npm prefix
# is /usr, so the global `claude` bin lands in /usr/bin (already on the default
# PATH and thus reachable from /etc/profile.d/garden.sh below). The trailing
# `command -v claude` asserts the exec contract at build time: a broken install
# fails the build loudly rather than at first `./garden`.
RUN npm install -g @anthropic-ai/claude-code \
    && command -v claude

# Create the bot user matching the HOST user (name + uid, from --build-arg) so the
# bind-mounted home stays writable and nothing is pinned to one account. Ubuntu
# 24.04 ships a default `ubuntu` user at uid 1000; remove it first so USER_UID
# (often 1000) is free.
RUN userdel -r ubuntu 2>/dev/null || true \
    && useradd -m -s /bin/bash -u "${USER_UID}" -G sudo "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Dotfiles in /opt so the bind mount can't mask them.
RUN git clone "${DOTFILES_REPO}" /opt/dotfiles \
    && chown -R "${USERNAME}:${USERNAME}" /opt/dotfiles

# Vundle + plugins.
USER ${USERNAME}
RUN git clone "${VUNDLE_REPO}" /opt/dotfiles/vim/bundle/Vundle.vim \
    && ln -sfn /opt/dotfiles/vim    "/home/${USERNAME}/.vim" \
    && ln -sfn /opt/dotfiles/.vimrc "/home/${USERNAME}/.vimrc" \
    && vim -E -u /opt/dotfiles/.vimrc -i NONE \
         -c 'set nomore' \
         -c 'PluginInstall' \
         -c 'qa!' \
       ; true
USER root

# Login-shell env via /etc/profile.d (bind-mounted $HOME has no dotfiles). This is
# the wiring the launcher's `bash -lc 'exec claude ...'` relies on:
#   - PATH: prepends the garden/go tool dirs while preserving the default PATH
#     (which already contains /usr/bin, where the global `claude` bin lives), so
#     `claude` resolves on a bare enter.
#   - USER / XDG_RUNTIME_DIR / DBUS: what `systemctl --user` needs to reach the
#     user bus. A `docker exec` (even `-l`) gets no PAM session, so these are unset
#     otherwise and every `systemctl --user` — the liaison's and its subprocesses'
#     — fails "No medium found" until self-healed. Setting them here (idempotent,
#     `${VAR:-…}`) retires that self-heal for every login shell; fleet scripts are
#     covered in parallel by common.sh's source-time systemd_user_env.
RUN printf '%s\n' \
    'export PATH="$HOME/bin:$HOME/go/bin:/opt/go-tools/bin:/usr/local/go/bin:$PATH"' \
    'export USER="${USER:-$(id -un)}"' \
    'export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"' \
    'export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"' \
    > /etc/profile.d/garden.sh

ENV PATH="/home/${USERNAME}/bin:/home/${USERNAME}/go/bin:${PATH}"

# Mask systemd units that don't make sense in a container (they would
# otherwise fail noisily on boot).
RUN systemctl mask \
        systemd-resolved.service \
        systemd-networkd.service \
        systemd-udev-trigger.service \
        systemd-tmpfiles-setup-dev.service \
        sys-kernel-debug.mount \
        sys-kernel-tracing.mount \
        getty.target \
        getty-static.service \
    || true

# Enable lingering for the bot user so systemd starts its user@<uid>.service at
# boot, which brings up the user-mode garden-* units (installed by
# scripts/jobs/install-units.sh into ~/.config/systemd/user/) without a
# logged-in session. This is the headless prerequisite the CLAUDE.md
# startup procedure relies on.
RUN mkdir -p /var/lib/systemd/linger && touch "/var/lib/systemd/linger/${USERNAME}"

# Bake the bot user's name so the runtime entrypoint (which relocates this user's
# home to the mirrored checkout path) knows it without a hardcoded account.
# Declared LATE, after the expensive apt/node/go layers, so it never invalidates
# their cache.
ENV GARDEN_USER=${USERNAME}

# Entrypoint links dotfiles and prepares the user-systemd dir before
# exec'ing systemd as PID 1.
COPY entrypoint.sh /usr/local/bin/garden-entrypoint
RUN chmod +x /usr/local/bin/garden-entrypoint

# systemd's clean-shutdown signal.
STOPSIGNAL SIGRTMIN+3

# PID 1 is systemd (entrypoint runs as root, its domain); the garden units run
# as the bot user via its user@<uid> manager. Interactive access is
# `docker exec -it -u <hostuser> ... bash -l` (the `garden` launcher does this) —
# entering as the bot user, not root, so the session uses its gh/ssh credentials
# and drives `systemctl --user` directly without sudo.
WORKDIR /home/${USERNAME}
ENTRYPOINT ["/usr/local/bin/garden-entrypoint"]
CMD ["/lib/systemd/systemd"]
