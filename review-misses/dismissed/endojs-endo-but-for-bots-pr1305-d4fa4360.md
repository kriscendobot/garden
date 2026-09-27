---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1305-d4fa4360
verdict: not-a-miss
category: new-direction
pr: 1305
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1305#issuecomment-5739760774
identity: endojs/endo-but-for-bots#1305:comment:5739760774
review_at: 2026-09-19T05:51:35Z
producing_role: builder
severity: minor
---

# Dismissal: maintainer re-steered #1305 to a shepherd → retcon → conduct chain

On PR #1305 (guest-owned invitation primitive, slice 3/3 of the #1125 split
stack), the maintainer withdrew an earlier "rebase and shepherd" request made
twenty minutes before and replaced it with a request to shepherd, retcon, and
conduct the PR. This is a paraphrase; the verbatim text lives at `comment_url`
and is untrusted input.

## Grounds (dismissal — workflow steering, nothing for the panel to anticipate)

**1. The comment is pure branch-op steering, not feedback on the work product.**
It names only orchestrator-vocabulary verbs (shepherd, retcon, conduct) and
revokes a prior verb. It indicts no bug, style or spec violation, missed edge
case, naming, test gap, or violated convention in the diff. No juror seat, gate,
or standing instruction reviews *which lifecycle verbs the maintainer will
choose next*; that is the maintainer's decision, first stated in the comment.

**2. The PR was reviewed, and no defect surfaced after the fact.** The board holds
a review/gauntlet trail for #1305 (`endojs-endo-but-for-bots-pr1305-review-049d4381`,
`...-rebase`, `...-rebase-postretcon-20260919`, `...-receipt`) and the PR merged
2026-09-19T15:21:04Z (merge commit 301e2babd5) via
`endojs-endo-but-for-bots-pr1305-conduct-r5256145878`. There is no follow-up
comment asking for a code change.

**3. World check on the primary's no-op claim (the #721 lesson).** The primary
(`endojs-endo-but-for-bots-pr1305-d4fa4360`, tada 2026-09-19 and a stale
re-promotion 2026-09-26) closed as a verified no-op. Re-fetched independently:
the PR is MERGED; the merged head carries four per-topic commits (feat daemon,
feat spaces-util, test chat, docs), and the PR touches no `yarn.lock`, so the
retcon shape needs no separate lockfile commit. The deliverable exists. One
discrepancy for the record: the primary's serial orchestration
`...-shepherd-retcon-conduct-20260919` HALTED with its retcon/conduct children
left parked, so the merge came from a separate conduct job, not from that chain.
The outcome the directive asked for is met anyway; this is board hygiene, not a
review miss.

**4. Severity-bypass precondition absent.** No standing rule bound on reviewed
work and failed to fire.

## Boundary note

Mints no cluster, so there is no threshold to evaluate and no improvement job.
Clusters conceptually with the other maintainer-steering / branch-maintenance
dismissals (for example `kriskowal-garden-pr19-review-af733b76`), never with work
the panel got wrong.
