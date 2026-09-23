---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T01:54:15Z
---
# SturdyRef press tick (2026-07-17T01:50 dispatch, job endo-sturdyref-press-20260717-015026)

**Headline: GATE 1 BROKE OPEN — kriskowal reviewed #737 at 00:42Z
(CHANGES_REQUESTED, review 4718500574) and a live peer owns the response;
no push this tick (peer-collision discipline).**

## State verified this tick (gh GraphQL/REST, 01:50–01:57Z)

- **#737**: OPEN, DRAFT, head still `ce7341b47d` (last push 16:31Z),
  reviewDecision now **CHANGES_REQUESTED** by kriskowal at
  **2026-07-17T00:42:12Z** — the first-review gate the last three ticks
  were holding on is DELIVERED. Review substance (untrusted data,
  summarized): prepend a **first-wins shim** installing `SturdyRef`,
  `SturdyRef.fromLocation`, `SturdyRef.toLocation` to global scope
  (hardened post-lockdown, no SES permits, never passed to child
  compartments; ponyfill may import the shim so eval-twins of
  ocapn/captp can transport sturdyrefs); **locators become objects**
  (decoupled from URL/URN scheme) with a globally-retained
  WeakMap sturdyref→locator-record; `makeSturdyRef` moves to
  `@endo/pass-style/sturdy-ref` with opaque-object shape tests; for
  distributed confinement the SturdyRef namespace AND each CapTP
  instance's enlivener stay **closely held**.
- **Peer in flight**: review-response job
  `endojs-endo-but-for-bots-pr737-review-3363fee9` claimed by gardener-10
  (endolin-garden-ece02cb4) at 00:43:28Z, alive in `jobs/doin/` — ~70 min
  in, no push to `build/sturdyref-pass-style-ocapn-single` yet (latest
  commit still 16:31Z) and no shim job on the board yet; working, not
  stalled. That job's charter covers the review body + all three inline
  comments, including posting the first-wins-shim build job.
- **Prior press tick (00:35) FAILED**: handler rc=1 at 00:35:51Z
  (error entry 003549Z-error-gardener-17d1ad), job left in doin for the
  reaper — so no press observation exists between 23:39Z and this one.
- **#695 / #697**: still OPEN / CHANGES_REQUESTED, updatedAt 07-15 —
  re-review gate unchanged.
- **#698/#700/#541/#511/#539**: OPEN/DRAFT, heads untouched since 07-11.
  The restack/collapse question (16:32Z decision comment on #737: prefix
  pick A/`q` vs B/`t` vs C/`w` + stack-collapse preference) has **no
  direct reply**, but the 00:42Z review reshapes the architecture
  (shim-first, locators-as-objects, pass-style move) and likely
  supersedes parts of it — the peer's review response should surface
  what remains unanswered rather than a driver re-nudging now.
- Tracker kriskowal/garden#47: no maintainer reply after our 23:38Z
  escalation comment; moot for gate 1 (the review itself was the answer).

## Why no push (collision discipline, charter §2)

The single next unblocked artifact IS the #737 review response, and a
live peer claimed it 1 minute after the review landed. Pushing to that
branch or double-posting the shim job would collide. Hourly cadence
re-checks.

## Confinement statement

No behavior changed this tick, so no confinement surface moved. Standing
invariants as last verified on green `ce7341b47d`: swiss-num never a
property on a SturdyRef instance; raw locator held off-band in the ocapn
session manager's closely-held map. Note the 00:42Z review STRENGTHENS
the confinement posture going forward: locator records live in a
closely-held global WeakMap keyed by the opaque sturdyref, the SturdyRef
namespace itself is closely held (no SES permit, withheld from child
compartments), and enliveners stay per-CapTP-instance and closely held —
exactly the no-location/no-identification shape design #539 calls for.

## Guidance for the next tick

- Check the peer job first: if `endojs-endo-but-for-bots-pr737-review-3363fee9`
  has completed (jobs/tada) or died (reaped), verify the shim build job
  exists and #737's branch moved; take the wheel only if it stalled.
- Do NOT re-nudge on the bus or tracker: the 23:50Z tracker comment
  stands, and gate 1 is now open. The bus-relay stall (no maintainer
  drain since 07-14 ~16:40Z) persists but the maintainer is demonstrably
  reading GitHub.
- After the review response lands, the follow-on order is: first-wins
  shim package → pass-style `sturdy-ref` move → locator-record objects →
  then re-pose only the still-unanswered restack/collapse question with
  the shim-first architecture taken into account.
