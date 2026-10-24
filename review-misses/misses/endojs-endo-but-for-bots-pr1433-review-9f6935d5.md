---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1433-review-9f6935d5
verdict: miss
category: process
pr: 1433
cluster: design-bespoke-mechanism-over-existing-path
review_at: 2026-10-22T05:52:12Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1433#pullrequestreview-5609806255
identity: endojs/endo-but-for-bots#1433:review:5609806255:retro
producing_role: designer
producing_job: design-endo-formula-identifier-indirection
missed_by: decomplector (category f, minimum viable abstraction) — the repeated-mechanism pre-pass fired in round 3 and the seat asked is-it-needed, but compared the registry only against repository surfaces (pet store, lookupById), never against the standard ocap revocable-forwarder (caretaker) idiom; critic/skeptic likewise hardened the registry across three rounds
severity: moderate
grounds: |
  Maintainer CHANGES_REQUESTED (paraphrase): close the PR; if independently
  revocable shares are wanted, a revocable proxy wrapping the referent
  achieves that, so the daemon-side opaque reference registry, schema
  v3->v4 migration, rotation/control facets, and new locator format are
  unnecessary. This is not new direction: the goal (independent per-share
  revocation) was the design's own stated goal, and the maintainer named an
  existing primitive that subsumes the invented mechanism. That is exactly
  this cluster's pattern, and the improvement (commit 7a88d0007c2,
  2026-10-07) was in force before the PR (opened 2026-10-08) and its panels
  ran. Evidence from the board: panel rounds 1-3 (jobs
  endojs-endo-but-for-bots-pr1433-gauntlet-panel-{1,2,3}, reviews
  5463639003, 5464499439, 5473283179) were each must-fix on the registry;
  round 3 reports the repeated-mechanism signal forced the decomplector's
  is-it-needed question, and the decomplector's must-fix #1 asked to
  justify the registry "against the existing pet-store and lookupById
  path" and noted the single new need is per-share revocation. No seat in
  any round mentioned a caretaker, revocable forwarder, or proxy-wrapping
  alternative. The design itself names a forwarding proxy only for live
  presences and defers it to non-goals, so the designer's
  name-the-existing-path prevention line (which enumerates repository paths
  such as bootstrap lookup and attenuators) did not prompt the canonical
  ocap revocation pattern. The gauntlet halted at panel-4
  (requeue-exhausted) and the maintainer closed the PR. Sensing fired but
  its lens is scoped to repository surfaces; prevention and sensing both
  omit well-known ocap composition idioms (caretaker/revocable forwarder,
  membrane) as candidate existing paths.
---
Design PR #1433 proposed a daemon-owned per-share opaque reference registry
to make formula shares independently revocable. The maintainer closed it,
noting a revocable proxy for the referent already gives independent
revocation. Three design-panel rounds hardened the registry; the round-3
decomplector is-it-needed question compared it only with the pet store and
lookupById, never with the caretaker idiom. Recurrence of the closed
cluster after its 2026-10-07 improvement.
