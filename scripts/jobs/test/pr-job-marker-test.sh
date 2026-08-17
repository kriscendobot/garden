#!/bin/bash
# pr-job-marker-test.sh — the durable garden-job marker on `gh pr create`
# (scripts/jobs/pr-job-marker.sh + the gh wrapper hook in scripts/jobs/bin/gh).
#
# WHAT THIS GUARDS
# A job claimed more than once must converge on ONE PR; ensure-pr.sh rediscovers a
# prior claimant's PR by its `<!-- garden-job: <base> -->` body marker. That only
# works if the PR carries the marker, so every fleet `gh pr create` must stamp it.
# This test covers the injection surface and the hard constraints:
#   * each body form (--body / -b inline; --body-file / -F file; -F - stdin) gains
#     EXACTLY ONE marker, byte-identical to ensure-pr.sh's;
#   * a --body-file on disk is NEVER mutated (a temp holds the marked body);
#   * an already-marked body is not doubled (idempotent);
#   * a non-create call, an absent/invalid $GARDEN_JOB_BASE, and a bodyless
#     (--fill) create are untouched (fail-open passthrough);
#   * the real wrapper stamps a create end-to-end (fake gh behind it).
# Hermetic: sources the library directly and inspects PRJM_NEWARGV for the precise
# cases, and drives the real wrapper for the exec path. No network.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
LIB="$JOBS/pr-job-marker.sh"
WRAPPER_DIR="$JOBS/bin"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_* / GH_ state under the fixture.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|GH_)' || true) 2>/dev/null || true

TMPBASE="${GARDEN_TEST_TMP:-$HOME}"
TR="$(mktemp -d "$TMPBASE/.prjm-test.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

export GARDEN_JOB_BASE="endo-but-for-bots-pin-node-24x-ci"
MARKER="<!-- garden-job: $GARDEN_JOB_BASE -->"

# shellcheck source=/dev/null
. "$LIB"

# body_of_bodyfile: last PRJM_NEWARGV pair is `--body-file <tmp>`; echo its content.
body_of_bodyfile() {
  local nm="${#PRJM_NEWARGV[@]}"
  [ "$nm" -ge 2 ] || { echo "__NO_BODYFILE__"; return; }
  local flag="${PRJM_NEWARGV[$((nm-2))]}" f="${PRJM_NEWARGV[$((nm-1))]}"
  [ "$flag" = "--body-file" ] || { echo "__NO_BODYFILE__"; return; }
  cat "$f"
}
count_markers() { grep -c -F "$MARKER" 2>/dev/null || true; }

hr; echo "1) --body inline: gains exactly one marker"
if pr_job_marker_rewrite_argv pr create --repo o/r --head h --base main \
     --title "feat: x" --body "the body"; then
  out="$(body_of_bodyfile)"
  case "$out" in
    "the body"*"$MARKER"*) ok "inline body marked" ;;
    *) bad "inline body not marked: [$out]" ;;
  esac
  [ "$(printf '%s' "$out" | count_markers)" = 1 ] && ok "exactly one marker" || bad "not exactly one marker"
  # the create keeps its identity flags
  printf '%s\n' "${PRJM_NEWARGV[@]}" | grep -qx -- "--repo" && ok "keeps --repo" || bad "dropped --repo"
  printf '%s\n' "${PRJM_NEWARGV[@]}" | grep -qx -- "feat: x" && ok "keeps title value" || bad "dropped title value"
else
  bad "inline body: expected rewrite (rc 0)"
fi
pr_job_marker_cleanup

hr; echo "2) --body-file: file on disk NOT mutated; temp carries the marker"
SRC="$TR/pr-body.md"; printf 'the file body' > "$SRC"
if pr_job_marker_rewrite_argv pr create -R o/r -H h -B main -t "t" --body-file "$SRC"; then
  [ "$(cat "$SRC")" = "the file body" ] && ok "source file untouched" || bad "source file MUTATED"
  out="$(body_of_bodyfile)"
  case "$out" in "the file body"*"$MARKER") ok "temp body marked" ;; *) bad "temp body wrong: [$out]" ;; esac
else
  bad "--body-file: expected rewrite (rc 0)"
fi
pr_job_marker_cleanup

hr; echo "3) -F - (stdin): body forwarded via temp, marked"
# here-string feeds stdin WITHOUT a pipe, so the function runs in THIS shell and
# PRJM_NEWARGV propagates (a pipe would run it in a subshell).
if pr_job_marker_rewrite_argv pr create -R o/r -H h -B main -t "t" -F - <<< "stdin body"; then
  out="$(body_of_bodyfile)"
  case "$out" in "stdin body"*"$MARKER") ok "stdin body marked" ;; *) bad "stdin body wrong: [$out]" ;; esac
else
  bad "stdin body: expected rewrite (rc 0)"
fi
pr_job_marker_cleanup

hr; echo "4) already-marked body: idempotent passthrough (rc 1)"
if pr_job_marker_rewrite_argv pr create -R o/r -H h -B main -t "t" \
     --body "already $MARKER here"; then
  bad "already-marked: expected passthrough (rc 1), got rewrite"
else
  ok "already-marked body passed through"
fi
pr_job_marker_cleanup

hr; echo "5) fail-open passthroughs (rc 1): non-create, no base, --fill"
pr_job_marker_rewrite_argv pr view 123 && bad "pr view rewritten" || ok "non-create passthrough"
( unset GARDEN_JOB_BASE
  . "$LIB"
  pr_job_marker_rewrite_argv pr create -R o/r -H h -B main -t "t" --body "b" \
    && echo REWROTE || echo PASSED ) | grep -qx PASSED \
  && ok "absent GARDEN_JOB_BASE passthrough" || bad "absent base was rewritten"
pr_job_marker_rewrite_argv pr create -R o/r -H h -B main -t "t" --fill \
  && bad "--fill (bodyless) rewritten" || ok "bodyless --fill passthrough"
pr_job_marker_cleanup

hr; echo "6) invalid GARDEN_JOB_BASE (contains ':'): passthrough"
( export GARDEN_JOB_BASE="bad:base"
  . "$LIB"
  pr_job_marker_rewrite_argv pr create -R o/r -H h -B main -t "t" --body "b" \
    && echo REWROTE || echo PASSED ) | grep -qx PASSED \
  && ok "invalid base passthrough" || bad "invalid base was rewritten"

hr; echo "7) end-to-end through the real wrapper (fake gh captures argv)"
FAKEBIN="$TR/fakebin"; mkdir -p "$FAKEBIN"
cat > "$FAKEBIN/gh" <<EOF
#!/bin/bash
# fake real-gh: token lookups succeed (so the wrapper injects nothing itself),
# and a 'pr create' records the resolved body so the test can inspect the marker.
case "\$1 \$2" in
  "auth token") echo "fake-token"; exit 0 ;;
  "pr create")
    shift 2
    while [ "\$#" -gt 0 ]; do
      if [ "\$1" = "--body-file" ]; then cat "\$2" > "$TR/created-body"; shift 2; continue; fi
      shift
    done
    echo "https://github.com/o/r/pull/1000"; exit 0 ;;
esac
exit 0
EOF
chmod +x "$FAKEBIN/gh"
BODYF="$TR/e2e-body.md"; printf 'e2e body' > "$BODYF"
# wrapper first on PATH, fake gh behind it; provenance lib absent under this root so
# only the marker hook can fire.
PATH="$WRAPPER_DIR:$FAKEBIN:$PATH" GARDEN_ROOT="$TR" \
  gh pr create -R o/r -H h -B main -t "t" --body-file "$BODYF" >/dev/null 2>&1
if [ -f "$TR/created-body" ]; then
  got="$(cat "$TR/created-body")"
  case "$got" in "e2e body"*"$MARKER") ok "wrapper stamped the marker end-to-end" ;; *) bad "e2e body wrong: [$got]" ;; esac
  [ "$(cat "$BODYF")" = "e2e body" ] && ok "e2e source file untouched" || bad "e2e source file MUTATED"
else
  bad "wrapper did not reach fake gh pr create"
fi

hr
echo "pr-job-marker: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
