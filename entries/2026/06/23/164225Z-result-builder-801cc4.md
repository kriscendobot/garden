---
ts: 2026-06-23T16:42:25Z
kind: result
role: builder
worktree: dispatches/builder--801cc4/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Built `@endo/pubsub` per the maintainer's inline asks on `endojs/endo-but-for-bots#507` (`designs/notifier-pubsub-migration.md` comments 3460676479 line 98 and 3460690829 line 320).
DRAFT PR opened: `endojs/endo-but-for-bots#513`.
Branch: `feat/endo-pubsub`. Base: `llm-44e3b17` (frozen snapshot of `origin/llm@44e3b17b0`).

## Package shape

`packages/pubsub/` with:

- `index.js`: re-exports the factories.
- `pub-sub.js`: `makePubSub()` (sink + spring over shared async promise linked list, lifted verbatim from historical commit `cbbd57c03`).
- `change-topic.js`: `makeChangeTopic()` (lossless deltas, wraps `makeStream` over `makePubSub`; adds terminal-disposition tracking so subscribers created after `return` / `throw` synthesize the terminal rather than waiting on a never-resolving tail).
- `latest-topic.js`: `makeLatestTopic()` (lossy, latest-cell + per-subscriber index tracking + replay-on-iterate semantic).
- `cancel-kit.js`: `makeCancelKit()` (small `{ cancel, cancelled }` primitive over `makePromiseKit`).
- `null-queue.js`: `nullSink` / `nullSpring` helpers.
- `types.js`: JSDoc typedef for `CancelKit`.
- Tests: `test/pub-sub.test.js` (4), `test/change-topic.test.js` (10), `test/latest-topic.test.js` (12), `test/cancel-kit.test.js` (4) = 30 tests total, all passing.
- `package.json`, `tsconfig.json`, `tsconfig.build.json`, `README.md`, `CHANGELOG.md`, `LICENSE`, `SECURITY.md` (copied from `packages/stream/`; per-package SECURITY.md hash uniformity is enforced by the gate's `security-md-hash-uniform` probe).
- Changeset entry at `.changeset/add-endo-pubsub.md`.

## Factory names

- `makeChangeTopic` — lossless deltas (every subscriber sees every value after iteration begins).
- `makeLatestTopic` — lossy (only the most-recent value is retained).
- `makePubSub` — underlying sink + spring primitive.
- `makeCancelKit` — `{ cancel, cancelled }` cancellation kit.

The factory names use the design's `makeLatestTopic` / `makeChangeTopic` naming directly (the design proposes the same names for the `@endo/exo-pubsub` package; `@endo/pubsub` is its local-layer sibling and uses the same names at the local layer).

## Tests

`corepack yarn workspace @endo/pubsub test`: **30 passed**.

Coverage:

- Subscribe-after-publish (lossless: late subscriber sees only deltas after subscribe; lossy: late subscriber sees the latest immediately and then blocks).
- Subscribe-before-publish (both variants block).
- Cancellation via `makeCancelKit` (basic reject, idempotent cancel, default-reason, race against `reader.next()`).
- Multiple subscribers (each receives independently).
- Race-safe publish/drain (parallel publisher.next() / for-await).
- Finish / fail terminal events (terminal-stickiness, late-subscribe-after-terminal, publish-after-terminal no-op).

`corepack yarn workspace @endo/pubsub lint`: clean (no warnings, no errors).

## Pre-push gates

All gate probes that fired on the diff passed except:

- `sentence-per-line-md` on `packages/pubsub/SECURITY.md`: multi-sentence lines in the boilerplate SECURITY.md content. This file is byte-identical with `packages/stream/SECURITY.md` and every other package's SECURITY.md per the `security-md-hash-uniform` probe; modifying it would break that probe. The maintainer directive on the dispatch instructions explicitly says *"do NOT edit existing SECURITY.md files"*. The probe's flag is the same across every new package and is accepted noise.

## Frozen base

`llm-44e3b17` pushed to `origin/feat/endo-pubsub`'s fork (the same `endojs/endo-but-for-bots` since this branch is on the upstream's repo, not a separate fork). Snapshot of `origin/llm@44e3b17b0`.

## Impasses

None. The historical pubsub material exists in commit `cbbd57c03` and is sufficient for the lossless variant; the lossy variant is implemented from the design's revision 3 contract directly.

## Notes

- The maintainer suggested `makeCancelKit` but no such primitive exists in the codebase today. I implemented it as a small `{ cancel, cancelled }` kit over `makePromiseKit`, mirroring the daemon's existing `Context['cancel']` / `Context['cancelled']` discipline. The kit is exported from `@endo/pubsub` so the package's own cancellation needs are satisfied without taking a dependency on the daemon's context machinery. If a future iteration wants `makeCancelKit` to land in a shared package, that is a separate change.
- The change-topic implementation includes a "graveyard cursor" trick on `publisher.throw(error)` to silence the otherwise-orphan rejected promise that `@endo/stream`'s `makeStream.throw` pushes onto the linked list. Without it, a test that creates a late subscriber after `publisher.throw()` would surface an unhandled-rejection warning even though the late subscriber's synthesized terminal correctly delivers the error.
- The package depends on `@endo/eventual-send` transitively through `@endo/stream`; the explicit dependency is in `package.json` so the workspace resolver can locate it.

Self-improvement: nothing this time. The dispatch's framing, library lookup, and pre-push gate guidance were sufficient; no role or skill ambiguity surfaced.
