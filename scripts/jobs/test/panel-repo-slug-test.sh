#!/bin/bash
# panel-repo-slug-test.sh — regression guard for panel.sh's derivation of the
# panel-run record's STORE KEY (`<owner>/<repo>`) from the worktree's origin URL.
#
# THE PROBLEM: the derived string keys the durable record's directory,
# `panel-runs/<owner>-<repo>-<pr>/`. A remote-URL form the strip misses does not
# fail loudly; it keys the run under a DIFFERENT directory, so one repository
# accumulates two archives and a query by repo silently sees half its history.
# The fleet's project worktrees carry `ssh://git@github.com/<owner>/<repo>.git`
# origins, which the scp-form (`git@host:`) and `https://` patterns both miss:
# `journal2:panel-runs/` held 9 runs under `ssh---git-github.com-endojs-endo-but-for-bots-<pr>`
# next to 4 under `endojs-endo-but-for-bots-<pr>` (the latter only where a caller
# happened to pass GARDEN_PANEL_REPO explicitly). They carry that form because the
# hosts configure `url.ssh://git@github.com/.insteadOf https://github.com/`, so a
# worktree cloned from an https URL reports an ssh one back.
#
# Every URL form git accepts must reduce to the SAME key. Each subtest builds an
# empty-diff worktree (so the panel terminates immediately, no seats, no network)
# with one origin form and asserts the key panel.sh wrote to `record-meta`. The
# fixtures run with an EMPTY global git config so the host's own `insteadOf`
# rewrites cannot silently substitute one form for another under the test.
#
# Hermetic: the record WRITER is stubbed, so nothing is pushed to journal2 —
# `record-meta` is written by panel.sh before the writer is invoked, which is
# exactly the value under test.
#
# Usage: panel-repo-slug-test.sh

# The ok/bad idiom is the intended A && pass || fail (SC2015, safe: ok never fails).
# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-repo-slug.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

# Hermetic git: an empty global config, so a host-level `insteadOf` rewrite cannot
# turn the fixture's origin URL into a different form behind the test's back.
: > "$TR/gitconfig-empty"
export GIT_CONFIG_GLOBAL="$TR/gitconfig-empty"
export GIT_CONFIG_NOSYSTEM=1

STUB_HOOK="$HERE/panel-hook-record-stub.sh"   # stands in for the un-draft hook AND
                                              # the record writer (never pushes)

WANT=endojs/endo-but-for-bots

# derive <label> <origin-url> -> echoes the repo key panel.sh recorded
derive() {
  local label="$1" url="$2"
  local wt="$TR/wt-$label" rundir="$TR/rd-$label"
  mkdir -p "$wt"
  (
    set -e
    cd "$wt"
    git init -q .
    git config user.name garden-test; git config user.email garden-test@example.invalid
    git remote add origin "$url"
    echo seed > seed.txt; git add seed.txt
    git commit -qm 'base commit'
    git commit -q --allow-empty -m 'chore: establish baseline'
  ) >/dev/null 2>&1 || { echo "FIXTURE-FAILED"; return; }
  PANEL_HOOK_LOG="$TR/hook-$label.log" \
  GARDEN_PANEL_RUNDIR="$rundir" \
  GARDEN_PANEL_RECORD="$STUB_HOOK" \
  GARDEN_PANEL_UNDRAFT="$STUB_HOOK" \
  GARDEN_PANEL_APPELLATE=":" \
    bash "$PANEL" "$wt" 847 HEAD~1 >/dev/null 2>&1
  sed -n 's/^repo=//p' "$rundir/record-meta" 2>/dev/null
}

hr; echo "every origin-URL form must reduce to the same store key"; hr
for form in \
  "ssh|ssh://git@github.com/$WANT.git" \
  "ssh-noext|ssh://git@github.com/$WANT" \
  "scp|git@github.com:$WANT.git" \
  "https|https://github.com/$WANT.git" \
  "http|http://github.com/$WANT"
do
  label="${form%%|*}"; url="${form#*|}"
  got="$(derive "$label" "$url")"
  [ "$got" = "$WANT" ] \
    && ok "$label ($url) -> $WANT" \
    || bad "$label ($url) -> '$got' (want '$WANT')"
done

hr; echo "a worktree with NO origin still yields a key (the basename fallback)"; hr
mkdir -p "$TR/wt-noremote"
(
  set -e
  cd "$TR/wt-noremote"
  git init -q .
  git config user.name garden-test; git config user.email garden-test@example.invalid
  echo seed > seed.txt; git add seed.txt
  git commit -qm 'base commit'
  git commit -q --allow-empty -m 'chore: establish baseline'
) >/dev/null 2>&1
PANEL_HOOK_LOG="$TR/hook-noremote.log" \
GARDEN_PANEL_RUNDIR="$TR/rd-noremote" \
GARDEN_PANEL_RECORD="$STUB_HOOK" \
GARDEN_PANEL_UNDRAFT="$STUB_HOOK" \
GARDEN_PANEL_APPELLATE=":" \
  bash "$PANEL" "$TR/wt-noremote" 847 HEAD~1 >/dev/null 2>&1
got="$(sed -n 's/^repo=//p' "$TR/rd-noremote/record-meta" 2>/dev/null)"
[ "$got" = "wt-noremote" ] \
  && ok "no origin -> worktree basename ('$got')" \
  || bad "no origin -> '$got' (want the worktree basename 'wt-noremote')"

hr; echo "an explicit GARDEN_PANEL_REPO still wins over the derivation"; hr
PANEL_HOOK_LOG="$TR/hook-explicit.log" \
GARDEN_PANEL_RUNDIR="$TR/rd-explicit" \
GARDEN_PANEL_REPO=someowner/somerepo \
GARDEN_PANEL_RECORD="$STUB_HOOK" \
GARDEN_PANEL_UNDRAFT="$STUB_HOOK" \
GARDEN_PANEL_APPELLATE=":" \
  bash "$PANEL" "$TR/wt-ssh" 847 HEAD~1 >/dev/null 2>&1
got="$(sed -n 's/^repo=//p' "$TR/rd-explicit/record-meta" 2>/dev/null)"
[ "$got" = "someowner/somerepo" ] \
  && ok "GARDEN_PANEL_REPO overrides the origin derivation" \
  || bad "explicit repo was '$got' (want someowner/somerepo)"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
