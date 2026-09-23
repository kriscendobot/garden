---
ts: 2026-06-23T05:48:49Z
kind: result
role: designer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--399aa8/project
---

Produced design 2 of 2 in a competing pair addressing PR #500 comment
`4775973308`. Branch `design/sturdy-refs-via-endor-syscall`, design
file `designs/sturdy-refs-endor-syscall.md`, DRAFT PR
[#510](https://github.com/endojs/endo-but-for-bots/pull/510) against
frozen base `llm-65b0abe`. The design rejects worker-local SturdyRef
retention and proposes daemon-side ephemeral retention plus a new
`endor` worker syscall (`retain` / `release`) for cross-turn retention.
The sibling design (option A, FinalizationRegistry) is the parallel
designer's deliverable; this PR's body marks the competing-pair
relationship and will cross-link when the sibling lands.

Key library-lookup findings that informed the design:

- The current `@endo/ocapn` shim already represents a SturdyRef as a
  `tagged('ocapn-sturdyref', undefined)` with a side WeakMap holding
  `{ location, secret }` (`packages/ocapn/src/client/sturdyrefs.js`).
  `ocapnPassStyleOf` is the upgrade that returns `'sturdyref'`. The
  design promotes both pieces into `@endo/pass-style` as a proper
  `'sturdyRef'` category with a `SturdyRefHelper` joining the existing
  helper table in `passStyleOf.js`.
- OCapN spec § *Sturdyref Locator* (held at `kriscendobot/ocapn`
  commit `f7005c12`, surfaced via the journal library at
  `library/sections/ocapn--draft-specifications-locators--sturdyref-locator--*.md`)
  carries the on-wire form `<ocapn-sturdyref peer swiss-num>` and the
  peer locator shape (`designator + transport + hints`) the design
  reuses verbatim. The parsed shape is already present as
  `OcapnLocation` in `packages/ocapn/src/codecs/components.js`.
- The daemon's existing pet-name-path surface is broad (`lookup`,
  `identify`, `locate`, `write`, `evaluate`, `makeUnconfined`); the
  design tabulates each method and how it changes (additive on the
  read side; no change to reverse-direction methods).
- `daemon-endor-architecture.md` documents the existing four-element
  CBOR envelope `[handle, verb, payload, nonce]` and the worker /
  supervisor verb partition; the design extends the worker-originating
  verb set with `retain` and `release`, plus their `retained` /
  `released` / `error` responses.
- `packages/daemon/src/residence.js` already keys retention by
  `(retainerId, retaineeId, retaineeIncarnation = CapTP slot)` and
  drops on `deleteExport`. The design reuses this machinery for the
  ephemeral half (no worker-VM GC observation needed) and extends it
  with explicit `retained:<worker>:<handle>` edges for the syscall
  half.
- `daemon-retention-paths.md` establishes the `listRetentionPaths`
  surface and the edge-label vocabulary the design extends with
  `ephemeral:<worker>:<turn>` and `retained:<worker>:<handle>`. No
  new user-facing surface is required for revocation: existing
  `disincarnate(worker)` triggers the bulk release through
  `releaseAllForRetainer`.
- `MetaMask/ocap-kernel` (journal source
  `library/sources/metamask-ocap-kernel--overview.md`, HEAD
  `a3eff0efb` 2026-05-28) is the named prior art for the
  "implicit-retention" virtue; the design sources that virtue from
  daemon bookkeeping rather than VM GC.

Open questions surfaced (in *Open questions* of the design):

- Should the syscall surface admit retention for any passable category
  whose identity is recoverable (presences, promises), not just
  SturdyRefs?
- Per-worker small integer handle, or globally-unique opaque
  bytestring?
- Should `retain` on a non-SturdyRef slot reject (the minimal shape)
  or generalise (the "any reference returned by an agent method"
  framing)?
- Should the `ephemeral:<worker>:<turn>` edges be visible by default
  in `listRetentionPaths`, or hidden behind a flag?
- Is the design's rereading of "collected" as "CapTP slot
  `deleteExport`'d at end-of-turn" faithful to the maintainer's
  framing in PR #500?

Explicit comparison points with the alternative plan
(`FinalizationRegistry`-based, design 1 of 2), captured in a ~16-row
table in the design under *Comparison points with the alternative
plan*:

- Where the worker holds the SturdyRef (handle integer vs. JS object)
- How daemon learns of release (syscall round-trip vs. VM GC callback)
- Release lag (microseconds vs. unbounded)
- What `listRetentionPaths` shows (explicit per-handle edges vs. one
  per-worker aggregate)
- Cost of "no retention" path (zero vs. per-SturdyRef registry entry)
- Cost of "retention" path (one retain + one release vs. zero
  explicit plus observation overhead)
- Compatibility with `lockdown` discouragement of
  `FinalizationRegistry` (no dependency vs. requires the API
  available)
- Behaviour under buggy workers that forget to release (visible
  retention path vs. invisible "VM hasn't GC'd yet")
- Behaviour under buggy workers that release the wrong handle
  (independent per-handle vs. not applicable)
- `endor` protocol surface added (2 verbs vs. likely 1 verb for the
  registry drop notification)
- Worker SDK surface added (`syscall.retain` / `syscall.release` vs.
  `FinalizationRegistry`)
- Reincarnation behaviour (fresh handle namespace vs. re-registration
  on boot)
- Posture summary: explicit-and-narrow (this design) vs.
  implicit-and-wide (the sibling)

Refs:

- Dispatch entry (parent): the orchestrator's dispatch journal entry
  for `designer--399aa8` (not read by this subagent).
- PR: https://github.com/endojs/endo-but-for-bots/pull/510
- Branch: `design/sturdy-refs-via-endor-syscall` on
  `endojs/endo-but-for-bots`
- Frozen base: `llm-65b0abe` (snapshot of `origin/llm` at dispatch
  start)
- Maintainer comment:
  https://github.com/endojs/endo-but-for-bots/pull/500#issuecomment-4775973308

Self-improvement: nothing this time.
