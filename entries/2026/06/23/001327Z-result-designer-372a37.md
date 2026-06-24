---
ts: 2026-06-23T00:13:27Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/23/000406Z-result-researcher-a4a14d.md
---

Designed the `@agoric/notifier` migration into Endo as a new sibling package
`@endo/exo-pubsub` coherent with the exo-streams discipline.
Landed as design file at `designs/notifier-pubsub-migration.md` on branch
`design/notifier-pubsub-migration` against `llm`; DRAFT PR
[#507](https://github.com/endojs/endo-but-for-bots/pull/507) opened.

Headline shape:

- **Package home**: a new sibling `@endo/exo-pubsub` (not absorption into
  `@endo/exo-stream`). Rationale: discoverability by name, scope-of-API
  signal (one-to-many is distinct from `@endo/exo-stream`'s one-to-one),
  composition not duplication (the new package builds on `@endo/exo-stream`
  and `@endo/stream` rather than subsuming them).
- **`makeUpdateTopic` disposition**: retired. The forward-lossless mode it
  represented is recovered by composition of `makeChangeTopic` with a
  one-shot `latestSnapshot()` query; a thin compatibility shim ships
  deprecated-on-arrival for one minor cycle and is removed at the next
  major.

Two retained topic shapes:

- `makeLatestTopic(options) → { publisher, subscribe, finish, fail }` —
  lossy. Late subscribers see most-recent then wait for next change.
  Publisher *is* `Writer<T>`; subscribers *are* `Reader<T>` /
  `PassableReader`. InterfaceGuard sketched.
- `makeChangeTopic(options) → { publisher, subscribe, finish, fail }` —
  lossless deltas. Late subscribers see only deltas after `subscribe()`.
  Direct precedent: `formulaChangeTopic` in `packages/daemon/src/daemon.js`
  + `retention-accumulator.js` from `daemon-cross-peer-gc.md`.

Final method signatures: `Stream`-shape (`next` / `return` / `throw`) on
the publisher to satisfy `Writer<T>` without adapter; subscribers conform
to `PassableReader` so remote consumers use `iterateReader` from
`@endo/exo-stream` without ceremony.

Cross-design coordination spelled out for:

- `daemon-message-streaming` (four-event taxonomy collapses onto the
  `Writer<T>` `next`/`return`/`throw` triple this package adopts; a
  daemon-message-streaming source that needs fan-out pumps into a
  `makeChangeTopic`).
- `daemon-cross-peer-gc` (`formulaChangeTopic` is the direct in-tree
  precedent; daemon's call site is the Phase 1 dogfood target).
- `presence-severance-observation` (PR #450: a remote subscriber's
  severance is the same event class as `pump` failure terminating a
  writer; topic uses `E.whenSevered(subscriberPresence)` to detect it
  and treats it as the subscriber's implicit `return()`).

Migration plan: three phases (Phase 1 package + daemon dogfood, Phase 2
codemod survey + dual publishing, Phase 3 retirement). Hard cutover
rejected because bulk of call sites live in agoric-sdk which is on
passive standing watch in the garden's project README.

Open questions surfaced (most resolved in-design with rationale; two
remaining for the maintainer):

- Storage / persistence of unread deltas in `makeChangeTopic` across
  daemon restart. Resolved out of scope for v1; producer-side replay is
  the composition pattern.
- Backpressure on a slow subscriber. Resolved with a per-subscriber
  `subscriberQueueLimit` option and pluggable overflow policy
  (default: drop oldest); `retention-accumulator` coalescing is the
  upgrade path.
- CapTP severance as unsubscribe. Resolved yes via `E.whenSevered`.
- Subscribe-time snapshot semantics. Resolved per-topic (lossy: see
  latest; lossless deltas: future only; forward-lossless: composition).
- Three topic names. Resolved: `makeLatestTopic` and `makeChangeTopic`
  retained; `makeUpdateTopic` retired-with-shim.
- `@agoric/notifier` per-call-site survey across agoric-sdk +
  endo-but-for-bots + endo. **Open**: this is Phase 2 work; anchor is
  *to be filed* tracking issue in the endo tracker once Phase 1 ships.

Concurrent-orchestrator awareness: re-polled
`gh pr list --search "notifier OR pubsub in:title"` after push; the four
hits are unrelated SES / claude-sandbox PRs from full-text matches on
unrelated content. No collision.

Self-improvement: nothing this time. The researcher's `## Library and
project references` block was assembled tightly enough that drafting
the design proceeded without library-lookup detours; the exo-streams
discipline citation, the lossiness taxonomy from the notifier readme,
and the `formulaChangeTopic` precedent were all surfaced where the
draft needed them. No structural lesson at the role or skill level.
