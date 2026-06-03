#!/bin/bash
# run-all.sh -- the pre-dispatch grep-gate runner.
#
# Iterates each gate subdirectory under scripts/checks/, runs its
# check.sh, and on a non-zero exit invokes `claude -p` with the focused
# prompt.md as the prompt body. Otherwise the gate is a silent no-op
# (no LLM tokens burned).
#
# Usage:
#   scripts/checks/run-all.sh [--dry-run] [--list] [--gate <name>]
#                             [--base <ref>] [--repo <path>]
#
# Options:
#   --dry-run        report which gates would fire without invoking claude.
#                    Exits non-zero if any gate fires; useful from CI.
#   --list           list installed gates by name and exit 0.
#   --gate <name>    run only the named gate (basename of its subdirectory).
#                    May be repeated.
#   --base <ref>     git ref to diff against when a gate's check.sh asks for
#                    GATE_BASE_REF (default: $(git merge-base HEAD main) on
#                    a feature branch, or HEAD itself on main / detached).
#   --repo <path>    project root to operate on (default: $PWD).
#
# Exit codes:
#   0  — all gates exited 0 (no matches; no dispatches).
#   1  — at least one gate exited non-zero. In --dry-run, that is the
#        whole story. Without --dry-run, each fired gate's claude
#        invocation is launched; the runner still exits non-zero so the
#        caller (driver pre-CI step 0, CI workflow, manual user) knows
#        a follow-up dispatch happened.
#   64 — usage error.
#
# The contract every gate implements is documented in
# skills/pre-dispatch-grep-gate/SKILL.md.

set -uo pipefail

DRY_RUN=0
LIST_ONLY=0
GATES_FILTER=()
BASE_REF=""
REPO_ROOT=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift;;
    --list)    LIST_ONLY=1; shift;;
    --gate)
      [ "$#" -ge 2 ] || { echo "run-all: --gate requires an argument" >&2; exit 64; }
      GATES_FILTER+=("$2"); shift 2;;
    --base)
      [ "$#" -ge 2 ] || { echo "run-all: --base requires an argument" >&2; exit 64; }
      BASE_REF=$2; shift 2;;
    --repo)
      [ "$#" -ge 2 ] || { echo "run-all: --repo requires an argument" >&2; exit 64; }
      REPO_ROOT=$2; shift 2;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
      exit 0;;
    -*)
      echo "run-all: unknown option: $1" >&2
      exit 64;;
    *)
      echo "run-all: unexpected positional argument: $1" >&2
      exit 64;;
  esac
done

CHECKS_DIR=$(cd "$(dirname "$0")" && pwd)

# Resolve the project root. Default to the runner's grandparent (the
# scripts/checks/ directory's grandparent is the project root in the
# garden's layout: scripts/checks/run-all.sh -> ../../../).
REPO_ROOT=${REPO_ROOT:-$(cd "$CHECKS_DIR/../.." && pwd)}
test -d "$REPO_ROOT" || { echo "run-all: REPO_ROOT not a directory: $REPO_ROOT" >&2; exit 64; }

# Resolve the diff base. The probe scripts that want to look at "new"
# content read GATE_BASE_REF from the environment. Probes that look at
# the whole tree ignore it.
if [ -z "$BASE_REF" ]; then
  if git -C "$REPO_ROOT" rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
    # Prefer the merge-base against main. Fall back to HEAD if main is
    # absent (the gate then sees an empty diff and short-circuits).
    if git -C "$REPO_ROOT" rev-parse --verify --quiet main >/dev/null 2>&1; then
      BASE_REF=$(git -C "$REPO_ROOT" merge-base HEAD main 2>/dev/null || echo HEAD)
    else
      BASE_REF=HEAD
    fi
  else
    BASE_REF=HEAD
  fi
fi

export GATE_REPO_ROOT="$REPO_ROOT"
export GATE_BASE_REF="$BASE_REF"

# Enumerate gates: every subdirectory of scripts/checks/ that contains
# both check.sh and prompt.md.
mapfile -t ALL_GATES < <(
  find "$CHECKS_DIR" -mindepth 2 -maxdepth 2 -name check.sh -type f \
    -printf '%h\n' | sort
)

if [ "${#ALL_GATES[@]}" -eq 0 ]; then
  echo "run-all: no gates installed under $CHECKS_DIR" >&2
  exit 0
fi

if [ "$LIST_ONLY" -eq 1 ]; then
  for gate_dir in "${ALL_GATES[@]}"; do
    echo "$(basename "$gate_dir")"
  done
  exit 0
fi

# Apply the optional filter.
RUN_GATES=()
if [ "${#GATES_FILTER[@]}" -eq 0 ]; then
  RUN_GATES=("${ALL_GATES[@]}")
else
  for want in "${GATES_FILTER[@]}"; do
    matched=0
    for gate_dir in "${ALL_GATES[@]}"; do
      if [ "$(basename "$gate_dir")" = "$want" ]; then
        RUN_GATES+=("$gate_dir")
        matched=1
        break
      fi
    done
    if [ "$matched" -eq 0 ]; then
      echo "run-all: no such gate: $want" >&2
      exit 64
    fi
  done
fi

FIRED_GATES=()
RUNNER_RC=0

for gate_dir in "${RUN_GATES[@]}"; do
  gate_name=$(basename "$gate_dir")
  check="$gate_dir/check.sh"
  prompt="$gate_dir/prompt.md"
  if [ ! -x "$check" ] && [ ! -f "$check" ]; then
    echo "run-all: gate $gate_name has no check.sh; skipping" >&2
    continue
  fi
  if [ ! -f "$prompt" ]; then
    echo "run-all: gate $gate_name has no prompt.md; skipping" >&2
    continue
  fi

  # check.sh must exit 0 if no match, non-zero if match. We invoke it
  # in a subshell so a check.sh that sets `set -e` cannot taint us.
  if ( bash "$check" ); then
    # No match; silent pass.
    continue
  fi

  FIRED_GATES+=("$gate_name")
  RUNNER_RC=1

  echo "[gate fired] $gate_name" >&2

  if [ "$DRY_RUN" -eq 1 ]; then
    continue
  fi

  # Dispatch the focused claude prompt. The prompt body is the gate's
  # prompt.md verbatim; the runner does not splice in the matched
  # lines (the prompt instructs the agent to re-run the grep itself).
  # If claude is absent, we surface a one-line note and continue;
  # the runner's non-zero exit still signals the firing.
  if ! command -v claude >/dev/null 2>&1; then
    echo "run-all: claude not on PATH; cannot dispatch gate $gate_name" >&2
    continue
  fi

  claude -p "$(cat "$prompt")" || {
    echo "run-all: claude exited non-zero on gate $gate_name" >&2
  }
done

if [ "$RUNNER_RC" -eq 0 ]; then
  echo "pre-dispatch grep gates: all ${#RUN_GATES[@]} clean."
else
  echo "pre-dispatch grep gates: ${#FIRED_GATES[@]} of ${#RUN_GATES[@]} fired: ${FIRED_GATES[*]}"
fi

exit "$RUNNER_RC"
