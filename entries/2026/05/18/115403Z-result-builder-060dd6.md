---
ts: 2026-05-18T11:54:03Z
kind: result
role: builder
host: endolinbot
short_id: 060dd6
dispatch_root: dispatches/builder--060dd6
repo: endojs/endo-but-for-bots
branch: feat/daemon-message-streaming-phase-1
base: llm
pr_number: 287
project: endo-but-for-bots
---

# Builder result: streamReply Phase 1

## PR
- https://github.com/endojs/endo-but-for-bots/pull/287 (DRAFT, base `llm`, branch `feat/daemon-message-streaming-phase-1`).

## Pre-flight (all clear, no impasse)
- Open-PR slug check: no open PR with `message-streaming`, `streamReply`, `mail-streaming`, or `stream-message` slug.
- Design-status drift: `designs/daemon-message-streaming.md` Status was `Not Started` on llm. Bumped to `In Progress` with a new `## Status` section.
- Existing-symbol check: zero load-bearing hits in `packages/` for `openStream`, `streamMessage`, `streamReply`, `appendStream`, `finaliseStream`, `finalize-stream`, `StreamWriter`, or `StreamReader`. Greenfield landing.

## Affected files (12 files, +939 / -6)
- New: `packages/daemon/src/mail-stream.js` (the stream pair: writer + reader exo + finalisation getter, in-memory buffered events).
- New: `packages/daemon/test/mail-stream.test.js` (10 unit tests on the helper).
- New: `.changeset/daemon-message-streaming-phase-1.md` (`@endo/daemon` minor).
- Modified: `packages/daemon/src/mail.js`
  - `streamReply(messageNumber, options?)` method.
  - `deliverTransient` helper that allocates a message number, publishes to the topic and in-memory map, and returns a `persist` hook the caller invokes on stream finalisation.
  - `post()` routes stream-bearing envelopes through `deliverTransient` on the sender side and attaches a persist hook on `streamFinalization.get()`.
  - `receive()` routes stream-bearing envelopes through `deliverTransient` on the recipient side and attaches its own persist hook.
  - `makeMessageFormula` / `makeStampedMessage` / `assertMessageEnvelope` accept optional `phase` / `aborted` / `abortReason` fields on package envelopes so the persisted record round-trips.
- Modified: `packages/daemon/src/interfaces.js` — `streamReply` method guard added to both `GuestInterface` and `HostInterface` (`M.call(MessageNumberShape).optional(M.splitRecord({}, { phase: M.string() })).returns(M.promise())`).
- Modified: `packages/daemon/src/host.js` and `packages/daemon/src/guest.js` — destructure `streamReply` from mailbox and expose it on the agent exo.
- Modified: `packages/daemon/src/daemon.js` — least-authority guest stub: add `streamReply: disallowedFn`. (This was the load-bearing fix; without it, the least-authority exo fails the interface guard, the daemon mis-initialises in a non-obvious way, and seven unrelated tests fail with subtle off-by-one symptoms. See *Self-improvement* below.)
- Modified: `packages/daemon/src/types.d.ts` — `StreamEvent`, `StreamWriter`, `StreamFinalization`, `StreamReplyOptions` types; `stream` / `phase` / `aborted` / `abortReason` added to `Package`; `streamReply` on `Mail` and `EndoAgent`.
- Modified: `packages/daemon/test/endo.test.js` — 6 daemon-level integration tests.
- Modified: `designs/daemon-message-streaming.md` — Status `Not Started` → `In Progress`, added Status section listing Phase 1 deliverables and out-of-scope deferrals.
- Modified: `designs/README.md` — summary table row updated (Updated: 2026-05-18, Status: In Progress).

## Tests (16 net new, all passing)
- 10 unit tests in `mail-stream.test.js`: writer event ordering; initial phase round-trip; abort surfaces partial text; empty stream (open + immediate end); phase-only stream (no append); late subscribers replay buffered events; append/setPhase reject after end; idempotent end; idempotent end-then-abort; recipient cancels iteration mid-stream.
- 6 integration tests in `endo.test.js` under `streamReply`: real two-host (host + guest, same daemon) round-trip exercising append+phase+end ordering; empty stream; phase-only; abort after partial append; recipient cancels iteration mid-stream; finalised text persisted in recipient inbox after end().
- Pre-existing reply tests still pass (`reply links to parent message`, `message hub avoids kebab-case reply metadata names`, `reply across nodes`).
- The seven tests that initially failed with my interface change (counter / cancellation / move / eval-mediated worker name) all pass after adding `streamReply: disallowedFn` to the least-authority guest stub.

## CI status at PR-open time
- Local: `yarn lint:eslint` clean (0 errors, only pre-existing warnings).
- Local: `yarn ava test/mail-stream.test.js` 10/10 pass.
- Local: `yarn ava test/endo.test.js --match "streamReply*|*reply links*|recreates counter*|@pins values reincarnate*|direct cancellation|eval-mediated worker name|cancel with pet name path|*move renames value*|*move moves value*"` all 18 pass.
- Full `yarn test` on `@endo/daemon` is in progress at PR-open time (serial; AVA reports ~45+ tests passing as of result-write time, no failures yet). PR opens DRAFT so the CI pipeline owns the final verdict.

## Out-of-scope deferrals (recorded in the design Status section)
- Back-pressure / throttling (the design's named future item).
- CLI / Genie integration (Phase 2+; design's migration path step 2).
- Persistent intermediate stream state across daemon restarts.
- Cross-peer streams beyond same-daemon round-trips.
- `streamSend` (the alternative for brand-new streaming conversations).

## Self-improvement

**`AgentNotFoundError` analogue for `least-authority`.** Adding any method to `GuestInterface` (or `HostInterface`) requires a matching stub on the `least-authority` guest exo at `packages/daemon/src/daemon.js`. Five prior builder dispatches impassed on related gates; this one almost added a sixth: I shipped a working `streamReply` implementation and the integration tests all passed, but `yarn test` surfaced seven unrelated failures in counter / cancellation / move tests. The failure mode is non-obvious — the off-by-one counter result looks like a state-corruption bug — and it took twenty-plus minutes to bisect to the missing stub. A faster shortcut for future builders extending `GuestInterface`: after editing `interfaces.js`, grep for the interface name across `packages/daemon/src/` to find every exo construction site, including stubbed-out ones like `least-authority`.

The fix is one line (`streamReply: disallowedFn,` next to `reply: disallowedFn,` in the `least-authority` block), but the *checklist* is what's worth lifting: a pointer in `roles/builder/AGENT.md`'s operating norms section reading "When extending `GuestInterface` or `HostInterface` in `packages/daemon`, grep for the interface name across `src/` and audit every match for completeness — the least-authority stub is the trap." If the maintainer prefers, this could also become a lint rule in `@endo/internal` that errors when an interface's method set is referenced in a `makeExo(...InterfaceName, { ... })` call site whose method-name keys don't cover the interface; that's a heavier change and arguably belongs in `@endo/exo` rather than the daemon's ESLint config.

Self-improvement: when a structural change to `GuestInterface` / `HostInterface` in `packages/daemon/src/interfaces.js` is part of a PR, grep `packages/daemon/src/` for the interface name and audit every `makeExo(...)` call that uses it; the `least-authority` stub in `daemon.js` is the easy-to-miss one.
