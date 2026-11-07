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
exec bwrap "${args[@]}" -- "$@"
