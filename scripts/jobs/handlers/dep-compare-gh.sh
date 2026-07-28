#!/bin/bash
# dep-compare-gh.sh — default CONTAINMENT oracle for the dependabot-watcher's
# supersession preflight.
#
# Invoked as: dep-compare-gh.sh <package> <old-version> <new-version>
#
# Answers one question and only that question: does the release tagged
# <new-version> STRICTLY CONTAIN the release tagged <old-version> in the package's
# own upstream repository? On success it emits a single TSV line
#
#   status  ahead_by  behind_by  upstream_repo  old_ref  new_ref
#
# and exits 0. `behind_by == 0` is the proof of containment — the newer tag has
# every commit the older one has, so a PR moving to the older target has nothing
# the newer PR lacks and is genuinely superseded. A NON-ZERO `behind_by` is a
# DIVERGENT RELEASE LINE (a maintenance/backport branch, a reverted commit, a
# re-tagged release), where the supersession claim does NOT hold without a
# human-grade read — the caller must fall open and commission the full review.
#
# Any failure to establish the comparison — unresolvable upstream, unresolvable
# tags, a network or API failure — exits NON-ZERO with NOTHING on stdout, which
# the caller treats identically to "containment not established": fall open. This
# handler never guesses; a silent empty line here would read as containment and
# auto-close a PR that deserved a review, so the contract is "prove it or fail".
#
# ── Resolving the upstream repository ────────────────────────────────────────
# The package identity Dependabot writes in a title is ecosystem-shaped:
#   * `github-actions`: the package name IS the repo slug (`actions/setup-node`),
#     so the upstream is the name itself — no lookup.
#   * `npm`: the name (`ses`, `@endo/marshal`) says nothing about the repo, so we
#     read `.repository.url` from the public npm registry document and extract the
#     `github.com/<owner>/<name>` it points at. A non-GitHub (or absent) repository
#     field is an unresolvable upstream → fail → the caller falls open.
#
# ── Resolving the tags ───────────────────────────────────────────────────────
# A version string is not a ref. We probe a small fixed set of tag conventions per
# version with `git/matching-refs/tags/<name>`, which returns 200 with an EMPTY
# array when nothing matches — so a miss costs no 404 and no retry noise, unlike
# probing the compare endpoint directly. For an npm package the PACKAGE-QUALIFIED
# convention is tried first (`@endo/marshal@1.6.2`), because in a monorepo a bare
# `v1.6.2` may well be a different package's release; for a github-action the repo
# IS the package, so `v<version>` leads.
#
# ── Monitoring safety ────────────────────────────────────────────────────────
# Inputs are the caller's already-validated package/version fields (narrow
# charsets, see dependabot-watcher.sh § parse_bump_title), never free text, and
# they are re-validated here so this handler is safe to call directly. Output is
# machine-shaped API metadata. Nothing here reaches an LLM.
#
# Silent-failure discipline: require_tools fails LOUD on a missing binary; every
# other failure path exits non-zero with a log line naming which step could not be
# established, so "we could not prove it" is never mistaken for "it is not so".
#
# Test seam: GARDEN_NPM_REGISTRY (default https://registry.npmjs.org) and the
# fleet-wide GARDEN_GH (the gh binary gh_api_retry drives).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="dep-compare"

pkg="${1:?usage: dep-compare-gh.sh <package> <old-version> <new-version>}"
oldv="${2:?usage: dep-compare-gh.sh <package> <old-version> <new-version>}"
newv="${3:?usage: dep-compare-gh.sh <package> <old-version> <new-version>}"

: "${GARDEN_NPM_REGISTRY:=https://registry.npmjs.org}"
: "${GARDEN_DEP_COMPARE_HTTP_TIMEOUT:=20}"

require_tools gh jq

# Re-validate the inputs against the same narrow charsets the caller enforces, so
# this handler cannot be turned into an arbitrary-URL fetcher by a malformed call.
case "$pkg" in
  *[!A-Za-z0-9._@/-]*|"") log "WARN: package '$pkg' has characters outside the bump-title charset; cannot compare"; exit 1;;
esac
for v in "$oldv" "$newv"; do
  case "$v" in
    *[!A-Za-z0-9.+_-]*|"") log "WARN: version '$v' has characters outside the bump-title charset; cannot compare"; exit 1;;
  esac
done

# --- upstream resolution -----------------------------------------------------

# A github-actions package name is exactly `<owner>/<repo>`: one slash, no leading
# `@`, and both halves plain. Anything else is treated as an npm name.
is_action_slug() {
  case "$1" in
    @*|*/*/*|*/) return 1;;
    */*) case "$1" in *[!A-Za-z0-9._/-]*) return 1;; esac; return 0;;
    *) return 1;;
  esac
}

npm_upstream() {  # npm_upstream <pkg> -> owner/name on stdout
  local p="$1" enc doc url
  command -v curl >/dev/null 2>&1 || { log "WARN: curl absent; cannot resolve npm upstream for $p"; return 1; }
  # Scoped names carry a `/` that must be percent-encoded into the registry path.
  enc="${p//\//%2f}"
  doc="$(curl -fsSL --max-time "$GARDEN_DEP_COMPARE_HTTP_TIMEOUT" \
          "$GARDEN_NPM_REGISTRY/$enc" 2>/dev/null)" \
    || { log "WARN: npm registry lookup failed for $p"; return 1; }
  url="$(printf '%s' "$doc" | jq -r '
      (.repository // empty)
      | if type == "string" then . else (.url // empty) end
      | select(type == "string")' 2>/dev/null | head -1)"
  [ -n "$url" ] || { log "WARN: npm document for $p names no repository; cannot resolve upstream"; return 1; }
  # Accept git+https://github.com/o/n.git, git://github.com/o/n, git@github.com:o/n.git,
  # https://github.com/o/n/tree/main, github:o/n. Reject anything not on github.com.
  local slug
  slug="$(printf '%s' "$url" | sed -n \
    -e 's#^github:\([A-Za-z0-9._-]\{1,\}\)/\([A-Za-z0-9._-]\{1,\}\)$#\1/\2#p' \
    -e 's#.*github\.com[:/]\([A-Za-z0-9._-]\{1,\}\)/\([A-Za-z0-9._-]\{1,\}\)\(\.git\)\{0,1\}\([/?#].*\)\{0,1\}$#\1/\2#p' \
    | head -1)"
  slug="${slug%.git}"
  case "$slug" in
    */*) printf '%s' "$slug"; return 0;;
    *) log "WARN: repository URL for $p is not a github.com repo ($url); cannot compare"; return 1;;
  esac
}

if is_action_slug "$pkg"; then
  upstream="$pkg"
else
  upstream="$(npm_upstream "$pkg")" || exit 1
fi

# --- tag resolution ----------------------------------------------------------

pkgbase="${pkg##*/}"

tag_candidates() {  # tag_candidates <version>
  local v="$1"
  if is_action_slug "$pkg"; then
    printf '%s\n' "v$v" "$v" "$pkgbase-v$v" "$pkgbase@$v"
  else
    # Monorepo-qualified first: a bare `v<version>` in a monorepo may belong to a
    # different package entirely, and picking it would compare the wrong history.
    printf '%s\n' "$pkg@$v" "$pkgbase@$v" "$pkgbase-v$v" "v$v" "$v"
  fi
}

resolve_tag() {  # resolve_tag <version> -> tag name on stdout
  local v="$1" t out
  while IFS= read -r t; do
    [ -n "$t" ] || continue
    out="$(gh_api_retry "repos/$upstream/git/matching-refs/tags/$t")" || continue
    if printf '%s' "$out" | jq -e --arg r "refs/tags/$t" 'any(.[]?; .ref == $r)' >/dev/null 2>&1; then
      printf '%s' "$t"; return 0
    fi
  done < <(tag_candidates "$v")
  log "WARN: no tag on $upstream matches version '$v' (tried the standard conventions); cannot compare"
  return 1
}

old_ref="$(resolve_tag "$oldv")" || exit 1
new_ref="$(resolve_tag "$newv")" || exit 1

# --- the comparison ----------------------------------------------------------
# `behind_by == 0` proves <new_ref> contains every commit <old_ref> has.
cmp_json="$(gh_api_retry "repos/$upstream/compare/$old_ref...$new_ref")" \
  || { log "WARN: compare $upstream $old_ref...$new_ref failed; cannot establish containment"; exit 1; }

cmp_tsv="$(printf '%s' "$cmp_json" | jq -r '
    if ((.status|type) == "string"
        and (.ahead_by|type) == "number"
        and (.behind_by|type) == "number")
    then [ .status, (.ahead_by|tostring), (.behind_by|tostring) ] | @tsv
    else empty end' 2>/dev/null || true)"
[ -n "$cmp_tsv" ] \
  || { log "WARN: compare response for $upstream $old_ref...$new_ref lacked status/ahead_by/behind_by; cannot establish containment"; exit 1; }

IFS=$'\t' read -r status ahead behind <<< "$cmp_tsv"
printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$status" "$ahead" "$behind" "$upstream" "$old_ref" "$new_ref"
