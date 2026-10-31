Implemented Phase 4 and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1592, stacked on a frozen snapshot of PR #1590.

- Snapshots live mounts before resolution and couples snapshot/CAS lifetime to the caplet.
- Added mutation-isolation and lifetime-release tests, design updates, types/docs, and a changeset.
- Verification: regression reproduced before the fix; all 13 focused tests, daemon type lint, pre-push gates, and non-test local verification passed.
- Follow-up: full CI and garden gauntlet review.
- Self-improvement: reported missing library coverage for mount-import snapshot semantics to the scholar queue.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-worker-import-from-mount-phase-four-snapshot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5230s

<!-- garden-usage-end -->
