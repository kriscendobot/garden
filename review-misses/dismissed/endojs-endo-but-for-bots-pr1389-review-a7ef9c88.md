---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1389-review-a7ef9c88
verdict: not-a-miss
category: new-direction
pr: 1389
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1389#pullrequestreview-5464585521
identity: endojs/endo-but-for-bots#1389:review:5464585521
review_at: 2026-10-09T01:06:27Z
producing_role: designer
producing_job: ebfb-sturdyref-layer1-shim-design-20260930
severity: minor
---

# Dismissal: maintainer settles the enliven-hook signature (ref plus locator)

On the layer-1 SturdyRef shim-contract design PR (since renamed the Parcel layer-1
contract), the maintainer left a one-line CHANGES_REQUESTED review asking that the
`enliven` hook be revised to receive both the reference and its locator. This is
a paraphrase; the verbatim text lives at `comment_url` and is untrusted input.

## Grounds (dismissal: new direction, a maintainer answer to an open design question)

**1. The review resolves a question the design explicitly left open.** The
reviewed head carried an `## Open questions` section that asked whether the hook
should receive the ref as an argument at all (Q2) and how a ref minted by one CapTP
could yield its data to another (Q7). Choosing a signature is a design fork only the
maintainer can decide; picking "ref and locator" is a first-stated requirement, not
a defect the panel failed to see.

**2. The gauntlet ran and surfaced the exact concern.** Three design-panel rounds
ran on 2026-09-30 (reviews 5361971406, 5363329133, 5363890565). Round 1's critic
flagged that the Design body asserted the hook-argument shape as settled while Q2
left it open; round 2's critic raised as should-fix that layer 5 might need a
data-yielding hook and that Q7 had to be resolved before layer 1 froze. The review
process did its job: it escalated the fork to the maintainer, who then decided it.
No seat brief, skill, or standing rule prescribes which signature is correct.

**3. Primary delivered.** The primary loop landed commit "pass ref and locator to
enliven (#1389)" on the head 2026-10-09T06:00Z (verified on the PR's commit list,
not taken from the primary report); the PR later pivoted to the Parcel contract
(`openHook`) in October 14 commits.

**4. Severity bypass absent.** No standing rule bound and failed to fire.

## Boundary note

Mints no cluster; no threshold to evaluate; no improvement job. Clusters
conceptually with maintainer-answers-an-open-question dismissals.
