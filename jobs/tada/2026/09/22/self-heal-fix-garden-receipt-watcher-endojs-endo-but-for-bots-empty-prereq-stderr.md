Pushed to `main2`.

## Completion report

**What the job asked:** Guard the receipt-watcher's prerequisite-failure branch so an empty `$PREREQ_ERR` no longer blindly claims "see prerequisite stderr above"; instead log a WARN noting the subshell produced no diagnostic (rc=$prereq_rc) and suggest a resource check.

**What I found:** The blind-claim defect described in the job had *already* been substantially repaired by recent commits — `3002969de5` added an ERR trap that captures any failing command, and the current code (lines 123-136) already splits on `[ -s "$PREREQ_ERR" ]`: the populated branch prints the captured stderr and dies "see prerequisite stderr above"; a separate empty-stderr fallback already existed at line 134. So the "blindly claims see stderr above even when empty" state no longer existed. The remaining gap was the fallback's *diagnosis*: it attributed an empty stderr to "an unclassified set -e exit in ensure_clone/sync_clone/journal_fetch" and did **not** suggest the resource check the job asked for.

**What I changed** (`scripts/jobs/receipt-watcher.sh`):
- Rewrote the empty-stderr fallback WARN. Given the ERR trap now captures any errexit command failure and every `die()`/`log()` path logs unconditionally, a *truly* empty stderr is now the environmental-interruption signature the job diagnosed. The WARN now says exactly that and points the responder at the actual causes — fork failure, ENOSPC on `$TMPDIR` (with the resolved value interpolated), OOM, or a signal — and tells them to check host disk space and fork/process limits.
- Updated the accompanying `die` message and added an explanatory comment tying the empty-stderr case to the ERR-trap invariant.

**Verification:** `bash -n` clean; full `receipt-watcher-test.sh` suite passes (11/11). My edit is confined to the terminal empty-stderr branch and leaves the populated-stderr path (exercised by the structural-journal test) untouched.

**No test added for the empty path:** it is only reachable when the subshell is killed without any command failing under errexit (signal / fork failure / ENOSPC) — inherently non-deterministic and not fixturable (every fetch-failure route goes through `sync_clone`'s unconditional FATAL log, which populates stderr). Consistent with the existing suite having no such fixture.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-endojs-endo-but-for-bots-empty-prereq-stderr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (635343 cached reads)
- Output: 7122 tokens
- Cost: $0.9768394999999999
- Wall-clock: 154s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
