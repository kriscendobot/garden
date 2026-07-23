---
gate: orchestrated
orchestrated_by: mystic-harness-recovery-20260723
priority: urgent
role: builder
posted_by: orchestrator
posted_at: 2026-07-23T20:52:45Z
---

---
model: gpt-5.6-terra
role: builder
handler-timeout: 10800
---
Replace the provisional Codex Responses Kimi implementation (commit 8f7b35468d) with the required official Kimi Code CLI harness. This is the linked recovery for stranded child kimi-k3-harness-implement-20260723, whose Claude handler failed on quota and cannot be safely reassigned while its claim is live. Work only in the isolated garden development worktree and push the corrected implementation directly to main2. Use worker kind mystic, provider moonshot, model kimi-k3. Kimi must claim only an explicit model: kimi-k3 job. Use the official supported Kimi Code CLI headless path, a per-job KIMI_CODE_HOME and persisted per-base session state, and MOONSHOT_API_KEY without logging it. Preserve worker-common worktree isolation, timeout/process cleanup, output report capture, sentinel-gated completion, resume/requeue, and provider/model/worker reputation. No default routing or high-stakes builder/design routing. Keep monk capacity disabled. Add and run focused offline tests for invocation/config isolation, missing credential, sentinel/resume, routing and worker spine. Do not enable mystic workers.
