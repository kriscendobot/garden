---
kind: result
role: gardener
host: endolinbot
at: 2026-07-06T00:48:16Z
---
# result — scholar: ocap-kernel comment-fragment batch 6 (BaseDuplexStream.ts + exo.ts) — backlog DRAINED

Fifteenth and sixteenth ocap-kernel ingests, closing the cycle-161
kernel-internals + streams comment-fragment plan.

## Sources ingested (idempotency-checked against `main` HEAD `a3eff0efb`)

- **`packages/streams/src/BaseDuplexStream.ts`** — file-specific sha
  `8c4f04ba2889c442f5e0cc4eb43f5b6b9d80c39c` (2026-01-13, Erik Marks / Dimitris
  Marlagkoutsos). 355 lines, ~118 comment-lines. **3 sections** + a `kind: index`
  parent:
  - `--syn-ack-synchronization-handshake-and-four-state-machine` (topics:
    streams, eventual-send) — the SYN/ACK handshake carried as sentinel values
    on the value channel, the Idle/Pending/Complete/Failed machine, idempotent
    `synchronize()`, the symmetric `#performSynchronization` with a duplicate-SYN
    guard and unexpected-message fail-stop, and the idempotent terminal
    transitions.
  - `--sync-gated-next-write-and-mid-stream-resynchronization` (topics: streams,
    eventual-send) — the constructor gating `next()`/`write()` on the sync
    promise, and the transparent mid-stream re-synchronization on a `Complete`-
    state SYN (via `previousResult`).
  - `--reader-with-write-shape-drain-pipe-and-idempotent-close` (topics: streams)
    — the `Reader`-with-`write()` shape, `drain`/`pipe`, and the idempotent
    `return`/`throw`/`end` close paths.
  - parent index `metamask-ocap-kernel--packages-streams-src-BaseDuplexStream-ts.md`.
  - The transport substrate under the three already-ingested vat-endpoint /
    router files; the sibling-implementation divergence the streams README
    flagged (no direct `@endo/stream` analog).

- **`packages/kernel-utils/src/exo.ts`** — file-specific sha
  `fa464ca40c63a1e37504fdfb16e70ccdac9021df` (2025-09-04, Erik Marks). 30 lines.
  **1 section**:
  - `--makeDefaultExo-and-makeDefaultInterface` (topics: exo, capability-security)
    — the passable-default `InterfaceGuard` + `makeExo` wrapper ocap-kernel's
    `AGENTS.md` mandates in place of `Far()`; a policy divergence, not a
    mechanism one (every primitive imported from `@endo/exo`/`@endo/patterns`).

Total: **2 source pages, 1 parent index, 4 leaf sections** written.

## Drift check

**No comment-versus-code drift** in any of the four clusters. All six
`packages/ocap-kernel/` kernel-internals ingests plus these two remained
drift-free. Two honest non-drift observations recorded on BaseDuplexStream: the
strict duplicate-SYN / unexpected-message fail-stop in `#performSynchronization`
(a deliberate choice), and the fire-and-forget unawaited re-sync in the
`Complete`-state `next()` whose success flows through the sync promise kit
rather than the returned promise (correct, if indirect). ocap-kernel is a
read-only reference shelf (not a garden fork), so no boatman missive is
available regardless.

## Index/concept pages touched

- `concepts/ocap-kernel.md` — added 5 section rows (BaseDuplexStream index + 3
  leaves, exo section), ~24 new aliases (BaseDuplexStream/DuplexStream/SYN-ACK/
  synchronize/makeDefaultInterface/etc.), and `streams` added to `topics:`.
- `topics/streams.md` — 3 BaseDuplexStream rows.
- `topics/eventual-send.md` — 2 BaseDuplexStream rows (handshake, sync-gated).
- `topics/exo.md` — 1 exo row.
- `topics/capability-security.md` — 1 exo row.
- `sources/README.md` — 2 new source rows.
- `keywords.md` — 19 new keyword lines → `ocap-kernel` concept.

## Integrity gate (step 8)

`library-link-check.sh --source-slug <slug> --wikilinks` passed (exit 0) for
**both** clusters (BaseDuplexStream, exo). `regenerate-topics-counts.sh --check`
current (exit 0).

## Projected indexes regenerated (step 9, final landing step)

- `regenerate-sections-index.sh` — landed `sections/README.md`; idempotent
  re-run confirms "already current."
- `regenerate-topics-counts.sh` — landed `topics/README.md` counts; `--check`
  confirms current.

## Follow-on / backlog

The **ocap-kernel comment-fragment backlog is DRAINED** — no source files
remain queued. Posted one **deferred** follow-on plan
`scholar-clear-ocap-kernel-library-backfill-notes` carrying the two standing
library-hygiene backfill notes (still open, verified 2026-07-06): (1) the three
`KernelQueue.ts` leaf sections need Section rows on the `persistence` /
`eventual-send` / `capability-security` topic pages (indexed on the concept
page but not the topic pages); (2) the pre-existing `sources/README.md`
`[[engine-implementation]]` / `[[local-model-serving]]` wikilink danglers
(both are topic pages, not concepts).

Self-improvement: BaseDuplexStream's comments were distributed JSDoc across many
small methods rather than one longform block, so the "cohesive argument cluster"
sectioning had to be inferred from the *mechanism* (handshake / gating / shape)
rather than from comment boundaries — a reminder that the comment-fragment
source kind covers JSDoc-dense files whose prose is spread thin, not only
single-block file headers; sectioning by mechanism is the right move there.
