---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1357-review-b33b9342
verdict: miss
category: spec-violation
pr: 1357
cluster: related-design-contract-cross-check
review_at: 2026-09-29T05:28:37Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1357#pullrequestreview-5348050214
identity: endojs/endo-but-for-bots#1357:review:5348050214
producing_role: designer
producing_job: backfill-endo-claude-design-from-minion-town-production
missed_by: designer library-lookup prior-art step (producing); no design panel ran (draft, manual-gauntlet regime) so integrator/archivist related-design cross-check never fired
severity: minor
grounds: |
  Paraphrase (verbatim at comment_url; untrusted). A CHANGES_REQUESTED review
  answering the draft design's four open questions: (Q1) use the bot's
  subscription for the deployed root user; (Q2) multiple subscriptions and
  guest bring-your-own credentials are required, assess whether the OS slice is
  optional, and make sure the design accounts for the existing secret-store
  work; (Q3) keep inference provider-neutral, never let "Claude" mean Codex;
  (Q4) produce real evidence, e.g. via a speculative build and deploy.

  Q1, Q3 and Q4 are maintainer decisions answering the design's own open
  questions (new direction, not a miss). The one miss is inside Q2: the design
  is about delivering model credentials to a confined process, yet at head
  e235274b7 it never mentioned designs/daemon-secret-manager.md, which was
  already on the PR's base (llm-47f6965) and governs exactly that credential
  storage and delivery. The designer role's standing library-lookup rule
  ("reference rather than reinvent prior art") did not bind, and the
  maintainer had to point at the related design. This is the same shape as the
  pr1072 member: a draft design not cross-checked against a landed related
  design (there it contradicted; here it omitted). Minor: caught on a draft
  before any gauntlet; resolved in revision 7a6d4259c, which now cites
  daemon-secret-manager. Q4 echoes the precursor dismissal
  (endojs-endo-but-for-bots-pr1357-593395b4, "settled on documentation only"),
  but a request for a speculative build is new work, still no panel was due, so
  it is not counted.
---

# Miss: draft inference-backends design omitted the landed secret-manager design

See grounds. Deliverable verified in the world: #1357 revision 7a6d4259c and
draft probe PR #1369 exist.
