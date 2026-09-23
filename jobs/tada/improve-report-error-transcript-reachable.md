Landed on `main2` as `fdac5502e2`.

**Report**

**Fix.** `skills/gardener-inbox-error-reporting/report-error.sh` now commits the transcript itself as `inboxes/$GARDEN/captures/<sha>` and stages it in the same commit as `gardener.md`, so the blob is in the pushed `journal2` tree and every off-host responder resolves the SHA after a plain fetch. The path *is* the SHA, so the write is idempotent and deduped across repeat escalations. The `Inspect via git cat-file -p <sha>` line is kept (now true) and a `- Capture: <path>` bullet was added next to it.

**Bounded, because journal2 is not the archive.** `designs/transcript-journal-capture.md` Decision 1 deliberately keeps transcripts *off* `journal2` (fleet-wide fetch cost); committed captures are a new, permanent cost that loose blobs did not have. So the helper truncates to the last `GARDEN_REPORT_ERROR_MAX_BYTES` (default 65536, `0` disables) **before** hashing — never after, or the SHA would again name bytes nobody can read. 64 KiB is exactly the slice `mentor.sh` and the gardener classifiers consume (`tail -c 65536`), so the cap costs a responder nothing; at the fleet's observed rate (888 sections across six hosts since 06-25, ~24/day) that is ~1.5 MiB/day worst case. I recorded this as an explicit bounded exception in the design doc rather than letting it silently contradict the decision.

**anchor_blob demoted, not dropped.** In `gardener.sh` the `refs/captures/<suffix>` push now fires only on the fallback path (when the inbox escalation failed outright), since `refs/captures/*` is outside the default refspec and an ordinary fetch never retrieved it.

**Root cause in the docs, corrected.** Three places asserted the wrong model — "write the SHA into a committed file and the push carries the blob with it" — in `scripts/jobs/common.sh` (the failure-capture header), `skills/prompt-on-failure-capture/SKILL.md`, and `skills/self-healing-wrapper/SKILL.md`. All now state that naming a SHA does not make it reachable; committing the content does. `SKILL.md` for this skill was rewritten (new step 2b, State, Notes on the cap and on capture accumulation).

**Verification (all run, output observed).**
- New `scripts/jobs/test/report-error-reachable-test.sh` — hermetic: a bare repo as `origin/journal2`, one clone as the failing host, a **second independent clone as the off-host mentor**. 9/9 pass: off-host resolution, section+capture in one commit, dedup, empty-transcript defense still reachable, truncation-before-hashing, caller's file unmutated.
- Regression proof: swapping the pre-fix script back in, the same test drops to **2 passed, 7 failed** (mentor gets `<unresolved>`).
- No regression in existing suites: `elapsed-constancy-classifier-test.sh` 35/35, `claude-session-limit-classifier-test.sh` 29/29, `signal-kill-classifier-test.sh` 17/17, `tests/checks/run.sh` 7 suites, `scripts/checks/run-all.sh` 5 gates, `library-link-check.sh --changed` OK.
- `shellcheck -S warning` clean on both the helper and the new test; the test added to CI's shellcheck list in `.github/workflows/checks.yml`.

**Follow-ups (not done, deliberately).**
1. The two transcripts named in the job spec (`7f51e38a…`, `b082d8fb…`) stay unrecoverable — those loose blobs live only in the originating gardener's clone and I found no matching loose object under `.garden-state`; only escalations from here on are reachable. No backfill is possible without a git read in the deployed root, which the job forbids.
2. No pruner exists for `inboxes/<host>/captures/`. Deleting old capture files is safe (history keeps the bytes) and shrinks the working tree; worth writing if the accumulation rate rises.
3. This lands on `main2` only — it reaches hosts on the next deliberate `deploy-garden.sh`, so escalations keep arriving un-inspectable until then.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-report-error-transcript-reachable.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 117 tokens (6063920 cached reads)
- Output: 41768 tokens
- Cost: $5.334950999999999
- Wall-clock: 732s

<!-- garden-usage-end -->
