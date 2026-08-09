Completed the 2026-08-09 Dependabotany backstop sweep.

- Recovered and reconciled all eight open ledger rows.
- PR #923 remains EMBARGO-2026-08-10 until 2026-08-10T20:37:45.880Z. Its head is unchanged, 24/24 CI checks pass, but it is conflicting and would partially revert two `@earendil-works/pi-*` sites.
- Documented four residual DOMPurify advisories and their source-level unreachability through Monaco’s consumed configuration.
- Ran seven MERGE-NOW rows through `ci-wait-merge.sh`; all were green but correctly blocked for lack of current maintainer approval. No merge or auto-merge occurred.
- Recorded the full findings in journal entry `entries/2026/08/09/162730Z-message-botanist-246caf.md`.
- Confirmed the PR #923 one-shot remains scheduled for 2026-08-10T21:15:00Z and the daily backstop remains active.
- Self-improvement: nothing this time.

Follow-up: rebase or regenerate PR #923 at maturity, re-enumerate its lockfile, and reassess the DOMPurify pin before issuing a terminal verdict.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260809-162001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 449s

<!-- garden-usage-end -->
