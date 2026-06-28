# Continue ymax0 v320 XS investigation — synthetic XS depth harness (export-free)

Maintainer directive on kriskowal/garden#9 (kriskowal, 2026-06-28): "continue
this investigation. Agoric SDK is equally germane to the garden as Endo."
Scope was widened the same day: experimentation on agoric/agoric-sdk IS allowed
**via the `kriscendobot/agoric-sdk` fork**; you must NOT link issues/PRs to, or
comment on, upstream `Agoric/agoric-sdk`.

## Already established on the issue thread (do not redo)
- `@agoric/internal/src/hex.js` is byte-identical across beta2..beta3 and last
  changed 3856 commits before beta2 — RED HERRING for the regression; its
  `flatMap`/`new Map` build is O(1) native stack depth (single-arg, not a spread).
- The real XS overflow mechanism is deep `passStyleOf`/`checkMatches` copyRecord
  recursion during bundle import/unserialize (~3 frames/level; XS budget ~350
  frames → passStyleOf ~115 levels, checkMatches ~15 levels; V8 ~15-30x deeper).
- Real-bundle import repro is BLOCKED: `bundle-ymax0.json` was wiped by a redeploy
  and is chain territory; the v320 swing-store export is also out of band.

## Task: run methodology step-6 synthetic fallback (export-free, decisive on thresholds)
Build an N-level `{value, tail}` `LogEntry`-shaped payload (e.g.
`['doFulfill', vowShape, deepChain]`), run `passStyleOf`, marshal `unserialize`,
and `mustMatch`/`checkMatches`/`equate` through the cached `xsnap-worker` v0.14.2
(`~/.cache/agoric-sdk/xsnap/prebuilt/0.14.2/.../xsnap-worker`), bisecting N until
`Stack meter exceeded`. Controls: same probe on Node/V8 (expect ~15-30x deeper).
Reuse `packages/async-flow/test` scaffolding. The XS engine is the only heavy
dep; if it needs re-provisioning that is now authorized.

Deliverable: empirical threshold curve (frames/level and overflow N for each
path) confirming or refuting the ~115/~15 estimates, posted back as a comment on
the issue thread below. Do NOT close the issue (the submitter does that).

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-9
issue_url: https://github.com/kriskowal/garden/issues/9#issuecomment-4825122191
submitter: kriskowal
----- END ISSUE NOTE -----

---
claim:
  host: endolinbot
  gardener: 41
  claimed_at: 2026-06-28T06:35:16Z
