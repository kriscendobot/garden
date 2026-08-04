---
role: assayer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Does planning work reduce human review rounds? (step 2 of 4)

Repository: https://github.com/kriscendobot/garden — land on `main2`, no PR.
Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

**Read-only analysis. Change no dispatch behaviour.** Steps 3 (correcting
`designs/omega-task-rank-and-foreman-retirement.md`) and 4 (admission gate) are
NOT in scope.

## The question, and why it decides the next step

Job `garden-budget-triple` established that **human review dominates machine cost
~50-190x at the median** (machine $0.16/merged PR median; human 1.75-2.41 review
rounds/PR; 88-91% of merged bot PRs take >=1 human review). At ~$0.125/job, token
spend is noise against maintainer attention.

That makes review rounds the scarce currency, and raises the question this job
must answer:

> **Does rank-1 (planning/design) work reduce the human review burden of the
> rank-0 work it spawns?**

- **If yes** — planning is investment. Surplus machine capacity should go to R1
  work, which costs tokens (nearly free) and buys back review rounds (scarce).
- **If no** — planning is backlog inflation. It should be suppressed, and the
  omega design's priority direction needs rethinking.

The maintainer will not commit to a dispatch policy without this number. An
honest "cannot tell" is a completely acceptable answer and is more useful than a
confident wrong one.

## The confound — read this before designing the analysis

**This is observational, not experimental, and selection bias is the dominant
threat.** Work that got a design phase is plausibly *different* work:

- harder or more novel (so it needed planning) -> would show MORE review rounds
  even if planning helped
- or better-understood and more routine -> would show FEWER rounds regardless of
  the planning

Either way the naive comparison of "PRs with an R1 ancestor" vs "PRs without"
measures **which work gets planned**, not **what planning does**. Do not report
a raw difference in means as if it answered the question.

If you can find a way to control for this — matched pairs on repo/area/size,
stratifying by diff size or changed-file count, restricting to a work class where
both arms occur — do it and say what it bought. If you cannot, **say so plainly
and report the comparison as descriptive only.**

## Instruments that already exist — use them, do not rebuild

| tool | what it gives | landed by |
|---|---|---|
| `scripts/jobs/review-rounds.sh` | per-merged-PR **human** review-round count (`gh`+`jq`+`awk`, bot/panel reviews excluded) | `garden-budget-triple` |
| `scripts/jobs/cost-by-pr.sh` | deterministic job->PR join (`jobs/index` identity + validated PR-shaped tokens) | `garden-budget-prs`, fixed by `garden-budget-triple` |
| `scripts/jobs/cnf-backlog-triple.py` | the rank rules (role-derived + realized floor) | `garden-backlog-triple` |

Spawn edges (job -> its parent) are discoverable from `jobs/orch/*.md`
`children:`, `orchestrated_by:` frontmatter, and `garden-promoted-from-plan`
provenance comments. `journal/reputation/events/` carries ~1910 events with
provider/model/duration.

**Reuse `cnf-backlog-triple.py`'s rank derivation rather than writing new rules.**
If you need it to classify a *completed* job rather than a queued one, extend it
or factor the classifier out — do not fork the rules. Two rule sets that drift is
exactly the hazard unum's `//devoker:test:parity` exists to prevent.

## Known limits on n — expect this to be small

- job->PR join coverage is **29%** (553 of 1910 priced bases -> 182 PRs, 77
  merged). Of those, only some will have a discoverable R1 ancestor.
- 190 merged bot PRs exist on `endojs/endo-but-for-bots`, but only 68 are joined.
- **Producer gap** (found by `garden-backlog-triple`): recurring standing
  drivers (`*-press-*`, `arc-status-daily-*`, `pi-release-watch-*`, `*-shepherd`)
  carry **no `role:`**, so they classify R0 though their output is a report.
  That mislabels some ancestors. Note its effect on your population; do not
  paper over it.

If the population with a discoverable R1 ancestor is under ~15, say so and stop
— report the count, the reason, and what would have to change. Do not compute a
correlation over single digits and dress it in a confidence interval.

## If observation cannot answer it

Then the deliverable changes shape, and that is fine: **design the prospective
experiment instead.** What would have to be recorded at job-creation time (an
ancestor-rank stamp? a planned/unplanned arm?) for a future analysis to be
clean, how long it would take to accumulate n, and what the decision rule would
be. `garden-budget-triple` found the memory axis had zero data and said so; the
same discipline applies here.

## Definition of done

A report — `designs/` or `journal/reports/`, your call, say which and why —
containing:

- the population, with n stated at every stage of filtering
- the comparison, with the selection-bias confound addressed or explicitly
  declared uncontrolled
- a **confidence grade per claim**, in the style of
  `designs/issue-cost-and-triple-evaluation.md`
- a plain answer to "should surplus machine capacity go to R1 work?" — including
  "cannot tell from this data" if that is the truth
- if the answer is "cannot tell": the prospective experiment design

Plus a `tada/` report summarising the finding and naming every question left
open. Prefer "insufficient evidence" to a number you cannot defend — the
maintainer is setting a dispatch policy from this.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-04T05:32:46Z
