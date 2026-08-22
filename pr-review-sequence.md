# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-08-22 (03:54 UTC), refreshed from the API. **293 open** (was
286 on 08-01); 174 draft, 52 changes-requested; **100 merged since the prior
snapshot**. Read "Awaiting your decision" first — it is the only section that
cannot advance without you — then "Review now", then the per-arc state._

_Mergeability caveat: GitHub computes `mergeable` lazily. This refresh queried
every open pull request individually and then re-probed every initial `UNKNOWN`:
166 are MERGEABLE and 127 are CONFLICTING. The conflict count is therefore a
full live census, not a floor._

## Awaiting your decision

Work that is **finished, directed, or at a fork in the road and cannot move
without a maintainer act**. This is the shortest path from held work to landed
work.

### One approval is still current: unfreeze and land the OAuth design

[`#621`](https://github.com/endojs/endo-but-for-bots/pull/621) is APPROVED at its
current head `ee359efb57`, MERGEABLE/CLEAN, and non-draft. It remains on frozen
base `llm-28dffa9`; five checks pass and four are cancelled artifacts of that
base. It needs an unfreeze/rebase, the resulting approval refresh if the head
moves, and conduct. It is the design gate for the connector-credential OAuth
line.

### Passable byte arrays: choose the landing line after the campaign

[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) is now the broad,
integrated line. Since the prior snapshot the maintainer-directed campaign:

- advanced it from a stale frozen base to a fresh `llm` snapshot and retconned
  the history;
- consolidated `frozenBytes` and `thawedBytes` in
  `@endo/immutable-arraybuffer`, carrying the change through bytes, marshal,
  OCapN, thixotrope, pass-style, docs, types, and changesets;
- completed DataView emulation and added hardened262, test262, XS, SES, bytes,
  and pass-style coverage, including the requested TextEncoder/TextDecoder
  intersection matrix;
- passed an incremental panel with no production must-fix.

It is now non-draft, MERGEABLE/CLEAN, and 27/27 green at head `4dbe5ffff6`.
The latest human state remains CHANGES_REQUESTED, but the requested work was
pushed after that review and further review comments were answered through the
current head. The shortest path is a fresh human pass on
[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475), then a decision to
close or explicitly retain the older
[`#503`](https://github.com/endojs/endo-but-for-bots/pull/503) line. The latter is
also green and MERGEABLE but has not moved since July, remains
CHANGES_REQUESTED, and still targets `master-a7ff191`.

[`#572`](https://github.com/endojs/endo-but-for-bots/pull/572), the view-model
design of record, is now CONFLICTING. The comparison implementation
[`#602`](https://github.com/endojs/endo-but-for-bots/pull/602) remains a clean,
green draft. These should be disposed with the landing decision rather than
sent through independent review loops.

### OCapN transport: fixes are green; one identity direction remains

[`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) lost its July
approval after a live-base conduct attempt exposed a Linux regression and a
later maintainer review requested six changes. All six were addressed; the
current head `b24aaee614` is non-draft, MERGEABLE, and 27/27 green. It now needs
re-review. One substantive choice remains from that review: keep the persistent
agent-identity attestation above the authenticated Noise peer key, or thread the
Noise peer identity upward and bind at the network layer. A ruling plus a fresh
approval releases the OCapN stack.

### Gateway admin stack: re-land the missing predecessor, or retire the line

[`#389`](https://github.com/endojs/endo-but-for-bots/pull/389) still reports
APPROVED and green, but its approval is stale and its base is the dead
`design/gateway-package-phase-2` branch. The phase-2 predecessor closed without
merging, so conducting this PR would land nothing on `llm`. Decide whether to
re-land phase 2 and restack the gateway series bottom-up, or retire the series.

### Two old approvals need explicit recovery

- [`#89`](https://github.com/endojs/endo-but-for-bots/pull/89), the
  genie-integration design, is 4/4 green and MERGEABLE, but its approval is on
  an old head. Unfreezing it conflicts semantically in the design index; it
  needs a weave and a light re-review.
- [`#132`](https://github.com/endojs/endo-but-for-bots/pull/132), the per-message
  Md/Raw/Pre toggle, is 23/23 green and MERGEABLE after reconstruction in
  `@endo/space-chat`. Its approval predates the current head. The requested
  gauntlet → retcon → conduct chain halted on an obsolete pre-reconstruction
  clean-stage failure and is now parked; choose whether to resume that chain or
  close and reopen the work cleanly.

### The remaining either-or decision

[`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) is the frozen
`master` Docker lane (15/15) while
[`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) is the authenticated
remote-gateway line (23/23). Both are ready and green; pick the canonical line.

The URL split is no longer an open decision:
[`#719`](https://github.com/endojs/endo-but-for-bots/pull/719) closed on 08-21,
leaving [`#263`](https://github.com/endojs/endo-but-for-bots/pull/263) as the
surviving universal-intrinsic implementation.

## Review now (cross-arc priority queue)

The prior queue was mostly consumed: five of its top entries merged
([`#885`](https://github.com/endojs/endo-but-for-bots/pull/885),
[`#898`](https://github.com/endojs/endo-but-for-bots/pull/898),
[`#652`](https://github.com/endojs/endo-but-for-bots/pull/652),
[`#656`](https://github.com/endojs/endo-but-for-bots/pull/656), and the earlier
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) dependency
[`#713`](https://github.com/endojs/endo-but-for-bots/pull/713)). The current
short queue is:

1. [`#1029`](https://github.com/endojs/endo-but-for-bots/pull/1029) — **new**:
   durable workflow system, statechart kernel, journaled runs, and chat space.
   Non-draft, MERGEABLE/CLEAN, 26/26, no human review.
2. [`#946`](https://github.com/endojs/endo-but-for-bots/pull/946) — **new**:
   test262 fixture consolidation and parameterized expectation lists.
   Non-draft, MERGEABLE/CLEAN, 26/26, no human review.
3. [`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) — authenticated
   remote-gateway Docker self-hosting, 23/23. This also resolves the Docker
   either-or above if selected.
4. [`#319`](https://github.com/endojs/endo-but-for-bots/pull/319) — Familiar
   cross-platform icon projection automation and CI verification, 27/27.
5. [`#603`](https://github.com/endojs/endo-but-for-bots/pull/603) — browser
   WASM/WebGPU voice-package scaffold, 25/25.

Also green, non-draft, and carried unreviewed:
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) unbounded stream
buffer 23/23,
[`#825`](https://github.com/endojs/endo-but-for-bots/pull/825) sorted persistent
collection stores 21/21,
[`#764`](https://github.com/endojs/endo-but-for-bots/pull/764) global-intrinsics
caching 15/15,
[`#779`](https://github.com/endojs/endo-but-for-bots/pull/779) cyclic star export
15/15,
[`#883`](https://github.com/endojs/endo-but-for-bots/pull/883) rerere fixture
22/22, and
[`#847`](https://github.com/endojs/endo-but-for-bots/pull/847) `master` CI baseline
14/14.

**Not review-ready:**
[`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) is MERGEABLE but
UNSTABLE (26/27, one cancelled; a shepherd is queued);
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) is MERGEABLE but
UNSTABLE (25/26, one failing);
[`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) and
[`#887`](https://github.com/endojs/endo-but-for-bots/pull/887) are CONFLICTING;
the Google Sheets follow-on
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) remains a
CONFLICTING draft.

## Arcs in progress

### Passable byte arrays ([kriscendobot/garden#48](https://github.com/kriscendobot/garden/issues/48)) — campaign complete, awaiting review

The integrated state and landing choice are in "Awaiting your decision" above.
The registry plumbing
[`#671`](https://github.com/endojs/endo-but-for-bots/pull/671) is merged; its
immutable-byte consumer
[`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) remains a clean,
green draft on a frozen SHA-256 base. The range consumer
[`#910`](https://github.com/endojs/endo-but-for-bots/pull/910) merged 08-20; its
base64 cleanup follow-up is correctly blocked on the byte-array landing.

### OCapN-over-Noise ([kriscendobot/garden#49](https://github.com/kriscendobot/garden/issues/49)) — re-review at the root

The root transport
[`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) is green after its
review fixes. Down-stack,
[`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) and
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) are CONFLICTING;
[`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) and
[`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) remain clean green
drafts. The codec migration
[`#885`](https://github.com/endojs/endo-but-for-bots/pull/885) and typed remote
session work
[`#952`](https://github.com/endojs/endo-but-for-bots/pull/952) merged in this
window. Review and land the root before restacking the demos.

### npm-via-CAS registry proxy ([kriscendobot/garden#56](https://github.com/kriscendobot/garden/issues/56)) — the ruling landed; finish the tail

The prior architecture question was answered by
[`#944`](https://github.com/endojs/endo-but-for-bots/pull/944): move Endor package
mapping into an XS-hosted JavaScript worker over Rust-acquired CAS trees. In the
same window, package imports
[`#875`](https://github.com/endojs/endo-but-for-bots/pull/875), runtime conditions
and webcrypto
[`#876`](https://github.com/endojs/endo-but-for-bots/pull/876), URL endowments
[`#878`](https://github.com/endojs/endo-but-for-bots/pull/878), and the
EndoRegistry capability
[`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) all merged.

The remaining feature
[`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) is CONFLICTING and
has one failing check. The old runtime-identity proposal
[`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) is also
CONFLICTING and predates the decisions now embodied in the landed implementation;
refresh or close it rather than reviewing it as-is. The older transport design
[`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) has likewise gone
CONFLICTING.

### VFS tool-call parity ([kriscendobot/garden#53](https://github.com/kriscendobot/garden/issues/53)) — core tracked work landed

[`#656`](https://github.com/endojs/endo-but-for-bots/pull/656) and
[`#652`](https://github.com/endojs/endo-but-for-bots/pull/652) merged in this
window, joining
[`#713`](https://github.com/endojs/endo-but-for-bots/pull/713) and
[`#714`](https://github.com/endojs/endo-but-for-bots/pull/714). The remaining
panel-fix bundle
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) is one red check
from returning to review. The Rust parity runner
[`#654`](https://github.com/endojs/endo-but-for-bots/pull/654) remains a green
draft with 23 passes and 23 cancelled checks on a closed stack base.

### SturdyRef system ([kriscendobot/garden#47](https://github.com/kriscendobot/garden/issues/47)) — restacked, still paused

The bridge cuts were refreshed on 08-13.
[`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) and
[`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) are clean and green;
[`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) is UNSTABLE;
the underlying design
[`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) and agent surface
[`#871`](https://github.com/endojs/endo-but-for-bots/pull/871) are CONFLICTING.
The first-class pass-style and later bridge cuts remain drafts. The press is
paused and the arc still needs the maintainer discussion before another large
gauntlet run.

### Daemon data plane ([kriscendobot/garden#50](https://github.com/kriscendobot/garden/issues/50)) — tracked implementation resolved

The tracked content-store and write-path work
([`#662`](https://github.com/endojs/endo-but-for-bots/pull/662),
[`#585`](https://github.com/endojs/endo-but-for-bots/pull/585), and
[`#739`](https://github.com/endojs/endo-but-for-bots/pull/739)) is merged.
[`#647`](https://github.com/endojs/endo-but-for-bots/pull/647), the streaming
mount-search design, remains a clean draft with CHANGES_REQUESTED; it is a design
follow-on, not a landing blocker for the completed tracked implementation.

### Endor xs2rust ([kriscendobot/garden#51](https://github.com/kriscendobot/garden/issues/51)) — original engine landed

[`#600`](https://github.com/endojs/endo-but-for-bots/pull/600) merged 08-06. The
arc has since expanded rapidly through test262 reporting, snapshot storage,
debugger design, and store-backed heaps, but those are successor work rather
than review blockers for the original tracked PR. The compartment-mapper ruling
now has an explicit boundary: Rust acquires CAS trees; the JS worker owns package
mapping.

### Git integration + Endor bindings ([kriscendobot/garden#52](https://github.com/kriscendobot/garden/issues/52)) — complete, with successors landing

All originally tracked artifacts remain merged. In this window the successor
line added facet catalogs and recovery
([`#646`](https://github.com/endojs/endo-but-for-bots/pull/646)), normalized remote
policy
([`#929`](https://github.com/endojs/endo-but-for-bots/pull/929)), streaming status
([`#959`](https://github.com/endojs/endo-but-for-bots/pull/959)), worktree-relative
designators
([`#974`](https://github.com/endojs/endo-but-for-bots/pull/974)), linked worktrees
([`#960`](https://github.com/endojs/endo-but-for-bots/pull/960)), and help surfaces
([`#1022`](https://github.com/endojs/endo-but-for-bots/pull/1022)). The parked
stack-surgery eval
[`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) is still a failing
draft, not active arc work.

### Finbot ([kriscendobot/garden#54](https://github.com/kriscendobot/garden/issues/54))

[`kriscendobot/finbot#7`](https://github.com/kriscendobot/finbot/pull/7) is
non-draft, MERGEABLE/CLEAN, and 1/1 green with no review. The inference-driven
observe stage
[`kriscendobot/finbot#5`](https://github.com/kriscendobot/finbot/pull/5) and
data-sufficiency gate
[`kriscendobot/finbot#6`](https://github.com/kriscendobot/finbot/pull/6) are also
green and mergeable but remain drafts. Their panel/fix jobs are parked; no live
press is advancing them.

### Compartments proposal ([kriscendobot/garden#61](https://github.com/kriscendobot/garden/issues/61)) — spec advances; native proof remains gated

JavaScriptCore and Endor validation reports
([`kriscendobot/proposal-compartments#1`](https://github.com/kriscendobot/proposal-compartments/pull/1)
and
[`kriscendobot/proposal-compartments#3`](https://github.com/kriscendobot/proposal-compartments/pull/3))
merged in this window. The V8 semantic harness
[`kriscendobot/proposal-compartments#2`](https://github.com/kriscendobot/proposal-compartments/pull/2)
and synchronous-import deferral annex
[`kriscendobot/proposal-compartments#4`](https://github.com/kriscendobot/proposal-compartments/pull/4)
are clean, green drafts. Native V8, JSC, XS, and Endor proof remains blocked on
source-phase-import parser/runtime support; no test262 PR is open yet.

### Google Sheets

[`#874`](https://github.com/endojs/endo-but-for-bots/pull/874) remains a clean,
green draft. Its attenuated-facets successor
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) is CONFLICTING.
The network and OAuth floor improved because the registry capability
[`#403`](https://github.com/endojs/endo-but-for-bots/pull/403) merged; the approved
credential design
[`#621`](https://github.com/endojs/endo-but-for-bots/pull/621) is now the explicit
next gate.

## Blocked on the garden, not on review

A distinct class: PRs whose review state is not the immediate obstacle.

- [`#132`](https://github.com/endojs/endo-but-for-bots/pull/132) has the
  maintainer's explicit wrap-up directive, but the journal chain is parked behind
  a failed pre-reconstruction gauntlet record. The live PR is green; the board
  needs reconciliation before the directive can finish.
- [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) has a queued
  shepherd for its cancelled check.
- [`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) has parked fix and
  weave jobs, but no active owner while it remains one check red.
- The base64 cleanup requested during
  [`#910`](https://github.com/endojs/endo-but-for-bots/pull/910) is correctly
  blocked on [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475), not on
  another review of the already-merged range work.

The daily arc-status schedule and all eight associated arc presses have remained
paused since 08-01. This snapshot is a one-shot catch-up; nothing was unpaused.
Given the 100-merge drift in three weeks, it is worth asking separately whether a
lower-frequency automated refresh should replace the former press cadence.

## Newly landed since the prior snapshot

**100 pull requests merged after the 2026-08-01 15:20 UTC snapshot.** The
review-sequence-changing landings are:

- npm/Endor: [`#875`](https://github.com/endojs/endo-but-for-bots/pull/875),
  [`#876`](https://github.com/endojs/endo-but-for-bots/pull/876),
  [`#878`](https://github.com/endojs/endo-but-for-bots/pull/878),
  [`#944`](https://github.com/endojs/endo-but-for-bots/pull/944),
  [`#403`](https://github.com/endojs/endo-but-for-bots/pull/403), and
  [`#903`](https://github.com/endojs/endo-but-for-bots/pull/903);
- VFS/platform/daemon: [`#652`](https://github.com/endojs/endo-but-for-bots/pull/652),
  [`#656`](https://github.com/endojs/endo-but-for-bots/pull/656),
  [`#910`](https://github.com/endojs/endo-but-for-bots/pull/910),
  [`#920`](https://github.com/endojs/endo-but-for-bots/pull/920),
  [`#926`](https://github.com/endojs/endo-but-for-bots/pull/926),
  [`#941`](https://github.com/endojs/endo-but-for-bots/pull/941), and
  [`#1033`](https://github.com/endojs/endo-but-for-bots/pull/1033);
- Ironhorse: [`#600`](https://github.com/endojs/endo-but-for-bots/pull/600),
  [`#963`](https://github.com/endojs/endo-but-for-bots/pull/963),
  [`#969`](https://github.com/endojs/endo-but-for-bots/pull/969),
  [`#975`](https://github.com/endojs/endo-but-for-bots/pull/975),
  [`#998`](https://github.com/endojs/endo-but-for-bots/pull/998), and
  [`#1026`](https://github.com/endojs/endo-but-for-bots/pull/1026);
- Git/capability surfaces: [`#646`](https://github.com/endojs/endo-but-for-bots/pull/646),
  [`#906`](https://github.com/endojs/endo-but-for-bots/pull/906),
  [`#929`](https://github.com/endojs/endo-but-for-bots/pull/929),
  [`#948`](https://github.com/endojs/endo-but-for-bots/pull/948),
  [`#958`](https://github.com/endojs/endo-but-for-bots/pull/958),
  [`#959`](https://github.com/endojs/endo-but-for-bots/pull/959),
  [`#960`](https://github.com/endojs/endo-but-for-bots/pull/960),
  [`#962`](https://github.com/endojs/endo-but-for-bots/pull/962),
  [`#973`](https://github.com/endojs/endo-but-for-bots/pull/973),
  [`#974`](https://github.com/endojs/endo-but-for-bots/pull/974), and
  [`#1022`](https://github.com/endojs/endo-but-for-bots/pull/1022);
- agent/code-mode surfaces: [`#902`](https://github.com/endojs/endo-but-for-bots/pull/902),
  [`#905`](https://github.com/endojs/endo-but-for-bots/pull/905),
  [`#907`](https://github.com/endojs/endo-but-for-bots/pull/907),
  [`#924`](https://github.com/endojs/endo-but-for-bots/pull/924),
  [`#925`](https://github.com/endojs/endo-but-for-bots/pull/925),
  [`#932`](https://github.com/endojs/endo-but-for-bots/pull/932),
  [`#956`](https://github.com/endojs/endo-but-for-bots/pull/956),
  [`#957`](https://github.com/endojs/endo-but-for-bots/pull/957),
  [`#961`](https://github.com/endojs/endo-but-for-bots/pull/961),
  [`#965`](https://github.com/endojs/endo-but-for-bots/pull/965),
  and [`#1021`](https://github.com/endojs/endo-but-for-bots/pull/1021);
- review-queue and dependency items:
  [`#836`](https://github.com/endojs/endo-but-for-bots/pull/836),
  [`#856`](https://github.com/endojs/endo-but-for-bots/pull/856),
  [`#867`](https://github.com/endojs/endo-but-for-bots/pull/867),
  [`#885`](https://github.com/endojs/endo-but-for-bots/pull/885),
  [`#898`](https://github.com/endojs/endo-but-for-bots/pull/898), and
  [`#942`](https://github.com/endojs/endo-but-for-bots/pull/942).

The other landings are maintenance, dependency, CI, test, design-grooming, and
incremental feature PRs; they are included in the 100 count but omitted here to
keep this a review sequence rather than a changelog.

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
is still open and MERGEABLE with no review. Its old CI rollup is now explicitly
UNSTABLE: the two Hermes multichain legs failed while the remaining substantive
checks passed or skipped. The decision is unchanged: larger runners for the
resource-heavy multichain legs, make them non-required on the fork, or perform a
dedicated infra-tuning pass.

Upstream `agoric/agoric-sdk` stays comment-and-link-free; experimentation remains
confined to the bot fork.

## Scope

**293 open pull requests.** This is the curated maintainer sequence for current
arc work and garden-unblocking edges, not an assertion that the remaining long
tail is review-ready.

The headline since 08-01 is conversion at scale: 100 merges, including the
original xs2rust engine, the VFS core, the npm runtime-condition work, the
compartment-mapper ruling, the registry capability, SHA-256 succession, and the
ReadableBlob range system. The bottleneck is now concentrated in three places:
human re-review of large repaired roots
([`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) and
[`#340`](https://github.com/endojs/endo-but-for-bots/pull/340)), recovery of
stale approvals and frozen/dead bases, and paused garden chains that no longer
match the live PR state.
