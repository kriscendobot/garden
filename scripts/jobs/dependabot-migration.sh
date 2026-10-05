#!/bin/bash
# dependabot-migration.sh — the closed table of per-(repo, package) MIGRATION HOOKS a
# Dependabot bump predictably needs before CI can pass, and the fail-closed runner
# that applies one on a botanist's PR-head checkout.
#
# Usage:
#   dependabot-migration.sh lookup <owner/repo> <package>
#       -> prints the hook id and exits 0, or exits 1 when no hook matches.
#   dependabot-migration.sh run <hook-id> <checkout> <base-ref>
#       -> runs the hook in <checkout> (a project checkout of the PR head) and
#          commits its output; never pushes.
#
# Why: every `@anthropic-ai/claude-code` bump on kriscendobot/minion.town leaves the
# Dependabot head red, because tools/claude-harness/check.mjs pins
# tools/claude-harness/release.json to the npm version and only
# `npm run claude-harness:refresh` (signed-manifest verify + regenerate) moves it
# (journal 2026-10-05T09:42:13Z, PR #158; also PR #103 on 2026-09-27). The botanist
# had to discover that from a red CI run each time. dependabot-watcher.sh looks the
# parsed (repo, package) up here and, on a match, tells the botanist to run the hook
# before shepherding CI (designs/claude-harness-provisioning.md § Standing upgrade
# obligation, step 3).
#
# The lookup is an exact string match on the watcher's charset-validated captures,
# so no PR text reaches a job body through it. The runner fails CLOSED at each gate
# and never commits on a failure:
#   rc 2  usage, unknown hook, dirty checkout, or the PR diff against <base-ref>
#         touches a path outside the hook's allowed input set (not a plain bump)
#   rc 3  the command changed or created a path outside the hook's output set
#   rc 4  the refresh or post-refresh validation command failed, or timed out
# rc 0 prints `committed <sha>` or `already-current` (nothing to commit).
set -euo pipefail

: "${GARDEN_DEP_MIGRATION_TIMEOUT_SECS:=900}"

# The hook table. Fields, tab-separated:
#   id  repo  package  allowed-inputs  command  validate  outputs  commit-subject
# allowed-inputs: paths the PR may already touch relative to the base (space-separated).
# outputs: the ONLY paths the command may modify. Adding a row is a reviewed change
# to this file, never runtime configuration.
hook_table() {
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    claude-harness-refresh kriscendobot/minion.town @anthropic-ai/claude-code \
    'tools/claude-harness/package.json tools/claude-harness/package-lock.json tools/claude-harness/release.json' \
    claude-harness:refresh claude-harness:check \
    'tools/claude-harness/release.json' \
    'chore(claude-harness): refresh release.json pin'
}

die() { printf 'dependabot-migration: %s\n' "$*" >&2; exit "${2:-2}"; }
fail() { local rc="$1"; shift; printf 'dependabot-migration: %s\n' "$*" >&2; exit "$rc"; }

in_set() {  # in_set <path> <space-separated set>
  local p
  for p in $2; do [ "$p" = "$1" ] && return 0; done
  return 1
}

run_npm_script() {  # run_npm_script <checkout> <script>
  # ignore-scripts skips pre/post lifecycle hooks; `npm run` still runs <script>.
  local cmd=(env npm_config_ignore_scripts=true npm --prefix "$1" run --silent "$2")
  if command -v timeout >/dev/null 2>&1; then
    timeout --signal=TERM --kill-after=10s "${GARDEN_DEP_MIGRATION_TIMEOUT_SECS}s" "${cmd[@]}"
  else
    "${cmd[@]}"
  fi
}

action="${1:-}"
case "$action" in
  lookup)
    [ $# -eq 3 ] || die "usage: $0 lookup <owner/repo> <package>"
    hook_table | awk -F'\t' -v r="$2" -v p="$3" '$2 == r && $3 == p {print $1; f=1; exit} END {exit !f}'
    ;;
  run)
    [ $# -eq 4 ] || die "usage: $0 run <hook-id> <checkout> <base-ref>"
    id="$2" co="$3" baseref="$4"
    row="$(hook_table | awk -F'\t' -v i="$id" '$1 == i')"
    [ -n "$row" ] || die "unknown hook '$id'"
    IFS=$'\t' read -r _ _ _ inputs refresh validate outputs subject <<< "$row"
    git -C "$co" rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "'$co' is not a git checkout"
    git -C "$co" rev-parse -q --verify "$baseref^{commit}" >/dev/null || die "base ref '$baseref' is not a commit in '$co'"

    # Gate 1: a clean checkout, so the output scan below sees only the hook's writes.
    [ -z "$(git -C "$co" status --porcelain --untracked-files=all)" ] \
      || die "checkout '$co' has uncommitted changes; refusing to run"

    # Gate 2: the PR is still the plain bump this hook was written for.
    changed="$(git -C "$co" diff --name-only "$baseref...HEAD")"
    [ -n "$changed" ] || die "PR head has no diff against '$baseref'"
    while IFS= read -r p; do
      in_set "$p" "$inputs" || die "PR touches '$p', outside the '$id' input set ($inputs); not a plain bump"
    done <<< "$changed"

    # Run the refresh. A failure leaves whatever it wrote in place and uncommitted.
    run_npm_script "$co" "$refresh" || fail 4 "'npm run $refresh' failed in '$co'; nothing committed"

    # Gate 3: the command wrote only its declared outputs.
    dirty="$(git -C "$co" status --porcelain --untracked-files=all)"
    if [ -z "$dirty" ]; then
      run_npm_script "$co" "$validate" || fail 4 "'npm run $validate' failed in '$co'"
      echo already-current
      exit 0
    fi
    while IFS= read -r line; do
      p="${line:3}"
      case "$line" in
        ' M '*) in_set "$p" "$outputs" || fail 3 "'$id' modified '$p', outside its output set ($outputs); nothing committed" ;;
        *) fail 3 "'$id' produced '$line', not a modification of ($outputs); nothing committed" ;;
      esac
    done <<< "$dirty"

    # Gate 4: the regenerated pin agrees with the bumped manifest and lockfile.
    run_npm_script "$co" "$validate" || fail 4 "'npm run $validate' rejected the refreshed output in '$co'; nothing committed"

    # shellcheck disable=SC2086  # $outputs is a space-separated path list
    git -C "$co" add -- $outputs
    # shellcheck disable=SC2086
    git -C "$co" commit -q -m "$subject" \
      -m "Regenerated by \`npm run $refresh\` (garden scripts/jobs/dependabot-migration.sh hook '$id') after the Dependabot bump; \`npm run $validate\` passed on the result." \
      -- $outputs
    printf 'committed %s\n' "$(git -C "$co" rev-parse HEAD)"
    ;;
  *)
    die "usage: $0 lookup <owner/repo> <package> | run <hook-id> <checkout> <base-ref>"
    ;;
esac
