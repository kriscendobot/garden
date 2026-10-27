#!/bin/bash
# pre-push-gates.sh -- mutating style checks and deterministic review probes.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Package-manager detection shared with local-verify.sh (npm/yarn/pnpm/bun), so
# both gates select the same runner from the same signals.
# shellcheck source=/dev/null
. "$HERE/../package-manager.sh"

usage() {
  echo "usage: pre-push-gates.sh [--no-auto-fix] [--probes-only] [--summary] [--base-ref <ref>] [<project-root>]" >&2
}

auto_fix=1
probes_only=0
summary=0
project_root=""
base_ref=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --no-auto-fix) auto_fix=0 ;;
    --probes-only) probes_only=1 ;;
    --summary) summary=1 ;;
    --base-ref)
      shift
      [ "$#" -gt 0 ] || { usage; exit 2; }
      base_ref="$1"
      ;;
    -h|--help) usage; exit 0 ;;
    --*) usage; exit 2 ;;
    *)
      [ -z "$project_root" ] || { usage; exit 2; }
      project_root="$1"
      ;;
  esac
  shift
done

project_root="${project_root:-$PWD}"
project_root="$(cd "$project_root" 2>/dev/null && pwd)" || {
  echo "pre-push-gates: no such project root: $project_root" >&2
  exit 2
}
if [ -n "$base_ref" ]; then
  git -C "$project_root" rev-parse --verify "$base_ref^{commit}" >/dev/null 2>&1 || {
    echo "pre-push-gates: base ref is not a commit: $base_ref" >&2
    exit 2
  }
  export PRE_PUSH_BASE_REF="$base_ref"
fi

select_package_runner() {
  # Detection and runner resolution live in package-manager.sh, shared with
  # local-verify.sh. GARDEN_YARN / GARDEN_PACKAGE_MANAGER / GARDEN_PACKAGE_RUNNER
  # keep their meaning there. A resolution failure (a selected manager whose
  # binary is unavailable, or an unsupported manager) prints to stderr and is
  # fatal to this gate, as before.
  package_manager="$(detect_package_manager "$project_root")"
  package_runner="$(package_manager_runner "$package_manager")" || exit 2
}

select_package_runner

has_script() {
  local name="$1"
  [ -f "$project_root/package.json" ] || return 1
  if command -v jq >/dev/null 2>&1; then
    jq -e --arg name "$name" '(.scripts // {}) | has($name)' \
      "$project_root/package.json" >/dev/null 2>&1
  else
    grep -qE "\"$name\"[[:space:]]*:" "$project_root/package.json"
  fi
}

temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT
failures=0
worst_exit=0
stage_count=0

record_stage() { # record_stage <label> <exit-code> <output-file>
  local label="$1" exit_code="$2" output_file="$3"
  stage_count=$((stage_count + 1))
  if [ "$exit_code" -eq 0 ]; then
    if [ "$summary" -eq 1 ]; then printf '%-31s pass\n' "$label"; fi
    return
  fi

  failures=$((failures + 1))
  [ "$exit_code" -le "$worst_exit" ] || worst_exit="$exit_code"
  printf '%-31s fail (exit %s)\n' "$label" "$exit_code"
  [ ! -s "$output_file" ] || sed 's/^/  /' "$output_file"
}

# --- resource bounds for project-script stages -------------------------------
# A project's own scripts (format, lint:fix, typecheck) are unbounded by default:
# a whole-repository `lint:fix` exhausted host memory on 2026-10-27 and the job's
# remaining wall went to OOM recovery. Each project-script stage therefore runs in
# its own session under a wall-clock limit and a sampled memory limit summed over
# the whole process tree. Exceeding either, a Node heap-exhaustion abort, or a
# SIGKILL death (the kernel OOM killer's signature) is a RESOURCE-EXHAUSTED result:
# the gate stops at once with exit 3 and does not run later stages, because the
# fix is a narrower stage, never a retry with a larger heap that starves the host.
#   GARDEN_PRE_PUSH_RESOURCE_LIMITS=0   disable both bounds (the unbounded run)
#   GARDEN_PRE_PUSH_STAGE_WALL          per-stage seconds; 0 disables (1200)
#   GARDEN_PRE_PUSH_STAGE_MEMORY_MB     per-stage tree RSS in MiB; 0 disables
#                                       (25% of MemTotal)
#   GARDEN_PRE_PUSH_DEADLINE_MARGIN     seconds kept free before the claim's
#                                       handler deadline (300)
# Claim safety: gardener.sh exports GARDEN_HANDLER_DEADLINE_EPOCH; the stage wall
# is clamped so the stage ends at least the margin before that deadline, leaving
# the agent time to report instead of being killed mid-stage by the handler wall.
RESOURCE_EXHAUSTED_EXIT=3
: "${GARDEN_PRE_PUSH_RESOURCE_LIMITS:=1}"
: "${GARDEN_PRE_PUSH_STAGE_WALL:=1200}"
: "${GARDEN_PRE_PUSH_DEADLINE_MARGIN:=300}"
: "${GARDEN_PRE_PUSH_SAMPLE_INTERVAL:=1}"
: "${GARDEN_PRE_PUSH_KILL_GRACE:=5}"
if [ -z "${GARDEN_PRE_PUSH_STAGE_MEMORY_MB:-}" ]; then
  GARDEN_PRE_PUSH_STAGE_MEMORY_MB=$(awk '/^MemTotal:/ { printf "%d\n", $2 / 1024 / 4 }' /proc/meminfo 2>/dev/null)
  : "${GARDEN_PRE_PUSH_STAGE_MEMORY_MB:=0}"
fi
for knob in GARDEN_PRE_PUSH_STAGE_WALL GARDEN_PRE_PUSH_STAGE_MEMORY_MB \
  GARDEN_PRE_PUSH_DEADLINE_MARGIN GARDEN_PRE_PUSH_KILL_GRACE; do
  case "${!knob}" in
    ''|*[!0-9]*)
      echo "pre-push-gates: $knob must be a non-negative integer: ${!knob}" >&2
      exit 2
      ;;
  esac
done

# stage_wall_seconds -> the wall for a stage starting now, clamped to the claim
# deadline. Prints 0 for "no wall" and -1 when no claim-safe time remains.
stage_wall_seconds() {
  local wall="$GARDEN_PRE_PUSH_STAGE_WALL" deadline="${GARDEN_HANDLER_DEADLINE_EPOCH:-}" remaining
  case "$deadline" in
    ''|*[!0-9]*) ;;
    *)
      remaining=$(( deadline - $(date +%s) - GARDEN_PRE_PUSH_DEADLINE_MARGIN ))
      if [ "$remaining" -le 0 ]; then
        echo -1
        return
      fi
      if [ "$wall" -eq 0 ] || [ "$remaining" -lt "$wall" ]; then wall="$remaining"; fi
      ;;
  esac
  echo "$wall"
}

session_rss_kib() { # session_rss_kib <session-id>
  ps -s "$1" -o rss= 2>/dev/null | awk '{ total += $1 } END { print total + 0 }'
}

stop_session() { # stop_session <session-id>
  local session="$1" waited=0
  pkill -TERM -s "$session" 2>/dev/null || true
  while [ "$waited" -lt "$GARDEN_PRE_PUSH_KILL_GRACE" ] && pgrep -s "$session" >/dev/null 2>&1; do
    sleep 1
    waited=$((waited + 1))
  done
  pkill -KILL -s "$session" 2>/dev/null || true
}

# run_project_command <output-file> <command-string>: runs a project script in the
# project root. Sets stage_exit, and stage_exhausted to a non-empty reason when the
# stage hit a resource bound.
run_project_command() {
  local output_file="$1" command_string="$2" wall memory_kib pid session started
  stage_exit=0
  stage_exhausted=""
  if [ "$GARDEN_PRE_PUSH_RESOURCE_LIMITS" = 0 ]; then
    (cd "$project_root" && bash -c "$command_string") >"$output_file" 2>&1 || stage_exit=$?
    return 0
  fi

  wall=$(stage_wall_seconds)
  if [ "$wall" -lt 0 ]; then
    stage_exit=124
    stage_exhausted="no claim-safe time left before the handler deadline (margin ${GARDEN_PRE_PUSH_DEADLINE_MARGIN}s); stage not started"
    : >"$output_file"
    return 0
  fi
  memory_kib=$(( GARDEN_PRE_PUSH_STAGE_MEMORY_MB * 1024 ))

  # A background child of a non-interactive shell is not a process-group leader,
  # so setsid(1) makes it a session leader in place: its pid names the session.
  (cd "$project_root" && exec setsid bash -c "$command_string") >"$output_file" 2>&1 &
  pid=$!
  session="$pid"
  started=$(date +%s)
  while kill -0 "$pid" 2>/dev/null; do
    if [ "$memory_kib" -gt 0 ] && [ "$(session_rss_kib "$session")" -gt "$memory_kib" ]; then
      stage_exhausted="memory: process tree exceeded ${GARDEN_PRE_PUSH_STAGE_MEMORY_MB} MiB RSS"
      pkill -KILL -s "$session" 2>/dev/null || true
      break
    fi
    if [ "$wall" -gt 0 ] && [ $(( $(date +%s) - started )) -ge "$wall" ]; then
      stage_exhausted="wall: exceeded ${wall}s"
      stop_session "$session"
      break
    fi
    sleep "$GARDEN_PRE_PUSH_SAMPLE_INTERVAL"
  done
  wait "$pid" || stage_exit=$?
  # Reap anything the stage left behind in its session.
  pkill -KILL -s "$session" 2>/dev/null || true

  if [ -z "$stage_exhausted" ] && [ "$stage_exit" -ne 0 ]; then
    if grep -Eq 'JavaScript heap out of memory|Reached heap limit|Allocation failed - process out of memory' \
      "$output_file" 2>/dev/null; then
      stage_exhausted="memory: Node heap exhausted"
    elif [ "$stage_exit" -eq 137 ]; then
      stage_exhausted="memory: killed by SIGKILL (likely the kernel OOM killer)"
    fi
  fi
  return 0
}

# stop_on_resource_exhaustion <label> <output-file>: when the stage just run hit a
# resource bound, report it and end the gate immediately.
stop_on_resource_exhaustion() {
  local label="$1" output_file="$2"
  [ -n "$stage_exhausted" ] || return 0
  printf '%-31s resource-exhausted (%s)\n' "$label" "$stage_exhausted"
  [ ! -s "$output_file" ] || tail -n 40 "$output_file" | sed 's/^/  /'
  echo "result: resource-exhausted; gate stopped. Do NOT retry with a larger heap or"
  echo "  a raised limit: narrow the stage (lint only the changed packages or files)"
  echo "  or report the bound in the job instead."
  exit "$RESOURCE_EXHAUSTED_EXIT"
}

run_command_stage() { # run_command_stage <label> <command-string>
  local label="$1" command_string="$2" output_file exit_code=0
  output_file="$temporary_directory/stage-$stage_count"
  (cd "$project_root" && bash -c "$command_string") >"$output_file" 2>&1 || exit_code=$?
  record_stage "$label" "$exit_code" "$output_file"
  return 0
}

run_project_stage() { # run_project_stage <label> <command-string>
  local label="$1" command_string="$2" output_file
  output_file="$temporary_directory/stage-$stage_count"
  run_project_command "$output_file" "$command_string"
  stop_on_resource_exhaustion "$label" "$output_file"
  record_stage "$label" "$stage_exit" "$output_file"
  return 0
}

package_script_command() { # package_script_command <script> [arguments]
  local script="$1" arguments="${2:-}"
  if [ -n "$arguments" ] && [ "$package_manager" = npm ]; then
    printf '%s run %s -- %s\n' "$package_runner" "$script" "$arguments"
  elif [ -n "$arguments" ]; then
    printf '%s run %s %s\n' "$package_runner" "$script" "$arguments"
  else
    printf '%s run %s\n' "$package_runner" "$script"
  fi
}

if [ "$probes_only" -eq 0 ] && [ "$auto_fix" -eq 1 ]; then
  if has_script format; then
    run_project_stage "$package_manager format" "$(package_script_command format)"
    git -C "$project_root" add -A
  fi
  # Prefer a dedicated fix script over appending `--fix` to `lint`: package
  # runners append extra args to the END of the script string, so on a chained
  # script (`lint:a && lint:b && lint:sh`) the flag lands on the last leg
  # only — and a leg that does not know `--fix` (shellcheck) hard-fails the
  # stage even though every real linter passed.
  if has_script lint-fix; then
    run_project_stage "$package_manager lint-fix" "$(package_script_command lint-fix)"
    git -C "$project_root" add -A
  elif has_script lint:fix; then
    run_project_stage "$package_manager lint:fix" "$(package_script_command lint:fix)"
    git -C "$project_root" add -A
  elif has_script lint; then
    run_project_stage "$package_manager lint --fix" \
      "$(package_script_command lint --fix)"
    git -C "$project_root" add -A
  fi
fi

# This probe has a deterministic fixer. Run it before the read-only probe pass,
# even in --probes-only mode, unless the caller explicitly requested no fixes.
typist_probe="$HERE/pre-push-gates/probes/typist-friendly-code-points.sh"
if [ "$auto_fix" -eq 1 ] && [ -x "$typist_probe" ]; then
  run_command_stage "typist code points --fix" \
    "$(printf '%q' "$typist_probe") --fix $(printf '%q' "$project_root")"
fi

for probe in "$HERE"/pre-push-gates/probes/*.sh; do
  [ -x "$probe" ] || continue
  output_file="$temporary_directory/stage-$stage_count"
  exit_code=0
  "$probe" "$project_root" >"$output_file" 2>&1 || exit_code=$?
  record_stage "probe $(basename "$probe" .sh)" "$exit_code" "$output_file"
done

# Added multi-line prose comments need judgment: they may preserve a non-obvious
# invariant, or may only narrate the adjacent code. Reuse the panel-hints signal
# as a non-blocking author-time advisory so builders and fixers reread candidates
# before push without turning every substantial comment into a gate failure.
comment_concision_probe="$HERE/../../../skills/panel-hints/probes/C-pruner.sh"
if [ -x "$comment_concision_probe" ]; then
  stage_count=$((stage_count + 1))
  comment_concision_output=""
  if [ -n "$base_ref" ]; then
    comment_concision_output=$(cd "$project_root" && PRUNER_SKIP_IF_MARKDOWN=0 BASE="$base_ref" "$comment_concision_probe" 2>/dev/null)
  else
    comment_concision_output=$(cd "$project_root" && "$comment_concision_probe" --staged 2>/dev/null)
  fi
  if [[ "$comment_concision_output" == fire\ pruner* ]]; then
    printf '%-31s warn (non-blocking)\n' "advisory comment concision"
    printf '%s\n' "$comment_concision_output" | sed 's/^/  /'
  elif [ "$summary" -eq 1 ]; then
    printf '%-31s pass\n' "advisory comment concision"
  fi
fi

if [ "$probes_only" -eq 0 ] && has_script typecheck; then
  output_file="$temporary_directory/stage-$stage_count"
  run_project_command "$output_file" "$(package_script_command typecheck)"
  stop_on_resource_exhaustion "$package_manager typecheck" "$output_file"
  exit_code="$stage_exit"
  # Typecheck is the terminal, non-auto-fixable stage. Reserve exit 2 for it so
  # callers can distinguish it from a deterministic probe finding.
  [ "$exit_code" -eq 0 ] || exit_code=2
  record_stage "$package_manager typecheck" "$exit_code" "$output_file"
fi

if [ "$failures" -eq 0 ]; then
  [ "$summary" -eq 0 ] || echo "result: pass ($stage_count stages)"
  exit 0
fi

echo "result: $failures failing stage(s); address and re-run."
exit "$worst_exit"
