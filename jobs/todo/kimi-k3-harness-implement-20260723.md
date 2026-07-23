---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-23T20:10:04Z -->

Implement the approved Kimi K3 harness in the garden repository using the official Kimi Code CLI, based on completed research job research-kimi-k3-harness-20260723.

Work in an isolated garden development worktree; never edit the deployed root. Follow the garden convention of committing and pushing directly to main2 with the bot identity, with no PR. Add a dedicated Kimi Code handler integrated through the existing worker-kind spine. Preserve explicit model: kimi-k3-only claiming, isolated per-job worktrees, per-job KIMI_CODE_HOME/session state, timeout and process cleanup, output capture, completion sentinel, resume/requeue semantics, and reputation metadata. Ensure MOONSHOT_API_KEY reaches the worker without logging it. Do not make Kimi a default and do not leave the Kimi pool enabled.

Use current primary Moonshot/Kimi Code documentation. Add focused offline tests for provider selection, CLI invocation/config isolation, completion gating, resume behavior, missing credential diagnostics, and unit/scaler integration. Run relevant existing worker-spine and routing tests. Record exact verification and the pushed main2 commit in the completion report, and message the maintainer when deployment-ready.
