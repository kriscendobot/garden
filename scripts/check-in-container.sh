#!/bin/bash
# check-in-container.sh — verify this shell is inside the garden container.
#
# Usage: check-in-container.sh
#   exit 0 (silent)  — running inside the container, as intended.
#   exit 1 (warns)   — running on the HOST; the user likely forgot `./garden`.
#
# Why this exists: the container bind-mounts the host garden directory onto
# /home/kris, so the files look IDENTICAL whether you are inside the container
# or sitting in the same directory on the host. That makes it easy to forget to
# run `./garden` and start operating on the host by mistake — where commands run
# under the maintainer's identity (not the bot's), the systemd --user fleet and
# journal worktree are not the ones you think, and any push could land under the
# wrong identity. The liaison runs this at the start of every session (CLAUDE.md
# § Container guard) and surfaces the warning prominently.
#
# The signal is the container marker `/.dockerenv` (present in the container and
# in every gardener/subagent, which run inside it too; absent on the host). We
# deliberately do NOT key off `pwd == $HOME`: gardeners run jobs in per-job
# worktrees (cwd != home) yet are legitimately inside the container, and a host
# shell sitting in the bind-mounted garden dir has cwd == home yet is NOT.

set -euo pipefail

if [ -e /.dockerenv ] || grep -qaE 'docker|containerd|libpod' /proc/1/cgroup 2>/dev/null; then
    exit 0
fi

cat >&2 <<'EOF'

  ⚠️  NOT INSIDE THE GARDEN CONTAINER

  This shell appears to be running on the HOST, not inside the garden
  container. You most likely forgot to enter it with `./garden`.

  On the host, commands run under YOUR identity (not the bot's), the
  systemd --user fleet is not the garden's, and any git push could land
  under the wrong identity. The bind-mounted home makes the files look
  identical, which is exactly why this is easy to miss.

  To enter the container:   ./garden

EOF
exit 1
