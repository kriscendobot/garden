Pushed on attempt 1 (commit `1c9f29fefd` on `origin/main2`). The worktree is clean and the deployed root is no longer dirtied by my work.

**Self-improvement:** nothing this time. The one friction (I initially wrote the design into the deployed root checkout at `/home/kris/garden2/designs/` instead of my job worktree, because I reflexively used the absolute root path) is a near-miss of a discipline the gardener role and `roles/COMMON.md` already document prominently. No new rule warranted; caught and corrected before commit.

---

## Completion report

**Job:** `design-evaluation-epochs-panel-calibration` (designer role). Delivered a garden meta-design at `designs/evaluation-epochs-panel-calibration.md`, direct-committed to `main2` per garden convention (no self-PR), plus its index row in `designs/README.md`. Commit `1c9f29fefd`, pushed to `origin/main2` on the first CAS attempt.

**What the design covers** (turning the scholar's RQGM / arXiv 2606.26294 5-part sketch into a buildable spec, scoped to PR review only):
- **Hard safety boundary up front:** promotion is maintainer-gated with a single-origin `approved_by` flag (on the ferry's `identity_switch_authorized` model); no autonomous rubric self-mutation; deterministic checks and independent evidence survive every epoch; all changes route through the existing self-improvement / review-retrospective workflow as designer/builder jobs.
- **Registry** (`journal/evaluation-epochs/pr-review.md`): frozen per-epoch seat composition + disposition rubric, epoch ID stamped into every verdict (run dir, tada report, posted review footer), append-only stanzas.
- **Anchor corpus:** exact case definition, three confirmed label sources (review-misses store, CI-red-after-green escapes, adjudicated findings), maintainer-confirmed curation, a held-out split never shown to challenger authors, and per-decision immutable versioning.
- **Frozen-epoch operation, checkpoint promotion** (with a validated mermaid state diagram), **promotion threshold math** (conservative lower-bound recall via paired McNemar, with false-accept/reject, cost, and adversarial-resistance gates), **invalidation rule** (re-run only open-PR verdicts dependent on changed seats/rules; merged PRs re-tagged not re-run), and **adversarial replay** as a bounded, separately-reported metric.
- **Surfaces touched/added** (panel.sh, panel-review, review-retrospective/prosecutor, self-improvement, schedule, job-board; new `scripts/jobs/evaluation/` helpers and two analysis-only job kinds), an explicit **"what this pilot does NOT do"** section, a **5-phase build plan** whose Phase 0 (registry + epoch tagging) is pure observability and the recommended first green-light target, and 5 open questions for the maintainer.

**Verification evidence:** mermaid diagram validated parse-only per `skills/mermaid-validation` (`node check.mjs` → `OK stateDiagram`); prose swept clean of em-dashes and Latin shorthand (`grep` returned no matches for either); push confirmed by `git log` showing HEAD at `origin/main2`.

**Follow-ups / notes:**
- The job asked me to read the maintainer-inbox report from `scholar-arxiv-2606-26294` first. That report is **not present** in this instance's `journal2` (searched inbox, entries, and tada; the only scholar/26294 hit was an unrelated 2026-05-14 endo#3121 entry). I worked from the job body's own RQGM summary, which was complete enough to build the spec. If the maintainer wants the design reconciled against the full scholar analysis, that report needs to be surfaced.
- Design status is **Proposed**; it ends with a phased plan so the maintainer can green-light implementation (Phase 0 is the safe, reversible first increment).
