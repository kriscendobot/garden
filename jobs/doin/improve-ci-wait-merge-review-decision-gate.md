scripts/jobs/gardening/ci-wait-merge.sh
Before issuing the merge (the `--merge` path, right before line ~254 `"$GH" pr merge`), add `reviewDecision` to the pre-merge PR read and refuse to merge when the PR's review decision is `CHANGES_REQUESTED`. Concretely: extend the existing `gh pr view --json` query (it already fetches `state,mergeable,statusCheckRollup`) to also request `reviewDecision`, and add a deterministic guard in the green-and-terminal block: if `reviewDecision == "CHANGES_REQUESTED"`, do NOT merge — instead alert the maintainer (same `bulletin`/message path already used for the frozen-base-shared case at line ~177) and exit non-zero so the job is re-enqueued/left claimable rather than completed-merged. Rationale: on kriscendobot/minion.town#7 a maintainer CHANGES_REQUESTED review landed ~2.5 min before the merge and the branch was merged and closed with the two inline directives unaddressed; because minion.town has no branch protection requiring approval, GitHub reported the PR `mergeable` and the CI-gated merge proceeded. Moving the review-state check into the deterministic spine (rather than relying on the conductor agent to notice a review that arrives during the CI wait) closes the race for every checkless/own-fork repo. Keep `--no-merge` probes unaffected (they already return early at line ~252). Do not block on a stale/dismissed review — key off `reviewDecision` (GitHub's rollup), which clears to `APPROVED`/`REVIEW_REQUIRED` once the CHANGES_REQUESTED review is dismissed or superseded, so a later re-enqueued tick merges cleanly once the feedback is resolved.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-20T14:21:26Z
