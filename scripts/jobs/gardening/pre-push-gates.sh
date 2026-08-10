#!/bin/bash
# pre-push-gates.sh -- mutating style checks and deterministic review probes.

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

if [ -n "${GARDEN_YARN:-}" ]; then
  yarn_command="$GARDEN_YARN"
elif command -v yarn >/dev/null 2>&1; then
  yarn_command=yarn
else
  yarn_command="npx corepack yarn"
fi

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

run_command_stage() { # run_command_stage <label> <command-string>
  local label="$1" command_string="$2" output_file exit_code=0
  output_file="$temporary_directory/stage-$stage_count"
  (cd "$project_root" && bash -c "$command_string") >"$output_file" 2>&1 || exit_code=$?
  record_stage "$label" "$exit_code" "$output_file"
  return 0
}

if [ "$probes_only" -eq 0 ] && [ "$auto_fix" -eq 1 ]; then
  if has_script format; then
    run_command_stage "yarn format" "$yarn_command run format"
    git -C "$project_root" add -A
  fi
  if has_script lint; then
    run_command_stage "yarn lint --fix" "$yarn_command run lint --fix"
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

if [ "$probes_only" -eq 0 ] && has_script typecheck; then
  output_file="$temporary_directory/stage-$stage_count"
  exit_code=0
  (cd "$project_root" && bash -c "$yarn_command run typecheck") \
    >"$output_file" 2>&1 || exit_code=$?
  # Typecheck is the terminal, non-auto-fixable stage. Reserve exit 2 for it so
  # callers can distinguish it from a deterministic probe finding.
  [ "$exit_code" -eq 0 ] || exit_code=2
  record_stage "yarn typecheck" "$exit_code" "$output_file"
fi

if [ "$failures" -eq 0 ]; then
  [ "$summary" -eq 0 ] || echo "result: pass ($stage_count stages)"
  exit 0
fi

echo "result: $failures failing stage(s); address and re-run."
exit "$worst_exit"
