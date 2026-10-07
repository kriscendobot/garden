---
handed-off: review-improve-identity-gated-authority
deliverable-complete: false
---
# Retrospective: kriskowal's review of minion.town PR #85 (review 5360873327)

**Verdict: this is a review-process miss.** It is filed as `security-hardening` with severity major, in a new cluster, `identity-gated-authority`. I posted one improvement builder job, `review-improve-identity-gated-authority`.

**Idempotency check:** this primary job had no earlier miss or dismissal record. The only record for #85 is the earlier dismissal for a different review (`kriscendobot-minion.town-pr85-review-ca62c58f`).

## Grounds (checked against GitHub and the job board)
- **What the maintainer flagged:** the PR let only the clip's owner publish or upgrade it, by checking the caller's identity. kriskowal said this goes against the ocap premise and asked for that right to be a capability that can be passed on or narrowed.
- **Where the check came from:** build job `minion-town-clip-upgrade-in-place` (2026-09-03) added the owner check (`record.owner === owner` in `publish.ts`), copying the existing owner check on unpublish.
- **Why it counts as a miss:** a written rule already forbade this. minion.town's design of record, `designs/mcp-endo-guest.md`, has an Access-control directive from the maintainer dated 2026-07-09 (on `main` since 07-10). It says per-action authority comes only from capabilities the guest holds. So this is not new direction.
- **No review panel saw it:** none ran on #85 before the 09-30 review. All six panel rounds are dated 2026-10-03, after the fix. Under the manual-gauntlet rules in force on 09-03 no panel was due, so I did not file it as the panel being skipped on purpose.
- **Gaps on both halves:**
  - *Prevention:* the builder brief has no rule against deciding authorization by who the caller is.
  - *Detection:* neither the locksmith brief nor its `C-locksmith.sh` probe targets an owner or identity comparison. The probe's pattern could easily miss a diff like #85's.
- **The primary job's work exists:** its fixer, `kriscendobot-minion.town-pr85-fix-ocap-publish-authority`, replaced the owner check with an attenuable upgrade capability and replied on the PR. It also posted `design-minion-town-clip-lifecycle-capabilities`, because unpublish and listSites still check the owner. The PR's 10-03 commits include "add revocable, attenuable upgrade capabilities". There is no gap between what the primary claimed and what landed.

## What I recorded
- **Miss record:** `review-misses/misses/kriscendobot-minion.town-pr85-review-9f17a419.md`, written in my own words with the review URL; none of the review text is pasted in.
- **New cluster:** `identity-gated-authority`, count 1, one PR.
- **Threshold call:** the normal floor (3 misses across 2 PRs) is not met. I dispatched anyway under the severity rule for a single major miss that broke a standing rule. The cluster is now marked improvement-dispatched, with the reasoning recorded.
- **Job posted:** `review-improve-identity-gated-authority` (identity `review-cluster:identity-gated-authority`). Its contract has two parts:
  - **Prevention:** a builder-brief rule against identity-keyed authorization, including not copying an existing sibling check.
  - **Detection:** a new recurring-finding line in the locksmith brief, plus a panel-hints probe that fires on owner or caller equality checks.
  - **Proof:** it must show the probe fires on the original #85 diff, then close the cluster.

## Follow-ups
- The minion.town unpublish and listSites paths still decide by owner. That work belongs to `design-minion-town-clip-lifecycle-capabilities` and open design PR #142.
- I made no commits to `main2`; all changes are in the review-miss records and the job board on `journal2`.
- My inbox was empty.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-review-9f17a419-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1529789 cached reads)
- Output: 13263 tokens
- Cost: $1.2937618000000002
- Wall-clock: 172s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
