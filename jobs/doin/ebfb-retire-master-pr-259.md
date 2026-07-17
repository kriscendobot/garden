---
role: weaver
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T11:58:06Z -->

Retire the master base for https://github.com/endojs/endo-but-for-bots/pull/259 under the 2026-07-16 maintainer directive. Confirm the PR remains open and targets master. Obtain the base SHA from upstream endojs/endo master, never from the fork master. Reuse or create the fork reflection master-<sha7>, rebase the PR head onto that upstream commit, push with --force-with-lease, and set the PR base to the reflection. Follow skills/frozen-base-branch/SKILL.md. If the PR is a long-idle or stale mirror, do not wedge this sweep: record the condition in the completion report for maintainer follow-up. If there is a conflict beyond a focused weave, report it rather than changing the fork master. The maintainer directive authorizes the rebase, force-with-lease push, and base edit for this PR.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 17
  worker_kind: gardener
  claimed_at: 2026-07-17T11:58:09Z
