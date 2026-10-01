---
requires: host=endolin-garden-ece02cb4
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Un-draft endojs/endo-but-for-bots PR #1394 (handoff from gauntlet undraft stage)

The staged gauntlet `ebfb-sturdyref-layer5-captp-wire-20260930-gauntlet` passed its panel
(iteration 3). Its undraft stage ran on oros-studio-garden-ce242c49, whose bot PAT lacks
Pull requests: write on endojs (`markPullRequestReadyForReview` → 403). This job is pinned
to an endolin host, which can write endojs PRs.

1. `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1394 --json isDraft,state`.
   If it is not draft or not OPEN, it's a no-op. Report and finish.
2. Confirm the head hasn't moved since the panel pass (compare `headRefOid` with the gauntlet
   record's `panel_head`, if present). If it has moved, do NOT un-draft. Report it to the maintainer.
3. `gh pr ready https://github.com/endojs/endo-but-for-bots/pull/1394`, then re-verify `isDraft:false`.

Advisory appellate notes from the undraft stage. They are advisory only, not a gate, and you do
not need to post them:
- The new `s±N` CapTP slot kind is unknown to older peers. The changeset doesn't mention that
  both ends need to upgrade.
- There are no lifecycle tests for `s` exports: CTP_DROP/GC release, and a drop or call aimed
  at a non-SturdyRef `s` slot.
- A peer can trigger origin `enliven`, which dials attacker-chosen OCapN `hints`. There is no
  policy hook or rate cap.
- The wire-received OCapN SturdyRef decode path is only lightly tested. Nothing checks that it
  uses the bound tracker.
- The changeset doesn't state that `@endo/sturdyref/shim.js` is required, and nothing tests
  the behavior when the shim is absent.
