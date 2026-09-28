---
role: gardener
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
handler-timeout: 14400
token-budget: 800000
---
# Verify demo 3: `git push` an artifact straight into a capability

Maintainer request (kriskowal, comment on
https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232):
"Please expand all of these into verified step-by-step instructions." This
job covers demo idea #3 from that issue's body only — read the full issue
first for the exact pitch and script sketch.

## The pitch (issue #114, demo 3)

`git remote add endo <capability-url>`, `git push`, then show the pushed
artifact live inside the Endo directory from the other side. Design:
`kriscendobot/minion.town`#41 ("the capability-addressed git remote"),
**merged 2026-08-18**.

## What to check first, carefully

A liaison-session spot-check on 2026-09-28 found no build/implementation PR
following #41's merge in either `kriscendobot/minion.town` or
`endojs/endo-but-for-bots` — meaning this may be a landed DESIGN with no
actual runnable implementation yet, over five weeks later. **Re-verify this
yourself, thoroughly** (search both repos' PR history since 2026-08-18 for
anything touching `git-remote-capability`, the M3 git trio
`daemon-git-capability`/`daemon-git-remotes`/`daemon-git-next-steps`, or a
custom git transport/remote-helper) before concluding either way — the
earlier check was a quick search, not exhaustive.

## What "verified" means here

If an implementation exists (even partial/branch-only, not yet merged): find
it, actually run the described `git remote add` / `git push` flow end to end
against a real Endo directory, and produce the exact verified steps.

If NO implementation exists yet: do not invent a hypothetical walkthrough.
Report plainly that the design landed but nothing built on it, name the
`daemon-git-*` design trio and `endor-git-bindings` as the endo-side scope
that would need to land first (per the project's own README dependency
notes), and say clearly that this demo needs a `build` job before it can be
verified or performed — do not attempt to build it yourself in this job
(scope creep); recommend it as a follow-on for the liaison to post.

## Deliverable

1. Either a precise, reproducible step-by-step runbook (if verifiable), or a
   clear, honest "not yet buildable, here's exactly what's missing" report
   (if not).
2. Post it as a REPLY COMMENT on
   https://github.com/kriscendobot/garden/issues/114 (issue-inbox routed
   work; reply on the thread per `skills/issue-inbox/SKILL.md`, do not close
   the issue). Lead with a one-line verdict (fully verified / not yet
   implemented — needs a build) before the detail.
3. Your job completion report: the same content, plus the comment URL.

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-28T14:46:08Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T14:46:36Z
