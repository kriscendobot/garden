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
# Second row: every `peter-evans/create-pull-request` bump on endojs/endo-but-for-bots
# rewrites the SHA pin in .github/workflows/update-action-pins{,-major}.yml but keeps
# the floating `# v8` trailing comment, which zizmor flags as a mismatched version
# comment (PR #1662, 2026-11-15T20:25:40Z, repaired by a hand-made bot commit). The
# built-in `action-pin-comments` step resolves the pinned SHA to its exact
# `vX.Y.Z` tag on the action's upstream (`git ls-remote`, no PR text) and rewrites
# only that comment. A step named `builtin:<fn>` runs a function in this file; any
# other step name is an `npm run` script.
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
    'tools/claude-harness/package.json tools/claude-harness/package-lock.json tools/claude-harness/manifest.json tools/claude-harness/manifest.json.sig tools/claude-harness/release.json' \
    claude-harness:refresh claude-harness:check \
    'tools/claude-harness/manifest.json tools/claude-harness/manifest.json.sig tools/claude-harness/release.json' \
    'chore(claude-harness): refresh signed release manifest'
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    action-pin-comments endojs/endo-but-for-bots peter-evans/create-pull-request \
    '.github/workflows/update-action-pins.yml .github/workflows/update-action-pins-major.yml' \
    builtin:action-pin-comments builtin:action-pin-comments-check \
    '.github/workflows/update-action-pins.yml .github/workflows/update-action-pins-major.yml' \
    'chore: pin action version comments to the exact tag'
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

# --- built-in steps -------------------------------------------------------------
# A built-in exits rc 2 itself (via die) when the PR is not the plain bump it knows;
# any other failure returns non-zero and the runner reports rc 4. Each is called as <fn> <checkout> <base-ref> <action> <outputs>, where <action> is
# the row's package (an `owner/repo` GitHub Action) and <outputs> its output set.
: "${GARDEN_DEP_MIGRATION_ACTION_REMOTE:=https://github.com}"

pin_line_re() {  # ERE for one `uses: <action>@<sha> # <comment>` line of <action>
  local a="${1//./\\.}"
  printf '^[[:space:]]*(- )?uses: %s@[0-9a-f]{40}( # [A-Za-z0-9.+_-]+)?[[:space:]]*$' "$a"
}

# pinned_shas <checkout> <action> <outputs>: the distinct SHAs <action> is pinned to.
# Every output must carry at least one pin line, or it is not the file this row knows.
pinned_shas() {
  local co="$1" a="$2" f re
  re="$(pin_line_re "$a")"
  for f in $3; do
    [ -f "$co/$f" ] || { echo "missing $f" >&2; return 1; }
    grep -Eq "$re" "$co/$f" || { echo "no '$a' pin line in $f" >&2; return 1; }
    grep -E "$re" "$co/$f" | sed -E 's/.*@([0-9a-f]{40}).*/\1/'
  done | sort -u
}

# exact_tag <action> <sha>: the single `vX.Y.Z` tag whose commit is <sha>.
exact_tag() {
  local refs tags n
  local to=()
  command -v timeout >/dev/null 2>&1 && to=(timeout --kill-after=10s 60s)
  refs="$("${to[@]}" git ls-remote --tags "$GARDEN_DEP_MIGRATION_ACTION_REMOTE/$1" 2>/dev/null)" \
    || { echo "git ls-remote of '$1' failed" >&2; return 1; }
  # A peeled `^{}` row names an annotated tag's commit; a bare row a lightweight tag's.
  tags="$(printf '%s\n' "$refs" | awk -v s="$2" '
    { r = $2; sub(/^refs\/tags\//, "", r); p = sub(/\^\{\}$/, "", r)
      if (p) peeled[r] = $1; else direct[r] = $1 }
    END { for (r in direct) { c = (r in peeled) ? peeled[r] : direct[r]
            if (c == s && r ~ /^v[0-9]+\.[0-9]+\.[0-9]+$/) print r } }' | sort -u)"
  n="$(printf '%s' "$tags" | grep -c . || true)"
  [ "$n" -eq 1 ] || { echo "'$1@$2' resolves to $n exact vX.Y.Z tags (${tags//$'\n'/ }), need exactly 1" >&2; return 1; }
  printf '%s\n' "$tags"
}

builtin_action-pin-comments() {
  local co="$1" base="$2" a="$3" outs="$4" re line shas sha tag f
  re="$(pin_line_re "$a")"
  # Plain-bump gate: the PR's changed lines are all pin lines of <action>.
  # shellcheck disable=SC2086
  while IFS= read -r line; do
    case "$line" in '+++ '*|'--- '*|'@@'*|'diff '*|'index '*|'') continue ;; esac
    [[ "${line:0:1}" == [+-] ]] || continue
    printf '%s\n' "${line:1}" | grep -Eq "$re" \
      || die "PR changes a line that is not a '$a' pin (${line:0:120}); not a plain bump"
  done < <(git -C "$co" diff -U0 "$base...HEAD" -- $outs)
  shas="$(pinned_shas "$co" "$a" "$outs")" || die "the '$a' pins are not in the shape this hook knows"
  [ "$(printf '%s\n' "$shas" | grep -c .)" -eq 1 ] \
    || die "'$a' is pinned to more than one SHA (${shas//$'\n'/ }); not a plain bump"
  sha="$shas"
  tag="$(exact_tag "$a" "$sha")" || return 1
  for f in $outs; do
    sed -E -i "s|^([[:space:]]*(- )?uses: ${a//./\\.}@$sha)( # [A-Za-z0-9.+_-]+)?[[:space:]]*\$|\1 # $tag|" "$co/$f"
  done
}

builtin_action-pin-comments-check() {
  local co="$1" a="$3" outs="$4" re shas tag f
  re="$(pin_line_re "$a")"
  shas="$(pinned_shas "$co" "$a" "$outs")" || return 1
  [ "$(printf '%s\n' "$shas" | grep -c .)" -eq 1 ] || { echo "'$a' pinned to several SHAs" >&2; return 1; }
  tag="$(exact_tag "$a" "$shas")" || return 1
  for f in $outs; do
    if grep -E "$re" "$co/$f" | grep -vqF "@$shas # $tag"; then
      echo "$f has a '$a' pin whose comment is not '# $tag'" >&2; return 1
    fi
  done
}

# run_step <checkout> <base-ref> <step> <package> <outputs>
run_step() {
  case "$3" in
    builtin:*) "builtin_${3#builtin:}" "$1" "$2" "$4" "$5" ;;
    *) run_npm_script "$1" "$3" ;;
  esac
}
describe_step() { case "$1" in builtin:*) printf '%s' "$1" ;; *) printf 'npm run %s' "$1" ;; esac; }

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
    IFS=$'\t' read -r _ _ pkg inputs refresh validate outputs subject <<< "$row"
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
    run_step "$co" "$baseref" "$refresh" "$pkg" "$outputs" || fail 4 "'$(describe_step "$refresh")' failed in '$co'; nothing committed"

    # Gate 3: the command wrote only its declared outputs.
    dirty="$(git -C "$co" status --porcelain --untracked-files=all)"
    if [ -z "$dirty" ]; then
      run_step "$co" "$baseref" "$validate" "$pkg" "$outputs" || fail 4 "'$(describe_step "$validate")' failed in '$co'"
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
    run_step "$co" "$baseref" "$validate" "$pkg" "$outputs" || fail 4 "'$(describe_step "$validate")' rejected the refreshed output in '$co'; nothing committed"

    # shellcheck disable=SC2086  # $outputs is a space-separated path list
    git -C "$co" add -- $outputs
    # shellcheck disable=SC2086
    git -C "$co" commit -q -m "$subject" \
      -m "Regenerated by \`$(describe_step "$refresh")\` (garden scripts/jobs/dependabot-migration.sh hook '$id') after the Dependabot bump; \`$(describe_step "$validate")\` passed on the result." \
      -- $outputs
    printf 'committed %s\n' "$(git -C "$co" rev-parse HEAD)"
    ;;
  *)
    die "usage: $0 lookup <owner/repo> <package> | run <hook-id> <checkout> <base-ref>"
    ;;
esac
