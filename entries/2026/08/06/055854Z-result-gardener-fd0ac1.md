---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-06T05:58:56Z
---
---
kind: result
role: designer
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/938
---

Design plan for integrating `@endo/reminder` into Familiar, per the
[endojs/endo-but-for-bots#721 review](https://github.com/endojs/endo-but-for-bots/pull/721#pullrequestreview-4701251219)
follow-up request (kriskowal, 2026-07-15). Slug `endo-reminder-familiar-integration`;
draft PR https://github.com/endojs/endo-but-for-bots/pull/938 against `llm`.

Findings: PR #721 is MERGED (2026-07-30) and APPROVED, so the API is final and the
integration is not gated on the plugin changing shape (correcting the job spec's
stale "open, CHANGES_REQUESTED" premise). Familiar is a thin Electron supervisor
with no capability code of its own; the integration lives in the bundled daemon +
packages/lal. The one missing seam is a durable recipient-adapter exo with
`notify(message)` (LAL has no inbound notify facet; the agent wakes only via
`followMessages()`). The reminder/store/setup.js-provisioning/scheduler-tool
substrate is shared with the in-flight Chat and minion.town integration plans and
should be built once; coordination note sent to the Chat peer. Familiar is framed
as the Phase-3 "one worked integration demonstrating restart-survival".

Self-improvement: nothing this time.
