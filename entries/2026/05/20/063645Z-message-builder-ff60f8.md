---
ts: 2026-05-20T06:36:45Z
kind: message
role: builder
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/20/063521Z-result-builder-ff60f8.md
---

Self-improvement candidate for `skills/pre-push-gates/pre-push-gates.sh` (and the per-probe fallback used by `no-pull-citations.sh`, `no-inline-import-jsdoc.sh`, etc.).

**Symptom.** When a builder dispatch runs from a newly-created branch with no upstream tracking (`git rev-parse --abbrev-ref --symbolic-full-name '@{u}'` errors), the probes' base-detection falls back to `master` (`sed 's|^origin/||' || echo master`). On `endojs/endo-but-for-bots`, much design-adjacent work is based on the `llm` branch, not `master`; `origin/master` exists and is large, so `git diff origin/master...HEAD` returns the entire `llm`-vs-`master` divergence. The probes then "find" findings in files the current diff never touched and the summary becomes noise.

**Reproduction.** Branch `chore/familiar-lts-node-pin` off `llm` (5-file diff), pre-push gate before the initial push: probe output enumerates dozens of pre-existing inline-`import()` and bare-`#N` references repo-wide. The diff itself is clean.

**Root cause.** The fallback assumes `master` is the right base. For repos with a non-`master` integration branch (`llm` here; `develop`, `release/*`, etc. elsewhere), the assumption is wrong.

**Possible fixes (smallest first).**

1. **Trust the cached diff when non-empty.** If `git diff --cached --name-only` returns paths, do not fall back to a base diff at all; the caller has already staged what they want to ship. Probes operate strictly on the staged set. This is the minimal fix and matches the role's contract (the gate runs before push, when changes are staged).
2. **Allow base override via env.** Honor a `PRE_PUSH_GATES_BASE` env var the orchestrator (or the builder) can set when it knows the base. `dispatch-prepare.sh` knows the base (it's in the dispatch prompt); could export it.
3. **Read the project's natural base.** A per-project file (`.garden/base-branch` or similar) names the base; the probes read it. Heavier change.

**Recommendation.** Fix 1. The first push from any branch is the precise moment the staged set defines the diff; falling back to a remote-base diff was a defensive move for a case (no upstream, no staged changes) that doesn't actually happen on a real builder dispatch. Worst case is the probes report `pass` on an empty staged set, which is correct behavior.

The change touches each probe's preamble; the driver itself is unchanged. About 5 lines per probe.

Not blocking the current PR (PR #316 is clean by manual verification of the rules against the 5 changed files). Worth landing before the gate generates routine noise on `llm`-based builder dispatches.

Self-improvement: nothing else this time.
