---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T03:10:18Z
---
# SturdyRef press tick (2026-07-17T03:05 dispatch, job endo-sturdyref-press-20260717-030502)

**Headline: HOLDING with a liveness probe armed — the endojs/endo-but-for-bots#737
review-response peer is 2.5h into its claim with ZERO externally visible output on
any channel; I pinged its inbox instead of taking the wheel, and set a decidable
stall criterion for the next tick.**

## State verified this tick (gh REST, 03:05–03:12Z)

- **endojs/endo-but-for-bots#737**: OPEN/DRAFT, head still `ce7341b47d` (16:31Z),
  reviewDecision CHANGES_REQUESTED (kriskowal review 4718500574 at 00:42Z). Full
  inline-comment substance read this tick (untrusted data, summarized): (1)
  SturdyRefs must be opaque objects via `makeSturdyRef` from pass-style, with a
  pass-style test that `passStyleOf` throws on extra own props / wrong proto;
  (2) the utility moves to `@endo/pass-style/sturdy-ref`; (3) the
  sturdyref→locator-record WeakMap must be retained GLOBALLY, and the maintainer
  explicitly asked to **post a job to build a first-wins shim** installing
  `SturdyRef` / `SturdyRef.fromLocation` / `SturdyRef.toLocation` to global
  scope — no SES permits, never passed to child compartments, hardened via
  `@endo/harden` post-lockdown; ponyfill may import the shim so eval twins of
  ocapn/captp transport sturdyrefs; SturdyRef namespace AND each CapTP
  instance's enlivener stay closely held (the design endojs/endo-but-for-bots#539
  no-location/no-identification shape).
- **Peer** `endojs-endo-but-for-bots-pr737-review-3363fee9` (gardener-10,
  endolin-garden-ece02cb4, claimed 00:43:28Z): claim live in `jobs/doin/`, but
  **no output on any channel in 2.5h** — no push to the PR head, no review-thread
  replies, no shim job on the board (todo/plan grepped), no productive-cycle
  hints (the migrate jobs on the SAME host emit them regularly), no journal
  entries, no bus messages. Ambiguous: could be a long local build/test loop
  before first commit; the reaper has NOT reaped it.
- **Liveness probe armed**: I sent inbox message `20260717T030939Z-704afb` to the
  peer. A live peer drains its inbox at checkpoints, so the message moving
  unread/→read/ is a decidable liveness signal.
- **Stale press claim**: `endo-sturdyref-press-20260717-003509` (claimed
  00:35:18Z, gardener-16, endolin-garden-ece02cb4) still sits in `jobs/doin/`
  despite the 00:35:51Z rc=1 handler-start failure (error entry
  003549Z-error-gardener-17d1ad). Almost certainly an orphaned claim awaiting the
  reaper; it produced nothing in 2.5h. Not mine to reap.
- **endojs/endo-but-for-bots#695 / #697** design PRs: unchanged, CHANGES_REQUESTED
  since 07-15, awaiting kriskowal re-review (maintainer-gated).
- **#698/#700/#541/#511/#539**: OPEN/DRAFT, heads untouched since 07-11, still
  gated on the restack/collapse answer (unanswered; per last tick's guidance,
  re-pose only after the shim-first architecture lands).

## Decision & next-tick criterion (the point of this entry)

No push, no job posted this tick — the sole unblocked artifact (the #737 review
response incl. the shim job) is peer-owned and the claim is live. **Stall
criterion for the next tick (≥04:05Z, ≥3.6h after the peer's claim): if the
ping `20260717T030939Z-704afb` is still in the peer's `unread/`, AND there is
still zero output on every channel above, AND the claim persists — declare the
lane stalled.** Then: (1) post the maintainer-requested first-wins-shim build
job with deterministic base `ebfb-737-first-wins-sturdyref-shim` (CAS-collides
harmlessly if the peer wakes and posts the same); (2) message the peer + the
maintainer noting the partial takeover (shim job only — leave the review-thread
replies and the pass-style-move commits to the peer or its requeue); (3) do NOT
push to `build/sturdyref-pass-style-ocapn-single` while the peer claim lives.

## Confinement statement

No behavior changed this tick, so no confinement surface moved. Standing
invariants as last verified on green `ce7341b47d`: swiss-num never a property on
a SturdyRef instance; raw locator only in the closely-held session map
(no-location). The review's demanded shape (closely-held SturdyRef namespace,
globally-retained WeakMap to locator records, closely-held per-CapTP enliveners)
strengthens no-location/no-identification; token unlinkability remains
unverified — the endojs/endo-but-for-bots#695-gated provide/accept surface is
unbuilt.
