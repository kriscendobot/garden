#!/bin/bash
# review-write-deny-test.sh — the host-local learned review-write exclusion: a
# token-grant 403 on the panel's review post arms a per-owner marker, panel.sh then
# refuses before any seat runs, and claim-job.sh leaves that owner's review-posting
# gauntlet stages for another host (endojs/endo-but-for-bots #1543 on oros-studio).
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PANEL="$JOBS/gardening/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/review-write-deny.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

echo "SUBTEST 1 — marker helpers: key, TTL, and the 403 text match"
(
  export GARDEN_REVIEW_WRITE_DENY_DIR="$TR/lib"
  # shellcheck source=../review-write-deny.sh
  . "$JOBS/review-write-deny.sh"
  review_write_denied endojs && exit 11
  review_write_deny_record EndoJS endojs/endo-but-for-bots probe
  review_write_denied endojs || exit 12
  review_write_denied ENDOJS || exit 13
  review_write_denied agoric && exit 14
  sed -i 's/^expires=.*/expires=1/' "$GARDEN_REVIEW_WRITE_DENY_DIR/endojs"
  review_write_denied endojs && exit 15
  [ -e "$GARDEN_REVIEW_WRITE_DENY_DIR/endojs" ] && exit 16
  printf 'GraphQL: Resource not accessible by personal access token (addPullRequestReview)\n' > "$TR/e1"
  printf 'HTTP 403: You have exceeded a secondary rate limit\n' > "$TR/e2"
  review_write_forbidden_text "$TR/e1" || exit 17
  review_write_forbidden_text "$TR/e2" && exit 18
  exit 0
); rc=$?
[ "$rc" -eq 0 ] && ok "owner-keyed, case-folded, expiring marker; rate-limit 403 does not match" || bad "helper check failed (rc=$rc)"

stage_job() {  # stage_job <file> <stage> <pr-url>
  printf -- '---\nrole: gardener\ngauntlet: g\ngauntlet_stage: %s\ngauntlet_iteration: 1\npr: %s\n---\n\n# stage\n' "$2" "$3" > "$1"
}
(
  export GARDEN_REVIEW_WRITE_DENY_DIR="$TR/lib2"
  . "$JOBS/review-write-deny.sh"
  review_write_deny_record endojs endojs/endo-but-for-bots t
  stage_job "$TR/p.md" panel https://github.com/endojs/endo-but-for-bots/pull/1543
  stage_job "$TR/u.md" undraft https://github.com/endojs/endo-but-for-bots/pull/1543
  stage_job "$TR/f.md" fix https://github.com/endojs/endo-but-for-bots/pull/1543
  stage_job "$TR/o.md" panel https://github.com/kriscendobot/garden/pull/7
  printf '# plain\n' > "$TR/plain.md"
  [ "$(job_review_write_denied_owner "$TR/p.md")" = endojs ] || exit 21
  job_review_write_denied_owner "$TR/u.md" >/dev/null || exit 22
  job_review_write_denied_owner "$TR/f.md" >/dev/null && exit 23
  job_review_write_denied_owner "$TR/o.md" >/dev/null && exit 24
  job_review_write_denied_owner "$TR/plain.md" >/dev/null && exit 25
  exit 0
); rc=$?
[ "$rc" -eq 0 ] && ok "panel/undraft stages for a denied owner are excluded; fix, other owners, plain jobs are not" || bad "job owner predicate failed (rc=$rc)"

echo "SUBTEST 2 — panel.sh: a 403 on the post arms the marker; the next run spends no seats"
git_id=(-c user.name=test -c user.email=test@localhost)
WT="$TR/wt"
git init -q "$WT"
git -C "$WT" remote add origin https://github.com/example/panel-fixture.git
printf 'base\n' > "$WT/file.txt"; git -C "$WT" add file.txt; git -C "$WT" "${git_id[@]}" commit -q -m base
printf 'head\n' >> "$WT/file.txt"; git -C "$WT" add file.txt; git -C "$WT" "${git_id[@]}" commit -q -m head
SEAT="$TR/seat.sh"
cat > "$SEAT" <<EOF
#!/bin/bash
echo "\$1" >> "$TR/seats.\${SEAT_TAG}"
exec "$HERE/panel-fixer-aggregate-stub.sh" "\$@"
EOF
chmod +x "$SEAT"
run_panel() {  # run_panel <tag> <fail-mode>
  SEAT_TAG="$1" \
  GARDEN_REVIEW_WRITE_DENY_DIR="$TR/panel-deny" \
  PANEL_GH_AUTH_LOGIN=kriscendobot PANEL_GH_AUTHOR_LOGIN=human-reviewee \
  PANEL_GH_LOG="$TR/$1.gh.log" PANEL_GH_BODY="$TR/$1.body.md" PANEL_GH_FAIL_REVIEW="$2" \
  FAN_DIR="$TR/$1.fan" FAN_SLEEP=0 DECIDE_VERDICT=must-fix \
  GARDEN_TEST=1 GARDEN_PANEL_SINGLE_ROUND=1 GARDEN_PANEL_REVIEW_SUBMIT=panel_submit_review \
  GARDEN_PANEL_GH="$HERE/panel-review-submit-gh-stub.sh" \
  GARDEN_CODE_SEATS='assessor stylist' GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$SEAT" GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_RELATED_DESIGN=: GARDEN_PANEL_APPELLATE=: GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$TR/$1.rundir" \
    bash "$PANEL" "$WT" 777 HEAD~1
}

out="$(run_panel ratelimit ratelimit 2>&1)"; rc=$?
{ [ "$rc" -ne 0 ] && [ ! -e "$TR/panel-deny/example" ]; } \
  && ok "a rate-limit 403 fails the post without arming the marker" \
  || bad "rate-limit 403: rc=$rc marker=$(ls "$TR/panel-deny" 2>/dev/null) out=$out"

out="$(run_panel first 403 2>&1)"; rc=$?
[ "$rc" -ne 0 ] && ! grep -q '<!-- gauntlet-stage-result:' <<<"$out" \
  && ok "token-grant 403 fails the stage with no success marker" || bad "first run rc=$rc out=$out"
grep -q 'Resource not accessible by personal access token' <<<"$out" \
  && ok "the gh error is still surfaced on stderr" || bad "gh error swallowed: $out"
[ -f "$TR/panel-deny/example" ] && grep -q '^repo=example/panel-fixture$' "$TR/panel-deny/example" \
  && ok "marker armed for owner 'example'" || bad "no marker after the 403"

out="$(run_panel second 0 2>&1)"; rc=$?
[ "$rc" -ne 0 ] && grep -q 'review-write preflight' <<<"$out" \
  && ok "the next panel refuses at the review-write preflight" || bad "second run rc=$rc out=$out"
[ ! -s "$TR/seats.second" ] && [ ! -e "$TR/second.gh.log" ] \
  && ok "no seat ran and no review was attempted after the marker" \
  || bad "seats ran after the marker: $(cat "$TR/seats.second" 2>/dev/null)"

echo "SUBTEST 3 — claim-job.sh leaves a denied owner's panel stage for another host"
BARE="$TR/journal.git"; SEED="$TR/seed"; BRANCH=journal2
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
for d in jobs/todo jobs/doin jobs/tada work inbox/maintainer/unread inbox/maintainer/read; do mkdir -p "$SEED/$d"; touch "$SEED/$d/.gitkeep"; done
stage_job "$SEED/jobs/todo/g-panel-1.md" panel https://github.com/endojs/endo-but-for-bots/pull/1543
printf '# ordinary job\n' > "$SEED/jobs/todo/plain.md"
git -C "$SEED" add -A; git -C "$SEED" "${git_id[@]}" commit -qm seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"
claim() {  # claim <tag> <deny-dir>
  env GARDEN_TEST=1 GARDEN=host-a GARDEN_STATE="$TR/state-$1" GARDEN_REVIEW_WRITE_DENY_DIR="$2" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN_WORKER_CLONE="$TR/clone-$1" \
    "$JOBS/claim-job.sh" 1
}
mkdir -p "$TR/claim-deny"
( export GARDEN_REVIEW_WRITE_DENY_DIR="$TR/claim-deny"; . "$JOBS/review-write-deny.sh"; review_write_deny_record endojs endojs/endo-but-for-bots t )
got="$(claim denied "$TR/claim-deny" 2>/dev/null || true)"
[ "$got" = plain ] && ok "denied host claims the plain job" || bad "denied host claimed '$got' (wanted plain)"
got="$(claim denied2 "$TR/claim-deny" 2>"$TR/claim.err" || true)"
[ -z "$got" ] && ok "denied host leaves the endojs panel stage unclaimed" || bad "denied host claimed '$got'"
grep -q "skipping (review-write)" "$TR/claim.err" && ok "the skip is logged" || bad "no review-write skip log ($(tr '\n' ' ' < "$TR/claim.err"))"
got="$(claim capable "$TR/capable-deny" 2>/dev/null || true)"
[ "$got" = g-panel-1 ] && ok "a host without the marker claims the panel stage" || bad "capable host claimed '$got'"

echo "review-write-deny-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
