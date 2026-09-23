Fixed PR #1018 and pushed commit `7b9e4e1ad8e79ff5e05db8d8220778ff2c4ea59e`.

Clarified the Ironhorse/Slot Machine boundary: Ironhorse owns panic/abort classification and engine snapshots; Slot Machine owns durable snapshots, transcripts, message embargo, commit/discard, restore, and replay. Renamed successful execution to `Quiesced` to avoid implying an Ironhorse-level durable commit, and updated diagrams, tables, milestones, and recovery flow.

Verified formatting, pre-push probes, Mermaid diagrams, and all five current-head GitHub checks: build, lint, test, browser-tests, and zizmor. Full local lint remains affected by pre-existing base-branch ESLint errors.

Posted the SHA-anchored completion summary: https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5495695653 and re-requested review from `kriskowal`. Working tree is clean; no further implementation follow-up identified.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-fix-20260901-132013.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 6134s

<!-- garden-usage-end -->
