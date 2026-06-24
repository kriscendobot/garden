---
ts: 2026-05-18T12:37:31Z
kind: result
role: cleaner
host: endolinbot
short_id: b026a1
dispatch_root: dispatches/cleaner--b026a1
repo: endojs/endo-but-for-bots
branch: feat/daemon-message-streaming-phase-1
base: llm
pr_number: 287
project: endo-but-for-bots
refs:
  - entries/2026/05/18/115753Z-dispatch-cleaner-b026a1.md
  - entries/2026/05/18/115403Z-result-builder-060dd6.md
---

# Cleaner pass on PR #287 (daemon-message-streaming Phase 1)

Branch `feat/daemon-message-streaming-phase-1` on base `llm`.
PR remains DRAFT pending the judge.

## Cleaner commits

Two commits on top of the builder's `4af9cd0ea` (and the in-between
prettier fix `8fe1c531d` someone else pushed during the cleaner pass).

- `84a2a8ac0` chore(daemon): clarify mail-stream reader is single-consumer.
  Corrects a misleading comment that claimed each iteration starts a
  fresh cursor.  `makeReaderIterator` is called once and its closed-over
  cursor is shared across every `next()` call on the reader exo; late
  subscribers replay because the buffer retains every event, not because
  they get a fresh cursor.  Documenting the actual single-consumer
  contract avoids a future reader mistakenly extending the reader for a
  multi-consumer use case under the wrong premise.
- `ff3053cbe` test(daemon): cleaner regression tests for stream edge cases.
  Three adversarial cases each proven load-bearing by mutating the
  relevant guard or buffer push and observing the failure.

Pushed to `feat/daemon-message-streaming-phase-1`.

## Lint / format / tests

### Before the cleaner pass

- Prettier check on touched files: drift in `packages/daemon/src/mail.js`
  and `packages/daemon/test/mail-stream.test.js`.  Fixed in parallel by a
  separate bot push (`8fe1c531d`); my redundant prettier commit was
  superseded.
- `yarn lint:eslint` on `@endo/daemon`: 0 errors, 327 warnings, none new
  on the touched files (three pre-existing warnings on `mail-stream.js`,
  same shape as the rest of the package).
- `yarn ava test/mail-stream.test.js`: 10/10 pass (builder's tests).
- `yarn ava test/endo.test.js --match='*streamReply*'`: 6/6 pass
  (builder's integration tests).

### After the cleaner pass

- `yarn lint:prettier`: clean.
- `yarn lint:eslint` on `@endo/daemon`: 0 errors, 327 warnings; no new
  warnings introduced.
- `yarn ava test/mail-stream.test.js`: 13/13 pass (10 builder + 3 cleaner).
- `yarn ava test/endo.test.js`: 160/160 pass.
- Full `@endo/daemon` `yarn ava`: 555 passed, 1 pre-existing flake
  (`channel-relay > channel join fails gracefully without
  adoptFromLocator (no peer info)`).  Reproduced and confirmed
  pre-existing on the `llm` base (`68246ad92`); the test passes when
  run alone but fails under the full serial suite's resource pressure.
  The same flake was documented on the previous cleaner pass
  (`entries/2026/05/18/091222Z-result-cleaner-638ea4.md`, PR #286).
  Not introduced by this PR.

`yarn lint:types` reports a pre-existing TS2307 in
`@libp2p/utils/src/adaptive-timeout.js` that reproduces on `llm` base;
also not introduced by this PR.

## CI on the cleaner's HEAD

At result-write time (12:37 UTC), the converging matrix on
`ff3053cbe` shows 12 successful, 13 in progress, 0 failed: browser-tests,
build, build-wasm, check-action-pins, familiar-bundle, lint (docs-only),
test262 x 2, test-async-hooks, test-hermes, test-ocapn-python, test-xs.
Remaining jobs are the heavy test matrix and viable-release; based on
the prior cleaner pass on PR #286 the heavy matrix typically converges
green within 25 minutes of push.  No need to block the result on the
last slow jobs; the judge dispatch will be gated on full convergence.

## Adversarial regression tests added

Three cases on `test/mail-stream.test.js`, each load-bearing per
`skills/regression-evidence/SKILL.md` (mutation experiments quoted
below).

1. **`end() after abort() is a no-op (abort wins)`** — mirrors the
   existing `end()`-then-`abort()` idempotency test in the opposite
   direction.  Once `abort()` has terminated the stream, a subsequent
   `end()` must not overwrite the finalisation record AND must not
   emit a spurious `end` event after the `abort` event the recipient
   already observed.  The test asserts both the final status and that
   a late subscriber's drained log ends at the `abort` terminator.
   Mutation that catches it: drop the `if (terminated) return` guard
   from `end()`.  Observed diff: drained events become
   `[..., abort, end]` instead of `[..., abort]`.

2. **`late subscriber after abort() replays the abort event`** — the
   existing late-subscriber test covers `end()`-terminated streams.
   The abort-terminated variant exercises a distinct code path
   because `abort()` pushes a different terminal event into the
   buffer and its ordering relative to `terminate()` is independent
   from `end()`'s.  Mutation that catches it: drop the
   `buffer.push(harden({ type: 'abort', reason }))` line.  Observed
   diff: subscriber misses the abort marker entirely; the drained
   log silently truncates to the last `append`.

3. **`rapid fire-and-forget append+end preserves order`** — issues
   five operations (`append('a')`, `append('b')`, `append('c')`,
   `append('d')`, `end()`) without awaiting each, then `Promise.all`s
   the lot.  Asserts the recipient sees the events in submission
   order.  The mail-stream design treats `append` as fire-and-forget
   at the writer boundary (the design's "back-pressure deferred"
   trade-off); the recipient still relies on the buffer's
   submission-order invariant.  Mutation that catches it: drop the
   buffering of any one event (e.g. `if (text === 'b') return;`
   inside `append`).  Observed diff: drained events become
   `[a, c, d, end]`, missing `b`.

## Least-authority stub audit

The builder's self-improvement called out the trap: every `makeExo(...
GuestInterface)` or `makeExo(... HostInterface)` call site needs a
stub for every interface method.  My audit:

```
$ grep -nR --include='*.js' 'makeExo[^)]*GuestInterface\|makeExo[^)]*HostInterface' packages/daemon/src/
src/daemon.js:2959:  makeExo('EndoGuest', GuestInterface, {        # least-authority stub
src/guest.js:366-368: makeExo('EndoGuest', GuestInterface, { ... } # real guest
src/host.js:1435-1437: makeExo('EndoHost', HostInterface, { ... }  # real host
```

Three sites total.  All three carry `streamReply`:

- `daemon.js:2993` — `streamReply: disallowedFn` (the builder's load-bearing fix).
- `guest.js:158, 352` — destructured from mailbox, exposed on the agent exo.
- `host.js:1259, 1394` — destructured from mailbox, exposed on the agent exo (via `...host` spread on the exo's option bag).

Every method enumerated in `GuestInterface` (43 methods) is present in
the least-authority `daemon.js` stub.  Cross-referenced by inspection;
the harden-exports / makeExo guard would also reject a missing one at
exo construction time, which is the reason for the seven mysterious
test failures the builder hit before adding `streamReply: disallowedFn`.

**No other least-authority points were missed.**  The codebase has
exactly one least-authority guest exo and the builder patched it
correctly.

## Drift between design and implementation

One drift item, surfaced for the judge.  Not blocking, not a fixer
hand-off; the cleaner does not widen scope into the dispatch prompt's
framing.

**Persistence-on-abort framing.**  The dispatch prompt's verification
note reads:

> Persistence boundary: `end()` persists the final message; `abort()`
> should NOT persist (it discards in-flight state).  Verify this is
> honored.

The actual design (`designs/daemon-message-streaming.md` § Persistence
shape, lines 30-39, and § Implementation sketch § 4 Persistence, lines
223-228) says the opposite:

> On `end()`, the assembled text is persisted as a normal `package`
> message [...].  On `abort()`, the partial text plus `aborted: true`
> and `abortReason` are persisted in the same shape.

The implementation matches the design (see
`buildFinalisedEnvelope` in `src/mail.js:868-883` and the
`attachStreamPersistOnSenderSide` / `dispatch` hook in
`src/mail.js:844-857` and `src/mail.js:1267-1285`): abort persists a
finalised envelope with `aborted: true` and the partial text.  The
existing integration test `streamReply: abort after partial append
surfaces the partial content` (`test/endo.test.js:1338`) covers the
event surface, and the persistence path is exercised end-to-end by
the analogous `streamReply persists the finalised text in the
recipient inbox after end()` test for the `end` shape — there is no
direct integration test for the persisted-after-abort form.  Adding
one is a reasonable follow-up but not required for cleaner-stage
DoD; the unit-level coverage on `mail-stream.js` already pins the
finalisation payload that the daemon persists.

I did NOT change the design or the implementation to match the
dispatch prompt's framing, because the design is canonical and the
implementation honors it.  Flagging here so the judge does not chase
the framing inconsistency.

### Phase 2+ deferrals verified

I confirmed nothing accidentally implements any deferred phase:

- **Back-pressure**: `append` returns a promise that resolves once the
  writer's synchronous mutations complete, not gated on consumer
  consumption.  Fire-and-forget by design.
- **CLI / Genie integration**: `grep -rn 'streamReply\|streamSend'
  packages/` shows only daemon-internal hits (mail.js, daemon.js,
  guest.js, host.js, interfaces.js, endo.test.js).  No Genie main
  module changes.
- **Persistent intermediate stream state**: no `type: 'stream'` formula
  type exists; in-flight state lives only in `messages` map and the
  change topic.
- **Cross-peer streams**: the integration tests use a single
  `prepareHost(t)` setup.
- **`streamSend`**: `grep -rn streamSend packages/` returns no hits.

## Cleanup nits

Beyond the prettier drift the other bot push fixed and the single
comment I corrected, no further nits found:

- No `console.log` from library code; the daemon's silent-by-default
  norm is honored.
- All `harden()` calls correctly applied per the project's
  `@endo/harden-exports` rule (`makeMailStream`, the writer's events,
  the reader's iterator results, and the final envelope).
- `// @ts-check` present on `mail-stream.js`; JSDoc types use `@import`
  for `StreamEvent` / `StreamFinalization` per the project's preference
  over inline `import()` types.
- `makeExo` (not `Far`) used for the StreamReader exo so it carries
  `__getMethodNames__` for CapTP introspection; `Far` is used only for
  the StreamWriter and StreamFinalization getter, both of which are
  lightweight one-off remotables that do not need runtime type
  checking — the project's `CLAUDE.md` § "Modules and exports" calls
  this out explicitly as acceptable.

## Out-of-scope items I did not pursue

Per the dispatch's *Out of scope* clause: no implementation of any
deferred phase, no refactoring of `mail.js` beyond the cleaner-grade
nits.  The `streamReply` plumbing in `mail.js` could be made tidier
(the `attachStreamPersistOnSenderSide` and the inline lambda in
`receive()` share the persist-hook shape but are not factored), but
that is design-shaped refactor work that belongs in a follow-up or in
Phase 2 when the routing actually grows.

## Self-improvement

The mid-pass collision with another bot's prettier push
(`8fe1c531d`, opened while I was working) caused a non-fast-forward
push rejection and a stash/reset/replay cycle.  This is the second
cleaner dispatch in 24 hours that had to handle a parallel push, and
both times the resolution shape was the same: fetch, reset to
remote, reapply the cleaner-specific edits, push.

A future refinement worth considering for `roles/cleaner/AGENT.md` (or
`skills/pr-creation-flow/SKILL.md`): a one-line note that the cleaner
should `git fetch origin <branch>` immediately before each push, and
if the remote moved during the cleaner pass, prefer to rebase the
cleaner's own commits on the remote head rather than blindly pushing.
The current role brief assumes single-actor branch ownership, but the
PR-creation-flow chain now sometimes interleaves a maintainer-driven
or in-concert assayer-driven push between the builder result and the
cleaner dispatch.

Not landing this change from the cleaner dispatch (the cleaner does
not commit role / skill changes); routing as a `message` if the
maintainer wants it.

Self-improvement: when another bot push lands on the PR's branch
mid-cleaner-pass, `git fetch && git reset --hard origin/<branch>` then
reapply the cleaner's edits is the shortest path — but
`roles/cleaner/AGENT.md` could note this expected interleave so the
next cleaner does not waste time investigating the non-fast-forward
push rejection as an anomaly.
