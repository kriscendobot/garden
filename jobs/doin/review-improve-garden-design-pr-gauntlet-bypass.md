---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# review-improve: garden-design-pr-gauntlet-bypass

Cluster `review-misses/clusters/garden-design-pr-gauntlet-bypass.md` has reached
the default dispatch floor: count=3 across three distinct PRs (7, 809, and 41).
The latest member classifies the recurring route-around-the-evaluator failure as
the avoidance shape of `evaluator-gaming`; the older two records used the legacy
`process` category. Read the cluster and all three member records:

- `review-misses/misses/kriskowal-garden-pr7-review-4798277a.md`
- `review-misses/misses/endojs-endo-but-for-bots-pr809-review-581b1021.md`
- `review-misses/misses/kriscendobot-minion.town-pr41-review-5b4e7d27.md`

In every member, a garden-produced design PR reached maintainer review before
the required design-panel gauntlet ran. Deliver both halves below; either half
alone is incomplete.

## (a) Prevention

Edit the narrowest governing producer artifacts so every job that creates a
reviewable design PR durably stages its gauntlet before the producing job can
complete. Cover exceptional garden-repository design surfaces as well as project
design PRs. Prefer moving the invariant into the deterministic PR-creation or job
completion machinery over relying only on a role reminder. Preserve the probe
exception: a deliberate gap-revealing probe remains draft and does not enter the
mergeable-feature gauntlet.

## (b) Durable review-cycle sensing

Add a deterministic check that detects a garden-owned design PR with no formal
design-panel verdict/gauntlet record before it can be presented for maintainer
review or considered complete. If no reliable mechanical enforcement point
exists, amend the appropriate design-review seat and add a panel-hints probe in
the same commit, but explain why deterministic enforcement was not viable. The
check must sense absence of the evaluator, not merely inspect document quality.

## Verification: re-litigation test

For each of the three member misses, name the exact new prevention and sensing
check that would catch the historical failure. Demonstrate the check against the
historical board/PR shape for garden PR 7, endo-but-for-bots PR 809, and
minion.town PR 41. Include regression coverage for the valid probe exception and
for an ordinary design PR whose gauntlet is staged correctly.

After both deliverables and the per-member demonstrations land, close the
cluster with:

`scripts/jobs/review-miss-record.sh cluster-status garden-design-pr-gauntlet-bypass closed --improved-by "<commits/files changed>"`

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-14T05:38:15Z
