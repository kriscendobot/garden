---
gate: orchestrated
orchestrated_by: orch-jev-triage-foreman
priority: normal
posted_by: producer
posted_at: 2026-10-08T04:09:46Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Integrate Jev into triage and foreman, only if the trial passed

Read the trial report from job `trial-jev-triage-foreman-classification` in `jobs/tada/`.

- If its first-line `verdict:` is **not `pass`**, integrate NOTHING. Complete with a short
  report saying the trial verdict and why, and (for `fail`) what the numbers suggest trying
  next. Do not lower a pass criterion after the fact.
- If `verdict: pass`, integrate exactly the design's recommended first stage (normally
  shadow or advisory, not gating) into the triager and/or foreman: the deterministic policy
  stays authoritative, any Jev failure, low confidence, or missing credential falls back to
  today's behavior, a per-day spend cap is enforced, and every decision is logged for
  audit. Put the periodic template-proposer on a schedule (`skills/schedule/SKILL.md`),
  leader-only where it would double-post. Ship behind a switch that is OFF unless the
  credential and the maintainer's egress authorization for that surface both exist.
  Add tests, update `roles/triager/AGENT.md`, `roles/foreman/AGENT.md`, and the operator doc.
- Never widen the data sent beyond what the design records as authorized. A stage that
  needs new egress authorization (third-party comments) ships inert and posts one question
  to the maintainer inbox.

Land on `main2` directly. Post a journal message summarizing what is live, what is inert
and waiting on the maintainer, and how to turn each stage off.
