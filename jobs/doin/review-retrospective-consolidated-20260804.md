---
role: prosecutor
tier: mentor
fallback-tier: minion
handler-timeout: 7200
dispatch: automatic
---

# Consolidated review retrospective — 85 review events, one cross-cutting pass

**This job REPLACES 85 individual `*-retro` jobs** that were parked in `jobs/plan/`
(withdrawn 2026-08-04 by maintainer direction). Every event they covered is listed
below; nothing was dropped.

## Why this is consolidated, and why that is not merely cheaper

Each withdrawn retro carried the same instruction: judge whether the review process
*should* have anticipated one maintainer/contributor review, **"and if a pattern is
forming"**, improve the roles/skills/panel so the gauntlet catches the next instance.

A pattern across 85 events cannot be detected 85 times in isolation. Each individual
run saw exactly ONE review and had to infer, from that single point, whether a trend
existed. The evidence says that mostly failed: `review-misses/` records **158
completed retrospectives — 24 misses and 134 dismissed**, an ~85% dismissal rate.
Those 134 dismissals are the expected output of asking a population question one
sample at a time.

**Your job is the question none of them could answer.** Do not re-run 85 verdicts.

## What to produce

1. **Cluster the 85 events below by failure mode**, not by PR. What KIND of thing did
   a human catch that the panel did not? Name each cluster and its size.
2. **Read the existing corpus first** — `review-misses/misses/` (24) and
   `review-misses/dismissed/` (134). The 134 dismissals are data, not noise: a
   failure mode dismissed 20 times individually may be the largest real cluster.
3. **For each cluster above threshold, propose ONE concrete change** to a juror seat,
   a skill, or the panel aggregation — with the specific seat/skill path. Prefer
   sharpening an existing seat over adding one.
4. **Say plainly which clusters are NOT worth acting on**, and why. A short, honest
   list beats a long speculative one.
5. Record per-event outcomes into `review-misses/` under the existing convention so
   the corpus stays complete and this pass is not re-done.

## Scope discipline

Do NOT open PRs against project repos. This is a garden-library improvement pass:
land changes to `roles/`, `skills/`, or `scripts/jobs/gardening/` on `main2`, or
report a recommendation if a change is larger than one job. **Note that 39 of the 85
events belong to PRs already MERGED or CLOSED** — they are still valid evidence about
the review process, but no PR action follows from them.

## The 85 events

| PR | PR state | primary review job | directive identity |
| --- | --- | --- | --- |
| #160 | MERGED | `endojs-endo-but-for-bots-pr160-review-85ea7a37` | `endojs/endo-but-for-bots#160:review:4751390688` |
| #160 | MERGED | `endojs-endo-but-for-bots-pr160-review-b7e466e9` | `endojs/endo-but-for-bots#160:review:4751820634` |
| #169 | MERGED | `endojs-endo-but-for-bots-pr169-6f24fd4e` | `endojs/endo-but-for-bots#169:comment:5111746900` |
| #241 | OPEN | `endojs-endo-but-for-bots-pr241-review-b15e4ef6` | `endojs/endo-but-for-bots#241:review:4803410792` |
| #259 | CLOSED | `endojs-endo-but-for-bots-pr259-review-2a6e7b12` | `endojs/endo-but-for-bots#259:review:4802874419` |
| #282 | OPEN | `endojs-endo-but-for-bots-pr282-148f5c93` | `endojs/endo-but-for-bots#282:comment:5111900373` |
| #357 | OPEN | `endojs-endo-but-for-bots-pr357-623fe9bc` | `endojs/endo-but-for-bots#357:comment:5053401895` |
| #403 | OPEN | `endojs-endo-but-for-bots-pr403-ad7046e4` | `endojs/endo-but-for-bots#403:comment:5124648430` |
| #600 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr600-cb3a204f` | `endojs/endo-but-for-bots#600:comment:5126537369` |
| #647 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr647-review-ec3d282c` | `endojs/endo-but-for-bots#647:review:4803376766` |
| #655 | CLOSED | `endojs-endo-but-for-bots-pr655-0cb1a0bc` | `endojs/endo-but-for-bots#655:comment:5111081574` |
| #667 | OPEN | `endojs-endo-but-for-bots-pr667-198c8d1e` | `endojs/endo-but-for-bots#667:comment:5112096155` |
| #671 | MERGED | `endojs-endo-but-for-bots-pr671-review-36ae135d` | `endojs/endo-but-for-bots#671:review:4801850520` |
| #671 | MERGED | `endojs-endo-but-for-bots-pr671-review-9737517c` | `endojs/endo-but-for-bots#671:review:4803235197` |
| #676 | MERGED | `endojs-endo-but-for-bots-pr676-review-4939792d` | `endojs/endo-but-for-bots#676:review:4803468004` |
| #676 | MERGED | `endojs-endo-but-for-bots-pr676-review-87b8c044` | `endojs/endo-but-for-bots#676:review:4803277081` |
| #683 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr683-review-84f0d6ef` | `endojs/endo-but-for-bots#683:review:4802903254` |
| #684 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr684-review-67f8b51a` | `endojs/endo-but-for-bots#684:review:4803347200` |
| #705 | MERGED | `endojs-endo-but-for-bots-pr705-review-207112c7` | `endojs/endo-but-for-bots#705:review:4751302956` |
| #705 | MERGED | `endojs-endo-but-for-bots-pr705-review-c7f0268c` | `endojs/endo-but-for-bots#705:review:4802878336` |
| #713 | MERGED | `endojs-endo-but-for-bots-pr713-review-2b03f8c3` | `endojs/endo-but-for-bots#713:review:4802848515` |
| #719 | OPEN | `endojs-endo-but-for-bots-pr719-1a882a7d` | `endojs/endo-but-for-bots#719:comment:5079229245` |
| #719 | OPEN | `endojs-endo-but-for-bots-pr719-ade4a938` | `endojs/endo-but-for-bots#719:comment:5079220882` |
| #719 | OPEN | `endojs-endo-but-for-bots-pr719-review-9fcf7da1` | `endojs/endo-but-for-bots#719:review:4751242280` |
| #723 | MERGED | `endojs-endo-but-for-bots-pr723-review-b5ddd4da` | `endojs/endo-but-for-bots#723:review:4803487425` |
| #730 | OPEN | `endojs-endo-but-for-bots-pr730-review-27278ba1` | `endojs/endo-but-for-bots#730:review:4803439037` |
| #740 | MERGED | `endojs-endo-but-for-bots-pr740-40e1dd8c` | `endojs/endo-but-for-bots#740:comment:5084077705` |
| #740 | MERGED | `endojs-endo-but-for-bots-pr740-review-15d45e11` | `endojs/endo-but-for-bots#740:review:4782022890` |
| #740 | MERGED | `endojs-endo-but-for-bots-pr740-review-6ca53b57` | `endojs/endo-but-for-bots#740:review:4779501767` |
| #755 | MERGED | `endojs-endo-but-for-bots-pr755-review-a0778b2e` | `endojs/endo-but-for-bots#755:review:4726236299` |
| #755 | MERGED | `endojs-endo-but-for-bots-pr755-review-ea305fae` | `endojs/endo-but-for-bots#755:review:4799487076` |
| #778 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr778-review-1d2c2074` | `endojs/endo-but-for-bots#778:review:4815423848` |
| #778 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr778-review-95a2b3a4` | `endojs/endo-but-for-bots#778:review:4814070872` |
| #778 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr778-review-b48bc106` | `endojs/endo-but-for-bots#778:review:4815067371` |
| #786 | MERGED | `endojs-endo-but-for-bots-pr786-28d1e1d7` | `endojs/endo-but-for-bots#786:comment:5050759948` |
| #792 | MERGED | `endojs-endo-but-for-bots-pr792-review-91808a86` | `endojs/endo-but-for-bots#792:review:4751416266` |
| #804 | OPEN | `endojs-endo-but-for-bots-pr804-47b714b2` | `endojs/endo-but-for-bots#804:comment:5044043025` |
| #804 | OPEN | `endojs-endo-but-for-bots-pr804-review-8df7f3e2` | `endojs/endo-but-for-bots#804:review:4752868838` |
| #806 | MERGED | `endojs-endo-but-for-bots-pr806-review-aebac5fc` | `endojs/endo-but-for-bots#806:review:4752810208` |
| #807 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr807-5e6eb4e5` | `endojs/endo-but-for-bots#807:comment:5047598527` |
| #807 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr807-c55523fb` | `endojs/endo-but-for-bots#807:comment:5046488104` |
| #809 | MERGED | `endojs-endo-but-for-bots-pr809-review-39ff950a` | `endojs/endo-but-for-bots#809:review:4749706542` |
| #809 | MERGED | `endojs-endo-but-for-bots-pr809-review-3fb4c8b9` | `endojs/endo-but-for-bots#809:review:4756578831` |
| #809 | MERGED | `endojs-endo-but-for-bots-pr809-review-69e51cb3` | `endojs/endo-but-for-bots#809:review:4756527159` |
| #809 | MERGED | `endojs-endo-but-for-bots-pr809-review-722e1113` | `endojs/endo-but-for-bots#809:review:4749702996` |
| #809 | MERGED | `endojs-endo-but-for-bots-pr809-review-784e5f86` | `endojs/endo-but-for-bots#809:review:4756562026` |
| #809 | MERGED | `endojs-endo-but-for-bots-pr809-review-e892a99c` | `endojs/endo-but-for-bots#809:review:4756521941` |
| #824 | MERGED | `endojs-endo-but-for-bots-pr824-review-e4950d9b` | `endojs/endo-but-for-bots#824:review:4752746710` |
| #825 | OPEN | `endojs-endo-but-for-bots-pr825-review-18fde0da` | `endojs/endo-but-for-bots#825:review:4798529077` |
| #826 | MERGED | `endojs-endo-but-for-bots-pr826-448995f1` | `endojs/endo-but-for-bots#826:comment:5052452290` |
| #826 | MERGED | `endojs-endo-but-for-bots-pr826-review-0ea51177` | `endojs/endo-but-for-bots#826:review:4757241489` |
| #826 | MERGED | `endojs-endo-but-for-bots-pr826-review-1756c24f` | `endojs/endo-but-for-bots#826:review:4752012032` |
| #827 | MERGED | `endojs-endo-but-for-bots-pr827-569ae9f5` | `endojs/endo-but-for-bots#827:comment:5047639672` |
| #831 | CLOSED | `endojs-endo-but-for-bots-pr831-14cde530` | `endojs/endo-but-for-bots#831:comment:5063492506` |
| #831 | CLOSED | `endojs-endo-but-for-bots-pr831-cfde756b` | `endojs/endo-but-for-bots#831:comment:5063556146` |
| #836 | OPEN | `endojs-endo-but-for-bots-pr836-06bbcc3d` | `endojs/endo-but-for-bots#836:comment:5126574701` |
| #836 | OPEN | `endojs-endo-but-for-bots-pr836-review-03bd85ff` | `endojs/endo-but-for-bots#836:review:4813841783` |
| #836 | OPEN | `endojs-endo-but-for-bots-pr836-review-3e0d6210` | `endojs/endo-but-for-bots#836:review:4782049359` |
| #836 | OPEN | `endojs-endo-but-for-bots-pr836-review-eda700a0` | `endojs/endo-but-for-bots#836:review:4782014530` |
| #836 | OPEN | `endojs-endo-but-for-bots-pr836-review-ee46b083` | `endojs/endo-but-for-bots#836:review:4782068426` |
| #852 | CLOSED | `endojs-endo-but-for-bots-pr852-d502e7a9` | `endojs/endo-but-for-bots#852:comment:5077090769` |
| #852 | CLOSED | `endojs-endo-but-for-bots-pr852-review-a9f2d553` | `endojs/endo-but-for-bots#852:review:4778419539` |
| #852 | CLOSED | `endojs-endo-but-for-bots-pr852-review-c981d05c` | `endojs/endo-but-for-bots#852:review:4778542287` |
| #853 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr853-review-37004cbc` | `endojs/endo-but-for-bots#853:review:4777707468` |
| #855 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr855-df7988e4` | `endojs/endo-but-for-bots#855:comment:5077194948` |
| #856 | OPEN | `endojs-endo-but-for-bots-pr856-review-6cfb0803` | `endojs/endo-but-for-bots#856:review:4778593042` |
| #873 | MERGED | `endojs-endo-but-for-bots-pr873-4e8841bd` | `endojs/endo-but-for-bots#873:comment:5126616834` |
| #874 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr874-review-c58ec6c8` | `endojs/endo-but-for-bots#874:review:4810568121` |
| #874 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr874-review-ce8e8195` | `endojs/endo-but-for-bots#874:review:4810508061` |
| #874 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr874-review-e6cccb99` | `endojs/endo-but-for-bots#874:review:4783686528` |
| #874 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr874-review-fd62e60e` | `endojs/endo-but-for-bots#874:review:4810551844` |
| #875 | OPEN | `endojs-endo-but-for-bots-pr875-review-51bf66b1` | `endojs/endo-but-for-bots#875:review:4813914800` |
| #875 | OPEN | `endojs-endo-but-for-bots-pr875-review-8e639c41` | `endojs/endo-but-for-bots#875:review:4803517111` |
| #876 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr876-review-ac5d6dfa` | `endojs/endo-but-for-bots#876:review:4813923823` |
| #877 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr877-review-1eec395e` | `endojs/endo-but-for-bots#877:review:4813932381` |
| #881 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr881-review-5111ec6e` | `endojs/endo-but-for-bots#881:review:4799182277` |
| #881 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr881-review-b8bb5665` | `endojs/endo-but-for-bots#881:review:4800107598` |
| #881 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr881-review-baf7087b` | `endojs/endo-but-for-bots#881:review:4799231902` |
| #881 | OPEN/DRAFT | `endojs-endo-but-for-bots-pr881-review-d23c8dbf` | `endojs/endo-but-for-bots#881:review:4800101592` |
| #882 | MERGED | `endojs-endo-but-for-bots-pr882-review-4a754464` | `endojs/endo-but-for-bots#882:review:4800433644` |
| #885 | OPEN | `endojs-endo-but-for-bots-pr885-review-c5f39398` | `endojs/endo-but-for-bots#885:review:4813762886` |
| #10 | ? | `kriscendobot-agoric-sdk-pr10-review-14260266` | `kriscendobot/agoric-sdk#10:review:4765874818` |
| #10 | ? | `kriscendobot-agoric-sdk-pr10-review-a7bcbe21` | `kriscendobot/agoric-sdk#10:review:4746555282` |
| #10 | ? | `kriscendobot-agoric-sdk-pr10-review-c28034ac` | `kriscendobot/agoric-sdk#10:review:4762450059` |
| #12 | ? | `kriscendobot-minion.town-pr12-a3def291` | `kriscendobot/minion.town#12:comment:5040251719` |

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-04T04:59:22Z
