---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Build the remaining pieces needed for a pipelined `E.untag` /
`HandledPromise.untag`, based on upstream `endojs/endo`'s `master` (not the
fork's `llm` trunk — this is upstream-bound OCapN protocol work).

## What already exists (do not re-derive; verify against current master
## rather than trusting these line numbers, which may have drifted)

- The OCapN spec accepted `op:untag` as settled, not a live proposal:
  https://github.com/ocapn/ocapn/pull/161 and the follow-up spec-bug fix
  https://github.com/ocapn/ocapn/pull/245 are both merged.
- `endojs/endo` already has full **receive-side** wire support, merged via
  https://github.com/endojs/endo/pull/3013 ("OCapN: improve spec
  conformance"):
  - `packages/ocapn/src/codecs/operations.js` — `OpUntagCodec`, encoding/
    decoding `op:untag` on the wire.
  - `packages/ocapn/src/client/ocapn.js` — an `'op:untag'` handler (around
    line 893 as of this writing) that validates pass-style, checks the tag,
    and resolves the untagged value for an *incoming* untag request.
  - That same PR's body says explicitly: "needs means of sending
    `op:untag`" — the gap this job closes.

## What's missing (the actual "remaining needs")

Three sites, following the exact pattern the codebase already uses for
`get`/`applyMethod`/`applyFunction`:

1. **`packages/eventual-send/src/handled-promise.js`** — `HandledPromise`
   has no `untag` trap today. Its trap surface (as of this writing) is
   `get`, `applyFunction`, `applyFunctionSendOnly`, `applyMethod`,
   `applyMethodSendOnly`, each with: (a) a `HandledPromise.<trap>(...)`
   static forwarding method around line 400-435, (b) participation in the
   internal `handle(target, op, args, returnedP)` dispatcher and its
   trap-composition fallback logic (e.g. a missing `applyMethod` is composed
   from `get` + `applyFunction` — see the composition block around line
   150-180), and (c) a listing in the `Handler` JSDoc typedef around line
   598-640. Add `untag` as a new trap through all three of these — it's
   closer in shape to `get` (a single value-producing dereference with no
   natural "SendOnly" variant) than to `applyMethod`; judge for yourself
   whether a `untagSendOnly` genuinely makes sense here or whether that's
   over-generalizing, and say which you picked and why.
   **This is the part that makes it pipelined**: correctly wiring into
   `handle()`'s existing machinery is what lets `E.untag(p)` work on a
   *promise* for a tagged value, not just an already-resolved one — the
   same way `E(p).method()` already pipelines through an unresolved `p`.
   Don't hand-roll a separate resolve-then-untag path that bypasses this;
   that would defeat the actual point of this job.
2. **`packages/eventual-send/src/E.js`** — add the `E.untag(x)` sugar,
   calling through to `HandledPromise.untag`, mirroring how the existing
   `get` case is exposed (search the file for the current shape rather than
   assuming a specific line).
3. **`packages/ocapn/src/client/ocapn.js`** — the *send*-side
   `RemoteKitHandler` built by `makeHandlerForRemoteReference` (around line
   302-447) implements `applyMethod`/`applyMethodSendOnly` (around line
   421-436) but has no `untag` trap — this is the piece that actually
   constructs and sends an outbound `op:untag` OCapN message for a remote
   tagged-value reference, closing the loop with the already-existing
   receive-side handler. Mirror `applyMethod`'s shape for wiring an
   `answerPosition`/promise resolution.

## Tests and scope

Mirror the existing `get`/`applyMethod` test coverage in
`packages/eventual-send/test/` and `packages/ocapn/test/` for the new trap:
unit coverage on `HandledPromise.untag` (including a genuinely pipelined
case — untag a promise before it settles, not only a resolved presence),
and an end-to-end OCapN test sending a real `op:untag` over the loopback
client and asserting the untagged value comes back correctly, alongside a
rejection case (untagging a non-tagged value, and a tag mismatch) exercising
the existing receive-side error paths in `packages/ocapn/src/client/ocapn.js`.
A changeset is required per the packages' pre-1.0 convention (see
`endojs/endo-but-for-bots`#990's "Breaking change" section for the shape,
though this addition is unlikely to itself be breaking — judge that on its
own merits, don't assume).

This job's own scope is `E.untag`/`HandledPromise.untag` plus the send-side
OCapN wiring above — it does **not** extend to the `op:get`/`op:index`
question that https://github.com/endojs/endo-but-for-bots/pull/990
deliberately declined to promote to a distinct verb; that decision stands
and is out of scope here.

## Target and base

Land this on `endojs/endo-but-for-bots`, based on a frozen `master-<sha>`
snapshot of upstream `endojs/endo`'s live `master` (per
`skills/frozen-base-branch/SKILL.md` and the "no live `master` trunk on this
fork" exception in `roles/conductor/AGENT.md`) — fetch upstream master's
current HEAD at build time rather than trusting any SHA from this brief,
which may already be stale. This mirrors the same pattern already used
elsewhere this session for master-targeted work on this repo. This job
lands the PR; ferrying it upstream to the real `endojs/endo` afterward is a
separate, maintainer-gated boatman job, not part of this one.



<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->

<!-- garden-reaped: 1 -->
