#!/bin/bash
# check.sh -- the maintainer-inbox-information-hiding gate.
#
# Enforces the maintainer's 2026-06-28 directive: an agent scoped to an
# issue or a pull request communicates with the maintainer ONLY through
# comments on that issue/PR (inline-preferred + a summary), NEVER the
# garden's maintainer inbox. Stronger than "don't use it": an
# issue/PR-scoped role must not even be PRESENTED information suggesting
# the maintainer inbox exists (information-hiding). Only FREE-STANDING
# roles -- those that may be engaged with no issue/PR reference -- may
# reference the maintainer inbox.
#
# The RESTRICTED channel is the MAINTAINER inbox: the tokens
# `inbox/maintainer`, `message-user`, `maintainer-watch/-reply/-archive`,
# and the prose "maintainer inbox". The inter-agent message bus (role
# inboxes, `inbox-send.sh`, `send-msg.sh`, `read-msgs.sh`, broadcast) is
# a SEPARATE facility and is NOT matched here -- agent-to-agent routing
# is unaffected.
#
# Fires (exit 1) when ANY of:
#   1. An issue/PR-scoped role file (roles/<r>/AGENT.md or
#      roles/jurors/<seat>/AGENT.md, where <r>/<seat> is not in the
#      free-standing allowlist) contains a maintainer-inbox token.
#   2. A skill referenced by an issue/PR-scoped role contains a token
#      (the role would be presented the inbox via a loaded skill).
#   3. The set of token-bearing files under roles/ + skills/ is not
#      exactly the declared ALLOWLIST (a new leak anywhere, or a stale
#      allowlist entry). This is the machine-enforced "the set of files
#      that mention the inbox equals the audited free-standing set."
#
# Honors:
#   GATE_REPO_ROOT  the directory to scan (default: $PWD).
#
# Output: prints the specific violation(s) to stderr.
#
# Widening the free-standing set or the allowlist is a deliberate,
# reviewed act: edit FREE_STANDING_ROLES and INBOX_ALLOWLIST together in
# this file, in the same commit that adds the legitimate reference. That
# visible edit is the audit trail, the same shape as the monitoring
# safety constraint.

set -uo pipefail

REPO_ROOT=${GATE_REPO_ROOT:-$PWD}
test -d "$REPO_ROOT" || { echo "maintainer-inbox-information-hiding: REPO_ROOT not a directory: $REPO_ROOT" >&2; exit 2; }
cd "$REPO_ROOT" || { echo "maintainer-inbox-information-hiding: cd failed: $REPO_ROOT" >&2; exit 2; }

# No roles/ or skills/ layer to police (e.g. a fixture repo): pass.
if [ ! -d roles ] && [ ! -d skills ]; then
  exit 0
fi

# The maintainer-inbox token regex (ERE). Distinctive tokens only, so
# the bare word "maintainer" in unrelated prose does not match.
TOKEN_RE='inbox/maintainer|message-user|maintainer-watch|maintainer-reply|maintainer-archive|maintainer inbox|maintainer'"'"'s inbox|maintainer-inbox'

# FREE-STANDING roles: may be engaged WITHOUT an issue/PR reference, so
# they may reference the maintainer inbox. Every other role under roles/
# (and every juror seat) is issue/PR-scoped and must be inbox-free.
# Keyed by role-directory basename.
FREE_STANDING_ROLES=(
  liaison      # the maintainer-facing orchestrator
  proxy        # relays maintainer answers into blocked gardener inboxes
  foreman      # idle-pump orchestrator; defers blocked steps to the inbox
  gardener     # the worker; claims non-PR jobs and reaches the user
  watchman     # fleet-health broadcaster
  triager      # per-repo activity producer
  journalist   # bulletin narrator
  librarian    # on-demand journal search
  scholar      # documentation / library curator
  researcher   # refines a proposed design/build task
  monitor      # re-homed redirect onto triager + watchman
  mentor       # posts improvement jobs
  orchestrator # drives a job tree on the board; halts surface to the maintainer
)

# The EXACT set of files under roles/ + skills/ permitted to carry a
# maintainer-inbox token. Must equal the live token-bearing set; the
# gate fires on any drift in either direction.
INBOX_ALLOWLIST=(
  roles/README.md
  roles/liaison/AGENT.md
  roles/proxy/AGENT.md
  roles/foreman/AGENT.md
  roles/gardener/AGENT.md
  roles/orchestrator/AGENT.md
  roles/scholar/AGENT.md
  skills/message-bus/SKILL.md
  skills/at-mention-surveillance/SKILL.md
  skills/activity-feed-watcher/SKILL.md
  skills/self-healing-wrapper/SKILL.md
  skills/orchestration/SKILL.md
  skills/restore/SKILL.md
)

in_git=0
git rev-parse --git-dir >/dev/null 2>&1 && in_git=1

# token_files <path...> -> prints the subset of paths that contain a token.
token_files() {
  if [ "$in_git" -eq 1 ]; then
    git grep -lIE "$TOKEN_RE" -- "$@" 2>/dev/null || true
  else
    grep -rlIE --exclude-dir=.git "$TOKEN_RE" "$@" 2>/dev/null || true
  fi
}

# file_has_token <path> -> exit 0 if the file contains a token.
file_has_token() {
  [ -f "$1" ] || return 1
  grep -qIE "$TOKEN_RE" "$1" 2>/dev/null
}

is_free_standing() {
  local want=$1 r
  for r in "${FREE_STANDING_ROLES[@]}"; do
    [ "$r" = "$want" ] && return 0
  done
  return 1
}

VIOLATIONS=()

# --- Condition 1 + 2: every issue/PR-scoped role, and the skills it
# loads, must be inbox-free. ---
mapfile -t ROLE_FILES < <(
  { [ -d roles ] && find roles -name AGENT.md -type f; } 2>/dev/null | sort
)

for role_file in "${ROLE_FILES[@]}"; do
  # Role-directory basename: roles/<r>/AGENT.md -> <r>;
  # roles/jurors/<seat>/AGENT.md -> <seat>. Jurors are always scoped.
  role_dir=$(dirname "$role_file")
  role_name=$(basename "$role_dir")
  if is_free_standing "$role_name"; then
    continue
  fi

  # Condition 1: the scoped role file itself carries a token.
  if file_has_token "$role_file"; then
    VIOLATIONS+=("LEAK (scoped role): $role_file references the maintainer inbox; it is issue/PR-scoped and must reply via PR/issue comments only.")
  fi

  # Condition 2: a skill the scoped role loads carries a token.
  # Extract `skills/<name>/` references and resolve to the SKILL.md.
  mapfile -t loaded_skills < <(
    grep -oE 'skills/[a-z0-9-]+/' "$role_file" 2>/dev/null \
      | sed -E 's#^skills/([a-z0-9-]+)/$#\1#' | sort -u
  )
  for sk in "${loaded_skills[@]}"; do
    [ -n "$sk" ] || continue
    skill_file="skills/$sk/SKILL.md"
    if file_has_token "$skill_file"; then
      VIOLATIONS+=("LEAK (scoped role loads inbox skill): $role_file loads $skill_file, which references the maintainer inbox. A scoped role must not be presented the inbox even via a skill.")
    fi
  done
done

# --- Condition 3: the live token-bearing set must equal the allowlist. ---
mapfile -t LIVE_TOKEN_FILES < <(token_files roles skills | sort -u)

# 3a. Any live token file not on the allowlist is a leak.
declare -A ALLOWED=()
for f in "${INBOX_ALLOWLIST[@]}"; do ALLOWED["$f"]=1; done
for f in "${LIVE_TOKEN_FILES[@]}"; do
  if [ -z "${ALLOWED[$f]:-}" ]; then
    VIOLATIONS+=("LEAK (off-allowlist): $f references the maintainer inbox but is not on the free-standing allowlist in this gate. Either scrub it, or (if the file is a genuinely free-standing role/skill) add it to INBOX_ALLOWLIST + FREE_STANDING_ROLES.")
  fi
done

# 3b. Any allowlist entry that no longer carries the token is stale.
declare -A LIVE=()
for f in "${LIVE_TOKEN_FILES[@]}"; do LIVE["$f"]=1; done
for f in "${INBOX_ALLOWLIST[@]}"; do
  if [ -z "${LIVE[$f]:-}" ]; then
    VIOLATIONS+=("STALE allowlist entry: $f no longer references the maintainer inbox; remove it from INBOX_ALLOWLIST so the list keeps describing exactly the free-standing set.")
  fi
done

if [ "${#VIOLATIONS[@]}" -gt 0 ]; then
  printf 'maintainer-inbox-information-hiding gate fired:\n' >&2
  for v in "${VIOLATIONS[@]}"; do
    printf '  - %s\n' "$v" >&2
  done
  exit 1
fi

exit 0
