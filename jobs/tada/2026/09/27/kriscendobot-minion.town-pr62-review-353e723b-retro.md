## Retro report: kriscendobot/minion.town #62 (review 5072254610)

**Verdict: this was a review miss.** The panel should have caught it. I recorded it and joined it to an existing cluster. The cluster is below the dispatch threshold, so I posted no improvement job.

**Starting point.** Nothing from the earlier attempt survived, and there was no existing record for this retro in `review-misses/misses/` or `review-misses/dismissed/`.

**What I checked:**
- **The PR itself.** #62 was opened by the builder job `minion-town-rename-main-worker-to-at-main` to rename the guest's provisioned worker from `MAIN` to `@main`. That job opened it ready-for-review (not as a draft), and it merged on 2026-08-31.
- **The review history.** `jobs/tada` has no gauntlet or panel job for #62, only the builder job, the review primary, and the conductor jobs. No panel reviewed the PR before the maintainer did.
- **The primary's fix-up commit (`1aafcbefe6`).** It confirms the gap. The original rename changed the gateway's `evaluate` call to `@main`, but the pinned Endo daemon still only provides `MAIN`. The fix had to add a `MAIN` fallback, and it links endojs/endo-but-for-bots#982 for the upstream provisioning work.
- **The primary's claims.** I checked them against GitHub rather than the primary's report, and they hold: the fix-up commit and the summary comment exist, and the PR is merged.

**Why it counts as a miss:** the rename target was already decided, and the rename changed where the name is used without following it back to where it is created (guest provisioning, across the Endo boundary). That's the same "old name left behind" gap as the existing `incomplete-rename-old-name-sweep` cluster. The maintainer's request to link the upstream work is follow-up bookkeeping, not new direction.

**Recorded:** `review-misses/misses/kriscendobot-minion.town-pr62-review-353e723b.md`
- Category: naming. Severity: moderate.
- Missed by: no panel ran; the stylist (as rename-discipline backstop) and ergonomist seats would have owned the check.
- The record is my own paraphrase plus the review URL; I didn't copy the review text into the store.

**Cluster decision:** `incomplete-rename-old-name-sweep` now has 2 misses across 2 PRs (#475 and #62). The floor for dispatching an improvement is 3 misses across at least 2 PRs. The severity bypass doesn't apply either, because no existing rule required checking where a renamed name is created. The cluster stays open, with that rationale written to it.

When a third miss lands, the improvement job should also cover the docs-side sibling cluster `stale-identifier-reference-sweep`. The shared fix is one old-name grep across the whole PR, extended to where the renamed name is created. The missing gauntlet on #62 is a second factor, but a retro records only one category, and the existing `builder-pr-gauntlet-bypass` cluster already tracks that pattern.

No garden code changed; the only changes are the two review-misses store writes on journal2. No follow-ups needed beyond what the cluster rationale says.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr62-review-353e723b-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (2 unmetered)
- Input: 30 tokens (960250 cached reads)
- Output: 6620 tokens
- Cost: $0.855002 (2 engagement(s) unpriced)
- Wall-clock: 140s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
