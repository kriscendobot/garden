#!/bin/bash
# local-verify.sh — the deterministic, no-LLM pre-PR verification harness.
#
# Runs the project's real verification steps, IN ORDER, before a change is
# pushed for a pull request:
#
#   format -> lint -> build -> test -> docgen
#
# so the work is offloaded from the CI server: a change that passes here is far
# more likely to be green on the first CI push, which shortens (or eliminates)
# the shepherd loop and spends fewer tokens on remote test discovery.
#
# Design contract (see skills/local-verify/SKILL.md and the gardening state
# machine, designs/gardening-state-machine.md):
#
#   * NO LLM. Pure shell plus the project's own commands. It is the gardening
#     state machine's "evaluation gate (always)" body, wired as GARDEN_EVAL in
#     garden-pr.sh.
#
#   * SILENT ON SUCCESS. A run where every discovered step passes prints
#     NOTHING and exits 0, to protect the supervising agent's context window.
#
#   * GIT-CONTENT-STORE FAILURE CAPTURE. A failing step's combined stdout+stderr
#     is hashed into the project worktree's object store via `git hash-object -w`
#     (the capture_blob helper from common.sh). Only the resulting blob SHA (plus
#     a one-line tail and the exact inspect command) reaches stdout — never the
#     raw output. A debugging agent then reads ONLY the slices it needs:
#         git -C <worktree> cat-file -p <sha> | grep/sed/tail
#     so a large test log never floods the agent's context.
#
#   * DETERMINISTIC & RE-RUNNABLE. Identical inputs hash to identical SHAs, so a
#     recurring failure is recognizable by its content address.
#
#   * EVALUATION-GATE DISCIPLINE. It errs toward running the project's FULL
#     suite: false positives (a wasted check) are fine, false negatives (a
#     regression that slips to CI) are not. Steps are not sense-gated.
#
# Usage: local-verify.sh [<worktree>]
#   <worktree> defaults to the current directory (the gardening project/ tree).
#
# Per-step command discovery (each step, in order, first match wins):
#   1. An explicit override env var LOCAL_VERIFY_<STEP> (uppercased step name):
#        - set to a command string  -> run that command in the worktree
#        - set to "-"                -> skip this step
#   2. A package.json "scripts" entry matching the step's candidate names
#      (run as `<yarn> run <script>`).
#   3. Otherwise the step is skipped (recorded, silent).
#
# A project with no package.json and no overrides verifies nothing and exits 0;
# wire the real commands per project via package.json scripts or the overrides.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Reuse the shared failure-capture helper (capture_blob) and log() from the job
# board common library. Sourcing it does no network I/O; it only defines helpers
# and pins the fleet gh identity onto PATH.
# shellcheck source=/dev/null
. "$HERE/../common.sh"

wt="${1:-$PWD}"
wt="$(cd "$wt" 2>/dev/null && pwd)" || { echo "local-verify: no such worktree: ${1:-$PWD}" >&2; exit 2; }
pkg="$wt/package.json"

# The package runner: plain `yarn` is often absent in a fresh worktree, so fall
# back to `npx corepack yarn` (see skills/pre-pr-checklist § Pitfalls). Override
# with GARDEN_YARN for tests or a project that uses a different runner.
if [ -n "${GARDEN_YARN:-}" ]; then
  YARN="$GARDEN_YARN"
elif command -v yarn >/dev/null 2>&1; then
  YARN="yarn"
else
  YARN="npx corepack yarn"
fi

# Steps in execution order, and the package.json script names each maps to. The
# first candidate that exists wins. Check-only variants come first so the harness
# verifies rather than mutates where a project offers the choice.
STEPS="format lint build test docs"
candidates() {
  case "$1" in
    format) echo "format:check check:format format-check format" ;;
    lint)   echo "lint:check lint eslint" ;;
    build)  echo "build compile build:js" ;;
    test)   echo "test test:unit" ;;
    docs)   echo "docs build:types generate-docs" ;;
    *)      echo "" ;;
  esac
}

has_script() {  # has_script <name> — true if package.json defines scripts.<name>
  [ -f "$pkg" ] || return 1
  if command -v jq >/dev/null 2>&1; then
    jq -e --arg s "$1" '(.scripts // {}) | has($s)' "$pkg" >/dev/null 2>&1
  else
    # jq-less fallback: match a "<name>": key. Coarser but never silently empty.
    grep -qE "\"$1\"[[:space:]]*:" "$pkg"
  fi
}

discover() {  # discover <step> — print the command string to run, or nothing
  local step="$1" up override name
  up="$(printf '%s' "$step" | tr '[:lower:]' '[:upper:]')"
  override="LOCAL_VERIFY_$up"
  if [ -n "${!override+x}" ]; then        # override is SET (even if empty)
    case "${!override}" in
      -|"") return 0 ;;                    # explicit skip
      *)    printf '%s\n' "${!override}" ; return 0 ;;
    esac
  fi
  for name in $(candidates "$step"); do
    if has_script "$name"; then printf '%s run %s\n' "$YARN" "$name"; return 0; fi
  done
  return 0                                 # no command — skip
}

failures=0

run_step() {  # run_step <step> — run it; silent on pass; SHA-capture on fail
  local step="$1" cmd out sha lines tail
  cmd="$(discover "$step")"
  [ -n "$cmd" ] || return 0               # nothing discovered — skipped, silent

  out="$(mktemp "${TMPDIR:-/tmp}/local-verify-$step.XXXXXX")"
  if ( cd "$wt" && bash -c "$cmd" ) >"$out" 2>&1; then
    rm -f "$out"                          # success: silent; blob not needed
    return 0
  fi

  # Failure: hash the combined output into the worktree's object store and
  # surface only the SHA + a one-line tail + the inspect command.
  sha="$(capture_blob "$out" "$wt" 2>/dev/null)" || sha="(capture failed)"
  lines="$(wc -l <"$out" | tr -d ' ')"
  tail="$(grep -v '^[[:space:]]*$' "$out" | tail -n 1)"
  printf 'STEP %s FAILED: output blob %s (%s lines) inspect: git -C %s cat-file -p %s\n' \
    "$step" "$sha" "$lines" "$wt" "$sha"
  [ -n "$tail" ] && printf '  %s\n' "$tail"
  rm -f "$out"
  failures=$((failures + 1))
  return 1
}

for step in $STEPS; do
  run_step "$step" || true                 # run all steps; aggregate failures
done

# Exit non-zero if any step failed, so the caller (the eval gate) can fail loud
# and hand the emitted SHAs to a debugging agent. Quiet and zero on full pass.
[ "$failures" -eq 0 ]
