# PR-review sequence: `endojs/endo-but-for-bots`

_Live snapshot: 2026-08-27 (18:05 UTC), refreshed from the GitHub API. **287
open** (was 293 on 08-22); 170 draft, 48 changes-requested; **17 merged since
the prior snapshot**. Read "Awaiting your decision" first, then "Review now",
then the per-arc state._

_Mergeability caveat: GitHub computes `mergeable` lazily. This refresh queried
all open pull requests and individually re-probed all 85 initial `UNKNOWN`
results twice: 156 are MERGEABLE and 131 are CONFLICTING. The conflict count is
a full live census, not a floor._

## Awaiting your decision

Work that is finished, explicitly directed, or at a real fork that cannot move
without a maintainer act.

### Two current approvals are held by frozen-base policy

- [`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046), Hardened262
  coverage agents for Ironhorse, is non-draft, APPROVED at current head
  `6176dba196`, MERGEABLE/CLEAN, and 26/26 green. Conduct correctly stopped
  because it shares frozen base `llm-e22e67a` with open
  [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475). Decide whether
  to move the two independently or advance their shared snapshot together.
- [`#1061`](https://github.com/endojs/endo-but-for-bots/pull/1061), the marshal
  public-type declaration refactor, is APPROVED, MERGEABLE/CLEAN, and 14/14
  green at head `f5b159eb7d`. It targets frozen `master-8c402ee`, so the garden's
  `llm` conductor will not merge it. It needs the frozen-master ferry path or an
  explicit retargeting decision.

The other open approval is not ready to land:
[`#461`](https://github.com/endojs/endo-but-for-bots/pull/461) remains a draft
with four failures on an old frozen base.

### Passable byte arrays: final re-review is in flight

[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) is the sole
surviving implementation line. The older
[`#503`](https://github.com/endojs/endo-but-for-bots/pull/503), the view-model
design [`#572`](https://github.com/endojs/endo-but-for-bots/pull/572), and the
comparison implementation
[`#602`](https://github.com/endojs/endo-but-for-bots/pull/602) have all closed.

The latest seven-thread response restored constant-time equality and SES test
configurations, shared the indexed-byte helper, removed redundant TypeScript
directives, and avoided a workspace dependency cycle. Local focused tests and
lint passed. At snapshot time head `4795821262` is MERGEABLE with 26 checks
green and one newly failed; GitHub reports UNSTABLE. The human state remains
CHANGES_REQUESTED and review has been re-requested. The failing check must be
shepherded before a fresh human pass becomes the remaining landing gate.

### Gateway admin stack: restore the missing predecessor or retire the line

[`#389`](https://github.com/endojs/endo-but-for-bots/pull/389) is APPROVED and
26/26 green but now CONFLICTING. Its base is the dead
`design/gateway-package-phase-2` branch, whose predecessor closed without
merging. Re-land phase 2 and restack the gateway series bottom-up, or retire the
series. The approval alone cannot make the current branch land meaningful work.

### Docker self-hosting still has two canonical lines

[`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) is the frozen
`master` Docker lane (15/15), while
[`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) is the
authenticated remote-gateway line (23/23). Both are non-draft,
MERGEABLE/CLEAN, green, and unreviewed. Pick the canonical line.

### Four earlier decision gates are resolved

- OAuth design [`#621`](https://github.com/endojs/endo-but-for-bots/pull/621)
  merged on 08-25.
- OCapN-over-Noise root
  [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340) merged on 08-25.
- Chat render modes
  [`#132`](https://github.com/endojs/endo-but-for-bots/pull/132) merged on 08-23.
- Genie integration retrospective
  [`#89`](https://github.com/endojs/endo-but-for-bots/pull/89) merged on 08-27.

These supersede the prior snapshot's unfreeze, identity-direction, stale-chain,
and design-index recovery decisions.

## Review now (cross-arc priority queue)

The prior top two entries,
[`#1029`](https://github.com/endojs/endo-but-for-bots/pull/1029) and
[`#946`](https://github.com/endojs/endo-but-for-bots/pull/946), are now
CONFLICTING and have moved out of the ready queue. The current short queue is:

1. [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877): Endor
   dual-build npm execution. Conflict resolution, review fixes, and CI are
   complete at head `1199cbe4f1`; non-draft, MERGEABLE/CLEAN, 28/28 green. Its
   conductor stopped only because the rewritten head has no current approval.
2. [`#796`](https://github.com/endojs/endo-but-for-bots/pull/796): hashline edit
   core plus `@endo/crc32`. Six panel/fix rounds, retcon, and a live-`llm`
   rebase are complete; non-draft, MERGEABLE/CLEAN, 28 current successes. The
   final shepherd exceeded its handler budget and conduct stayed parked, so a
   human review is the useful next act.
3. [`#1049`](https://github.com/endojs/endo-but-for-bots/pull/1049): owner-PID
   watchdog for orphaned test daemons. Non-draft, MERGEABLE/CLEAN, 25/25 green,
   no human review.
4. [`#1038`](https://github.com/endojs/endo-but-for-bots/pull/1038): document
   and gate the silent `setExceptionBreakMode('uncaught')` no-op. Non-draft,
   MERGEABLE/CLEAN, 25/25 green, no human review.
5. [`#977`](https://github.com/endojs/endo-but-for-bots/pull/977): pin the guest
   host-authority boundary. Non-draft, MERGEABLE/CLEAN, 25/25 green, no human
   review.

Also green, non-draft, and carried unreviewed:
[`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) authenticated
remote gateway 23/23,
[`#319`](https://github.com/endojs/endo-but-for-bots/pull/319) Familiar icon
projection 27/27,
[`#603`](https://github.com/endojs/endo-but-for-bots/pull/603) browser voice
scaffold 25/25,
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) unbounded stream
buffer 23/23,
[`#825`](https://github.com/endojs/endo-but-for-bots/pull/825) sorted persistent
stores 21/21,
[`#764`](https://github.com/endojs/endo-but-for-bots/pull/764) global-intrinsics
cache 15/15,
[`#779`](https://github.com/endojs/endo-but-for-bots/pull/779) cyclic star
export 15/15,
[`#883`](https://github.com/endojs/endo-but-for-bots/pull/883) rerere fixture
22/22, and
[`#847`](https://github.com/endojs/endo-but-for-bots/pull/847) `master` CI
baseline 14/14.

**Not review-ready:**
[`#1029`](https://github.com/endojs/endo-but-for-bots/pull/1029),
[`#946`](https://github.com/endojs/endo-but-for-bots/pull/946),
[`#887`](https://github.com/endojs/endo-but-for-bots/pull/887), and
[`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) are CONFLICTING;
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) has one failing
check;
[`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) is a draft with
fresh CI still running;
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) and
[`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) are drafts with
one and two failures respectively.

## Arcs in progress

### Passable byte arrays ([garden issue 48](https://github.com/kriscendobot/garden/issues/48)): one live landing line

The integrated state is in "Awaiting your decision" above. The competing PRs
are closed, so no second implementation line needs independent review.
Registry consumer
[`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) remains a
MERGEABLE draft on an old SHA-256 base with two failures. Its base64 cleanup
follow-up and the passable-byte work parked behind
[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) should remain
blocked until the root lands.

### OCapN-over-Noise ([garden issue 49](https://github.com/kriscendobot/garden/issues/49)): root landed, restack the demonstrations

Root transport [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340)
merged with 28 green checks. Down-stack,
[`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) and
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) are CONFLICTING;
[`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) and
[`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) remain clean,
green drafts on their stack branches. The former root review gate is gone. The
next arc action is to restack or retire the demonstrations in dependency order.

### npm-via-CAS registry proxy ([garden issue 56](https://github.com/kriscendobot/garden/issues/56)): review the repaired tail

The architecture ruling and most implementation layers are merged. Remaining
feature [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) is now
MERGEABLE/CLEAN and 28/28 green after its full review response. It should lead
this arc's review. Old runtime-identity proposal
[`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) and transport
design [`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) remain
CONFLICTING and predate the landed decisions; refresh or close them instead of
reviewing them as current designs.

### VFS tool-call parity ([garden issue 53](https://github.com/kriscendobot/garden/issues/53)): core landed, one red follow-up

The tracked VFS core remains merged. Panel-fix bundle
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) is MERGEABLE but
has one repeatable failing check. Rust parity runner
[`#654`](https://github.com/endojs/endo-but-for-bots/pull/654) remains a green
draft with 23 passes and 23 cancelled checks on a closed stack base. Neither is
ready for maintainer review today.

### SturdyRef system ([garden issue 47](https://github.com/kriscendobot/garden/issues/47)): paused after the bridge restack

Bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) and
[`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) are clean and
green drafts. Read-side cut
[`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) has one failure;
design [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) and agent
surface [`#871`](https://github.com/endojs/endo-but-for-bots/pull/871) are
CONFLICTING. The arc still needs the maintainer discussion before another broad
gauntlet run.

### Daemon data plane ([garden issue 50](https://github.com/kriscendobot/garden/issues/50)): tracked implementation complete

The tracked content-store and write-path work remains merged. Streaming
mount-search design
[`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) is a MERGEABLE
draft with CHANGES_REQUESTED and five green checks. It is a follow-on, not a
landing blocker for the completed data-plane work.

### Endor and Ironhorse ([garden issue 51](https://github.com/kriscendobot/garden/issues/51)): three review gates

The original Ironhorse engine is merged. Current review edges are now:

- approved Hardened262 coverage PR
  [`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046), held by the
  shared frozen base;
- green `@endo/crc32` and hashline PR
  [`#796`](https://github.com/endojs/endo-but-for-bots/pull/796), whose automated
  merge chain halted at the shepherd budget;
- green dual-build npm execution PR
  [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877), which needs a
  current approval after its rewritten head.

Fixture-parity walker
[`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) is being woven and
gauntleted now; it remains draft while that loop runs. This supersedes the prior
snapshot's description of the arc as merely an expanded successor set.

### Git integration and Endor bindings ([garden issue 52](https://github.com/kriscendobot/garden/issues/52)): original scope complete

All originally tracked artifacts remain merged. Validated Git CAS blob-store PR
[`#872`](https://github.com/endojs/endo-but-for-bots/pull/872) merged in this
window. Root-advancement design
[`#889`](https://github.com/endojs/endo-but-for-bots/pull/889) has since been
refreshed and made mergeable, but it is successor design work rather than a
blocker for the completed original arc. Stack-surgery eval
[`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) is now a clean,
green draft.

### Finbot ([garden issue 54](https://github.com/kriscendobot/garden/issues/54))

[`kriscendobot/finbot#7`](https://github.com/kriscendobot/finbot/pull/7) is
non-draft, MERGEABLE/CLEAN, and 1/1 green with no review. Inference-driven
observe [`kriscendobot/finbot#5`](https://github.com/kriscendobot/finbot/pull/5)
and the data-sufficiency gate
[`kriscendobot/finbot#6`](https://github.com/kriscendobot/finbot/pull/6) are
green, mergeable drafts. Their panel/fix jobs remain parked.

### Compartments proposal ([garden issue 61](https://github.com/kriscendobot/garden/issues/61)): native proof remains gated

JavaScriptCore and Endor validation reports
([`kriscendobot/proposal-compartments#1`](https://github.com/kriscendobot/proposal-compartments/pull/1)
and
[`kriscendobot/proposal-compartments#3`](https://github.com/kriscendobot/proposal-compartments/pull/3))
remain merged. V8 semantic harness
[`kriscendobot/proposal-compartments#2`](https://github.com/kriscendobot/proposal-compartments/pull/2)
and synchronous-import deferral annex
[`kriscendobot/proposal-compartments#4`](https://github.com/kriscendobot/proposal-compartments/pull/4)
are clean, green drafts. Native V8, JSC, XS, and Endor proof remains blocked on
source-phase-import parser and runtime support.

### Google Sheets

Portable client [`#874`](https://github.com/endojs/endo-but-for-bots/pull/874)
remains a clean, green draft. Attenuated-facets successor
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) is now MERGEABLE
rather than CONFLICTING, but one check fails. OAuth design
[`#621`](https://github.com/endojs/endo-but-for-bots/pull/621) has merged, so the
credential design floor is no longer a review blocker.

## Blocked on garden execution, not on review

- [`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046) is approved
  and green; the shared-frozen-base guard, not review quality, blocks conduct.
- [`#796`](https://github.com/endojs/endo-but-for-bots/pull/796) is green after
  its live-base rebase; a 2,400-second shepherd budget expiration halted its
  three-child orchestration before conduct.
- [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) is in a fresh
  weave and gauntlet cycle; current pending checks are expected execution state.
- [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) has one fresh CI
  failure after the latest review response and needs shepherding before re-review.

The former daily arc-status schedule remains paused. This refresh did not alter
any schedule.

## Newly landed since the prior snapshot

**17 pull requests merged after 2026-08-22 03:54 UTC:**

- [`#1048`](https://github.com/endojs/endo-but-for-bots/pull/1048), upstream
  master integration;
- [`#398`](https://github.com/endojs/endo-but-for-bots/pull/398), streaming tree
  clone;
- [`#132`](https://github.com/endojs/endo-but-for-bots/pull/132), chat render
  modes;
- [`#872`](https://github.com/endojs/endo-but-for-bots/pull/872), validated Git
  CAS blob store;
- [`#621`](https://github.com/endojs/endo-but-for-bots/pull/621), OAuth connector
  credential design;
- [`#970`](https://github.com/endojs/endo-but-for-bots/pull/970), Ironhorse JS
  completion;
- [`#340`](https://github.com/endojs/endo-but-for-bots/pull/340), OCapN-over-Noise
  transport;
- [`#1058`](https://github.com/endojs/endo-but-for-bots/pull/1058), hardener
  indexed-cardinality design;
- [`#89`](https://github.com/endojs/endo-but-for-bots/pull/89), genie-integration
  retrospective;
- [`#1060`](https://github.com/endojs/endo-but-for-bots/pull/1060), Ironhorse
  async-generator intrinsic metadata;
- maintenance PRs
  [`#1050`](https://github.com/endojs/endo-but-for-bots/pull/1050),
  [`#1051`](https://github.com/endojs/endo-but-for-bots/pull/1051),
  [`#1052`](https://github.com/endojs/endo-but-for-bots/pull/1052),
  [`#1053`](https://github.com/endojs/endo-but-for-bots/pull/1053),
  [`#1054`](https://github.com/endojs/endo-but-for-bots/pull/1054),
  [`#1056`](https://github.com/endojs/endo-but-for-bots/pull/1056), and
  [`#1057`](https://github.com/endojs/endo-but-for-bots/pull/1057).

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
is still open and MERGEABLE with no review. Its old CI rollup remains UNSTABLE:
73 successes, 12 skips, and two failed Hermes multichain legs. The decision is
unchanged: supply larger runners, make the resource-heavy legs non-required on
the fork, or perform a dedicated infrastructure-tuning pass.

Upstream `agoric/agoric-sdk` stays comment-and-link-free; experimentation remains
confined to the bot fork.

## Scope and refresh provenance

**287 open pull requests.** This is the curated maintainer sequence for current
arc work and garden-unblocking edges, not an assertion that the remaining long
tail is review-ready.

The abandoned `refresh-pr-review-sequence-20260823` job made five short attempts
and never produced a document commit. Its durable specification was recovered
from `jobs/plan/`: individually re-probe lazy mergeability, account for every
post-08-22 merge, re-check the OAuth and byte-array gates, retain the established
section structure, validate canonical links, and leave schedules untouched.
Those requirements are applied here. Its forecasted merger list was superseded
by the live API census above; its useful rigor and scope survived.
