#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
JOBS="$ROOT/scripts/jobs"
TEST_ROOT="$(mktemp -d "$ROOT/.review-docket-test.XXXXXX")"
trap '[ -n "${KEEP:-}" ] || rm -rf "$TEST_ROOT"' EXIT
fail() { echo "review-docket-test: FAIL: $*" >&2; exit 1; }
JOURNAL="$TEST_ROOT/journal"; mkdir -p "$JOURNAL/config/arc-budgets" "$JOURNAL/maintainers" "$JOURNAL/jobs/plan" "$JOURNAL/pr-deps"
printf 'kriskowal\n' > "$JOURNAL/maintainers/allowlist"
printf '# Journal\n' > "$JOURNAL/README.md"
printf '%s\n' '{"schema":1,"week_start":"2026-10-03T04:00:00Z","total_tokens":1000000,"slate":[{"rank":1,"arc":"alpha","summary":"first","token_cap":600000},{"rank":2,"arc":"beta","summary":"second","token_cap":300000}],"unallocated_tokens":100000}' > "$JOURNAL/config/apportionment"
printf '%s\n' '{"schema":2,"status":"active","arc":"alpha","rank":1,"summary":"first","token_cap":600000,"window":"week","window_start":"2026-10-03T04:00:00Z"}' > "$JOURNAL/config/arc-budgets/alpha"
printf '%s\n' '{"schema":2,"status":"active","arc":"beta","rank":2,"summary":"second","token_cap":300000,"window":"week","window_start":"2026-10-03T04:00:00Z"}' > "$JOURNAL/config/arc-budgets/beta"
printf '# blocked\n' > "$JOURNAL/jobs/plan/critical.md"
META="$TEST_ROOT/meta.json"
printf '%s\n' '{"head_oid":"aaaaaaaaaaaaaaaa","state":"OPEN","ci":{"state":"green","observed_at":"2026-10-08T00:00:00Z"},"reviews":[]}' > "$META"
STUB="$TEST_ROOT/metadata"
sed "s#META_FILE#$META#" > "$STUB" <<'EOF'
#!/bin/bash
cat META_FILE
EOF
chmod +x "$STUB"
export GARDEN_REVIEW_DOCKET_CURSOR="$TEST_ROOT/reconcile-cursor"
run() { GARDEN_REVIEW_DOCKET_CLONE="$JOURNAL" GARDEN_REVIEW_DOCKET_NO_PUSH=1 GARDEN_REVIEW_DOCKET_METADATA="${METADATA_HANDLER:-$STUB}" GARDEN_REVIEW_DOCKET_NOW=2026-10-08T12:00:00Z "$JOBS/review-docket.sh" "$@"; }
request() {
  local file="$1" arc="$2" milestone="$3" source_id="$4" summary="$5" unblocks="${6:-[]}" ask="${7:-approve}"
  jq -cn --arg arc "$arc" --arg milestone "$milestone" --arg source "$source_id" --arg summary "$summary" --arg ask "$ask" --argjson unblocks "$unblocks" '{schema:1,arc:$arc,milestone:$milestone,source:$source,summary:$summary,ask:$ask,unblocks:$unblocks}' > "$file"
}
R1="$TEST_ROOT/r1"; request "$R1" beta M2 s1 'Beta | [summary](bad) <img>'
run upsert https://github.com/example/repo/pull/2 "$R1"
[ "$(jq -r .generation "$JOURNAL/review-docket/open/example-repo-pr2.json")" = 1 ]
run upsert https://github.com/example/repo/pull/2 "$R1"
[ "$(jq -r .generation "$JOURNAL/review-docket/open/example-repo-pr2.json")" = 1 ]

R2="$TEST_ROOT/r2"; request "$R2" alpha M9 s2 'No live dependent' '[]'
run upsert https://github.com/example/repo/pull/3 "$R2"
R3="$TEST_ROOT/r3"; request "$R3" alpha M1 s3 'Direct blocker' '[{"kind":"job","ref":"critical","summary":"unblocks critical job"}]'
run upsert https://github.com/example/repo/pull/4 "$R3"
order="$(grep -o 'example/repo#[234]' "$JOURNAL/PRIORITIES.md" | paste -sd' ' -)"
[ "$order" = 'example/repo#4 example/repo#3 example/repo#2' ]
grep -qF 'Beta \| \[summary' "$JOURNAL/PRIORITIES.md"
grep -qF '\[summary\](bad) &lt;img&gt;' "$JOURNAL/PRIORITIES.md"
grep -q '2026-10-08.md' "$JOURNAL/priorities-archive/README.md"
grep -q '](PRIORITIES.md)' "$JOURNAL/README.md"
printf '\n<!-- review-docket-migration-appendix -->\nlegacy inventory sentinel\n' >> "$JOURNAL/priorities-archive/2026-10-08.md"
run render
grep -q 'legacy inventory sentinel' "$JOURNAL/priorities-archive/2026-10-08.md" \
  || fail 'same-day render erased the immutable migration appendix'

# An unallowlisted review and a delayed old review cannot retire the generation.
run retire-review https://github.com/example/repo/pull/2 mallory COMMENTED 2026-10-08T13:00:00Z 1
[ -f "$JOURNAL/review-docket/open/example-repo-pr2.json" ]
run retire-review https://github.com/example/repo/pull/2 kriskowal COMMENTED 2026-10-07T13:00:00Z 2
[ -f "$JOURNAL/review-docket/open/example-repo-pr2.json" ]
run retire-review https://github.com/example/repo/pull/2 kriskowal COMMENTED 2026-10-08T13:00:00Z 3
[ ! -f "$JOURNAL/review-docket/open/example-repo-pr2.json" ]
retired="$(find "$JOURNAL/review-docket/retired" -name 'example-repo-pr2-g1.json')"
[ "$(jq -r .retirement.state "$retired")" = COMMENTED ]

# Every formal review state retires; a later non-maintainer review cannot hide
# an earlier qualifying maintainer review from reconciliation.
for pair in '5 APPROVED' '6 CHANGES_REQUESTED'; do
  review_pr="${pair%% *}"; review_state="${pair#* }"
  request "$TEST_ROOT/r$review_pr" alpha M2 "s$review_pr" "state $review_state"
  run upsert "https://github.com/example/repo/pull/$review_pr" "$TEST_ROOT/r$review_pr"
  run retire-review "https://github.com/example/repo/pull/$review_pr" kriskowal "$review_state" 2026-10-08T13:00:00Z "$review_pr"
  [ ! -f "$JOURNAL/review-docket/open/example-repo-pr$review_pr.json" ] || fail "$review_state did not retire"
done
request "$TEST_ROOT/r7" alpha M3 s7 'reconcile review'
run upsert https://github.com/example/repo/pull/7 "$TEST_ROOT/r7"
printf '%s\n' '{"head_oid":"aaaaaaaaaaaaaaaa","state":"OPEN","ci":{"state":"green","observed_at":"2026-10-08T14:00:00Z"},"reviews":[{"id":"7","state":"APPROVED","author":"kriskowal","submitted_at":"2026-10-08T13:00:00Z"},{"id":"8","state":"COMMENTED","author":"mallory","submitted_at":"2026-10-08T13:30:00Z"}]}' > "$META"
run reconcile
[ ! -f "$JOURNAL/review-docket/open/example-repo-pr7.json" ] \
  || fail 'reconcile let a later outsider review hide a maintainer review'

# A new head creates a new generation and terminal state retires it.
printf '%s\n' '{"head_oid":"bbbbbbbbbbbbbbbb","state":"OPEN","ci":{"state":"pending","observed_at":"2026-10-08T14:00:00Z"},"reviews":[]}' > "$META"
run upsert https://github.com/example/repo/pull/3 "$R2"
[ "$(jq -r .generation "$JOURNAL/review-docket/open/example-repo-pr3.json")" = 2 ]
run retire-terminal https://github.com/example/repo/pull/3 MERGED 2026-10-08T15:00:00Z
[ ! -f "$JOURNAL/review-docket/open/example-repo-pr3.json" ]
printf '%s\n' '{"head_oid":"cccccccccccccccc","state":"OPEN","ci":{"state":"green","observed_at":"2026-10-08T16:00:00Z"},"reviews":[]}' > "$META"
run reenter https://github.com/example/repo/pull/3 fixer-complete
[ "$(jq -r .generation "$JOURNAL/review-docket/open/example-repo-pr3.json")" = 3 ]
[ "$(jq -r .ask "$JOURNAL/review-docket/open/example-repo-pr3.json")" = re-review ]

request "$TEST_ROOT/r8" beta M4 s8 'closed terminal'
run upsert https://github.com/example/repo/pull/8 "$TEST_ROOT/r8"
run retire-terminal https://github.com/example/repo/pull/8 CLOSED 2026-10-08T17:00:00Z
[ ! -f "$JOURNAL/review-docket/open/example-repo-pr8.json" ] || fail 'closed PR did not retire'

# A bare reconcile is a bounded batch that resumes after its host-local cursor
# and wraps; per-request timeouts and the run budget skip rather than fail.
for pr in 21 22 23; do
  request "$TEST_ROOT/r$pr" beta M6 "s$pr" "batch $pr"
  run upsert "https://github.com/example/repo/pull/$pr" "$TEST_ROOT/r$pr"
done
open_before="$(ls "$JOURNAL/review-docket/open")"
COUNTER="$TEST_ROOT/fetches"; : > "$COUNTER"
SLOW="$TEST_ROOT/slow-metadata"
cat > "$SLOW" <<EOF
#!/bin/bash
echo "\$1" >> "$COUNTER"
case "\$1" in *"/pull/\${SLOW_PR:-none}") sleep 30;; esac
cat "$META"
EOF
chmod +x "$SLOW"
batch() { METADATA_HANDLER="$SLOW" GARDEN_REVIEW_DOCKET_RECONCILE_BATCH=2 run reconcile "$@"; }
rm -f "$GARDEN_REVIEW_DOCKET_CURSOR"
batch
[ "$(wc -l < "$COUNTER")" = 2 ] || fail 'reconcile batch did not cap metadata requests'
first_cursor="$(cat "$GARDEN_REVIEW_DOCKET_CURSOR")"
[ "$first_cursor" = "$(ls "$JOURNAL/review-docket/open" | sed 's/\.json$//' | LC_ALL=C sort | sed -n 2p)" ] \
  || fail "cursor did not record the last visited record ($first_cursor)"
: > "$COUNTER"; batch
[ "$(sed -n 1p "$COUNTER")" = "$(jq -r .url "$JOURNAL/review-docket/open/$(ls "$JOURNAL/review-docket/open" | sed 's/\.json$//' | LC_ALL=C sort | sed -n 3p).json")" ] \
  || fail 'reconcile did not resume after its cursor'
[ "$(ls "$JOURNAL/review-docket/open")" = "$open_before" ] || fail 'bounded reconcile changed the open set'
: > "$COUNTER"; rm -f "$GARDEN_REVIEW_DOCKET_CURSOR"
start="$(date +%s)"
SLOW_PR="$(jq -r .pr "$JOURNAL/review-docket/open/$(ls "$JOURNAL/review-docket/open" | LC_ALL=C sort | sed -n 1p)")" \
  GARDEN_REVIEW_DOCKET_METADATA_TIMEOUT=1 batch || fail 'a slow metadata request failed the whole reconcile'
[ $(( $(date +%s) - start )) -lt 20 ] || fail 'per-request metadata timeout was not enforced'
[ "$(wc -l < "$COUNTER")" = 2 ] || fail 'a timed-out request stopped the rest of the batch'
: > "$COUNTER"; rm -f "$GARDEN_REVIEW_DOCKET_CURSOR"
GARDEN_REVIEW_DOCKET_RECONCILE_BUDGET=0 batch || fail 'an exhausted budget failed the reconcile'
[ ! -s "$COUNTER" ] && [ ! -f "$GARDEN_REVIEW_DOCKET_CURSOR" ] || fail 'an exhausted budget still fetched or advanced the cursor'
: > "$COUNTER"; batch https://github.com/example/repo/pull/23
[ "$(cat "$COUNTER")" = https://github.com/example/repo/pull/23 ] || fail 'targeted reconcile did not fetch exactly its PR'
[ ! -f "$GARDEN_REVIEW_DOCKET_CURSOR" ] || fail 'targeted reconcile moved the periodic cursor'

# Two producers sharing the production clone serialize their whole local
# transaction, then converge through the journal CAS without losing either row.
git init -q --bare "$TEST_ROOT/journal.git"
git -C "$JOURNAL" init -q
git -C "$JOURNAL" checkout -q -b journal2
git -C "$JOURNAL" add -A
git -C "$JOURNAL" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$JOURNAL" remote add origin "$TEST_ROOT/journal.git"
git -C "$JOURNAL" push -q origin HEAD:journal2
request "$TEST_ROOT/r9" alpha M5 s9 'parallel nine'
request "$TEST_ROOT/r10" beta M5 s10 'parallel ten'
parallel_pids=()
for pr in 9 10; do
  GARDEN_STATE="$TEST_ROOT/state" JOURNAL_REMOTE="$TEST_ROOT/journal.git" JOURNAL_BRANCH=journal2 \
    GARDEN_REVIEW_DOCKET_CLONE="$TEST_ROOT/shared-clone" GARDEN_REVIEW_DOCKET_METADATA="$STUB" \
    GARDEN_REVIEW_DOCKET_NOW=2026-10-08T18:00:00Z \
    "$JOBS/review-docket.sh" upsert "https://github.com/example/repo/pull/$pr" "$TEST_ROOT/r$pr" \
    >"$TEST_ROOT/parallel-$pr.log" 2>&1 &
  parallel_pids+=("$!")
done
parallel_rc=0
for pid in "${parallel_pids[@]}"; do wait "$pid" || parallel_rc=1; done
[ "$parallel_rc" -eq 0 ] || { cat "$TEST_ROOT"/parallel-*.log >&2; fail 'parallel producer command failed'; }
git clone -q --single-branch --branch journal2 "$TEST_ROOT/journal.git" "$TEST_ROOT/verify"
[ -f "$TEST_ROOT/verify/review-docket/open/example-repo-pr9.json" ] \
  && [ -f "$TEST_ROOT/verify/review-docket/open/example-repo-pr10.json" ] \
  || { cat "$TEST_ROOT"/parallel-*.log >&2; fail 'parallel producers lost a docket request'; }

# A transaction-lock timeout names the holder and the wait, then spools intake
# under a distinct retryable rc instead of dropping it; repeats dedupe.
live() { GARDEN_STATE="$TEST_ROOT/state" JOURNAL_REMOTE="$TEST_ROOT/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_REVIEW_DOCKET_CLONE="$TEST_ROOT/shared-clone" GARDEN_REVIEW_DOCKET_METADATA="${METADATA_HANDLER:-$STUB}" \
  GARDEN_REVIEW_DOCKET_NOW=2026-10-08T19:00:00Z "$JOBS/review-docket.sh" "$@"; }
SPOOL="$TEST_ROOT/state/review-docket/spool"
LOCK="$TEST_ROOT/state/review-docket/transaction.lock"
printf 'pid=%s op=upsert target=x since=now\n' "$$" > "$LOCK.holder"
flock -o "$LOCK" sleep 30 & holder_pid=$!
sleep 0.5
request "$TEST_ROOT/r11" alpha M5 s11 'spooled eleven'
rc=0; GARDEN_REVIEW_DOCKET_LOCK_WAIT=1 live upsert https://github.com/example/repo/pull/11 "$TEST_ROOT/r11" \
  >"$TEST_ROOT/timeout.log" 2>&1 || rc=$?
[ "$rc" -eq 76 ] || { cat "$TEST_ROOT/timeout.log" >&2; fail "lock timeout exited $rc, not the spooled rc 76"; }
grep -q 'timed out after [0-9]*s (limit 1s)' "$TEST_ROOT/timeout.log" || fail 'timeout message lacks the wait time'
grep -q "holder: pid=$$ op=upsert" "$TEST_ROOT/timeout.log" || fail 'timeout message lacks the holder record'
grep -q 'kernel flock holder pid=[0-9]* cmd=flock ' "$TEST_ROOT/timeout.log" || { cat "$TEST_ROOT/timeout.log" >&2; fail 'timeout message lacks the kernel holder'; }
! grep -q FATAL "$TEST_ROOT/timeout.log" || fail 'a spooled lock timeout still logged FATAL'
[ "$(ls "$SPOOL"/*.json | wc -l)" = 1 ] || fail 'lock timeout did not spool the upsert'
[ "$(jq -r .request.summary "$SPOOL"/*.json)" = 'spooled eleven' ] || fail 'spool lost the request body'
rc=0; GARDEN_REVIEW_DOCKET_LOCK_WAIT=1 live upsert https://github.com/example/repo/pull/11 "$TEST_ROOT/r11" >/dev/null 2>&1 || rc=$?
[ "$rc" -eq 76 ] && [ "$(ls "$SPOOL"/*.json | wc -l)" = 1 ] || fail 'a repeated timeout duplicated the spool entry'
rc=0; GARDEN_REVIEW_DOCKET_LOCK_WAIT=1 live reconcile >/dev/null 2>&1 || rc=$?
[ "$rc" -eq 75 ] && [ "$(ls "$SPOOL"/*.json | wc -l)" = 1 ] || fail "a bare reconcile timeout should skip (75) without spooling (rc=$rc)"
pkill -P "$holder_pid" 2>/dev/null || true; kill "$holder_pid" 2>/dev/null || true; wait "$holder_pid" 2>/dev/null || true
rm -f "$LOCK.holder"

# The next successful transaction drains the spool before its own operation.
live render >"$TEST_ROOT/drain.log" 2>&1 || { cat "$TEST_ROOT/drain.log" >&2; fail 'draining render failed'; }
[ -z "$(ls "$SPOOL"/*.json 2>/dev/null)" ] || fail 'spool was not drained'
git -C "$TEST_ROOT/verify" pull -q
[ "$(jq -r .summary "$TEST_ROOT/verify/review-docket/open/example-repo-pr11.json" 2>/dev/null)" = 'spooled eleven' ] \
  || { cat "$TEST_ROOT/drain.log" >&2; fail 'drained upsert did not land in the journal'; }
[ ! -e "$LOCK.holder" ] || fail 'holder record outlived the transaction'

# A hung push cannot hold the lock past the window: each push is bounded, and
# the whole CAS section is killed at the window and its intake spooled.
printf '#!/bin/sh\necho push >> "%s"\nexec sleep 30 >/dev/null 2>&1\n' "$TEST_ROOT/push-attempts" > "$TEST_ROOT/journal.git/hooks/pre-receive"
chmod +x "$TEST_ROOT/journal.git/hooks/pre-receive"
request "$TEST_ROOT/r12" alpha M5 s12 'hung twelve'
start="$(date +%s)"; rc=0
GARDEN_REVIEW_DOCKET_LOCK_WAIT=6 GARDEN_REVIEW_DOCKET_PUSH_TIMEOUT=2 \
  live upsert https://github.com/example/repo/pull/12 "$TEST_ROOT/r12" >"$TEST_ROOT/hung.log" 2>&1 || rc=$?
elapsed=$(( $(date +%s) - start ))
[ "$rc" -eq 76 ] || { cat "$TEST_ROOT/hung.log" >&2; fail "hung push exited $rc, not the spooled rc 76"; }
[ "$elapsed" -lt 25 ] || fail "hung push held the lock for ${elapsed}s"
[ "$(wc -l < "$TEST_ROOT/push-attempts")" -ge 2 ] || fail 'a hung push was not bounded per attempt'
! pgrep -f "receive-pack.*$TEST_ROOT" >/dev/null || fail 'a hung push outlived its transaction'
grep -q 'exceeded the 6s lock window' "$TEST_ROOT/hung.log" || { cat "$TEST_ROOT/hung.log" >&2; fail 'hung push did not report the window kill'; }
[ "$(jq -r .request.summary "$SPOOL"/*.json)" = 'hung twelve' ] || fail 'hung push did not spool its upsert'
rm -f "$TEST_ROOT/journal.git/hooks/pre-receive"
live render >"$TEST_ROOT/drain2.log" 2>&1 || { cat "$TEST_ROOT/drain2.log" >&2; fail 'second drain failed'; }
git -C "$TEST_ROOT/verify" pull -q
[ -f "$TEST_ROOT/verify/review-docket/open/example-repo-pr12.json" ] || fail 'spooled upsert after hung push was lost'

echo 'review-docket-test: PASS'
