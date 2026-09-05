Implemented and pushed commit `61e8666741` to `main2`.

- Live sweep now skips failed `stat` calls and transcripts that vanish before staging, preventing tick aborts and ledger corruption.
- Added a deterministic two-session regression scenario confirming exit 0, survivor archival, correct indexing, and warning output.
- Tests: transcript capture suite passed 24/24; production shellcheck and all-script syntax checks passed.
- Repository-wide checks had one unrelated existing failure involving `roles/groom/AGENT.md`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-transcript-capture-live-sweep-vanished-jsonl.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 176s

<!-- garden-usage-end -->
