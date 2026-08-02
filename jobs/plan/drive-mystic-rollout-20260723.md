---
gate: go-ahead
priority: normal
parked_at: 2026-08-02T21:03:45Z
parked_by: liaison:endolin-garden-ece02cb4
parked_reason: maintainer directive — board cleared so the fleet runs
  ONLY the budget/cost-attribution orchestration. Restore with
  promote-plan.sh when that work concludes.
---

---
role: orchestrator
model: gpt-5.6-terra
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:00:06Z cleared=none -->

---
role: orchestrator
model: gpt-5.6-terra
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-07-24T00:44:51Z -->

model: gpt-5.6-terra
role: orchestrator
handler-timeout: 10800
Drive the Mystic (Moonshot Kimi K3 via official Kimi Code CLI) rollout to verified completion.

Own and recover the existing serial orchestration kimi-k3-harness-rollout-20260723 and its children kimi-k3-harness-implement-20260723 and kimi-k3-harness-validate-20260723. The implementation child is stranded in doin after a Claude quota failure; all Claude monk workers are intentionally disabled and must remain unable to claim jobs. Use the normal board/reaper/requeue mechanisms or create a clearly linked replacement child if recovery cannot safely reassign it. Ensure implementation work is performed by a non-Anthropic backend, preferably the Codex cleric path.

Completion means all of the following: (1) land a dedicated worker kind named mystic, provider moonshot, model kimi-k3, using the official Kimi Code CLI rather than Codex Responses; (2) preserve explicit-model-only routing, isolated per-job worktree and KIMI_CODE_HOME, secret hygiene, bounded process cleanup, output/report capture, completion sentinel, resume/requeue behavior, and reputation metadata; (3) add and pass focused offline and worker-spine regression tests; (4) independently validate the landed implementation; (5) coordinate with the leader liaison for deliberate deployment of main2 rather than editing the deployed root; (6) ensure MOONSHOT_API_KEY reaches user systemd without printing it and install the supported Kimi Code CLI; (7) enable exactly one Mystic only for a reversible tool-using canary, prove correct worker/provider/model reputation scope plus interruption/resume behavior, then return Mystic capacity to zero unless the maintainer explicitly authorizes otherwise; and (8) leave monk capacity at zero.

Do not make Kimi a default, do not enable high-stakes design/build routing, do not delete failed diagnostic evidence, and do not bypass the journal claim/completion contracts. Monitor every stage instead of merely posting follow-ups. Send concise progress only for a real blocker and send the final evidence-backed result to the maintainer inbox.

<!-- garden-reaped: 0 -->
