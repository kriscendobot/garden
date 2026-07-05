---
model: fable
---

# Fable: review the garden's scripts, serially fix discovered issues, push main2

**GARDEN self-development.** Work in your per-job worktree off `origin/main2`; push **directly to `origin/main2`** (no PR, garden convention). Run the whole flow on **Fable** — the review, and every fix subagent you dispatch.

> **Worktree caution:** if your `gardener-wt-*` git admin entry is swept mid-job, commit/push from a standalone scratch clone. (The `garden2` bind-mount root cause is being repaired host-side; if a `git worktree` op writes `/home/kris/garden2/...` paths, that repair has not landed yet — surface it rather than fighting it.)

## Phase 1 — Review (Fable)

Review the garden's **`scripts/`** tree — the shell scripts for humans and systemd: the job-system logic (`scripts/jobs/` and `scripts/jobs/**`), the watchers (`scripts/watcher/`), the daemon wrappers (`scripts/daemons/`), the templated units (`scripts/systemd/`), the handlers (`scripts/jobs/handlers/`, `scripts/jobs/gardening/`), and the top-level scripts (`garden`, etc.). Read `roles/COMMON.md` first.

Look for real defects and fragility, not style nits: shell-correctness bugs (unquoted expansions, missing `set -euo pipefail`, `[ ]` vs `[[ ]]` pitfalls, subshell/`|| true` swallowing failures under `set -e`), broken or racy CAS/retry logic, unhandled error paths that abort a whole tick and silently drop work, dead/duplicated code, and cross-script inconsistencies. Produce a **prioritized list of concrete issues**, each naming the file, the symptom, and the failure scenario.

## Phase 2 — Serial fix subagents (Fable)

For **each** discovered issue, **dispatch a fix subagent serially — one at a time, on Fable** (via the Agent tool). Serial is required: the fixes all touch `scripts/` and land on the same `main2` worktree, so concurrent subagents would conflict. Each subagent:
- addresses exactly one issue in the `main2` worktree,
- makes a focused, self-contained commit (garden self-dev; message describes the fix),
- returns a short report of what it changed and how it verified.

Wait for each subagent to finish and its commit to land before dispatching the next. If a fix turns out unsafe or out of scope, skip it and record why rather than forcing it. Prefer running any existing script tests (`scripts/jobs/test/*.sh`) touched by a fix.

## Phase 3 — Push main2

After all fixes are committed, **push once to `origin/main2`** (`git push origin HEAD:main2`, rebasing on the current tip first if needed — the fleet advances main2 concurrently). No PR (garden convention: the garden pushes directly to its own repo).

## Definition of done

A prioritized review of `scripts/` was produced; each accepted issue was fixed by its own serial Fable subagent as a focused commit; touched tests pass; `main2` is pushed. The report lists each issue, its disposition (fixed / skipped-with-reason), and the pushed commit range.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot
  gardener: 65
  claimed_at: 2026-07-05T17:35:57Z
