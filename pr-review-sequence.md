# PR-review sequence: `endojs/endo-but-for-bots`

_Live snapshot: 2026-09-04 (22:53 UTC), refreshed from the GitHub API. **293
open** (was 289 on 09-03); 177 draft (was 178), 56 changes-requested (unchanged),
**13 merged and 2 closed without merge since the prior snapshot**. Read
"Awaiting your decision" first, then "Review now", then the per-arc state._

_Mergeability caveat: GitHub computes `mergeable` lazily. This refresh queried
all open pull requests and individually re-probed all 68 initial `UNKNOWN`
results twice: 185 are MERGEABLE (was 179) and 108 are CONFLICTING (was 110).
The conflict count is a full live census, not a floor. Eighteen initial
`UNKNOWN` results in the other tracked repositories were likewise re-probed
twice. GitHub's date-filtered
`is:closed` search returned only 13 records; individual PR API records confirmed
those 13 merges plus two unmerged closures._

## Awaiting your decision

Work that is finished, explicitly directed, or at a real fork that cannot move
without a maintainer act.

### One frozen-master approval still needs a landing path

[`#1061`](https://github.com/endojs/endo-but-for-bots/pull/1061), the marshal
public-type declaration refactor, remains APPROVED, MERGEABLE/CLEAN, and 14/14
green at head `0be9359063`. It still targets frozen `master-8c402ee`, so the
garden's live-`llm` conductor cannot land it. Choose the frozen-master ferry
path or explicitly retarget it.

Aside from gateway approval `#389` below, the only other open primary-repo
approval is
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

### Garden spelling design still has five explicit open questions

[`kriscendobot/garden#75`](https://github.com/kriscendobot/garden/pull/75) is
the frozen review surface for the already-landed American-English normalization
design. It asks the maintainer to decide external-author scope, design-panel
membership, seed-rule ownership, blocking versus non-blocking disposition, and
the proposed names. The PR is a MERGEABLE draft answer surface, not a merge
vehicle; it remains CHANGES_REQUESTED. The follow-on build is gated on those
answers.

### Two approved minion.town lines are ready for a landing disposition

[`kriscendobot/minion.town#37`](https://github.com/kriscendobot/minion.town/pull/37)
(OCap mailboxes) and
[`kriscendobot/minion.town#79`](https://github.com/kriscendobot/minion.town/pull/79)
(reconciled MCP tool names) are both non-draft, APPROVED, MERGEABLE/CLEAN, and
1/1 green. The conductor for `#79` is parked; neither needs more review before a
landing decision.

## Review now (cross-arc priority queue)

1. [`#1016`](https://github.com/endojs/endo-but-for-bots/pull/1016): Ironhorse
   panic-on-reference-error and rejection-handling design. Its gauntlet
   completed and un-drafted it; MERGEABLE/CLEAN, 5/5 green, no human review.
2. [`#1152`](https://github.com/endojs/endo-but-for-bots/pull/1152): route
   Ironhorse arguments objects through the apply property MOP. Fresh,
   MERGEABLE/CLEAN, 27/27 green, and unreviewed.
3. [`#1145`](https://github.com/endojs/endo-but-for-bots/pull/1145): report
   exo-git remote credential health without using credentials. MERGEABLE/CLEAN,
   27/27 green, and unreviewed.
4. [`#1142`](https://github.com/endojs/endo-but-for-bots/pull/1142): stop the
   platform `**` glob from recursing through directory symlinks.
   MERGEABLE/CLEAN, 27/27 green, and unreviewed.
5. [`#1141`](https://github.com/endojs/endo-but-for-bots/pull/1141): snapshot
   native HTTP responses before hardening. MERGEABLE/CLEAN, 25/25 green, and
   unreviewed.

Also green, non-draft, mergeable, and carried unreviewed:
[`#1049`](https://github.com/endojs/endo-but-for-bots/pull/1049) owner-PID
watchdog (25/25),
[`#1038`](https://github.com/endojs/endo-but-for-bots/pull/1038) silent
`setExceptionBreakMode('uncaught')` no-op gate (25/25; its current head
postdates the old approval),
[`#977`](https://github.com/endojs/endo-but-for-bots/pull/977) guest
host-authority boundary (25/25; its current head has no approval),
[`#1144`](https://github.com/endojs/endo-but-for-bots/pull/1144) spaces-util
pet-name and pattern fix (25/25),
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
[`#1113`](https://github.com/endojs/endo-but-for-bots/pull/1113) is clean and
27/27 green, but its gauntlet is unfinished and parked after a deadline overrun;
[`#996`](https://github.com/endojs/endo-but-for-bots/pull/996) is clean and
green with gauntlet fix round 5 queued;
[`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) is green but
CHANGES_REQUESTED with fix round 2 active;
[`#1156`](https://github.com/endojs/endo-but-for-bots/pull/1156) is clean and
green with panel round 2 active;
[`#858`](https://github.com/endojs/endo-but-for-bots/pull/858) remains green but
CHANGES_REQUESTED;
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) has one failure;
and
[`#877`](https://github.com/endojs/endo-but-for-bots/pull/877),
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897),
[`#887`](https://github.com/endojs/endo-but-for-bots/pull/887),
[`#730`](https://github.com/endojs/endo-but-for-bots/pull/730), and
[`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) are CONFLICTING.

## Arcs in progress

### Passable byte arrays ([garden issue 48](https://github.com/kriscendobot/garden/issues/48)): root landed; master transplant still needs review fixes

The `llm` root [`#475`](https://github.com/endojs/endo-but-for-bots/pull/475)
remains merged. Draft
[`#1099`](https://github.com/endojs/endo-but-for-bots/pull/1099) carries the same
narrowed byte-array work toward `master`; it is MERGEABLE/CLEAN with 17 green
checks but remains CHANGES_REQUESTED. Its review-retrospective jobs are parked
and no fix is active. Registry consumer
[`#888`](https://github.com/endojs/endo-but-for-bots/pull/888) remains a
MERGEABLE draft on an old SHA-256 base with two failures.

### OCapN-over-Noise ([garden issue 49](https://github.com/kriscendobot/garden/issues/49)): root landed; protocol-hint implementation awaits repair

The transport root and one-hint-per-protocol design
[`#1071`](https://github.com/endojs/endo-but-for-bots/pull/1071) remain merged.
Implementation
[`#1072`](https://github.com/endojs/endo-but-for-bots/pull/1072) is a MERGEABLE
draft with CHANGES_REQUESTED and 27/27 green, but its repair and retrospective
jobs are parked. Down-stack demonstrations
[`#683`](https://github.com/endojs/endo-but-for-bots/pull/683) remains
CONFLICTING,
[`#684`](https://github.com/endojs/endo-but-for-bots/pull/684) is MERGEABLE but
CHANGES_REQUESTED, and
[`#688`](https://github.com/endojs/endo-but-for-bots/pull/688) and
[`#693`](https://github.com/endojs/endo-but-for-bots/pull/693) remain clean,
green (26/26) drafts.

### npm-via-CAS registry proxy ([garden issue 56](https://github.com/kriscendobot/garden/issues/56)): repaired tail needs a fresh base

The architecture and directory-tree registry decisions are merged, with the
design completion tracker
[`#892`](https://github.com/endojs/endo-but-for-bots/pull/892) landing in this
window. Remaining feature
[`#877`](https://github.com/endojs/endo-but-for-bots/pull/877) still has 28/28
green at head `1199cbe4f1`, but it is now CONFLICTING and must be refreshed
before review. Runtime-identity proposal
[`#879`](https://github.com/endojs/endo-but-for-bots/pull/879) and transport
design [`#730`](https://github.com/endojs/endo-but-for-bots/pull/730) are also
CONFLICTING and predate the landed decisions; refresh or close them rather than
reviewing them as current designs.

### VFS tool-call parity ([garden issue 53](https://github.com/kriscendobot/garden/issues/53)): implementation repair is active

Streaming mount-search design
[`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) remains merged.
Its implementation
[`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) is a MERGEABLE
draft with CHANGES_REQUESTED and 27/27 green; gauntlet fix round 2 is active.
Panel-fix bundle
[`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) is now
CONFLICTING and CHANGES_REQUESTED, with its weave, shepherd, and retrospective
jobs parked. Rust parity runner
[`#654`](https://github.com/endojs/endo-but-for-bots/pull/654) remains a draft on
a mount-glob stack base.

### SturdyRef system ([garden issue 47](https://github.com/kriscendobot/garden/issues/47)): paused after the bridge restack

Bridge cuts [`#698`](https://github.com/endojs/endo-but-for-bots/pull/698) and
[`#700`](https://github.com/endojs/endo-but-for-bots/pull/700) remain clean,
green drafts. Read-side cut
[`#541`](https://github.com/endojs/endo-but-for-bots/pull/541) is MERGEABLE but
still has one failure; design
[`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) is
CHANGES_REQUESTED and CONFLICTING with its panel job parked, and agent surface
[`#871`](https://github.com/endojs/endo-but-for-bots/pull/871) has become
CONFLICTING. The arc still needs maintainer discussion before another broad
gauntlet run.

### Daemon data plane ([garden issue 50](https://github.com/kriscendobot/garden/issues/50)): tracked implementation complete

The tracked content-store and write-path work remains merged. Streaming search
design [`#647`](https://github.com/endojs/endo-but-for-bots/pull/647) landed and
its implementation
[`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) is an active
green draft follow-on, not a blocker for the completed data-plane work.

### Endor and Ironhorse ([garden issue 51](https://github.com/kriscendobot/garden/issues/51)): panic design landed; two review edges are ready

The panic mechanism and message-embargo design
[`#1018`](https://github.com/endojs/endo-but-for-bots/pull/1018), the two-part
general JavaScript compatibility implementation
[`#1138`](https://github.com/endojs/endo-but-for-bots/pull/1138) and
[`#1139`](https://github.com/endojs/endo-but-for-bots/pull/1139), and the prior
snapshot-store and fixture-consolidation work are merged. Review
[`#1016`](https://github.com/endojs/endo-but-for-bots/pull/1016) for the
rejection-handling decision and
[`#1152`](https://github.com/endojs/endo-but-for-bots/pull/1152) for the fresh
arguments-object fix. Test262 ratchet
[`#1113`](https://github.com/endojs/endo-but-for-bots/pull/1113) is clean and
27/27 green after its rebase, but its gauntlet is parked unfinished after a
deadline overrun.

### Git integration and Endor bindings ([garden issue 52](https://github.com/kriscendobot/garden/issues/52)): follower implementation landed

Root-advancement design
[`#889`](https://github.com/endojs/endo-but-for-bots/pull/889) remains merged,
and follower implementation
[`#1080`](https://github.com/endojs/endo-but-for-bots/pull/1080) merged in this
window. The gix and vendored-libgit2 gap probes
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
green, mergeable drafts. Their panel and fix jobs remain parked.

### Compartments proposal ([garden issue 61](https://github.com/kriscendobot/garden/issues/61)): validation reports landed; native proof remains gated

V8 semantic harness
[`kriscendobot/proposal-compartments#2`](https://github.com/kriscendobot/proposal-compartments/pull/2)
and synchronous-import deferral annex
[`kriscendobot/proposal-compartments#4`](https://github.com/kriscendobot/proposal-compartments/pull/4)
both merged in this window, leaving no open PRs in the repository. Native V8,
JSC, XS, and Endor proof remains blocked on source-phase-import parser and
runtime support.

### Google Sheets

Portable client [`#874`](https://github.com/endojs/endo-but-for-bots/pull/874)
remains a clean, green draft. Attenuated-facets successor
[`#881`](https://github.com/endojs/endo-but-for-bots/pull/881) remains a
MERGEABLE draft with one failure; its gauntlet was withdrawn after repeated
no-progress requeues.

### Garden and minion.town review surfaces

In the garden repo, merge-queue design
[`kriscendobot/garden#72`](https://github.com/kriscendobot/garden/pull/72),
follower self-deploy design
[`kriscendobot/garden#73`](https://github.com/kriscendobot/garden/pull/73), and
the minion.town MCP guest-surface campaign
[`kriscendobot/garden#77`](https://github.com/kriscendobot/garden/pull/77) all
merged in this window. The live decision remains
[`kriscendobot/garden#75`](https://github.com/kriscendobot/garden/pull/75)
above. The six other open garden PRs are drafts; old main2 review vessel
[`kriscendobot/garden#28`](https://github.com/kriscendobot/garden/pull/28) is
the only conflicting one.

In minion.town, credential-refresh fix
[`kriscendobot/minion.town#17`](https://github.com/kriscendobot/minion.town/pull/17)
merged in this window. Clip-gutter build
[`kriscendobot/minion.town#90`](https://github.com/kriscendobot/minion.town/pull/90)
and content-store GC design
[`kriscendobot/minion.town#89`](https://github.com/kriscendobot/minion.town/pull/89)
also merged during this refresh. Approved
[`kriscendobot/minion.town#37`](https://github.com/kriscendobot/minion.town/pull/37)
and
[`kriscendobot/minion.town#79`](https://github.com/kriscendobot/minion.town/pull/79)
are called out above. The other clean, green, non-draft unreviewed surface is
[`kriscendobot/minion.town#32`](https://github.com/kriscendobot/minion.town/pull/32).
Clip publisher
[`kriscendobot/minion.town#68`](https://github.com/kriscendobot/minion.town/pull/68)
and developer-default fix
[`kriscendobot/minion.town#91`](https://github.com/kriscendobot/minion.town/pull/91)
are green but CHANGES_REQUESTED; `#68` has panel round 4 active. The remaining
open minion.town PRs are drafts except these ready surfaces, and three are
conflicting.

## Blocked on garden execution, not on review

- [`#1085`](https://github.com/endojs/endo-but-for-bots/pull/1085) has gauntlet
  fix round 2 active. Its 27/27 green rollup does not finish the requested
  review repair.
- [`#996`](https://github.com/endojs/endo-but-for-bots/pull/996) has fix round 5
  queued, while
  [`#1151`](https://github.com/endojs/endo-but-for-bots/pull/1151) has fix round
  4 queued,
  [`#1156`](https://github.com/endojs/endo-but-for-bots/pull/1156) has panel
  round 2 active, and
  [`#1157`](https://github.com/endojs/endo-but-for-bots/pull/1157) has panel
  round 1 active.
- Panel and fix rounds are also live for
  [`#665`](https://github.com/endojs/endo-but-for-bots/pull/665),
  [`#666`](https://github.com/endojs/endo-but-for-bots/pull/666),
  [`#695`](https://github.com/endojs/endo-but-for-bots/pull/695),
  [`#891`](https://github.com/endojs/endo-but-for-bots/pull/891),
  [`#935`](https://github.com/endojs/endo-but-for-bots/pull/935), and
  [`#938`](https://github.com/endojs/endo-but-for-bots/pull/938).
- [`#1113`](https://github.com/endojs/endo-but-for-bots/pull/1113) is rebased,
  MERGEABLE/CLEAN, and 27/27 green, but its standalone gauntlet was parked after
  a deterministic deadline overrun. It needs renewed execution disposition,
  not maintainer review of an unfinished gauntlet.
- The previously live rounds for
  [`#241`](https://github.com/endojs/endo-but-for-bots/pull/241),
  [`#264`](https://github.com/endojs/endo-but-for-bots/pull/264),
  [`#266`](https://github.com/endojs/endo-but-for-bots/pull/266),
  [`#356`](https://github.com/endojs/endo-but-for-bots/pull/356), and
  [`#539`](https://github.com/endojs/endo-but-for-bots/pull/539) are now parked
  on the plan board. They are no longer in-flight blockers.
- [`#897`](https://github.com/endojs/endo-but-for-bots/pull/897) still has its
  weave, shepherd, and retrospective jobs parked. It is now CONFLICTING, so the
  weave is again the first execution edge.

The former daily arc-status schedule and every per-arc press schedule remain
paused; this refresh did not alter them.

## Newly landed since the prior snapshot

**13 pull requests merged after 2026-09-03 21:10 UTC:**

- daemon, chat, and platform robustness:
  [`#1148`](https://github.com/endojs/endo-but-for-bots/pull/1148),
  [`#1140`](https://github.com/endojs/endo-but-for-bots/pull/1140),
  [`#1126`](https://github.com/endojs/endo-but-for-bots/pull/1126),
  [`#1122`](https://github.com/endojs/endo-but-for-bots/pull/1122),
  [`#1119`](https://github.com/endojs/endo-but-for-bots/pull/1119), and
  [`#1115`](https://github.com/endojs/endo-but-for-bots/pull/1115);
- Ironhorse compatibility:
  [`#1138`](https://github.com/endojs/endo-but-for-bots/pull/1138) and
  [`#1139`](https://github.com/endojs/endo-but-for-bots/pull/1139);
- feature and design work:
  [`#1127`](https://github.com/endojs/endo-but-for-bots/pull/1127),
  [`#1080`](https://github.com/endojs/endo-but-for-bots/pull/1080),
  [`#1018`](https://github.com/endojs/endo-but-for-bots/pull/1018),
  [`#892`](https://github.com/endojs/endo-but-for-bots/pull/892), and
  [`#254`](https://github.com/endojs/endo-but-for-bots/pull/254).

**2 pull requests closed without merge in the same window:**
[`#1106`](https://github.com/endojs/endo-but-for-bots/pull/1106) and
[`#1103`](https://github.com/endojs/endo-but-for-bots/pull/1103). GitHub's
date-filtered closed-PR search omitted both; their canonical PR API records
confirm the closures and null `merged_at` values.

Nineteen PRs opened during the window. Five of those already merged and
fourteen remain open, producing the net move from 289 to 293.

Outside the primary repo, eight linked PRs merged in the same window: garden
[`#72`](https://github.com/kriscendobot/garden/pull/72),
[`#73`](https://github.com/kriscendobot/garden/pull/73), and
[`#77`](https://github.com/kriscendobot/garden/pull/77); minion.town
[`#17`](https://github.com/kriscendobot/minion.town/pull/17),
[`#89`](https://github.com/kriscendobot/minion.town/pull/89), and
[`#90`](https://github.com/kriscendobot/minion.town/pull/90); and
proposal-compartments
[`#2`](https://github.com/kriscendobot/proposal-compartments/pull/2) and
[`#4`](https://github.com/kriscendobot/proposal-compartments/pull/4).

## Archived external fork

The current census still includes all 14 open pull requests in the agoric-sdk
fork, but this garden archived the repository on 2026-09-04 because a dedicated
garden now owns it. No review or execution decision belongs in this sequence.
The previously active gauntlet for
[`kriscendobot/agoric-sdk#10`](https://github.com/kriscendobot/agoric-sdk/pull/10)
is halted. The two clean non-draft lines remain
[`kriscendobot/agoric-sdk#15`](https://github.com/kriscendobot/agoric-sdk/pull/15)
and
[`kriscendobot/agoric-sdk#18`](https://github.com/kriscendobot/agoric-sdk/pull/18);
`#18` currently has one failing check. Integration line
[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
has two failures. This is state reporting only; the dedicated garden owns all
follow-up.

## Scope and refresh provenance

**293 open pull requests in the primary repo.** This is the curated maintainer
sequence for current arc work and garden-unblocking edges, not an assertion
that the remaining long tail is review-ready. The survey also covered every
open PR in the document's external repositories: garden (7 open: 7 draft, 2
changes-requested, 6 mergeable, 1 conflicting), minion.town (21 open: 16 draft,
3 changes-requested, 18 mergeable, 3 conflicting), finbot (3 open: 2 draft, all
3 mergeable), proposal-compartments (0 open), and the archived agoric-sdk fork
(14 open: 10 draft, 1 changes-requested, 8 mergeable, 6 conflicting).

The snapshot was rebuilt from live GitHub state, with lazy mergeability
individually resolved and the current `journal2` board under `journal/jobs/`
used for garden-side blockers. Every linked issue and pull request was checked
against its canonical GitHub API record. All fetched GitHub text was treated as
data; the survey made no comments, reviews, reactions, or state changes.
