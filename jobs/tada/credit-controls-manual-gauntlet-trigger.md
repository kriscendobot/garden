The stray file is gone from the deployed root and my worktree is clean. The work is complete and pushed.

## Completion report

**Job:** `credit-controls-manual-gauntlet-trigger` (child 2 of 4, orchestration `credit-controls-20260916`) — adopt the manual-gauntlet-trigger design so gauntlets are not staged autonomously.

**Found, not written:** the design already existed at `designs/manual-gauntlet-trigger.md` (Status: Proposed). I implemented it and marked it Accepted with an implementation note; I did not write a new one.

**What changed (pushed to `main2` as `db3687f60d`):**

- **Automatic stager retired.** Deleted `scripts/jobs/auto-gauntlet-handoff.sh` and removed its call from the gardener completion path. A completed `build`/`design`/any producer now stops at its open **draft** PR and stages no gauntlet.
- **Completion sensor generalized.** Replaced `assert-design-pr-gauntlet.sh` with `assert-producer-pr-draft.sh` (a draft guardrail): a **draft** producer PR completes cleanly with nothing owed; completion is blocked only for a bot-authored **OPEN NON-DRAFT** PR named in the report with no gauntlet coverage (the "opened ready by mistake" class). It never mutates PR state, applies to all roles, and fails open on inconclusive reads.
- **The autonomous coverage-audit timer → made to alert, not stage.** `design-pr-gauntlet-coverage-audit.sh` (same filename + systemd unit) is now **non-mutating**: it raises a **deduplicated maintainer alert** (keyed on `<repo>#<number>:<headRefOid>`) about uncovered non-draft bot PRs and never stages a record or re-drafts a PR. **Its hourly cadence is retained** — an alert-only sweep costs ~nothing versus the 2026-08-30 mass-stage ($482). This is the explicit answer to the task's question: the timer is neither retired nor slowed; it is demoted from a stager to a readiness alerter.
- **Trigger:** `run the gauntlet #N` (→ `post-gauntlet.sh`, already recognized by the comment-watcher and liaison) is now the sole ordinary trigger.
- **Docs/vocab:** updated `CLAUDE.md`, `README.md`, `roles/liaison|builder|designer/AGENT.md`, `skills/pr-creation-flow/SKILL.md`; marked `designs/auto-gauntlet-pr-reconciler.md` superseded.
- **Regression tests:** new `assert-producer-pr-draft-test.sh` (draft passes/no mutation/no record; non-draft uncovered blocks; covered/probe/non-bot/carve-out/citation/inconclusive pass) and rewritten `design-pr-gauntlet-coverage-audit-test.sh` (alert-only, head-dedup, re-alert on changed head, nothing staged). Retired the stager tests. `comment-watcher-test.sh` already asserts `run the gauntlet` creates a durable record (349/0).

**Verification (all run):** both new tests PASS; `comment-watcher-test.sh` 349/0; `tests/checks/run.sh` 10 suites/0 fail; `shellcheck -S warning` clean on all changed `scripts/jobs/*.sh`; `bash -n` clean on all changed test files.

**Note/process:** I initially wrote two files to the deployed root path by mistake; I reverted the root (verified byte-identical to pristine, stray script removed) and redid all work in the job worktree before committing.

**Follow-ups (not blocking):** historical design docs `staged-gauntlet.md`, `gardening-state-machine.md`, and `kimi-k3-...md` still mention `auto-gauntlet-handoff.sh` in prose; left as dated records (the directly-affected reconciler design is marked superseded).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/credit-controls-manual-gauntlet-trigger.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 190 tokens (14178955 cached reads)
- Output: 76640 tokens
- Cost: $11.0487095
- Wall-clock: 1054s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
