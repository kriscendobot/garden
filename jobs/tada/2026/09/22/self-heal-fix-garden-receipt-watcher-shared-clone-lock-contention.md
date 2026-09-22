The requested fix is already present on `main2` — no work remained.

## Completion report

**Finding:** The job describes the receipt-watcher's shared-clone lock contention as if `GARDEN_RECEIPT_WATCH_CLONE` still defaults to the un-slugged `$GARDEN_STATE/receipt-watcher/journal`. In fact the exact fix it prescribes was already landed on `main2`:

- **`scripts/jobs/receipt-watcher.sh:59`** already defaults to the per-slug clone: `: "${GARDEN_RECEIPT_WATCH_CLONE:=$GARDEN_STATE/receipt-watcher/journal-$slug}"`, with an extended comment block (lines 45–58) explaining precisely the contention rationale the job cites (16-way fan-out, one shared `clone_lock`, per-slug clone gives each instance its own `$DIR.lock` sibling). Landed by commit **`05c22e5c0e` "fix(receipt-watcher): per-slug journal clone to end shared-clone contention"**, an ancestor of current HEAD `3002969de5`.
- **`scripts/jobs/test/receipt-watcher-test.sh`** was updated in the same spirit: it adds a `run_watch_default` helper that leaves `GARDEN_RECEIPT_WATCH_CLONE` unset and a dedicated assertion — *"default receipt clone is per-slug (distinct journal-`<slug>` dirs per instance)"* (lines 105–109, 222–233). The remaining hardcoded `WATCH_CLONE="$STATE/receipt-watcher/journal"` (line 50) is the deliberate explicit-pin path for other tests, which the override contract permits.

**Verification:** Ran the full test suite — **11 passed, 0 failed**, including the per-slug default test.

**Changes made:** None. The deliverable already exists on `main2`; there was nothing to commit or push. This was a stale/already-resolved self-heal job (posted against an earlier snapshot of the file before `05c22e5c0e` landed).

**Follow-ups:** None. If FATAL restart-loops persist in `journalctl --user -u "garden-receipt-watcher@*"`, they would be a *different* cause than the shared-clone contention this job named (that root cause is fixed); worth a fresh diagnosis rather than reopening this one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-shared-clone-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (277251 cached reads)
- Output: 2420 tokens
- Cost: $0.6444315
- Wall-clock: 49s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
