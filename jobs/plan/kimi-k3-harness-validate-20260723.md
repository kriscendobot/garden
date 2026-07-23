---
gate: orchestrated
orchestrated_by: kimi-k3-harness-rollout-20260723
priority: normal
role: assayer
posted_by: producer
posted_at: 2026-07-23T20:09:52Z
---

Review and validate the Kimi K3 harness implementation produced by kimi-k3-harness-implement-20260723 after it lands on main2.

Inspect the landed commit and primary Kimi Code CLI/SDK documentation. Verify the implementation preserves the garden worker invariants: explicit-model-only routing, no secret leakage, isolated KIMI_CODE_HOME and worktree, bounded process cleanup, completion sentinel, output/report capture, session resume/requeue, reputation scope, and zero default Kimi workers. Run the focused and relevant regression tests independently. Do not enable production Kimi workers or perform the live canary. Report any blocking defect with orchestration-failed: true; otherwise provide exact deploy and bounded live-canary commands/evidence expectations for the liaison, and message the maintainer that it is ready.
