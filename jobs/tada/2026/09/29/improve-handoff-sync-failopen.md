**Completion report: improve-handoff-sync-failopen**

The follow-up gate no longer blocks on stale board state when the producer-clone sync fails. It now logs why and passes the job. Pushed to `main2` as `d5fb51b1440`.

**What was wrong**
- `scripts/jobs/assert-followup-posted.sh` ran `sync_clone "$DIR" >/dev/null 2>&1 || true` twice: in the handoff check (the line the job named) and before the inbox and inferred-handoff checks. A sync failure was thrown away silently, so the gate read an out-of-date clone. That is how r4 was blocked even though its r5 one-time schedule had been committed about a minute earlier.
- There was a second failure path. On an outage, `sync_clone` can `exit` with the temp-fail code, or it can `die`. Called directly as a shell function, either one ended the whole gate with a non-zero code, and `gardener.sh` treats any non-zero code as a block.

**What changed**
- **New helper `sync_or_fail_open`:** it runs `sync_clone` in a subshell, so an internal `exit` or `die` is caught. Any failure logs `gate: producer clone … sync failed (rc=N: <last stderr lines>); board state may be stale; inconclusive, not blocking '<base>'` and then passes the job. The async follow-up sweep is still the backstop. Both call sites now use this helper.
- **Header docs:** the rc 0 and fail-open sections now say that a failed sync counts as inconclusive.
- **New test, case (i), in `scripts/jobs/test/followup-posted-gate-test.sh`:**
  1. Load the producer clone.
  2. Post the successor upstream.
  3. Make the remote unreachable.
  4. Check that the gate passes and logs the `sync failed` diagnostic.

**Verification**
- The full gate test suite passes.
- The new case fails against the old gate (it blocks on the stale board) and passes with the fix.
- shellcheck reports only info-level notes that were already there.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-handoff-sync-failopen.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (517550 cached reads)
- Output: 5438 tokens
- Cost: $0.63699
- Wall-clock: 383s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
