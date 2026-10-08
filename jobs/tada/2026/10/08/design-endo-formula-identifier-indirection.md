Completed the formula-identifier indirection design.

- Opened draft PR: https://github.com/endojs/endo-but-for-bots/pull/1433
- Specified daemon-owned, per-share opaque references; atomic rotation/revocation; fail-closed old locators; live-session behavior; schema v3→v4 migration; GC; threat model; alternatives; staged rollout; and ownership map.
- Verified and bounded the ocap-kernel analogy; kept vat/slot ideas explicitly speculative.
- Updated the design index and roadmap.
- Mermaid validation, formatting, docs, lint, pre-push probes, and PR CI passed.
- Sent the maintainer the PR link and first-read guidance.
- Follow-up: implement the daemon registry and migration, then adopt it for minion.town clip-link rotation.
- Self-improvement: auditing every identifier boundary exposed the inspector as a potential diagnostic leak, so the design now uses ephemeral inspection handles.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-formula-identifier-indirection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 2046s

<!-- garden-usage-end -->
