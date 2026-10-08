---
gate: orchestrated
orchestrated_by: orch-jev-triage-foreman
priority: normal
posted_by: producer
posted_at: 2026-10-08T04:09:21Z
---

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: Jev in the triage and foreman workflows, with an amortized prompt template

Maintainer directive (2026-10-08): investigate options for integrating Jev (TypeSafe's
non-agentic structured-decision classifier) in the **triage** and **foreman** workflows,
for (a) **reactions to maintainer feedback** and (b) **job classification**. The
maintainer expects this to need an agent that **proposes a reusable Jev prompt template
periodically** and then applies it to classify **numerous inputs**, so the cost of
generating the template is amortized over many cheap classifications.

Read first, do not re-derive: `designs/typesafe-jev-classification.md` (accepted: Jev is a
primitive called by deterministic code, never a worker kind or tier), `skills/typesafe-ai/SKILL.md`,
`designs/jev-trusted-sender-quoted-text.md`, `skills/foreign-content-preclassification/SKILL.md`,
`scripts/jobs/{muster-pilot,classify-foreign-content}.sh`, `roles/triager/AGENT.md`,
`roles/foreman/AGENT.md`, `scripts/jobs/{comment-watcher,foreman}.sh`.

## What the design must settle

1. **Decision points.** Enumerate where a typed classification would replace or back up
   today's behavior, and rank by fit and value: the comment-watcher's no-deterministic-match
   residual, reaction/acknowledgment choice to maintainer feedback, job-kind and role
   classification when a job is posted or promoted, foreman promotion ordering. Keep the
   deterministic verb table and every existing policy authoritative: Jev proposes a label
   plus confidence, code decides, and low confidence or any failure preserves today's path.
2. **The amortization loop.** Specify the periodic template-proposer: its inputs (a sample
   of recent real inputs and their eventual ground-truth dispositions), what it emits (the
   question set, answer sets, and prompt text, versioned and content-addressed), how often
   it runs, its cost against the classifications it serves, and how a new template is
   evaluated against the incumbent before it replaces it (shadow run, agreement, regret).
   Show the break-even arithmetic with real volumes from the journal.
3. **Ground truth.** What counts as the correct label for each decision point, derived from
   what actually happened (the verb a maintainer's comment eventually produced, the role a
   job was actually run as, how the maintainer disposed of an inbox item). Say how it is
   extracted from the journal without new instrumentation if possible.
4. **Data egress and trust.** Every classification sends text to an external service. The
   existing maintainer authorization covers the opt-in Muster pilot and foreign-content
   pre-classification only; it does NOT cover autonomous watchers or PR-comment monitoring.
   State per decision point exactly what text leaves the host, from which senders, and whether
   it is already covered. Maintainer-authored text and the maintainer inbox are the likely
   first surface; third-party comment text needs a fresh, explicit authorization, which the
   design lists as an open question rather than assuming. Never route text from an
   unauthorized sender.
5. **Failure and cost.** Fail-open to today's behavior, per-day spend cap, credential
   absence (`TYPESAFE_API_KEY` is maintainer-provisioned; never acquire it from a job),
   injection posture (bounded answer set; a hostile input can still pick a wrong label
   within the set, so the design bounds the blast radius of a wrong label).
6. **Options and a recommendation.** At least three real options (for example: advisory
   annotation only; classification gating with a confidence threshold; full
   template-proposer loop), each with trade-offs, and one recommendation with a staged
   rollout (shadow, advisory, gating).
7. **Trial plan.** The exact offline replay the next job will run on real journal data,
   with the pass criteria stated as numbers (agreement with ground truth, false-act rate,
   cost per decision, break-even point). The next job must be able to execute it as written.

Include mermaid flows (no ASCII art) and an `## Ownership map`.

## Landing and notification

This is a design on the garden's own repo with a non-empty `## Open questions` section
(the egress question alone qualifies), so use the carve-out in CLAUDE.md § Conventions:
snapshot the commit before the design as the frozen base, put the design commit on a head
branch, open a PR on `kriscendobot/garden` marked `<!-- garden-design-open-questions -->`
(so no design panel is staged for it). Then **send the PR link to the maintainer inbox**
(a `message` entry/inbox post per `roles/COMMON.md`), with one sentence on what to look at
first. Do not wait for the maintainer's answer to finish: the orchestration proceeds to the
trial, which uses only already-authorized data classes.
