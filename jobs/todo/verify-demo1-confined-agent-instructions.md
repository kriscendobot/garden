---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 14400
token-budget: 800000
---
# Verify demo 1: a confined AI agent that literally cannot escape its box

Maintainer request (kriskowal, comment on
https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232):
"Please expand all of these into verified step-by-step instructions." This
job covers demo idea #1 from that issue's body only — read the full issue
first for the exact pitch and script sketch.

## The pitch (issue #114, demo 1)

A `claude -p` session running INSIDE an Endo guest as its whole tool surface
(`endo-claude`), asked on camera to do something outside its granted
capabilities (read a file it wasn't given, reach a network host it wasn't
granted) — show the refusal, then show the same agent doing real useful work
within its actual grant. Depends on `endojs/endo-but-for-bots`#1015
(feat(claude): add @endo/claude confinement core) and #1102 (design: endow a
new agent with indelible special names on provisioning) — both currently
**draft, unmerged** (verify this is still current; it may have changed since
this job was posted).

## What "verified" means here

Do not write a plausible-sounding script from reading the PR descriptions.
Actually stand up the capability (check out the #1015 branch, or find
whatever the current furthest-along implementation is if #1015 has been
superseded) and RUN the demo script yourself, end to end, in a scratch
worktree — every command, every expected output. If a step doesn't work as
described, that is a finding, not something to paper over: report exactly
what broke and what the real current behavior is.

If the underlying capability genuinely cannot be exercised yet (both PRs are
draft and something essential is missing, not just unreviewed), say so
plainly rather than inventing a hypothetical walkthrough, and name exactly
what's missing.

## Deliverable

1. A precise, reproducible step-by-step runbook (exact commands, exact
   expected output/behavior at each step) for whatever you could actually
   verify — production-ready or dev/bench-only, be explicit which.
2. Post it as a REPLY COMMENT on
   https://github.com/kriscendobot/garden/issues/114 (this is issue-inbox
   routed work — replying on the thread is the sanctioned, expected action
   per `skills/issue-inbox/SKILL.md`; do not close the issue). Lead with a
   one-line verdict (fully verified / partially verified / not yet
   verifiable, and why) before the runbook.
3. Your job completion report: the same content, plus the comment URL.
