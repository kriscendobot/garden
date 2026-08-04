---
gate: deferred
priority: normal
posted_by: prosecutor
posted_at: 2026-08-04T05:27:31Z
---

---
role: builder
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# review-improve: merge-base-pinning (prevention + durable sensing)

Cluster `review-misses/clusters/merge-base-pinning.md` cleared the threshold in the
consolidated review-retrospective pass (job `review-retrospective-consolidated-20260804`):
count=4 across PRs #719, #831, #836 (endojs/endo-but-for-bots). In each case a PR
reached maintainer review without its merge base pinned to the frozen
`master-xxxx` / `llm-xxxx` branch per standing instruction, so it entrained
irrelevant commits or stray artifacts:

- #831 `comment:5063492506` — "set the merge base to a master-xxxx branch per
  standing instructions. **These may need to be reinforced.**"
- #831 `comment:5063556146` — 79 commits entrained, many irrelevant; may need a
  restart from scratch.
- #836 `review:4782068426` — "pin the llm branch base to llm-xxxx by hash, rebasing
  on current llm."
- #719 `review:4751242280` (inline) — a stray package.json artifact because "this PR
  predates the master-xxx pinned base convention. Please refresh."

The maintainer explicitly said the standing instruction "may need to be reinforced" —
a standing rule that did not bind, spanning ≥3 PRs. Deliver BOTH halves:

**(a) Prevention.** The `skills/frozen-base-branch/SKILL.md` procedure already exists
and the builder role references it. Reinforce it: make the frozen-base pin (branch off
`<base>-<short-sha>` of the current upstream tip, never a floating `master`/`llm`) an
explicit, hard precondition in the builder AND weaver flows, and in the
`rebase-before-followup` / `rebase-hygiene-audit` skills, so a rebase/weave that
re-parents onto a moving branch is disallowed. Name the failure shapes: (1) basing on
floating `master`/`llm` instead of a pinned `-xxxx` snapshot, (2) a rebase that
entrains commits outside the intended delta.

**(b) Sensing (durable, prefer deterministic).** Add a check that fails when a PR's
base branch is a floating `master`/`llm` rather than a pinned `<base>-<sha>` snapshot,
or when the PR's commit count vs its merge base exceeds the intended delta by a wide
margin (the "79 entrained commits" signal). Prefer a `scripts/jobs/gardening/`
pre-PR / weave-time check over a juror-seat instruction (a deterministic check cannot
forget). If a seat is the right tier, sharpen the seat that owns branch hygiene and add
a `panel-hints` probe on the diff signal (stray artifacts from an unpinned base).

Close with the re-litigation test: for each of #719/#831/#836, name the exact check
that would now catch it. Update the cluster to `closed` with `--improved-by` via
`scripts/jobs/review-miss-record.sh cluster-status merge-base-pinning closed`.
