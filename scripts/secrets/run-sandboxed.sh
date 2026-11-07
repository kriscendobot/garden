#!/bin/bash
# Harness child mount/PID boundary. Secret injection happens in the trusted parent.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
source "$HERE/lib.sh"
worktree=''
allow_home=none
secret_kind=''
secret_environment=''
rw_paths=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --worktree) worktree="${2:?}"; shift 2;;
    --allow-home) allow_home="${2:?}"; shift 2;;
    --secret) secret_kind="${2:?}"; secret_environment="${3:?}"; shift 3;;
    --rw) rw_paths+=("${2:?}"); shift 2;;
    --) shift; break;;
    *) echo "run-sandboxed.sh: invalid option" >&2; exit 2;;
  esac
done
if [ ! -d "$worktree" ] || [ "$#" -eq 0 ]; then
  echo "run-sandboxed.sh: worktree and command required" >&2
  exit 2
fi
case "$allow_home" in claude|codex|kimi|opencode|none) ;; *) exit 2;; esac
case "$secret_kind:$secret_environment" in
  :) ;;
  anthropic:ANTHROPIC_API_KEY|moonshot:KIMI_MODEL_API_KEY|fireworks:FIREWORKS_API_KEY|openrouter:OPENROUTER_API_KEY|ollama-cloud:ANTHROPIC_AUTH_TOKEN) ;;
  *) echo "run-sandboxed.sh: invalid secret projection" >&2; exit 2;;
esac

# Read in the trusted launcher, then remove every inherited provider variable.
# The selected value is exported with a shell builtin, so it never appears in
# the argv of env(1), bubblewrap, or the CLI.
selected_secret=''
[ -z "$secret_kind" ] || selected_secret="$(secret_value "$secret_kind")" \
  || { echo "$secret_kind: secret unavailable" >&2; exit 75; }
unset ANTHROPIC_API_KEY MOONSHOT_API_KEY FIREWORKS_API_KEY OPENROUTER_API_KEY \
  OLLAMA_CLOUD_API_KEY TYPESAFE_API_KEY KIMI_MODEL_API_KEY ANTHROPIC_AUTH_TOKEN \
  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN \
  AWS_PROFILE AWS_SHARED_CREDENTIALS_FILE AWS_CONFIG_FILE
if [ -n "$secret_kind" ]; then
  printf -v "$secret_environment" '%s' "$selected_secret"
  export "${secret_environment?}"
  unset selected_secret
fi

# Hermetic handler tests exercise environment projection without depending on the
# host kernel's user-namespace policy. Production has no bypass.
if [ "${GARDEN_TEST:-0}" = 1 ]; then exec "$@"; fi
command -v bwrap >/dev/null 2>&1 || { echo "bubblewrap unavailable; refusing a secret-bearing harness" >&2; exit 75; }

args=(--die-with-parent --new-session --unshare-pid --ro-bind / / --proc /proc
      --dev-bind /dev /dev --chdir "$worktree" --tmpfs /tmp --bind "$worktree" "$worktree")
for path in "$GARDEN_SECRETS_DIR" /run/environment.d "$GARDEN_STATE/secret-broker" "$HOME/.aws"; do
  [ -e "$path" ] && args+=(--tmpfs "$path")
done
case "$allow_home" in
  claude) hidden=("$HOME/.codex" "$HOME/.config/opencode"); rw_paths+=("$HOME/.claude");;
  codex) hidden=("$HOME/.claude" "$HOME/.config/opencode"); rw_paths+=("$HOME/.codex");;
  kimi|opencode|none) hidden=("$HOME/.claude" "$HOME/.codex" "$HOME/.config/opencode");;
esac
for path in "${hidden[@]}"; do [ -e "$path" ] && args+=(--tmpfs "$path"); done
# Git worktrees keep mutable refs/index state outside the checkout. Bind only the
# selected worktree's administrative directory and its object store read-write.
if git_dir="$(git -C "$worktree" rev-parse --absolute-git-dir 2>/dev/null)"; then rw_paths+=("$git_dir"); fi
if common_dir="$(git -C "$worktree" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"; then rw_paths+=("$common_dir"); fi
for path in "${rw_paths[@]}"; do [ -e "$path" ] && args+=(--bind "$path" "$path"); done
# Project checkouts are created after the harness starts.  Their standing bare
# clones need to update FETCH_HEAD, refs, objects, and worktree administration,
# while git worktree add also needs to create the checkout below GARDEN_SCRATCH.
# Bind exactly those two project-checkout areas read-write; the rest of the
# garden root remains covered by the read-only root bind above.
# GARDEN_SCRATCH is normally an unexported common.sh default, so derive it here
# the same way (else the scratch bind is silently skipped) and pin it inside.
project_rw_paths=()
sbx_scratch="${GARDEN_SCRATCH:-${GARDEN_ROOT:+$GARDEN_ROOT/scratch}}"
[ -z "${GARDEN_ROOT:-}" ] || project_rw_paths+=("$GARDEN_ROOT/worktrees")
[ -z "$sbx_scratch" ] || project_rw_paths+=("$sbx_scratch")
for path in "${project_rw_paths[@]}"; do
  [ -d "$path" ] && args+=(--bind "$path" "$path")
done
[ -z "$sbx_scratch" ] || args+=(--setenv GARDEN_SCRATCH "$sbx_scratch")
# The scratch bind must not undo the narrower isolation below it: other jobs'
# garden worktrees and the shared TMPDIR parent (scratch/tmpexec, whose per-job
# children are bound rw individually below) are re-covered read-only.
if [ -n "$sbx_scratch" ] && [ -d "$sbx_scratch" ]; then
  own_wt="$(realpath -m "$worktree")"
  for path in "$sbx_scratch"/gardener-wt-*; do
    [ -d "$path" ] && [ "$(realpath -m "$path")" != "$own_wt" ] && args+=(--ro-bind "$path" "$path")
  done
  [ -n "${TMPDIR:-}" ] && [ -d "$TMPDIR" ] && args+=(--ro-bind "$TMPDIR" "$TMPDIR")
fi
# The harness needs a writable, exec-capable TMPDIR (Claude's Bash tool creates
# $TMPDIR/claude-<uid>/... per session). The inherited TMPDIR lives under the
# read-only root bind, so every shell call died with EROFS. Give each job its own
# fresh directory beneath it and bind ONLY that read-write; siblings stay read-only.
if [ -n "${TMPDIR:-}" ] && [ -d "$TMPDIR" ] && [ -w "$TMPDIR" ]; then
  # Opportunistic sweep of per-job dirs left by earlier (exec'd, uncleanable) runs.
  find "$TMPDIR" -maxdepth 1 -type d -name 'sbx-tmp.*' -mmin +1440 -exec rm -rf {} + 2>/dev/null || true
  if job_tmp="$(mktemp -d "$TMPDIR/sbx-tmp.XXXXXX" 2>/dev/null)"; then
    args+=(--bind "$job_tmp" "$job_tmp" --setenv TMPDIR "$job_tmp")
  fi
fi
# The garden's host state ($GARDEN_STATE) also lives under the read-only root, so
# inbox-read.sh / message-user.sh / report scripts died with EROFS opening their
# journal clone lock and the job requeued until exhausted (2026-11-07T02:13Z).
# Give each job a fresh, isolated state directory, bind ONLY it read-write, and
# export it as GARDEN_STATE. The host's real state (worker clones, markers,
# secret-broker) stays read-only and unshared. The one deliberate exception is
# repo-locks: per-job copies would silently stop serializing same-host pushes to
# the shared garden repository, so that directory is linked back and bound rw.
if [ -n "${GARDEN_STATE:-}" ]; then
  sbx_root="$GARDEN_STATE/sandbox-state"
  if mkdir -p "$sbx_root" 2>/dev/null; then
    find "$sbx_root" -mindepth 1 -maxdepth 1 -type d -name 'sbx-state.*' -mmin +2880 \
      -exec rm -rf {} + 2>/dev/null || true
    if job_state="$(mktemp -d "$sbx_root/sbx-state.XXXXXX" 2>/dev/null)"; then
      args+=(--bind "$job_state" "$job_state" --setenv GARDEN_STATE "$job_state")
      # Clone paths inherited from the parent point into the read-only host state
      # (and at the supervising worker's own clone); re-derive them per job.
      args+=(--unsetenv GARDEN_WORKER_CLONE --unsetenv GARDEN_PRODUCER_CLONE
             --unsetenv GARDEN_INBOX_CLONE --unsetenv GARDEN_JOURNAL_CLONE_BASE
             --unsetenv JOURNAL_REMOTE_CACHE)
      if mkdir -p "$GARDEN_STATE/repo-locks" 2>/dev/null \
        && ln -s "$GARDEN_STATE/repo-locks" "$job_state/repo-locks" 2>/dev/null; then
        args+=(--bind "$GARDEN_STATE/repo-locks" "$GARDEN_STATE/repo-locks")
      fi
      # The project dependency cache is likewise host-shared by design: a per-job
      # copy would cold-build every lockfile in every job and its per-slug flock
      # would stop serializing builds. Keep pointing at the host cache, bound rw.
      dep_cache="${GARDEN_DEP_CACHE_ROOT:-$GARDEN_STATE/dep-cache}"
      if mkdir -p "$dep_cache" 2>/dev/null; then
        args+=(--bind "$dep_cache" "$dep_cache" --setenv GARDEN_DEP_CACHE_ROOT "$dep_cache")
      fi
    fi
  fi
fi
exec bwrap "${args[@]}" -- "$@"
