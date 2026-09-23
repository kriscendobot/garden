#!/bin/bash
# package-manager.sh — detect the JS package manager a project uses and resolve
# the command that runs it. A shared library so the pre-push style gate
# (scripts/jobs/gardening/pre-push-gates.sh) and the pre-PR verification harness
# (scripts/jobs/gardening/local-verify.sh) select the SAME runner from the SAME
# signals rather than each hardcoding Yarn.
#
# Source this; do not execute it. It defines helpers only — no side effects, no
# network, no global mutation.
#
# The motivating defect: local-verify.sh always resolved its runner to `yarn`
# (or `npx corepack yarn`) unless GARDEN_YARN was set, so an npm-only repository
# such as kriscendobot/minion.town failed every step with "This package doesn't
# seem to be present in your lockfile" and every gauntlet had to remember
# `GARDEN_YARN=npm`. pre-push-gates.sh already solved selection in commit
# 0389ac0130; these helpers lift that logic to one home both scripts call.

# detect_package_manager <project-root> — echo the manager name: npm|yarn|pnpm|bun.
#
# Resolution order (first match wins):
#   1. GARDEN_YARN set            -> yarn. The legacy escape hatch and the tests'
#      stub seam: when GARDEN_YARN is set the runner is its value verbatim (see
#      package_manager_runner), so the manager it implies is yarn.
#   2. GARDEN_PACKAGE_MANAGER set -> that value verbatim.
#   3. package.json "packageManager" field (npm@…, yarn@…, pnpm@…, bun@…).
#   4. A lockfile: yarn.lock -> yarn; pnpm-lock.yaml -> pnpm;
#      package-lock.json / npm-shrinkwrap.json -> npm.
#   5. Default yarn — the garden's historical default. A new npm/pnpm project
#      should declare `packageManager` so this fallback is never reached.
detect_package_manager() {
  local project_root="${1:-$PWD}" manager="" specification=""
  if [ -n "${GARDEN_YARN:-}" ]; then printf 'yarn\n'; return 0; fi
  manager="${GARDEN_PACKAGE_MANAGER:-}"
  if [ -z "$manager" ] && [ -f "$project_root/package.json" ]; then
    if command -v jq >/dev/null 2>&1; then
      specification="$(jq -r '.packageManager // empty' \
        "$project_root/package.json" 2>/dev/null)" || specification=""
    else
      specification="$(sed -nE \
        's/.*"packageManager"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' \
        "$project_root/package.json" | head -n 1)"
    fi
    manager="${specification%%@*}"
  fi
  if [ -z "$manager" ]; then
    if [ -f "$project_root/yarn.lock" ]; then
      manager=yarn
    elif [ -f "$project_root/pnpm-lock.yaml" ]; then
      manager=pnpm
    elif [ -f "$project_root/package-lock.json" ] \
      || [ -f "$project_root/npm-shrinkwrap.json" ]; then
      manager=npm
    else
      manager=yarn
    fi
  fi
  printf '%s\n' "$manager"
}

# package_manager_runner <manager> — echo the command that runs that manager
# (`npm`, `yarn`, `pnpm`, `bun`, or `npx corepack <mgr>`). Both `<runner> run
# <script>` (universal across all four) and `<runner> install` work against it.
#
# Overrides, highest first:
#   - GARDEN_YARN         wins verbatim regardless of <manager> (the legacy
#     escape hatch and the tests' stub seam).
#   - GARDEN_PACKAGE_RUNNER wins verbatim next.
# Otherwise: npm/bun must be on PATH (they have no corepack shim path); yarn/pnpm
# fall back to `npx corepack <mgr>` when the bare binary is absent, since a fresh
# worktree often lacks it.
#
# Returns non-zero with a message on stderr when the required binary is missing
# or the manager is unsupported, so a caller can refuse rather than run a bogus
# command.
package_manager_runner() {
  local manager="$1"
  if [ -n "${GARDEN_YARN:-}" ]; then printf '%s\n' "$GARDEN_YARN"; return 0; fi
  if [ -n "${GARDEN_PACKAGE_RUNNER:-}" ]; then
    printf '%s\n' "$GARDEN_PACKAGE_RUNNER"; return 0
  fi
  case "$manager" in
    npm)
      command -v npm >/dev/null 2>&1 || {
        echo "package_manager_runner: project selects npm, but npm is unavailable" >&2
        return 2
      }
      printf 'npm\n' ;;
    yarn|pnpm)
      if command -v "$manager" >/dev/null 2>&1; then
        printf '%s\n' "$manager"
      else
        printf 'npx corepack %s\n' "$manager"
      fi ;;
    bun)
      command -v bun >/dev/null 2>&1 || {
        echo "package_manager_runner: project selects bun, but bun is unavailable" >&2
        return 2
      }
      printf 'bun\n' ;;
    *)
      echo "package_manager_runner: unsupported package manager '$manager'" >&2
      return 2 ;;
  esac
}

# package_manager_exec_prefix <manager> <runner> — echo the command PREFIX that
# executes a package BINARY resolved from the project's dependencies (`tsc`, …).
# Yarn/pnpm/bun dispatch a bin through their own runner; npm has no such verb, so
# it goes through `npx`. Used for the parity steps that CI spells `corepack yarn
# tsc` (local-verify's root-types), so the same check maps sensibly per manager
# instead of emitting an invalid `npm tsc`.
package_manager_exec_prefix() {
  local manager="$1" runner="$2"
  case "$manager" in
    yarn)     printf '%s\n' "$runner" ;;      # yarn <bin>
    pnpm)     printf '%s exec\n' "$runner" ;; # pnpm exec <bin>
    bun)      printf '%s x\n' "$runner" ;;    # bun x <bin>
    npm|*)    printf 'npx\n' ;;               # npm has no bin verb
  esac
}
