---
tier: mentor
posted_at: 2026-11-03T20:22:22Z
handler-timeout: 7200
split-indivisible-reason: 'one already-written patch whose docket helper, rc constant, and regression tests only pass together; the overrun was suite wall time on a loaded host, not scope'
split-lineage-root: improve-gardener-handler-rc76-collision
split-lineage-parent: improve-gardener-handler-rc76-collision-split
split-lineage-depth: 1
split-lineage-max-depth: 1
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-03T20:31:22Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Land the gardener fix for spooled review-docket notices failing finished jobs

Split from `improve-gardener-handler-rc76-collision` after a 2400s wall overrun. The implementation is written (patch below), never committed. What remains is to apply it, verify it, and land it on `main2`. Do not redesign it unless verification shows it is wrong.

## Finding (corrects the original job's premise)

The original job reported that the weave handler for `kriscendobot-minion.town-pr199-weave-20261103` exited rc=76, colliding with complete-job's `GARDEN_HANDOFF_UNVERIFIED_RC`. The evidence says otherwise:

- The handler exited 0 with its completion signal. oros `journalctl` at 06:56:04Z: `panel-head freshness could not record the stale-review disposition ... (rc=76)`, then `handler FAILED (rc=76) ... (handler elapsed=1819s)`.
- The 76 is `GARDEN_REVIEW_DOCKET_SPOOLED_RC`. Capture `af31c97531ac66c64295dd922af15bfc6e92708d`: `the upsert transaction exceeded the 180s lock window and was killed; upsert spooled, exiting rc=76 (retryable)`.
- `gardener.sh` compares `crc` and `hrc` separately, so 76 never reached complete-job's branch. The two 76s look alike but nothing was misrouted, so renumbering would fix nothing.
- The damage: the spooled notice is durable, but it pushed a finished job into the failure path. The report was discarded, and the sentinel teardown had already removed the worktree and retired the session. The retry died at rc=75 after 18s (cause unknown, capture not kept) and the job doomed.
- Frequency on oros, 2026-10-25 to 11-03: 6 stale-notice rc=76 failures, 1 fixer re-entry rc=76 (fixed since by d45a2d77f58), 2 follow-up gate blocks (correct behavior), 1 complete-job offline.

## What the patch does

- Treats a spooled docket intake as landed in the stale-panel and draft-guardrail notices (`docket_intake_landed`), matching the fixer path. The report says the action is spooled, not received.
- Defines `GARDEN_REVIEW_DOCKET_SPOOLED_RC` once in `common.sh`, with a comment on the shared number; removes the literal 76 from the fixer case.
- Records `handler_exit_rc`, so failure records say when the handler exited 0 and a completion-local step set the rc.
- Adds spooled and hard-failure regression cases, and `GARDEN_DOCKET_SPY_RC` on the spy.

Deliberately not done: the job's head-SHA post-condition. No expected SHA is recorded anywhere, and a pushed head does not prove the job finished (a weaver still waits for CI and stages the gauntlet), so it risks a false completion, which is the worst outcome on this board. The worker's own completion signal is the stronger post-condition, and it was present in the incident. State this in the report so the job owner can disagree.

## Verification so far

- `panel-head-freshness-completion-test.sh`, `draft-guardrail-terminalization-test.sh`, `fixer-docket-spooled-completion-test.sh`: PASS with the patch. The first two FAIL with `gardener.sh` reverted to HEAD (`8b364fc1b55`), so the new cases catch the bug.
- `completion-signal-test.sh`: INCONCLUSIVE. 28 PASS and no FAIL, then killed by `timeout 1500` (rc=124). Not known whether it is slow or stuck. An earlier `timeout 280` run was also cut off.
- `review-docket-test.sh`: FAILED once with `a hung push was not bounded per attempt` (`scripts/jobs/test/review-docket-test.sh:245`). UNRESOLVED. It ran while the host was loaded and the patch only removes a default that `common.sh` now sets, so load is the guess, not a finding. Rerun it, and if it still fails compare against unpatched HEAD before landing.

## Remaining work

1. Apply the patch below to your worktree (`git apply`, or `--3way` if `main2` moved).
2. Rerun the three focused tests.
3. Resolve the two open suites above. Run long suites detached with output to a file under `$TMPDIR` and wait in bounded polls under the 600s tool limit; a previous foreground wait died with exit 137.
4. Use `scripts/checks/run-all.sh --dry-run` only. Without `--dry-run`, a fired gate launches a nested `claude -p`; `claude-md-inventory-drift` fired on the last run. Check whether that gate fires on unpatched HEAD; this patch does not touch `CLAUDE.md` or the role and skill inventory.
5. Commit explicit pathspecs and push to `main2` with the rebase CAS loop from your job prompt.

If a suite fails because of this patch and you cannot fix it, do not land it: emit the orchestration failure signal and say why.

## Patch (against `8b364fc1b55`)

```diff
diff --git a/scripts/jobs/common.sh b/scripts/jobs/common.sh
index ac03de72a6e..6f4c98249d3 100755
--- a/scripts/jobs/common.sh
+++ b/scripts/jobs/common.sh
@@ -827,6 +827,9 @@ post_deadline_exceeded() {  # <loop-start-SECONDS> <what> <attempt>
   log "$2 exceeded ${GARDEN_POST_DEADLINE_SECS}s wall-clock deadline under degraded connectivity (attempt $3); skipping tick (rc=$GARDEN_OFFLINE_RC)"
 }
 : "${GARDEN_HANDOFF_UNVERIFIED_RC:=76}" # soft job-level verdict: declared handoff successor is absent
+# Same number as GARDEN_HANDOFF_UNVERIFIED_RC, different command: compare each only
+# against the status of the command that owns it (complete-job.sh; review-docket.sh).
+: "${GARDEN_REVIEW_DOCKET_SPOOLED_RC:=76}" # review-docket intake durably spooled for a later transaction
 : "${GARDEN_COMPLETED_COLLISION_RC:=79}" # post-job: unidentified basename collides with a completed job
 : "${GARDEN_LOCK_WAIT:=60}"       # seconds a clone-lock waiter blocks before backing off
 : "${GARDEN_LOCK_RETRIES:=3}"     # bounded waits before a lock acquisition gives up
diff --git a/scripts/jobs/gardener.sh b/scripts/jobs/gardener.sh
index 4b517c6a6fd..308bcc11946 100755
--- a/scripts/jobs/gardener.sh
+++ b/scripts/jobs/gardener.sh
@@ -864,6 +864,9 @@ while :; do
   fi
   rm -f "$watchdog_marker"
   set -e
+  # The handler's own status. Completion-local steps below may overwrite $hrc, and
+  # the failure records must still say which of the two actually failed.
+  handler_exit_rc=$hrc
 
   # REAP the handler's process tree UNCONDITIONALLY, for every outcome. On an
   # rc=124 wall-clock overrun timeout killed only the direct handler (--foreground),
@@ -1000,6 +1003,19 @@ while :; do
     fi
   fi
 
+  # A review-docket intake landed if it committed (rc 0) or if the docket durably
+  # spooled it on this host for its next transaction (GARDEN_REVIEW_DOCKET_SPOOLED_RC).
+  # Spooling changes when the maintainer sees the action, not whether they will, and
+  # the docket drains or dead-letters with its own alert. So a spool must not undo a
+  # finished job: 2026-11-03 kriscendobot-minion.town-pr199-weave-20261103 ran to its
+  # completion signal (force-push, base move, gauntlet staged), then a spooled stale-
+  # panel notice sent it to the failure path. Its report was discarded, its retry
+  # died at rc=75, and it doomed requeue-exhausted with the work already landed. All
+  # six such failures on that host from 2026-10-25 to 11-03 came from this notice.
+  docket_intake_landed() { # <rc>
+    [ "$1" -eq 0 ] || [ "$1" -eq "$GARDEN_REVIEW_DOCKET_SPOOLED_RC" ]
+  }
+
   # AUTOMATIC GAUNTLET HANDOFF. A successful producer that names its new draft PR
   # must durably stage the review it calls for before the producer settles. The
   # hook is deliberately completion-local: it never scans historical drafts, never
@@ -1026,8 +1042,9 @@ while :; do
   # first citation. rc 2 (nothing to re-enter) and rc 3 (CI not green, from a
   # clerk that predates the pending path) are deferrals. rc 76 means the docket
   # could not commit now but durably spooled the re-entry on this host, so a
-  # later transaction drains it; that is also a deferral. Any other nonzero rc
-  # is a hard error that leaves this completion retryable.
+  # later transaction drains it; that is also a deferral (the same
+  # docket_intake_landed rule as the two docket notices below). Any other nonzero
+  # rc is a hard error that leaves this completion retryable.
   if [ "$hrc" -eq 0 ] && [ -e "$completion_sentinel" ] \
      && [ "$(plan_role "$jobfile" 2>/dev/null || true)" = fixer ]; then
     fixer_pr="$(fixer_reentry_pr "$jobfile" "$report" "$base" || true)"
@@ -1039,7 +1056,7 @@ while :; do
       case "$fixer_docket_rc" in
         0) ;;
         2|3) log "fixer review-docket re-entry for '$base' ($fixer_pr) deferred (rc=$fixer_docket_rc); completing the job" ;;
-        76) log "fixer review-docket re-entry for '$base' ($fixer_pr) spooled (rc=76); a later docket transaction drains it; completing the job" ;;
+        "$GARDEN_REVIEW_DOCKET_SPOOLED_RC") log "fixer review-docket re-entry for '$base' ($fixer_pr) spooled (rc=$fixer_docket_rc); a later docket transaction drains it; completing the job" ;;
         *)
           hrc=$fixer_docket_rc
           log "fixer review-docket re-entry FAILED for '$base' ($fixer_pr, rc=$hrc); leaving in doin for retry"
@@ -1094,7 +1111,10 @@ while :; do
       draft_gate_notice_rc=$?
       set -e
       rm -f "$draft_gate_notice"
-      if [ "$draft_gate_notice_rc" -eq 0 ]; then
+      if docket_intake_landed "$draft_gate_notice_rc"; then
+        draft_gate_docket="A deduplicated review-docket decision was recorded"
+        [ "$draft_gate_notice_rc" -eq 0 ] \
+          || draft_gate_docket="A deduplicated review-docket decision was spooled on $GARDEN for its next docket transaction"
         # Keep any exact final disposition marker FINAL. Appending ordinary prose
         # after an orchestration-failed or named-successor marker would make the
         # downstream last-line parser miss the agent's original disposition.
@@ -1112,10 +1132,10 @@ while :; do
         fi
         {
           printf '\n## Manual gauntlet handoff\n\n'
-          printf 'The completion guard found %s ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.\n' "$draft_gate_pr"
+          printf 'The completion guard found %s ready without gauntlet coverage. %s; the PR was not re-drafted and no gauntlet was staged.\n' "$draft_gate_pr" "$draft_gate_docket"
           [ -z "$draft_gate_tail_marker" ] || printf '%s\n' "$draft_gate_tail_marker"
         } >> "$report"
-        log "producer-PR draft GUARDRAIL docketed '$base' and terminalized it: $draft_gate_pr is non-draft without gauntlet coverage; PR left untouched"
+        log "producer-PR draft GUARDRAIL docketed '$base' (docket rc=$draft_gate_notice_rc) and terminalized it: $draft_gate_pr is non-draft without gauntlet coverage; PR left untouched"
       else
         hrc=$draft_gate_notice_rc
         log "producer-PR draft GUARDRAIL could not record the manual-gauntlet handoff for '$base' (rc=$hrc); leaving in doin for retry"
@@ -1172,7 +1192,10 @@ while :; do
       stale_notice_rc=$?
       set -e
       rm -f "$stale_notice"
-      if [ "$stale_notice_rc" -eq 0 ]; then
+      if docket_intake_landed "$stale_notice_rc"; then
+        stale_docket="the maintainer review docket received a deduplicated re-review action"
+        [ "$stale_notice_rc" -eq 0 ] \
+          || stale_docket="a deduplicated re-review action is spooled on $GARDEN for the maintainer review docket's next transaction"
         stale_tail_marker=""
         if report_has_orchestration_failure_marker "$report"; then
           stale_tail_marker="$GARDEN_ORCHESTRATION_FAILURE_MARKER"
@@ -1187,11 +1210,11 @@ while :; do
         fi
         {
           printf '\n## Panel-head freshness\n\n'
-          printf 'Disposition: **review required**. The last completed panel reviewed `%s`; this job presented `%s`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.\n' \
-            "$reviewed_head" "$presented_head"
+          printf 'Disposition: **review required**. The last completed panel reviewed `%s`; this job presented `%s`. The old panel verdict does not cover the current head. No gauntlet was staged; %s.\n' \
+            "$reviewed_head" "$presented_head" "$stale_docket"
           [ -z "$stale_tail_marker" ] || printf '%s\n' "$stale_tail_marker"
         } >>"$report"
-        log "panel-head freshness disposition recorded for '$base': $stale_pr moved $reviewed_head -> $presented_head; no gauntlet staged"
+        log "panel-head freshness disposition recorded for '$base' (docket rc=$stale_notice_rc): $stale_pr moved $reviewed_head -> $presented_head; no gauntlet staged"
       else
         hrc=$stale_notice_rc
         log "panel-head freshness could not record the stale-review disposition for '$base' (rc=$hrc); leaving in doin for retry"
@@ -1546,7 +1569,13 @@ while :; do
     fi
     idle_backoff "$fail_attempt"; fail_attempt=$((fail_attempt+1))
   else
-    rc=$hrc  # exit code of the failed handler (captured explicitly above)
+    rc=$hrc  # exit code of the failed handler or completion-local step (captured explicitly above)
+    # A completion-local step can fail a handler that exited 0, and its rc may be
+    # one that step owns (2026-11-03: a weave whose handler exited 0 was recorded as
+    # "handler FAILED (rc=76)" and read as complete-job's handoff verdict).
+    completion_step_note=""
+    [ "$handler_exit_rc" -ne 0 ] \
+      || completion_step_note="; the handler exited 0, a completion-local step set this rc"
     elapsed=$handler_elapsed  # wall-clock seconds the handler ran before it died
     post_handler_secs=$((SECONDS - handler_returned_at))
     if [ "$post_handler_secs" -ge 60 ]; then
@@ -1596,7 +1625,7 @@ while :; do
     # out of $capture so it can never change the transient-vs-real classification.
     watchdog_note=""
     [ -n "$watchdog_evidence" ] && watchdog_note="; watchdog: $watchdog_evidence"
-    log "handler FAILED (rc=$rc) for '$base' (handler elapsed=${elapsed}s$watchdog_note); capturing output and classifying transient-vs-real (job left in doin for the reaper)"
+    log "handler FAILED (rc=$rc) for '$base' (handler elapsed=${elapsed}s$watchdog_note$completion_step_note); capturing output and classifying transient-vs-real (job left in doin for the reaper)"
     # Most handlers (the default handlers/monk-claude.sh among them) write their
     # real output to $report, not to their own stdout/stderr, so $capture is often
     # empty even though the handler produced diagnostics. Fold the tail of $report
@@ -2170,8 +2199,8 @@ while :; do
         sha="$(capture_blob "$capture" "$CLONE" 2>/dev/null || echo unknown)"
         [ "$sha" = unknown ] || anchor_blob "$sha" "gardener/$id/$base" "$CLONE" 2>/dev/null || true
       fi
-      printf 'gardener-%s on %s: job %s handler FAILED (rc=%s); output captured as %s, escalated to the gardener inbox, left in doin for the reaper\n' \
-        "$id" "$GARDEN" "$base" "$rc" "$sha" \
+      printf 'gardener-%s on %s: job %s handler FAILED (rc=%s%s); output captured as %s, escalated to the gardener inbox, left in doin for the reaper\n' \
+        "$id" "$GARDEN" "$base" "$rc" "$completion_step_note" "$sha" \
         | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true
 
       # --- hermit capability probe (design hermit-failure-capability-demerit.md) --
diff --git a/scripts/jobs/review-docket.sh b/scripts/jobs/review-docket.sh
index 30936a4b62d..5c1bb3a4d37 100755
--- a/scripts/jobs/review-docket.sh
+++ b/scripts/jobs/review-docket.sh
@@ -501,7 +501,6 @@ fi
 # transaction instead of dropping intake merely because its push is in flight.
 GARDEN_REPO_LOCK_WAIT="${GARDEN_REVIEW_DOCKET_LOCK_WAIT:-180}"
 : "${GARDEN_REVIEW_DOCKET_SPOOL:=$GARDEN_STATE/review-docket/spool}"
-: "${GARDEN_REVIEW_DOCKET_SPOOLED_RC:=76}"
 : "${GARDEN_REVIEW_DOCKET_SPOOL_BATCH:=10}"
 : "${GARDEN_REVIEW_DOCKET_SPOOL_MAX_ATTEMPTS:=20}"
 # One journal push may not consume the whole transaction window; a timed-out
diff --git a/scripts/jobs/test/draft-guardrail-terminalization-test.sh b/scripts/jobs/test/draft-guardrail-terminalization-test.sh
index 04d698025fb..e14c0be85b5 100755
--- a/scripts/jobs/test/draft-guardrail-terminalization-test.sh
+++ b/scripts/jobs/test/draft-guardrail-terminalization-test.sh
@@ -102,4 +102,34 @@ git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
 [ "$(wc -l < "$TR/docket.log")" -eq 2 ] \
   || fail 'each producer did not converge through the same stable docket identity'
 
+# A spooled decision (docket rc=76) is durable: the finished job terminalizes and
+# its report says the decision is spooled rather than recorded.
+printf -- '---\nrole: builder\n---\nBuild the spooled feature.\n' \
+  > "$TR/verify/jobs/todo/readyjob-spooled.md"
+git -C "$TR/verify" add jobs/todo/readyjob-spooled.md
+git -C "$TR/verify" -c user.name=test -c user.email=test@example.invalid \
+  commit -q -m 'post spooled producer'
+git -C "$TR/verify" push -q origin HEAD:journal2
+: > "$TR/spooled-handler-calls.log"
+env GARDEN=draft-terminal-test GARDEN_STATE="$TR/state3" \
+  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
+  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
+  GARDEN_PRODUCER_CLONE="$TR/state3/producer/journal" \
+  GARDEN_GH="$HERE/assert-producer-pr-draft-gh-stub.sh" \
+  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
+  GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
+  GARDEN_DOCKET_SPY_LOG="$TR/docket.log" GARDEN_DOCKET_SPY_RC=76 \
+  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
+  GARDEN_STUB_CALL_LOG="$TR/spooled-handler-calls.log" \
+  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
+  "$JOBS/gardener.sh" 3 > "$TR/gardener-spooled.log" 2>&1 || true
+rm -rf "$TR/verify"
+git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
+spooled_tada="$(find "$TR/verify/jobs/tada" -type f -name readyjob-spooled.md -print -quit)"
+[ -n "$spooled_tada" ] || fail 'a spooled decision did not terminalize the finished job'
+[ "$(wc -l < "$TR/spooled-handler-calls.log")" -eq 1 ] || fail 'a spooled decision reran the handler'
+grep -q 'decision was spooled on draft-terminal-test' "$spooled_tada" \
+  || fail 'tada report does not say the decision is spooled'
+! grep -q 'handler FAILED' "$TR/gardener-spooled.log" || fail 'a spooled decision entered the failure path'
+
 echo 'PASS: conclusive draft guardrail hits terminalize completed jobs with one durable per-PR manual-gauntlet action, no PR mutation, and no repeated handler run'
diff --git a/scripts/jobs/test/panel-head-freshness-completion-test.sh b/scripts/jobs/test/panel-head-freshness-completion-test.sh
index 41666f9d9fd..889bdb6d557 100755
--- a/scripts/jobs/test/panel-head-freshness-completion-test.sh
+++ b/scripts/jobs/test/panel-head-freshness-completion-test.sh
@@ -110,4 +110,52 @@ grep -q 'fresh board sync/requeue can restore the input' "$TR/missing-input.log"
 grep -q "handler FAILED (rc=12) for 'missinginput'" "$TR/missing-input.log" \
   || fail 'missing freshness input did not enter the retryable completion-failure path'
 
-echo 'PASS: stale post-panel completion terminalizes explicitly, and successful handlers with missing freshness inputs retain a retryable claim with an actionable diagnostic'
+# Regression: the docket can spool the re-review instead of committing it (rc=76,
+# 2026-11-03 kriscendobot-minion.town-pr199-weave-20261103). The action is durable,
+# so the finished job terminalizes and says so. A hard docket failure stays retryable.
+run_docket_case() { # <job> <docket-rc> <gardener-id>
+  local job="$1" docket_rc="$2" id="$3"
+  rm -rf "$TR/verify-seed"
+  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify-seed"
+  printf -- '---\nrole: shepherd\n---\nRepair CI on the existing PR.\n' \
+    >"$TR/verify-seed/jobs/todo/$job.md"
+  git -C "$TR/verify-seed" add "jobs/todo/$job.md"
+  git -C "$TR/verify-seed" -c user.name=test -c user.email=test@example.invalid \
+    commit -q -m "seed $job"
+  git -C "$TR/verify-seed" push -q origin HEAD:journal2
+  : >"$TR/$job-handler-calls.log"
+  env GARDEN=panel-fresh-terminal-test GARDEN_STATE="$TR/state-$job" \
+    JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
+    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
+    GARDEN_PRODUCER_CLONE="$TR/state-$job/producer/journal" \
+    GARDEN_GH="$HERE/panel-head-freshness-completion-gh-stub.sh" \
+    GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
+    GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
+    GARDEN_DOCKET_SPY_LOG="$TR/docket.log" GARDEN_DOCKET_SPY_RC="$docket_rc" \
+    GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
+    GARDEN_STUB_CALL_LOG="$TR/$job-handler-calls.log" \
+    GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
+    "$JOBS/gardener.sh" "$id" >"$TR/$job.log" 2>&1 || true
+  rm -rf "$TR/verify-$job"
+  git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify-$job"
+}
+
+run_docket_case spooledjob 76 3
+spooled_tada="$(find "$TR/verify-spooledjob/jobs/tada" -type f -name spooledjob.md -print -quit)"
+[ -n "$spooled_tada" ] || fail 'a spooled stale-review notice did not terminalize the finished job'
+[ ! -e "$TR/verify-spooledjob/jobs/doin/spooledjob.md" ] || fail 'a spooled stale-review notice left the job in doin'
+[ "$(wc -l <"$TR/spooledjob-handler-calls.log")" -eq 1 ] || fail 'a spooled stale-review notice reran the handler'
+grep -q 'is spooled on panel-fresh-terminal-test' "$spooled_tada" \
+  || fail 'tada report does not say the re-review action is spooled'
+! grep -q 'received a deduplicated re-review action' "$spooled_tada" \
+  || fail 'tada report claims the docket received a spooled action'
+! grep -q 'handler FAILED' "$TR/spooledjob.log" || fail 'a spooled notice entered the failure path'
+
+run_docket_case hardjob 1 4
+[ -z "$(find "$TR/verify-hardjob/jobs/tada" -type f -name hardjob.md -print -quit)" ] \
+  || fail 'a hard docket failure still terminalized the job'
+[ -e "$TR/verify-hardjob/jobs/doin/hardjob.md" ] || fail 'a hard docket failure did not stay retryable in doin'
+grep -q "handler FAILED (rc=1) for 'hardjob'.*the handler exited 0, a completion-local step set this rc" "$TR/hardjob.log" \
+  || fail 'the failure record does not separate a completion-local rc from the handler status'
+
+echo 'PASS: stale post-panel completion terminalizes explicitly, and successful handlers with missing freshness inputs retain a retryable claim with an actionable diagnostic; a spooled re-review notice terminalizes honestly and a hard docket failure stays retryable'
diff --git a/scripts/jobs/test/review-docket-request-spy.sh b/scripts/jobs/test/review-docket-request-spy.sh
index 516ee57ce9e..0b6b039f18e 100755
--- a/scripts/jobs/test/review-docket-request-spy.sh
+++ b/scripts/jobs/test/review-docket-request-spy.sh
@@ -3,3 +3,4 @@ set -euo pipefail
 : "${GARDEN_DOCKET_SPY_LOG:?GARDEN_DOCKET_SPY_LOG is required}"
 printf '%q ' "$@" >> "$GARDEN_DOCKET_SPY_LOG"
 printf '\n' >> "$GARDEN_DOCKET_SPY_LOG"
+exit "${GARDEN_DOCKET_SPY_RC:-0}"
```

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-04T00:53:06Z -->

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T01:03:04Z
