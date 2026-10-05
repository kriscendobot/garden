---
tier: mentor
handler-timeout: 5400
split-indivisible-reason: 'the deliverable is one atomic change — a narrow classifier predicate in common.sh plus its regression test in deadline-nudge-test.sh; neither half is useful or verifiable alone. The parent overran the 2400s wall not because of size but because the deadline-nudge suite takes ~10 min wall-clock under host load (load avg ~10) and was run several times. The implementation is already done and verified (passed 57, failed 0); the child only needs to apply, re-verify once, and land.'
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-05T21:07:08Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 5400
---
scripts/jobs/deadline-nudge.sh / scripts/jobs/common.sh

split-indivisible-reason: the deliverable is one atomic change — a narrow classifier predicate in common.sh plus its regression test in deadline-nudge-test.sh; neither half is useful or verifiable alone. The parent overran the 2400s wall not because of size but because the deadline-nudge suite takes ~10 min wall-clock under host load (load avg ~10) and was run several times. The implementation is already done and verified (passed 57, failed 0); the child only needs to apply, re-verify once, and land.

Defect: deadline-nudge.sh treats Git's journal2 receive-side ref compare-and-swap rejection (`! [remote rejected] ... (cannot lock ref 'refs/heads/journal2': is at X but expected Y)`, seen 2026-10-05T20:18:32Z) as `server-reject` and raises a repair alert. It is a lost race.

Task: apply the patch below to a main2 worktree (`git apply`), run
`bash scripts/jobs/test/deadline-nudge-test.sh` ONCE in the foreground (allow ~15 min; it is slow under load) plus `scripts/jobs/test/cursor-outage-cooldown-test.sh`, then commit
(common.sh, test/deadline-nudge-test.sh, new test/deadline-nudge-reflock-push-stub.sh — chmod +x) and push to main2 with the repo-lock CAS loop.

What the patch does: adds `journal_push_is_ref_lock_race` (matches only `cannot lock ref '...': is at <hex> but expected <hex>`), folds it into `journal_push_is_cas_contention`, and makes `journal_push_is_server_rejection` / `journal_push_is_definite_failure` return false for it — so commit_and_push classifies it `cas`, deadline-nudge re-syncs and recomputes the batch, and cursor-set/cursor-advance retry instead of paging. A non-race `cannot lock ref` (e.g. Permission denied) stays definite. The regression test lands a concurrent claim mid-push, emits the ref-lock diagnostic, and asserts: retried as lost race, both the original and the concurrently-added claim's warnings delivered, no rejection log, no repair alert/fingerprint. Previously verified: deadline-nudge 57/0, cursor-outage-cooldown 65/0, budget-snapshot-{warning-dedup,outage-reclone,publish-retry} pass.

```diff
diff --git a/scripts/jobs/common.sh b/scripts/jobs/common.sh
index 41ee7f08387..f17a024e477 100755
--- a/scripts/jobs/common.sh
+++ b/scripts/jobs/common.sh
@@ -5416,18 +5416,34 @@ journal_diagnostic_is_definite_failure() {  # <diagnostic>
 # signal that this is a lost compare-and-swap and can be reconciled by re-syncing.
 journal_push_is_cas_contention() {  # <diagnostic>
   printf '%s\n' "$1" | grep -qiE \
-    '\[rejected\].*\((non-fast-forward|fetch first)\)|Updates were rejected because (the tip of your current branch is behind|the remote contains work)'
+    '\[rejected\].*\((non-fast-forward|fetch first)\)|Updates were rejected because (the tip of your current branch is behind|the remote contains work)' \
+    || journal_push_is_ref_lock_race "$1"
+}
+
+# The receiver's own compare-and-swap: a concurrent writer advanced the ref after
+# the receiver read it, so its ref transaction refuses with
+#   ! [remote rejected] journal2 -> journal2 (cannot lock ref
+#   'refs/heads/journal2': is at <new> but expected <old>)
+# That arrives as a `[remote rejected]` and contains `cannot lock ref`, the
+# server-rejection and local-failure signatures, yet it is a lost race that a
+# re-sync resolves (2026-10-05T20:18:32Z, deadline-nudge). Recognize it narrowly
+# by the "is at X but expected Y" detail and let it override those classes.
+journal_push_is_ref_lock_race() {  # <diagnostic>
+  printf '%s\n' "$1" | grep -qiE \
+    "cannot lock ref '[^']*': is at [0-9a-f]+ but expected [0-9a-f]+"
 }
 
 # A receive-side policy or hook rejection is not CAS contention. Keep this set
 # separate from journal_diagnostic_is_definite_failure because these signatures
 # describe push-only failures, not fetch/clone diagnostics.
 journal_push_is_server_rejection() {  # <diagnostic>
+  journal_push_is_ref_lock_race "$1" && return 1
   printf '%s\n' "$1" | grep -qiE \
     '\[remote rejected\]|pre-receive hook declined|protected branch hook declined|GH00[0-9]|GH01[0-9]|remote: error:|deny updating a hidden ref'
 }
 
 journal_push_is_definite_failure() {  # <diagnostic>
+  journal_push_is_ref_lock_race "$1" && return 1
   journal_diagnostic_is_definite_failure "$1" \
     || journal_push_is_server_rejection "$1"
 }
diff --git a/scripts/jobs/test/deadline-nudge-reflock-push-stub.sh b/scripts/jobs/test/deadline-nudge-reflock-push-stub.sh
new file mode 100755
index 00000000000..0f7ca67300c
--- /dev/null
+++ b/scripts/jobs/test/deadline-nudge-reflock-push-stub.sh
@@ -0,0 +1,36 @@
+#!/bin/bash
+# First invocation lands a legitimate concurrent journal push (a new due claim)
+# and then refuses the scanner's push the way the receiver's own ref transaction
+# does when it loses that race: `[remote rejected] ... (cannot lock ref ...: is
+# at <new> but expected <old>)`. Later invocations perform the real push.
+
+set -euo pipefail
+: "${GARDEN_PUSH_DIR:?}"
+: "${GARDEN_NUDGE_REFLOCK_BARE:?}"
+: "${GARDEN_NUDGE_REFLOCK_MARKER:?}"
+: "${GARDEN_NUDGE_REFLOCK_CLAIM:?}"
+
+if [ ! -e "$GARDEN_NUDGE_REFLOCK_MARKER" ]; then
+  expected="$(git -C "$GARDEN_NUDGE_REFLOCK_BARE" rev-parse journal2)"
+  update="${GARDEN_NUDGE_REFLOCK_MARKER}.update"
+  rm -rf "$update"
+  git clone -q --branch journal2 "$GARDEN_NUDGE_REFLOCK_BARE" "$update"
+  base="${GARDEN_NUDGE_REFLOCK_CLAIM##*/}"
+  base="${base%.md}"
+  mkdir -p "$update/jobs/doin" "$update/inbox/$base/unread" "$update/inbox/$base/read"
+  cp "$GARDEN_NUDGE_REFLOCK_CLAIM" "$update/jobs/doin/$base.md"
+  touch "$update/inbox/$base/unread/.gitkeep" "$update/inbox/$base/read/.gitkeep"
+  git -C "$update" add -A
+  git -C "$update" -c user.name=test -c user.email=test@localhost \
+    commit -q -m "reflock fixture: concurrent claim $base"
+  git -C "$update" push -q origin HEAD:journal2
+  actual="$(git -C "$GARDEN_NUDGE_REFLOCK_BARE" rev-parse journal2)"
+  touch "$GARDEN_NUDGE_REFLOCK_MARKER"
+  printf '%s\n' \
+    'To github.com:kriscendobot/garden.git' \
+    " ! [remote rejected]       HEAD -> journal2 (cannot lock ref 'refs/heads/journal2': is at $actual but expected $expected)" \
+    "error: failed to push some refs to 'github.com:kriscendobot/garden.git'" >&2
+  exit 1
+fi
+
+git -C "$GARDEN_PUSH_DIR" push -q origin HEAD:journal2
diff --git a/scripts/jobs/test/deadline-nudge-test.sh b/scripts/jobs/test/deadline-nudge-test.sh
index 5dce59c3fc9..86f7f39c9dd 100755
--- a/scripts/jobs/test/deadline-nudge-test.sh
+++ b/scripts/jobs/test/deadline-nudge-test.sh
@@ -471,6 +471,47 @@ else
   sed 's/^/    /' "$TEST_ROOT/pushreject-clear.out" | tail -5
 fi
 
+# A legitimate concurrent journal push that beats the scanner inside the
+# receiver's ref transaction surfaces as `[remote rejected] ... (cannot lock ref
+# ...: is at X but expected Y)`. That is a lost CAS, not a receive-side wall: the
+# scanner must re-sync, recompute its batch (picking up the concurrent claim),
+# deliver both warnings, and raise no repair alert (2026-10-05T20:18:32Z).
+reflock_stub="$HERE/deadline-nudge-reflock-push-stub.sh"
+add_claim_at_tip reflock 300
+write_claim "$TEST_ROOT/reflock-claim" reflock-concurrent "fixer" "" 2400 300
+run_nudge reflock-scan env GARDEN_DEADLINE_NUDGE_PUSH_ATTEMPTS=3 \
+  GARDEN_NUDGE_REFLOCK_BARE="$BARE" GARDEN_NUDGE_REFLOCK_MARKER="$TEST_ROOT/reflock.marker" \
+  GARDEN_NUDGE_REFLOCK_CLAIM="$TEST_ROOT/reflock-claim/jobs/doin/reflock-concurrent.md" \
+  GARDEN_PUSH_CMD="$reflock_stub" > "$TEST_ROOT/reflock.out" 2>&1
+reflock_rc=$?
+if [ "$reflock_rc" -eq 0 ] \
+  && [ -e "$TEST_ROOT/reflock.marker" ] \
+  && grep -q 'push stage lost a race (attempt 1/3)' "$TEST_ROOT/reflock.out" \
+  && ! grep -q 'push stage rejected' "$TEST_ROOT/reflock.out" \
+  && ! grep -q 'repair alert' "$TEST_ROOT/reflock.out" \
+  && [ ! -e "$reject_fp" ] \
+  && [ -n "$(nudge_paths reflock)" ] \
+  && [ -n "$(nudge_paths reflock-concurrent)" ]; then
+  ok 'a remote ref-lock CAS race is retried as a lost race, recomputes the batch, and raises no alert'
+else
+  bad 'a remote ref-lock CAS race was treated as a rejection, dropped warnings, or alerted'
+  sed 's/^/    /' "$TEST_ROOT/reflock.out" | tail -8
+fi
+reflock_diag=" ! [remote rejected] HEAD -> journal2 (cannot lock ref 'refs/heads/journal2': is at 1111111111111111111111111111111111111111 but expected 2222222222222222222222222222222222222222)"
+if journal_push_is_cas_contention "$reflock_diag" \
+  && ! journal_push_is_server_rejection "$reflock_diag" \
+  && ! journal_push_is_definite_failure "$reflock_diag"; then
+  ok 'shared push classifier: remote ref-lock race is cas, not server-reject or definite'
+else
+  bad 'shared push classifier mislabels a remote ref-lock race'
+fi
+if ! journal_push_is_cas_contention " ! [remote rejected] HEAD -> journal2 (cannot lock ref 'refs/heads/journal2': Permission denied)" \
+  && journal_push_is_definite_failure " ! [remote rejected] HEAD -> journal2 (cannot lock ref 'refs/heads/journal2': Permission denied)"; then
+  ok 'shared push classifier: a non-race ref-lock failure stays definite'
+else
+  bad 'shared push classifier widened the race class past the expected-value mismatch'
+fi
+
 run_nudge invalid env GARDEN_DEADLINE_NUDGE_INTERVAL=oops > "$TEST_ROOT/invalid.out" 2>&1
 [ "$?" -eq 0 ] && grep -q 'disabling this tick' "$TEST_ROOT/invalid.out" && ok 'invalid timing knob disables one tick cleanly' || bad 'invalid timing knob did not fail open'
 set +e
```
