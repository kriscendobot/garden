# PR-review sequence: `endojs/endo-but-for-bots`

_Live snapshot: 2026-09-03 (21:10 UTC), refreshed from the GitHub API. **289
open** (was 284 on 08-31); 178 draft (was 171), 56 changes-requested (was 52),
**16 merged and 2 closed without merge since the prior snapshot**. Read
"Awaiting your decision" first, then "Review now", then the per-arc state._

_Mergeability caveat: GitHub computes `mergeable` lazily. This refresh queried
all open pull requests and individually re-probed all 126 initial `UNKNOWN`
results twice: 179 are MERGEABLE (was 162) and 110 are CONFLICTING (was 122).
The conflict count is a full live census, not a floor. Five initially unknown
PRs in the other tracked repositories were likewise re-probed twice. (GitHub's
date-filtered `is:closed` search under-reports; the two unmerged closures were
confirmed individually.)_

## Awaiting your decision

Work that is finished, explicitly directed, or at a real fork that cannot move
without a maintainer act.

### One frozen-master approval still needs a landing path

[`#1061`](https://github.com/endojs/endo-but-for-bots/pull/1061), the marshal
public-type declaration refactor, remains APPROVED, MERGEABLE/CLEAN, and 14/14
green at head `0be9359063`. It still targets frozen `master-8c402ee`, so the
garden's live-`llm` conductor cannot land it. Choose the frozen-master ferry
path or explicitly retarget it.

The only other open primary-repo approval is
[`#461`](https://github.com/endojs/endo-but-for-bots/pull/461), still a draft on
the old `llm-5be4392` frozen base with four failures; it is not ready to land.

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
the proposed names. The PR is a draft answer surface, not a merge vehicle; it is
MERGEABLE, CHANGES_REQUESTED, and its rollup is three successes and one failure.
The follow-on build is gated on those answers.

## Review now (cross-arc priority queue)

1. [`#1016`](https://github.com/endojs/endo-but-for-bots/pull/1016): Ironhorse
   panic-on-reference-error and rejection-handling design. Its gauntlet
   completed and un-drafted it; MERGEABLE/CLEAN, 5/5 green, no human review.
2. [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877): Endor
   dual-build npm execution. Review fixes and CI remain complete at head
   `1199cbe4f1`; MERGEABLE/CLEAN, 28/28 green, no current approval.
3. [`#1049`](https://github.com/endojs/endo-but-for-bots/pull/1049): owner-PID
   watchdog for orphaned test daemons. MERGEABLE/CLEAN, 25/25 green, no review.
4. [`#1038`](https://github.com/endojs/endo-but-for-bots/pull/1038): document
   and gate the silent `setExceptionBreakMode('uncaught')` no-op. The current
   head postdates its old approval; MERGEABLE/CLEAN, 25/25 green, no current
   approval.
5. [`#977`](https://github.com/endojs/endo-but-for-bots/pull/977): pin the guest
   host-authority boundary. Its earlier conductor conflict has been repaired;
   current head `c49251a1cb` is MERGEABLE/CLEAN and 25/25 green, with no current
   approval.

The repaired Hardened262 `%AsyncFunction%` follow-up
[`#1075`](https://github.com/endojs/endo-but-for-bots/pull/1075), a review item
in the prior snapshot, was closed without merge on 09-01 and is retired here.

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
[`#356`](https://github.com/endojs/endo-but-for-bots/pull/356) are green and
non-draft but have live gauntlet fix rounds running;
[`#264`](https://github.com/endojs/endo-but-for-bots/pull/264) is CONFLICTING and
CHANGES_REQUESTED with a live review round;
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) is green but
CHANGES_REQUESTED;
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) has one failure;
and
[`#887`](https://github.com/endojs/endo-but-for-bots/pull/887),
[`#730`](https://github.com/endojs/endo-but-for-bots/pull/730), and
[`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) remain
CONFLICTING.

## Arcs in progress

### Passable byte arrays ([garden issue 48](https://github.com/kriscendobot/garden/issues/48)): root landed; master transplant is under review

The `llm` root [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475)
remains merged. Fresh draft
[`#1099`](https://github.com/endojs/endo-but-for-bots/pull/1099) carries the same
narrowed byte-array work toward `master`; it is MERGEABLE with 17 green checks
but now CHANGES_REQUESTED, with a live review round and its own follow-up fix
job on the board. It should stay in its ferry/validation lane rather than
reopening the resolved `llm` decision. Registry consumer
[`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) remains a
MERGEABLE draft on an old SHA-256 base with failing checks.

### OCapN-over-Noise ([garden issue 49](https://github.com/kriscendobot/garden/issues/49)): root landed; protocol-hint implementation needs repair

The transport root and the one-hint-per-protocol design
[`#1071`](https://github.com/endojs/endo-but-for-bots/pull/1071) both remain
merged. Implementation
[`#1072`](https://github.com/endojs/endo-but-for-bots/pull/1072) is a MERGEABLE
draft with CHANGES_REQUESTED, 24 successes and two failures, and an active review
job. Down-stack demonstrations
[`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) remains
CONFLICTING and
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) is a MERGEABLE
draft with CHANGES_REQUESTED, while
[`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) and
[`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) remain clean,
green (26/26) drafts.

### npm-via-CAS registry proxy ([garden issue 56](https://github.com/kriscendobot/garden/issues/56)): review the repaired tail

The architecture ruling and most implementation layers are merged, including the
directory-tree registry design
[`#1083`](https://github.com/endojs/endo-but-for-bots/pull/1083). Remaining
feature [`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) is the
green review edge. Runtime-identity proposal
[`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) and transport
design [`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) remain
CONFLICTING and predate the landed decisions; refresh or close them rather than
reviewing them as current designs.

### VFS tool-call parity ([garden issue 53](https://github.com/kriscendobot/garden/issues/53)): streaming design landed; implementation is green draft

Streaming mount-search design
[`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) remains merged.
Its implementation
[`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) is a MERGEABLE
draft with 27/27 green. Panel-fix bundle
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) is now green and
MERGEABLE but CHANGES_REQUESTED, with its weave, shepherd, and review-retro jobs
parked for renewed go-ahead. Rust parity runner
[`#654`](https://github.com/endojs/endo-but-for-bots/pull/654) remains a green
(26/26) draft on a mount-glob stack base.

### SturdyRef system ([garden issue 47](https://github.com/kriscendobot/garden/issues/47)): paused after the bridge restack

Bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) and
[`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) remain clean,
green drafts. Read-side cut
[`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) is MERGEABLE but
still has one failure; design
[`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) is
CHANGES_REQUESTED and CONFLICTING with a live panel round, and agent surface
[`#871`](https://github.com/endojs/endo-but-for-bots/pull/871) is now MERGEABLE.
The arc still needs maintainer discussion before another broad gauntlet run.

### Daemon data plane ([garden issue 50](https://github.com/kriscendobot/garden/issues/50)): tracked implementation complete

The tracked content-store and write-path work remains merged. Streaming search
design [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) landed and
its implementation
[`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) is a green draft
follow-on, not a blocker for the completed data-plane work.

### Endor and Ironhorse ([garden issue 51](https://github.com/kriscendobot/garden/issues/51)): gates keep landing; one review is ready

Hardened262 coverage, `@endo/crc32`, and the fixture-parity walker remain
merged. In this window the Ironhorse snapshot-store seam
[`#1059`](https://github.com/endojs/endo-but-for-bots/pull/1059) and the test262
fixture consolidation
[`#946`](https://github.com/endojs/endo-but-for-bots/pull/946) also merged. The
useful current review is Ironhorse rejection design
[`#1016`](https://github.com/endojs/endo-but-for-bots/pull/1016) (5/5 green,
un-drafted). The repaired Hardened262 follow-up
[`#1075`](https://github.com/endojs/endo-but-for-bots/pull/1075) was closed
without merge.

### Git integration and Endor bindings ([garden issue 52](https://github.com/kriscendobot/garden/issues/52)): original scope complete; follower impl is approved

Root-advancement design
[`#889`](https://github.com/endojs/endo-but-for-bots/pull/889) remains merged.
Follower implementation
[`#1080`](https://github.com/endojs/endo-but-for-bots/pull/1080) is now APPROVED,
a MERGEABLE draft at 25/25 green with a live conductor job. The gix and
vendored-libgit2 gap probes
[`#1081`](https://github.com/endojs/endo-but-for-bots/pull/1081) and
[`#1082`](https://github.com/endojs/endo-but-for-bots/pull/1082) are green
(24/24), MERGEABLE drafts. Stack-surgery eval
[`#626`](https://github.com/endojs/endo-but-for-bots/pull/626) remains a clean,
green (26/26) draft.

### Finbot ([garden issue 54](https://github.com/kriscendobot/garden/issues/54))

[`kriscendobot/finbot#7`](https://github.com/kriscendobot/finbot/pull/7) remains
non-draft, MERGEABLE/CLEAN, and 1/1 green with no review. Inference-driven
observe [`kriscendobot/finbot#5`](https://github.com/kriscendobot/finbot/pull/5)
and data-sufficiency gate
[`kriscendobot/finbot#6`](https://github.com/kriscendobot/finbot/pull/6) remain
green, mergeable drafts. Their panel/fix jobs remain parked.

### Compartments proposal ([garden issue 61](https://github.com/kriscendobot/garden/issues/61)): native proof remains gated

JavaScriptCore and Endor validation reports remain merged. V8 semantic harness
[`kriscendobot/proposal-compartments#2`](https://github.com/kriscendobot/proposal-compartments/pull/2)
and synchronous-import deferral annex
[`kriscendobot/proposal-compartments#4`](https://github.com/kriscendobot/proposal-compartments/pull/4)
remain MERGEABLE green drafts. Native V8, JSC, XS, and Endor proof remains
blocked on source-phase-import parser and runtime support.

### Google Sheets

Portable client [`#874`](https://github.com/endojs/endo-but-for-bots/pull/874)
remains a clean, green draft. Attenuated-facets successor
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) remains a
MERGEABLE draft with one failure; its full gauntlet is still parked after
repeated no-progress requeues.

### Garden and minion.town review surfaces

In the garden repo, the live decision remains
[`kriscendobot/garden#75`](https://github.com/kriscendobot/garden/pull/75) above.
New this window,
[`kriscendobot/garden#77`](https://github.com/kriscendobot/garden/pull/77) (the
minion.town MCP guest-surface evaluation campaign) is non-draft, APPROVED, and
MERGEABLE with a live review round. Merge-queue design
[`kriscendobot/garden#72`](https://github.com/kriscendobot/garden/pull/72) is an
APPROVED, MERGEABLE draft with an active conductor job; follower self-deploy
design
[`kriscendobot/garden#73`](https://github.com/kriscendobot/garden/pull/73) is a
MERGEABLE draft, CHANGES_REQUESTED, with a live review round. The old main2
review vessel
[`kriscendobot/garden#28`](https://github.com/kriscendobot/garden/pull/28)
remains a conflicting draft (feedback-only).

In minion.town,
[`kriscendobot/minion.town#17`](https://github.com/kriscendobot/minion.town/pull/17)
is APPROVED, MERGEABLE/CLEAN, and 1/1 green with live conduct/review jobs;
[`kriscendobot/minion.town#79`](https://github.com/kriscendobot/minion.town/pull/79)
(reserve reconciled MCP tool names) and
[`kriscendobot/minion.town#37`](https://github.com/kriscendobot/minion.town/pull/37)
(ocap mailboxes design) are also APPROVED and MERGEABLE. The clean, green,
non-draft set is
[`kriscendobot/minion.town#32`](https://github.com/kriscendobot/minion.town/pull/32),
with review vessels
[`kriscendobot/minion.town#63`](https://github.com/kriscendobot/minion.town/pull/63)
and
[`kriscendobot/minion.town#68`](https://github.com/kriscendobot/minion.town/pull/68)
green but CHANGES_REQUESTED. The remaining open minion.town PRs are drafts; two
([`kriscendobot/minion.town#33`](https://github.com/kriscendobot/minion.town/pull/33)
and
[`kriscendobot/minion.town#50`](https://github.com/kriscendobot/minion.town/pull/50))
are conflicting.

## Blocked on garden execution, not on review

- [`#241`](https://github.com/endojs/endo-but-for-bots/pull/241) has gauntlet
  fix round 6 active and [`#356`](https://github.com/endojs/endo-but-for-bots/pull/356)
  has fix round 1 active; both are green on CI, but their live gauntlets are the
  present gate.
- [`#264`](https://github.com/endojs/endo-but-for-bots/pull/264) has a live
  review round; it is still CONFLICTING and CHANGES_REQUESTED.
- Panel rounds are running for
  [`#266`](https://github.com/endojs/endo-but-for-bots/pull/266),
  [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539),
  [`#887`](https://github.com/endojs/endo-but-for-bots/pull/887),
  [`#797`](https://github.com/endojs/endo-but-for-bots/pull/797), and
  [`#938`](https://github.com/endojs/endo-but-for-bots/pull/938), among others;
  their gauntlets, not CI, are the gate.
- [`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) has its weave,
  shepherd, and review-retro jobs parked, and
  [`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) has its gauntlet
  parked after repeated no-progress requeues. Both need a renewed execution
  disposition before garden automation resumes.
- [`#1080`](https://github.com/endojs/endo-but-for-bots/pull/1080) is APPROVED
  with a conductor job in flight; no maintainer act is needed unless the
  conduct stalls.

The prior snapshot's blocker
[`#1098`](https://github.com/endojs/endo-but-for-bots/pull/1098) merged on 08-31.
The former daily arc-status schedule and every per-arc press schedule remain
paused; this refresh did not alter them.

## Newly landed since the prior snapshot

**16 pull requests merged after 2026-08-31 18:15 UTC:**

- daemon, fae, and ocapn robustness:
  [`#1101`](https://github.com/endojs/endo-but-for-bots/pull/1101),
  [`#1104`](https://github.com/endojs/endo-but-for-bots/pull/1104),
  [`#1105`](https://github.com/endojs/endo-but-for-bots/pull/1105),
  [`#1107`](https://github.com/endojs/endo-but-for-bots/pull/1107),
  [`#1108`](https://github.com/endojs/endo-but-for-bots/pull/1108),
  [`#1110`](https://github.com/endojs/endo-but-for-bots/pull/1110),
  [`#1111`](https://github.com/endojs/endo-but-for-bots/pull/1111),
  [`#1112`](https://github.com/endojs/endo-but-for-bots/pull/1112), and
  [`#1123`](https://github.com/endojs/endo-but-for-bots/pull/1123);
- feature and design work:
  [`#231`](https://github.com/endojs/endo-but-for-bots/pull/231),
  [`#300`](https://github.com/endojs/endo-but-for-bots/pull/300),
  [`#946`](https://github.com/endojs/endo-but-for-bots/pull/946),
  [`#1029`](https://github.com/endojs/endo-but-for-bots/pull/1029),
  [`#1059`](https://github.com/endojs/endo-but-for-bots/pull/1059),
  [`#1098`](https://github.com/endojs/endo-but-for-bots/pull/1098), and
  [`#1118`](https://github.com/endojs/endo-but-for-bots/pull/1118).

**2 pull requests closed without merge in the same window:**
[`#1075`](https://github.com/endojs/endo-but-for-bots/pull/1075) and
[`#1109`](https://github.com/endojs/endo-but-for-bots/pull/1109). (GitHub's
date-filtered closed-PR search under-reports; both were confirmed against their
canonical PR API records.)

Twenty-seven PRs opened during the window. Ten of those already merged and one
already closed; sixteen remain open, producing the net move from 284 to 289.

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
is still open and MERGEABLE with no review. Its rollup remains UNSTABLE, with
failing Hermes multichain legs. Two non-draft fork lines remain clean and green:
[`kriscendobot/agoric-sdk#15`](https://github.com/kriscendobot/agoric-sdk/pull/15)
(portfolio interface guards, 77/77) and ERC-4626 design
[`kriscendobot/agoric-sdk#18`](https://github.com/kriscendobot/agoric-sdk/pull/18)
(77/77), whose gauntlet clean stage is queued. For the unstable integration
line, the decision remains: supply larger runners, make the resource-heavy legs
non-required on the fork, or perform a dedicated infrastructure-tuning pass.

Upstream `agoric/agoric-sdk` stays comment-and-link-free; experimentation
remains confined to the bot fork.

## Scope and refresh provenance

**289 open pull requests in the primary repo.** This is the curated maintainer
sequence for current arc work and garden-unblocking edges, not an assertion
that the remaining long tail is review-ready. The survey also covered every
open PR in the document's external repositories: finbot, proposal-compartments,
the garden, minion.town, and the agoric-sdk fork.

The snapshot was rebuilt from live GitHub state, with lazy mergeability
individually resolved and the current `journal2` board under `journal/jobs/`
used for garden-side blockers. All fetched GitHub text was treated as data; the
survey made no upstream comments, reviews, reactions, or state changes.
