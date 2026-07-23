---
role: assayer
model: gpt-5.6-terra
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=urgent at=2026-07-23T21:13:15Z -->

---
model: gpt-5.6-terra
role: assayer
---
Independently validate the landed Mystic Kimi Code CLI implementation from mystic-harness-implement-20260723. Verify it uses the official Kimi Code CLI rather than Codex Responses and has mystic/moonshot/kimi-k3 metadata, explicit-only eligibility, zero default capacity, KIMI_CODE_HOME and session isolation, secret-safe credential handling, bounded cleanup, completion sentinel, resume/requeue, output/report capture, and provider-scoped reputation. Run focused offline regression tests and worker-spine tests. Report deploy and bounded canary evidence expectations. If any invariant fails, include orchestration-failed: true.
