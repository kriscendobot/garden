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

# Node.js from the official nodejs.org tarball (NodeSource's apt repo and
# setup script both 403 as of 2026-07, so we no longer register it with apt —
# same self-contained pattern as the Go toolchain below).
RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in amd64) NODE_ARCH=x64 ;; arm64) NODE_ARCH=arm64 ;; *) NODE_ARCH="$ARCH" ;; esac \
    && NODE_TARBALL="$(curl -fsSL https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/ \
        | grep -oE "node-v${NODE_MAJOR}\.[0-9]+\.[0-9]+-linux-${NODE_ARCH}\.tar\.gz" | head -1)" \
    && test -n "$NODE_TARBALL" \
    && curl -fsSL "https://nodejs.org/dist/latest-v${NODE_MAJOR}.x/${NODE_TARBALL}" \
        | tar -C /usr/local --strip-components=1 -xz

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
# so `claude` MUST resolve on a bare login-shell PATH. Node is unpacked into
# /usr/local, so npm's prefix is /usr/local and the global `claude` bin lands in
# /usr/local/bin (already on the default PATH and thus reachable from
# /etc/profile.d/garden.sh below). The trailing
# `command -v claude` asserts the exec contract at build time: a broken install
# fails the build loudly rather than at first `./garden`.
#
# The version is a FLOOR, not an exact pin (ARG CLAUDE_CODE_MIN): a rebuild still
# tracks the latest published CLI — which is what a fleet of agents wants — but can
# never land BELOW the floor. That is the durability this arg buys. An upgrade done
# inside a running container (`npm install -g` into the writable layer) is lost the
# moment the container is recreated from an older image; raising the floor here is
# how such an upgrade is carried into the image. So: after upgrading the CLI in a
# live container, bump CLAUDE_CODE_MIN to the version you now run. `claude --version`
# makes the build fail loudly if the resolved install cannot even report itself.
ARG CLAUDE_CODE_MIN=2.1.220
RUN for attempt in 1 2 3; do \
        npm install -g "@anthropic-ai/claude-code@>=${CLAUDE_CODE_MIN}" \
            && command -v claude && claude --version && exit 0; \
        if [ "$attempt" -eq 3 ]; then exit 1; fi; \
        echo "npm install failed (attempt $attempt); retrying..." >&2; \
        sleep "$attempt"; \
    done

# Codex CLI (OpenAI) — installed globally alongside claude so the `codex` agent is
# available for jobs that use it. Same npm-prefix logic: the global bin lands
# in /usr/local/bin (on the default PATH). The trailing `command -v codex` asserts the
# install at build time, failing the build loudly rather than at first use.
RUN for attempt in 1 2 3; do \
        npm install -g @openai/codex && command -v codex && exit 0; \
        if [ "$attempt" -eq 3 ]; then exit 1; fi; \
        echo "npm install failed (attempt $attempt); retrying..." >&2; \
        sleep "$attempt"; \
    done

# Kimi Code CLI (Moonshot) is installed from Moonshot's official checksum-verifying
# installer, in an image-owned directory rather than the bind-mounted home. Mystic
# jobs invoke this binary with a per-job KIMI_CODE_HOME, so the installed program and
# each job's mutable state remain separate. The command check makes a broken download
# fail the image build instead of the first explicit Mystic job.
RUN for attempt in 1 2 3; do \
        curl -fsSL -o /tmp/kimi-code-install.sh https://code.kimi.com/kimi-code/install.sh \
        && KIMI_INSTALL_DIR=/opt/kimi-code KIMI_NO_MODIFY_PATH=1 bash /tmp/kimi-code-install.sh \
        && ln -sfn /opt/kimi-code/bin/kimi /usr/local/bin/kimi \
        && command -v kimi && kimi --version && rm -f /tmp/kimi-code-install.sh && exit 0; \
        if [ "$attempt" -eq 3 ]; then exit 1; fi; \
        echo "Kimi Code install failed (attempt $attempt); retrying..." >&2; \
        sleep "$attempt"; \
    done

# Ollama + its bundled ROCm 7.2 runtime — the image-side half of durable LOCAL
# inference on the AMD Ryzen (Strix Halo / gfx1151) host, so a rebuilt image ships a
# GPU-capable OpenAI-compatible /v1 endpoint with no manual install (the codex-CLI
# capture pattern above, applied to Ollama). Grounded in
# context/operations/local-inference-amd.md §§1,2,6. Two gotchas that bit the live
# verify-by-doing run are captured here so a rebuild never reintroduces them:
#   1. The one-line installer needs host packages absent from the base image — zstd
#      (the release tarballs are .tar.zst) and pciutils/lshw (the installer's GPU
#      auto-detect greps `lspci -d 1002:`; without it, it silently goes CPU-only and
#      never fetches the ROCm bundle).
#   2. On first run only the CUDA runtime extracts; the ROCm bundle (which carries
#      the gfx1151 rocBLAS kernels — no source build needed) must be fetched
#      explicitly. That bundle ships ROCm 7.2, which is ≥ the 7.0.2 gfx1151 floor, so
#      NO HSA_OVERRIDE_GFX_VERSION is needed (guide §1).
# Ollama bundles its own ROCm, so NO system /opt/rocm install is required for this
# path — only the host's amdgpu KERNEL driver (already loaded; the GPU nodes exist in
# the container). The GPU device-node GROUP access the bot user needs is granted
# host-adaptively by entrypoint.sh at container start (guide § Container GPU access),
# not here — the render gid is host-specific and must not be hardcoded.
# The version is pinned (ARG OLLAMA_VERSION) for reproducible rebuilds; the retry
# loop mirrors the claude/codex installs (network resilience). `command -v ollama`
# asserts the install at build time, failing the build loudly rather than at first
# serve. FOLLOW-UP: pre-`ollama pull` of a model (e.g. gpt-oss:20b) is intentionally
# left to first serve (into the bind-mounted home) rather than baked into an image
# layer; and a full GPU token-gen smoke test is the one check the guide flags as
# confirmable only on a real rebuild.
ARG OLLAMA_VERSION=0.31.2
RUN apt-get update && apt-get install -y zstd pciutils lshw \
    && rm -rf /var/lib/apt/lists/*
RUN for attempt in 1 2 3; do \
        curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION="${OLLAMA_VERSION}" sh \
        && curl -fSL https://ollama.com/download/ollama-linux-amd64-rocm.tar.zst \
             | zstd -d | tar -xf - -C /usr/local \
        && command -v ollama && exit 0; \
        if [ "$attempt" -eq 3 ]; then exit 1; fi; \
        echo "ollama install failed (attempt $attempt); retrying..." >&2; \
        sleep "$attempt"; \
    done

# Headless-Chromium shared libraries. Browser-verification jobs (the web-builder /
# web-designer roles, mermaid/SVG/data-URI rendering) launch a Chromium the project's
# own toolchain downloads (puppeteer/playwright) — the image ships NO Chromium binary,
# only the shared libraries that binary dynamically links. Their absence is exactly
# what made those jobs fail on a fresh image after a container recreation (`libnspr4.so`
# and friends — skills/mermaid-validation/SKILL.md, roles/web-{builder,designer}/AGENT.md).
# This is the Ubuntu 24.04 (noble) puppeteer/playwright dependency set, with the t64
# names from the 64-bit time_t transition; provision.sh's chromium-smoke.sh asserts a
# real headless launch against this set at bake time, so a future rename/removal fails
# the build rather than a browser job. Declared LATE so it never invalidates the
# expensive node/go/CLI layers above (apt is a no-op for any already pulled transitively).
RUN apt-get update && apt-get install -y \
    libnss3 \
    libnspr4 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0t64 \
    libcups2t64 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libglib2.0-0t64 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libx11-6 \
    libxcb1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2t64 \
    libatspi2.0-0t64 \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

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
#     `claude` resolves on a bare enter. `$HOME/.local/bin` is on the list because
#     the native installers land there (the AWS CLI v2 symlinks `aws` into it —
#     scripts/aws/install-aws-cli.sh), so a login shell (`bash -lc`, a tool that
#     re-execs one) can reach those tools too; without it only common.sh's runtime
#     PATH append covered them, which a login-shell re-derivation of PATH drops.
#   - USER / XDG_RUNTIME_DIR / DBUS: what `systemctl --user` needs to reach the
#     user bus. A `docker exec` (even `-l`) gets no PAM session, so these are unset
#     otherwise and every `systemctl --user` — the liaison's and its subprocesses'
#     — fails "No medium found" until self-healed. Setting them here (idempotent,
#     `${VAR:-…}`) retires that self-heal for every login shell; fleet scripts are
#     covered in parallel by common.sh's source-time systemd_user_env.
RUN printf '%s\n' \
    'export PATH="$HOME/bin:$HOME/.local/bin:$HOME/go/bin:/opt/go-tools/bin:/usr/local/go/bin:$PATH"' \
    'export USER="${USER:-$(id -un)}"' \
    'export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"' \
    'export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"' \
    > /etc/profile.d/garden.sh

ENV PATH="/home/${USERNAME}/bin:/home/${USERNAME}/.local/bin:/home/${USERNAME}/go/bin:${PATH}"

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

# Entrypoint links dotfiles, seeds the tmpfs-only API-key handoff for the
# lingering user manager, and prepares the user-systemd dir before exec'ing
# systemd as PID 1.
COPY entrypoint.sh /usr/local/bin/garden-entrypoint
COPY scripts/systemd/seed-api-key-handoff.sh /usr/local/lib/garden/seed-api-key-handoff.sh
RUN chmod +x /usr/local/bin/garden-entrypoint /usr/local/lib/garden/seed-api-key-handoff.sh

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
