# PR-review sequence: `endojs/endo-but-for-bots`

_Live snapshot: 2026-08-31 (18:15 UTC), refreshed from the GitHub API. **284
open** (was 287 on 08-27); 171 draft (was 170), 52 changes-requested (was 48),
**26 merged and 12 closed without merge since the prior snapshot**. Read
"Awaiting your decision" first, then "Review now", then the per-arc state._

_Mergeability caveat: GitHub computes `mergeable` lazily. This refresh queried
all open pull requests and individually re-probed all 30 initial `UNKNOWN`
results twice: 162 are MERGEABLE (was 156) and 122 are CONFLICTING (was 131).
The conflict count is a full live census, not a floor. Four initially unknown
PRs in the other tracked repositories were likewise re-probed twice._

## Awaiting your decision

Work that is finished, explicitly directed, or at a real fork that cannot move
without a maintainer act.

### The frozen-base approvals split has resolved; one frozen-master approval remains

The shared `llm-e22e67a` decision is retired. Hardened262 coverage
[`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046) merged on 08-28,
and passable byte arrays
[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) merged on 08-30.
They no longer share an open frozen base and need no joint disposition.

[`#1061`](https://github.com/endojs/endo-but-for-bots/pull/1061), the marshal
public-type declaration refactor, is still APPROVED, MERGEABLE/CLEAN, and 14/14
green at head `0be9359063`. It still targets frozen `master-8c402ee`, so the
garden's live-`llm` conductor cannot land it. Choose the frozen-master ferry
path or explicitly retarget it.

The only other open primary-repo approval is
[`#461`](https://github.com/endojs/endo-but-for-bots/pull/461), still a draft on
an old frozen base with four failures; it is not ready to land.

### Gateway admin stack: restore the missing predecessor or retire the line

[`#389`](https://github.com/endojs/endo-but-for-bots/pull/389) remains APPROVED
and 26/26 green but CONFLICTING. Its base is the dead
`design/gateway-package-phase-2` line, whose predecessor closed without merging.
Re-land phase 2 and restack the gateway series bottom-up, or retire the series.
The current approval cannot make this branch land meaningful work by itself.

### Docker self-hosting still has two canonical lines

[`#608`](https://github.com/endojs/endo-but-for-bots/pull/608) is the frozen
`master` Docker lane (15/15), while
[`#694`](https://github.com/endojs/endo-but-for-bots/pull/694) is the
authenticated remote-gateway lane (23/23). Both remain non-draft,
MERGEABLE/CLEAN, green, and unreviewed. Pick the canonical line.

### Garden spelling design has five explicit open questions

[`kriscendobot/garden#75`](https://github.com/kriscendobot/garden/pull/75) is
the frozen review surface for the already-landed American-English normalization
design. It asks the maintainer to decide external-author scope, design-panel
membership, seed-rule ownership, blocking versus non-blocking disposition, and
the proposed names. The PR is a draft answer surface, not a merge vehicle; its
current check rollup is three successes and one failure. The follow-on build is
gated on those answers.

## Review now (cross-arc priority queue)

1. [`#1016`](https://github.com/endojs/endo-but-for-bots/pull/1016): Ironhorse
   panic-on-reference-error and rejection-handling design. Its six-round
   gauntlet completed and un-drafted it; MERGEABLE/CLEAN, 5/5 green, no human
   review.
2. [`#1075`](https://github.com/endojs/endo-but-for-bots/pull/1075):
   Hardened262 `%AsyncFunction%` intrinsic metadata coverage. The 08-31 weave
   resolved the conductor's genuine baseline conflict; current head
   `de2f852a89` is MERGEABLE/CLEAN and 24/24 green, but has no current approval.
3. [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877): Endor
   dual-build npm execution. Review fixes and CI remain complete at head
   `1199cbe4f1`; MERGEABLE/CLEAN, 28/28 green, no current approval.
4. [`#1049`](https://github.com/endojs/endo-but-for-bots/pull/1049): owner-PID
   watchdog for orphaned test daemons. MERGEABLE/CLEAN, 25/25 green, no review.
5. [`#1038`](https://github.com/endojs/endo-but-for-bots/pull/1038): document
   and gate the silent `setExceptionBreakMode('uncaught')` no-op. The current
   head postdates its old approval; MERGEABLE/CLEAN, 25/25 green, no current
   approval.
6. [`#977`](https://github.com/endojs/endo-but-for-bots/pull/977): pin the guest
   host-authority boundary. Its earlier conductor conflict has been repaired;
   current head `c49251a1cb` is MERGEABLE/CLEAN and 25/25 green, with no current
   approval.

Also green, non-draft, mergeable, and carried unreviewed:
[`#319`](https://github.com/endojs/endo-but-for-bots/pull/319) Familiar icon
projection (27/27),
[`#603`](https://github.com/endojs/endo-but-for-bots/pull/603) browser voice
scaffold (25/25),
[`#825`](https://github.com/endojs/endo-but-for-bots/pull/825) sorted persistent
stores (21/21),
[`#764`](https://github.com/endojs/endo-but-for-bots/pull/764) global-intrinsics
cache (15/15),
[`#779`](https://github.com/endojs/endo-but-for-bots/pull/779) cyclic star
export (15/15),
[`#883`](https://github.com/endojs/endo-but-for-bots/pull/883) rerere fixture
(22/22), and
[`#847`](https://github.com/endojs/endo-but-for-bots/pull/847) frozen-`master`
CI baseline (14/14).

**Not review-ready:**
[`#241`](https://github.com/endojs/endo-but-for-bots/pull/241) and
[`#264`](https://github.com/endojs/endo-but-for-bots/pull/264) are green and
non-draft but still have live panel rounds queued;
[`#356`](https://github.com/endojs/endo-but-for-bots/pull/356) has an active
shepherd, a queued fix, one failure, and six pending checks;
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) is green but now
CHANGES_REQUESTED;
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) and
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) each have one
failure; and
[`#1029`](https://github.com/endojs/endo-but-for-bots/pull/1029),
[`#946`](https://github.com/endojs/endo-but-for-bots/pull/946),
[`#887`](https://github.com/endojs/endo-but-for-bots/pull/887), and
[`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) remain
CONFLICTING.

## Arcs in progress

### Passable byte arrays ([garden issue 48](https://github.com/kriscendobot/garden/issues/48)): root landed; master transplant is fresh

The long re-review gate resolved when
[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) merged to `llm`
with 27 green checks. Fresh draft
[`#1099`](https://github.com/endojs/endo-but-for-bots/pull/1099) carries the
same narrowed byte-array work toward `master`; it is MERGEABLE with 17 green
checks and should remain in its ferry/validation lane rather than reopening the
resolved `llm` decision. Registry consumer
[`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) remains a
MERGEABLE draft on an old SHA-256 base with two failures.

### OCapN-over-Noise ([garden issue 49](https://github.com/kriscendobot/garden/issues/49)): root landed; protocol-hint implementation needs repair

The transport root remains merged. The one-hint-per-protocol design
[`#1071`](https://github.com/endojs/endo-but-for-bots/pull/1071) also merged in
this window; implementation
[`#1072`](https://github.com/endojs/endo-but-for-bots/pull/1072) is a
MERGEABLE draft with CHANGES_REQUESTED, 24 successes, and two failures.
Down-stack demonstrations
[`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) and
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) remain
CONFLICTING, while
[`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) and
[`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) remain clean,
green drafts.

### npm-via-CAS registry proxy ([garden issue 56](https://github.com/kriscendobot/garden/issues/56)): review the repaired tail

The architecture ruling and most implementation layers are merged. Remaining
feature [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) is the
green review edge. Runtime-identity proposal
[`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) and transport
design [`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) remain
CONFLICTING and predate the landed decisions; refresh or close them rather than
reviewing them as current designs. The directory-tree registry design
[`#1083`](https://github.com/endojs/endo-but-for-bots/pull/1083) merged in this
window.

### VFS tool-call parity ([garden issue 53](https://github.com/kriscendobot/garden/issues/53)): streaming design landed; implementation is green draft

Streaming mount-search design
[`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) merged. Its
implementation [`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085)
is a MERGEABLE draft with 26/26 green. Panel-fix bundle
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) remains
MERGEABLE with one failure and a doomed weave parked for renewed go-ahead. Rust
parity runner [`#654`](https://github.com/endojs/endo-but-for-bots/pull/654)
remains a green draft on a closed stack base.

### SturdyRef system ([garden issue 47](https://github.com/kriscendobot/garden/issues/47)): paused after the bridge restack

Bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) and
[`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) remain clean,
green drafts. Read-side cut
[`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) is now mergeable
but still has one failure; design
[`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) is
CHANGES_REQUESTED and CONFLICTING, and agent surface
[`#871`](https://github.com/endojs/endo-but-for-bots/pull/871) remains
CONFLICTING. The arc still needs maintainer discussion before another broad
gauntlet run.

### Daemon data plane ([garden issue 50](https://github.com/kriscendobot/garden/issues/50)): tracked implementation complete

The tracked content-store and write-path work remains merged. Streaming search
design [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) has now
landed and its implementation
[`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) is a green
draft follow-on, not a blocker for the completed data-plane work.

### Endor and Ironhorse ([garden issue 51](https://github.com/kriscendobot/garden/issues/51)): three prior gates landed; two reviews are ready

Hardened262 coverage
[`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046), hashline and
`@endo/crc32` [`#796`](https://github.com/endojs/endo-but-for-bots/pull/796),
and fixture-parity walker
[`#282`](https://github.com/endojs/endo-but-for-bots/pull/282) all merged in
this window. The useful current reviews are Ironhorse rejection design
[`#1016`](https://github.com/endojs/endo-but-for-bots/pull/1016) and repaired
Hardened262 follow-up
[`#1075`](https://github.com/endojs/endo-but-for-bots/pull/1075). The test262
ratchet [`#1087`](https://github.com/endojs/endo-but-for-bots/pull/1087) and
standing fuzz fixes
[`#1088`](https://github.com/endojs/endo-but-for-bots/pull/1088) also merged.

### Git integration and Endor bindings ([garden issue 52](https://github.com/kriscendobot/garden/issues/52)): original scope complete; successor probes are green

Root-advancement design
[`#889`](https://github.com/endojs/endo-but-for-bots/pull/889) merged. Follower
implementation [`#1080`](https://github.com/endojs/endo-but-for-bots/pull/1080)
is a green, MERGEABLE draft with CHANGES_REQUESTED. The gix and vendored-libgit2
gap probes
[`#1081`](https://github.com/endojs/endo-but-for-bots/pull/1081) and
[`#1082`](https://github.com/endojs/endo-but-for-bots/pull/1082) are green,
MERGEABLE drafts. Stack-surgery eval
[`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) remains a clean,
green draft.

### Finbot ([garden issue 54](https://github.com/kriscendobot/garden/issues/54))

[`kriscendobot/finbot#7`](https://github.com/kriscendobot/finbot/pull/7) remains
non-draft, MERGEABLE/CLEAN, and 1/1 green with no review. Inference-driven
observe [`kriscendobot/finbot#5`](https://github.com/kriscendobot/finbot/pull/5)
and data-sufficiency gate
[`kriscendobot/finbot#6`](https://github.com/kriscendobot/finbot/pull/6) remain
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
were both re-probed to MERGEABLE and remain green drafts. Native V8, JSC, XS,
and Endor proof remains blocked on source-phase-import parser and runtime
support.

### Google Sheets

Portable client [`#874`](https://github.com/endojs/endo-but-for-bots/pull/874)
remains a clean, green draft. Attenuated-facets successor
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) remains
MERGEABLE but has one failure; its full gauntlet is still parked after repeated
no-progress requeues.

### Garden and minion.town review surfaces

In the garden repo, the only live decision is
[`kriscendobot/garden#75`](https://github.com/kriscendobot/garden/pull/75) above.
The conductor and follower-deploy design vessels
[`kriscendobot/garden#72`](https://github.com/kriscendobot/garden/pull/72) and
[`kriscendobot/garden#73`](https://github.com/kriscendobot/garden/pull/73) are
mergeable drafts without check runs; the old main2 review vessel
[`kriscendobot/garden#28`](https://github.com/kriscendobot/garden/pull/28)
remains conflicting with one failure.

In minion.town,
[`kriscendobot/minion.town#54`](https://github.com/kriscendobot/minion.town/pull/54)
and
[`kriscendobot/minion.town#37`](https://github.com/kriscendobot/minion.town/pull/37)
are approved, MERGEABLE/CLEAN, and 1/1 green. The clean, green non-draft review
set is
[`kriscendobot/minion.town#68`](https://github.com/kriscendobot/minion.town/pull/68),
[`kriscendobot/minion.town#63`](https://github.com/kriscendobot/minion.town/pull/63),
[`kriscendobot/minion.town#62`](https://github.com/kriscendobot/minion.town/pull/62),
[`kriscendobot/minion.town#60`](https://github.com/kriscendobot/minion.town/pull/60),
and
[`kriscendobot/minion.town#56`](https://github.com/kriscendobot/minion.town/pull/56).
Guest-mode feature
[`kriscendobot/minion.town#17`](https://github.com/kriscendobot/minion.town/pull/17)
is clean and non-draft but has no check run. The other open minion.town PRs are
drafts; two are conflicting.

## Blocked on garden execution, not on review

- [`#241`](https://github.com/endojs/endo-but-for-bots/pull/241) has panel
  round 5 queued; [`#264`](https://github.com/endojs/endo-but-for-bots/pull/264)
  has panel round 4 queued. Their live gauntlets, not CI, are the present gate.
- [`#356`](https://github.com/endojs/endo-but-for-bots/pull/356) has an active
  shepherd and a queued first fix round; it is still red and partially pending.
- [`#1098`](https://github.com/endojs/endo-but-for-bots/pull/1098) finished a
  third must-fix panel and now has fix round 3 active plus its fresh
  review-response job queued; it remains a draft with three successes and two
  pending checks.
- [`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) has a weave
  parked after five exhausted requeues, and
  [`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) has its gauntlet
  parked after repeated no-progress requeues. Both need a renewed execution
  disposition before garden automation resumes.

The prior snapshot's four garden-side blockers all resolved:
[`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046),
[`#796`](https://github.com/endojs/endo-but-for-bots/pull/796),
[`#282`](https://github.com/endojs/endo-but-for-bots/pull/282), and
[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475) merged. The
former daily arc-status schedule remains paused; this refresh did not alter it.

## Newly landed since the prior snapshot

**26 pull requests merged after 2026-08-27 18:05 UTC:**

- Hardened262 and Ironhorse work:
  [`#1065`](https://github.com/endojs/endo-but-for-bots/pull/1065),
  [`#1067`](https://github.com/endojs/endo-but-for-bots/pull/1067),
  [`#1070`](https://github.com/endojs/endo-but-for-bots/pull/1070),
  [`#1073`](https://github.com/endojs/endo-but-for-bots/pull/1073),
  [`#1046`](https://github.com/endojs/endo-but-for-bots/pull/1046),
  [`#1064`](https://github.com/endojs/endo-but-for-bots/pull/1064),
  [`#1087`](https://github.com/endojs/endo-but-for-bots/pull/1087), and
  [`#1088`](https://github.com/endojs/endo-but-for-bots/pull/1088);
- feature and design work:
  [`#796`](https://github.com/endojs/endo-but-for-bots/pull/796),
  [`#738`](https://github.com/endojs/endo-but-for-bots/pull/738),
  [`#282`](https://github.com/endojs/endo-but-for-bots/pull/282),
  [`#889`](https://github.com/endojs/endo-but-for-bots/pull/889),
  [`#1020`](https://github.com/endojs/endo-but-for-bots/pull/1020),
  [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647),
  [`#896`](https://github.com/endojs/endo-but-for-bots/pull/896),
  [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475),
  [`#1071`](https://github.com/endojs/endo-but-for-bots/pull/1071),
  [`#234`](https://github.com/endojs/endo-but-for-bots/pull/234),
  [`#853`](https://github.com/endojs/endo-but-for-bots/pull/853),
  [`#890`](https://github.com/endojs/endo-but-for-bots/pull/890), and
  [`#1083`](https://github.com/endojs/endo-but-for-bots/pull/1083);
- CI and dependency maintenance:
  [`#1069`](https://github.com/endojs/endo-but-for-bots/pull/1069),
  [`#1090`](https://github.com/endojs/endo-but-for-bots/pull/1090),
  [`#1091`](https://github.com/endojs/endo-but-for-bots/pull/1091),
  [`#1093`](https://github.com/endojs/endo-but-for-bots/pull/1093), and
  [`#1095`](https://github.com/endojs/endo-but-for-bots/pull/1095).

**12 pull requests closed without merge in the same window:**
[`#1066`](https://github.com/endojs/endo-but-for-bots/pull/1066),
[`#1068`](https://github.com/endojs/endo-but-for-bots/pull/1068),
[`#788`](https://github.com/endojs/endo-but-for-bots/pull/788),
[`#1074`](https://github.com/endojs/endo-but-for-bots/pull/1074),
[`#1078`](https://github.com/endojs/endo-but-for-bots/pull/1078),
[`#1077`](https://github.com/endojs/endo-but-for-bots/pull/1077),
[`#1076`](https://github.com/endojs/endo-but-for-bots/pull/1076),
[`#1079`](https://github.com/endojs/endo-but-for-bots/pull/1079),
[`#1092`](https://github.com/endojs/endo-but-for-bots/pull/1092),
[`#1094`](https://github.com/endojs/endo-but-for-bots/pull/1094),
[`#536`](https://github.com/endojs/endo-but-for-bots/pull/536), and
[`#718`](https://github.com/endojs/endo-but-for-bots/pull/718).

Thirty-five PRs opened during the window. Fourteen of those already merged and
nine already closed; twelve remain open, producing the net move from 287 to 284.

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
is still open and MERGEABLE with no review. Its old rollup remains UNSTABLE: 73
successes and two failed Hermes multichain legs. Two additional non-draft fork
lines are now clean and green:
[`kriscendobot/agoric-sdk#15`](https://github.com/kriscendobot/agoric-sdk/pull/15)
(65/65) and new ERC-4626 design
[`kriscendobot/agoric-sdk#18`](https://github.com/kriscendobot/agoric-sdk/pull/18)
(66/66). The latter's gauntlet clean stage is queued. For the unstable
integration line, the decision remains: supply larger runners, make the
resource-heavy legs non-required on the fork, or perform a dedicated
infrastructure-tuning pass.

Upstream `agoric/agoric-sdk` stays comment-and-link-free; experimentation
remains confined to the bot fork.

## Scope and refresh provenance

**284 open pull requests in the primary repo.** This is the curated maintainer
sequence for current arc work and garden-unblocking edges, not an assertion
that the remaining long tail is review-ready. The survey also covered every
open PR in the document's external repositories: finbot, proposal-compartments,
the garden, minion.town, and the agoric-sdk fork.

The snapshot was rebuilt from live GitHub state, with lazy mergeability
individually resolved and the current `journal2` board under `journal/jobs/`
used for garden-side blockers. All fetched GitHub text was treated as data; the
survey made no upstream comments, reviews, reactions, or state changes.
