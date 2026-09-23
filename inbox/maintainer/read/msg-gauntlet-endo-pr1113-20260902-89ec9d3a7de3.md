from_host: oros-studio-garden-ce242c49
from: gardener:gauntlet-endo-pr1113-20260902
reply_to: gauntlet-endo-pr1113-20260902
msg_key: msg-gauntlet-endo-pr1113-20260902-89ec9d3a7de3
notice_count: 1
first_seen: 2026-09-17T00:00:12Z
last_seen: 2026-09-17T00:00:22Z
sent_at: 2026-09-17T00:00:22Z
---
Policy refusal: gauntlet job on IronHorse PR endojs/endo-but-for-bots#1113 blocked by the active IronHorse pause.

I claimed `gauntlet-endo-pr1113-20260902` (run the gauntlet on
https://github.com/endojs/endo-but-for-bots/pull/1113, the IronHorse test262
compliance ratchet: three engine fix waves plus the refresh-20260901
ratchet-floor snapshot). I am NOT running it, because it is IronHorse work
under the standing pause.

Why refused:
- The IronHorse pause (kumavis, 2026-09-09, garden kriscendobot/garden#91) is
  still in force on today's `main2` (roles/COMMON.md line 107): the garden does
  not "run IronHorse ... review, test262 ... work" or "advance an IronHorse pull
  request" until a trusted maintainer explicitly lifts the pause. PR
  endojs/endo-but-for-bots#1113 is squarely IronHorse test262/engine work.
- This job was re-promoted from a doomed plan entry on 2026-09-16 via a generic
  `gate=go-ahead cleared=none`, with NO IronHorse-exception annotation. Prior
  pause exceptions (endojs/endo-but-for-bots#1257,
  endojs/endo-but-for-bots#1262) each carried an explicit kumavis authorization
  on a distinctively named board base (e.g.
  `pr1257-review-after-pause-20260911`, "one-review exception"). This job has
  none, so per the directive ("a new IronHorse request that does not explicitly
  lift it stays parked") it stays parked.
- Independently: the garden has no gauntlet/panel jurisdiction over the
  IronHorse Rust-engine arc. Prosecutor retros on
  endojs/endo-but-for-bots#1059 (2026-09-16) found the garden's role there is
  fixer, not gauntlet-reviewer, and no juror seat covers the ironhorse Rust
  internals. A code panel on a test262/engine PR would not be a meaningful
  review.

Disposition: completing my claim as a policy refusal (deliverable NOT run). The
intent is preserved by the issue-51 spine and the existing plan entry
`jobs/plan/gauntlet-endo-pr1113-20260902.md`. If you want this gauntlet to run,
please explicitly lift the IronHorse pause (or annotate a per-PR exception like
the endojs/endo-but-for-bots#1257 / endojs/endo-but-for-bots#1262 pattern) and
re-post it; I did not post a successor, since that would itself advance paused
IronHorse work.
