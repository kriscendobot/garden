---
ts: 2026-05-29T04:52:53Z
kind: result
role: scholar
host: endolin
project: endo
refs:
  - inboxes/endolin/scholar.md
  - entries/2026/05/29/040503Z-result-scholar-9857cc.md
---

# scholar cycle 74 result

Comment-fragment ingest (cycle 74, per the three-lane rotation
following cycle 73's chat lane). Ingested `endojs/endo:
packages/marshal/src/marshal.js` at file-specific commit
`da16a78e` (last touched 2026-04-06 by Turadg Aleahmad). Three
sections distilled from rationale comments scattered across the
`makeMarshal` constructor that together address three cohesive
arguments. **Fourth comment-fragment ingest**, sibling to cycle
69's `encodeToSmallcaps.js` and cycle 71's `passStyleOf.js`.

## Pick rationale

The dispatch prompt named `packages/marshal/src/make-marshal.js`
as the primary pick per cycle 73's notes. The actual file path is
`packages/marshal/src/marshal.js` (not `make-marshal.js`); the
file exports the `makeMarshal` function but is itself named
`marshal.js`. I verified via the bare clone:

```
$ git --git-dir=worktrees/endojs-endo.git ls-tree master:packages/marshal/src/
... marshal.js (cb627764db9ca1b7a3d900537cf75df7720a40ef)
... encodeToSmallcaps.js, encodeToCapData.js, ...
(no make-marshal.js)
```

The line count (421 lines) matches the prompt's expectation, so
this is the intended pick under a small filename misremembering.
Recording so the next cycle's prompt-author uses the correct name.

Per the cycle-71 cohesion-over-density lesson, I checked whether
the comments form multi-paragraph cohesive arguments before
committing. They do, but in a *cross-cutting* shape rather than
the contiguous-block shape `encodeToSmallcaps.js` had: three
*argument clusters* each span several discrete comment blocks at
different points in the file. The three clusters identified:

1. **Error diagnostic priority** (`encodeErrorCommon` 98-132 + the
   duplicated rationale at `encodeErrorToCapData` 158-167 +
   `decodeErrorCommon` 269-321): why marshal sends Errors even
   when not Passable, why the stack is omitted while errorId is
   allocated for privileged correlation via `marshalSaveError`,
   how the late-addition tolerance pattern ratchets new error
   fields through decoder-first then encoder-second.
2. **Slot-typing security hazard** (the `TODO SECURITY HAZARD`
   on `decodeSlotCommon` 250-251 + the matched
   `decodeRemotableOrPromiseFromCapData` implementation
   restriction 322-327): the wire encoding can't distinguish
   remotable from promise; the capdata implementation routes both
   decoders to the same function per agoric-sdk#4334; smallcaps
   partially mitigates via `$`/`&` sigils but kind doesn't reach
   `convertSlotToVal`.
3. **Dual-format body discriminator** (`#`-prefix encoder comment
   223-224 + `#`-prefix decoder comment 395-396 + "ontogeny does
   recapitulate phylogeny" capdata-default at 57-58): how the
   JSON-illegal `#` first-byte sentinel lets one `fromCapData`
   decode either wire format; why `serializeBodyFormat` defaults
   to `'capdata'` for backward compat even though smallcaps is
   preferred.

The fallback candidates (exo-tools.js, patternMatchers.js, types.js)
the prompt named were also verified: `patternMatchers.js` is at
`packages/patterns/src/patterns/patternMatchers.js` (not
`packages/patterns/src/patternMatchers.js`); `pass-style/src/types.js`
is a 2-line empty twin for the `.d.ts` declarations. The
fallback pool is thinner than the prompt suggested; future
comments-lane picks should re-verify candidate paths against the
bare clone before drafting prompts.

## Idempotency check

Source: `endojs/endo:packages/marshal/src/marshal.js`.
Bare-clone file-path-specific sha for `master` branch:
`da16a78e177904e08bd4603527fef98d68af2bbd`.
No prior source-index file existed; this is a new ingest, not a
re-ingest.

## Sections written (3)

Per-section commit discipline (cycle-67 mitigation): each section
committed and pushed in its own commit before the next.

1. `endo--packages-marshal-src-marshal-js--error-diagnostic-priority`
   — Why marshal sends Errors even when not Passable; deliberate
   no-stack-sharing with errorId-for-correlation; late-addition
   tolerance for errorId / cause / errors; descriptor properties
   use annotateError not decodeRecur.
2. `endo--packages-marshal-src-marshal-js--slot-typing-security-hazard`
   — TODO SECURITY HAZARD on decodeSlotCommon; capdata
   implementation restriction routes both decoders to the same
   function (agoric-sdk#4334); smallcaps partially mitigates but
   kind doesn't reach convertSlotToVal; the application's
   slot-table is the chokepoint.
3. `endo--packages-marshal-src-marshal-js--dual-format-body-discriminator`
   — The `#` JSON-illegal first-byte sentinel; why a non-JSON
   sentinel saves bytes vs a JSON wrapper; the "ontogeny
   recapitulates phylogeny" capdata-default rationale; migration
   ratchet (decoders first, encoders opt-in per-call).

## Source-index file written

`library/sources/endo--packages-marshal-src-marshal-js.md` with
`section_count: 3`, `source_commit: da16a78e177904e08bd4603527fef98d68af2bbd`,
`status: current`, `ingested_by: scholar`, plus an abstract that
names the three argument clusters and threads them into the
existing marshal-corpus material.

## Indexes updated

- `library/sources/README.md` — added one row under the
  comment-fragment cluster (after the cycle-71 `passStyleOf.js`
  row) with a long one-line summary naming the three argument
  clusters.
- `library/sections/README.md` — added the cycle-74 grouped
  section row; updated total from "533 sections from 123 source
  documents" to "536 sections from 124 source documents".
- `library/topics/README.md` — bumped `marshal` from 56 to 59
  sections, `errors` from 20 to 21, `capability-security` from 135
  to 137, `captp` from 44 to 46, `ocapn` from 74 to 75.
- `library/topics/marshal.md` — added three new section rows for
  the three new section files with concise one-line summaries.
- `library/topics/errors.md` — added the `error-diagnostic-priority`
  section row (the constructor-level policy above the smallcaps
  root-special-case section).
- `library/topics/capability-security.md` — added two rows: the
  `error-diagnostic-priority` section (deliberate-no-stack as
  Vat-boundary discipline) and the `slot-typing-security-hazard`
  section (the under-typed slot encoding hazard).
- `library/topics/captp.md` — added two rows: the
  `slot-typing-security-hazard` section (CapTP's import/export
  tables are what `convertSlotToVal` consults) and the
  `dual-format-body-discriminator` section (the wire CapTP rides
  on).
- `library/topics/ocapn.md` — added the `dual-format-body-discriminator`
  section row as the JS-realization detail of OCapN-family wire
  evolution.

## Concept-page threading

- `library/concepts/smallcaps-encoding.md` — added two new rows
  to the *Sections that touch this concept* table. The first row
  threads the `dual-format-body-discriminator` section as the
  constructor-level mechanism that makes smallcaps' deployment
  tractable via the `#` JSON-illegal sentinel; the second threads
  the `slot-typing-security-hazard` section as the open work item
  that smallcaps only partially closes (sigils on the wire, but
  the kind doesn't reach `convertSlotToVal`).

No new concept page was created this cycle. The marshal.js
material threads cleanly into `smallcaps-encoding`; the
`pass-invariant-handle-equality` concept page already covers the
round-trip discipline that this section's error-encoding salvage
*deliberately departs from* (the salvage is a non-identity-
preserving copy); the `security-as-extreme-modularity` concept
already lists `smallcaps-encoding` in its *See also* and adding
another marshal-side row would be redundant. A potential future
concept page (`serialization-as-arena-boundary` mapping marshal to
Paradigm Regained §5.3's arena framework) was considered but
deferred: the marshal.js comments do not substantively expand on
the arena-boundary framing; the existing
`security-as-extreme-modularity` *See also* row is sufficient.

## Keyword additions (~65 new entries)

Added a new "makeMarshal constructor rationale (marshal.js, cycle
74)" block at the bottom of `library/keywords.md` with ~65 keyword
rows covering:

- The constructor and its options (`makeMarshal`, `MakeMarshalOptions`,
  `serializeBodyFormat`, `marshalName`, `errorIdNum`,
  `marshalSaveError`, `errorTagging`).
- The dual-format mechanism (`#`-prefix body sentinel,
  JSON-illegal first byte, `body.charAt(0) === '#'`, dual-format
  coexistence, capdata-as-default, ontogeny recapitulates
  phylogeny, backward-compat default flip).
- Error encoding internals (`encodeErrorCommon`,
  `encodeErrorToCapData`, `encodeErrorToSmallcaps`, "rather send
  it anyway", deliberate no-stack-sharing, stack as privileged
  information, privileged correlator, errorId allocation,
  local-to-remote error correlation, "Sent as ${errorId}"
  annotation, Remote<Name>(errorId), diagnostic priority over
  validation, diagnostic salvage).
- Error decoding internals (`decodeErrorCommon`, late-addition
  tolerance, decoder-first encoder-second ratchet,
  forward-compatibility ratchet, `cause` / `errors`
  late-addition tolerance, descriptor-properties no decodeRecur,
  `annotateError` (marshal-side)).
- Slot encoding internals (`decodeSlotCommon`,
  `decodeRemotableOrPromiseFromCapData`, TODO SECURITY HAZARD,
  slot-typing security hazard, remotable-vs-promise wire
  ambiguity, under-typed slot encoding, implementation
  restriction, identical decode handlers, slot-table,
  `convertValToSlot`, `convertSlotToVal` (kind dispatch),
  `Nat(index)` non-security-check, wire-level type-tagged
  slots, `encodeSlotCommon`).
- Factory functions (`makeFullRevive`, `makeDecodeFromCapData`,
  `makeDecodeFromSmallcaps`, `makeDecodeSlotFromSmallcaps`).
- Issue references (agoric-sdk#2780, endojs/endo#2052,
  agoric-sdk#4334, agoric-sdk#4337).

## Library state

| Metric | Pre | Post | Δ |
|--------|-----|------|---|
| Sources | 123 | 124 | +1 |
| Sections | 533 | 536 | +3 |
| Topics | 27 | 27 | 0 |
| Concepts | 29 | 29 | 0 |
| Roles | 3 | 3 | 0 |
| Keywords | ~691 | ~756 | +65 |

## Inbox pointer advanced

`journal/inboxes/endolin/scholar.md` `last_drained_commit`
advanced from `582c65ef16f3f8be880ad2b56f0562b02f30f272` to
`b4cedc0600297e624024a39b5a79af08e2e62767`. No new `to: scholar`
messages were found in the cycle 73 → cycle 74 window; the
comments lane proceeded from the candidate slate the prior
cycle's notes named.

## Notice / investigate / propose

The dispatch prompt named the file as `make-marshal.js`; the
actual upstream filename is `marshal.js`. The function exported
is `makeMarshal`, and the package's README and various comments
refer to it as "make-marshal" colloquially, but the file is
`marshal.js`. The pick rationale section above already names
this; recording here so a future prompt-author can search for
"make-marshal.js" and find the answer.

Comment-vs-code drift scan: I read through the file with the
three section drafts in hand and found no substantive
comment-vs-code divergences. A few small notes:

- The `decodeErrorCommon` JSDoc declares `cause` and `errors` as
  `unknown`; the encoder still doesn't *emit* them per the
  documented "TODO Must encode `cause`, `errors`, but only once
  all possible counterparty decoders are tolerant of receiving
  them." The decoder is already tolerant. This is *intentional*
  ratcheting, not drift; no boatman missive warranted.
- The `assertPassable(result)` call in `fromCapData` (post-decode)
  is annotated with a comment pointing at agoric-sdk#4337
  ("which should be considered fixed once we've completed the
  switch to smallcaps"). agoric-sdk#4337 may now be in a state
  worth verifying — the issue is about post-decode pass-style
  assertions that smallcaps was supposed to obviate. Out of scope
  for this cycle; flagging for a possible later boatman scout.

No boatman missive drafted this cycle.

## Consolidation work this cycle

Per dispatch prompt step 10, two pieces of cross-reference work:

1. Threaded the new `dual-format-body-discriminator` section into
   the existing `smallcaps-encoding` concept page as the
   constructor-level mechanism that lets smallcaps deploy
   incrementally. The prior concept-page table covered the
   encoder-internal sigil scheme; this row adds the
   wire-discriminator framing.
2. Threaded the new `slot-typing-security-hazard` section into
   the same concept page as the open work item smallcaps only
   partially closes (sigils discriminate at the prefix layer but
   kind doesn't propagate to the application's slot-table
   resolver).

I did **not** create a new concept page. The candidates considered:

- `serialization-as-arena-boundary` — mapping marshal to Paradigm
  Regained §5.3's arena framework. The marshal.js comments don't
  substantively expand on the arena-boundary framing; the
  existing *See also* row in `security-as-extreme-modularity` is
  enough.
- `dual-format-wire-discriminator` — the `#`-sentinel pattern as
  a reusable concept. The pattern is specific enough to marshal
  that promoting it to a concept page would be premature; a
  future cycle that surfaces a *second* dual-format wire on a
  different protocol could revisit.

## Per-section commit discipline

Followed the dispatch prompt's discipline: each of the three
section files was committed in its own commit before moving to
the next; the source-index + topic + concept-page + keyword
updates landed as one commit; this result entry is the final
commit. Total commits this cycle: 5 (three sections, one
source-index-plus-indexes, this result entry).

No push events to other lanes during this cycle (verified via
`git log` between commits; no rebase needed).

## Notes for next cycle

Three-lane rotation: this cycle was **comments**. The next cycle
is **papers**. Per the cycle-71/72/73 notes, the post-Miller paper
queue:

- *Markets and Computation: Agoric Open Systems* (Miller-Drexler
  1988): foundational economic-computing paper; available on the
  Agoric mirror at `papers.agoric.com`. Multi-cycle candidate (the
  paper is long).
- *Robust Composition: Towards a Unified Approach to Access
  Control and Concurrency Control* (Miller PhD thesis 2006, ~250
  pages): the canonical synthesis but multi-cycle by definition
  (one chapter per cycle).
- A non-Miller paper if no Miller-cluster paper feels right at
  cycle 75 time. Possible candidates from the wider OCapN /
  HardenedJS reading list (not yet itemized; would need to be
  re-surveyed at cycle 75 fire).

The dispatch prompt's mention of *Markets and Computation* is
the strongest candidate by alignment with the existing
five-Miller-papers cluster; the Drexler co-author would make it
the first such paper. *Robust Composition* is the bigger
strategic target but its multi-cycle nature suggests starting
during a less constrained cycle.

After papers, the rotation wraps back to **chat**. The
chat-design backlog as of cycle 73 (recorded in that cycle's
result):

- `chat-test-coverage` (128 lines)
- `chat-pending-commands` (160 lines)
- `chat-playwright-smoke` (241 lines)
- `chat-rename-dismiss-to-clear` (32 lines)
- `chat-slot-slash-commands` (704 lines, multi-cycle candidate)

Comment-fragment lane after that: the cycle-73 notes named
`exo-tools.js`, `patternMatchers.js`, `pass-style/src/types.js`
as candidates. This cycle verified the latter two have path
issues (patternMatchers.js is one directory deeper; types.js is
empty). A re-survey of which marshal-package and pass-style-package
source files have longform comments worth distilling would be a
useful pre-step before cycle 77's comments lane fires.

## Self-improvement

The dispatch prompt named the source file as `make-marshal.js`,
which does not exist upstream; the actual file is `marshal.js`.
The cycle's own pick step (verify candidate against bare clone
before committing) caught the misnaming — same lesson as cycle
73's `chat-emoji-render` near-miss. The recurring pattern is
that prompt-authors writing several cycles in advance can drift
on exact filenames; the bare-clone verification step is doing
real work and should be kept as a step-3 explicit precondition
in future cycles' prompts.

Self-improvement: nothing this time — the bare-clone
verification caught the make-marshal.js vs marshal.js drift the
same way cycle 73's verification caught chat-emoji-render. The
discipline already in place is sufficient; the cycle-73
self-improvement lesson covers this class of slip and remains
the canonical lesson.
