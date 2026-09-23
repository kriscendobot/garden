---
ts: 2026-06-17T20:42:30Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/17/203500Z-result-researcher-4151cb.md
---

Drafted `designs/presence-severance-observation.md` on branch
`design/presence-severance-observation` against `llm` of
`endojs/endo-but-for-bots`.
DRAFT PR
[#450](https://github.com/endojs/endo-but-for-bots/pull/450) opened.

**Observer-API choice: (a) `E.whenSevered(presence) -> Promise<never>`.**
Rationale: aligns with the existing platform-neutral cancellation-promise
convention used in `designs/cli-http-client.md` (where
`cancellation: Promise<never>` is the cancellation token on `request`);
composes with `Promise.race` for "do X until severed" patterns; sits on
`E` because holders already import `E` for sends.  Considered and
rejected: (b) `HandledPromise.whenSevered` static (lower-level surface;
holders use `E`, would double the surface) and (c) Exo facet from the
presence (severance is a property of the binding, not of the target;
forcing every Exo author to opt in is wrong).

**Vocabulary choice: adopt "severance" as the umbrella term.**
"Partition" (the `captp-bounded-transient-pin` concept), "abort" (the
captp local entry point), and "disconnect" (the wire message) each name
a layer-specific facet but none covers the object-level
(peer-drops-export) and permission-revoked (host-revokes-import)
sub-cases the design generalizes.  Severance is the holder-facing
event; the existing terms remain valid for their layer.  A future
librarian / scholar pass should lift `concepts/presence-severance.md`
with the prior terms as cross-references.

**Verification results:**

- `handler.HAS` / `handler.DELETE`: **imagined.**  Grep of
  `packages/eventual-send/src/handled-promise.js` confirms the handler
  protocol exposes `get`, `applyMethod`, `applyFunction` plus their
  `*SendOnly` variants (lines 152, 158, 179) only.  The earlier
  prompt's reference to `HAS` / `DELETE` was unfounded.  The design
  does **not** extend the handler protocol; the severance hook is a
  property on the handler value (installed by whoever produces the
  presence — captp, or a future transport).
- `whenAborted` / `whenDisconnected` in `@endo/captp`: **absent.**
  Grep of `packages/captp/src/*.js` returns no occurrences.  The
  `makeCapTP` return triple is `{ abort, dispatch, getBootstrap,
  getStats, isOnlyLocal, serialize, unserialize }`.  `CTP_DISCONNECT`
  handling exists (line 812) and fans out to the `settlers` map (lines
  823-825) plus calls `importExportTables.didDisconnect()` (line 822),
  but neither produces a per-presence observable promise.  The design
  lands `whenAborted` as a new field on the return triple plus a
  per-presence WeakMap fan-out.

**Open questions surfaced (all flagged in the design's *Open questions*
section):**

1. Severance as a first-class concept page vs alias of existing
   (partition / abort / disconnect).  Recommended librarian pass after
   the design merges.
2. Re-binding / reconnection semantics.  Design inherits the
   `daemon-cross-peer-gc` reconnect-as-fresh-snapshot posture; an
   alternative `whenRebound` shape is noted as deferred until a use
   case forces it.
3. Debouncing for flaky networks.  Design recommends leaving debouncing
   to the consumer.
4. Cleanup ownership when the returned `Promise<never>` is dropped
   without `.catch`.  Design recommends caller-owned; rejects a
   callback shape (`E.onSevered(p, cb)`) because the GC-detach contract
   adds machinery for no compositional gain.

**Cross-design coordination citations landed:**

- `chat-slot-slash-commands.md` § *Release Exo lifetime and captp
  partition* — cited as prior art that explicitly flags the API gap.
- `daemon-cross-peer-gc.md` § *Crash and reconnect semantics* — cited
  as the source of the reconnect-as-fresh-snapshot posture this design
  inherits.
- `ocapn-network-transport-separation.md` § *New conceptual model* —
  cited as where the netlayer connection-closed event surfaces.
- `daemon-message-streaming.md` § *4. Persistence* — cited as the
  graceful-end vs abort precedent; severance is the unilateral form of
  abort.

**Vocabulary nod:** MetaMask / ocap-kernel `rref` ("remote reference,
does not survive the channel") cited under Related work as the sibling
vocabulary for what severance ends.

`designs/README.md` summary table row added (Not Started).

PR is DRAFT awaiting maintainer review; un-drafting is the
maintainer's call after design review per
`roles/designer/AGENT.md`.

Self-improvement: the dispatch prompt named `handler.HAS` /
`handler.DELETE` as part of the verified primitive list.  The
researcher's section flagged them as potentially imagined, and the
verification confirmed they do not exist.  Lens for future designer
dispatches: when the prompt names a primitive that the researcher's
references do not corroborate, verification is a first-class deliverable
of the design, not a footnote — the design's authority depends on it.
The current `designer/AGENT.md` already nudges this direction via the
2026-06-09 *Notes from the field* row on consumer-smoke-testing
substantive behaviour changes; a *Notes from the field* row on
"verify prompt primitives against source when researcher flags
uncertainty" would consolidate the pattern.  Recorded here, not
forwarded as a `message` entry, because a single observation is below
threshold for a hard rule per the self-improvement skill.
