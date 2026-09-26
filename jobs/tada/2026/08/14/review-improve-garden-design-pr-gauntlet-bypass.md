All deliverables complete and verified. Writing the completion report.

## Completion report

**Job:** `review-improve-garden-design-pr-gauntlet-bypass` — close review-miss cluster `garden-design-pr-gauntlet-bypass` (count=3: kriskowal/garden #7, endojs/endo-but-for-bots #809, kriscendobot/minion.town #41). In all three, a garden-produced **design PR** reached maintainer review with no design-panel gauntlet, because the auto-gauntlet completion edge fired only for `role: builder` and the three producing jobs carried other roles (researcher-designer, gardener, designer).

**Root cause:** `scripts/jobs/auto-gauntlet-handoff.sh` (the completion-machinery edge `gardener.sh` runs on every job) early-exited unless `plan_role == builder`. Producer-coupling, exactly as `designs/auto-gauntlet-pr-reconciler.md` predicted.

### (a) Prevention — deterministic, in the job-completion machinery (not a role reminder)
- **`scripts/jobs/auto-gauntlet-handoff.sh`**: no longer gates on `role: builder`. The builder feature/probe path is byte-for-byte unchanged; any **non-builder** completion that named a bot-authored, OPEN, **DRAFT**, DESIGN-ONLY PR now records that PR's design gauntlet under a **PR-keyed** base (`<owner>-<repo>-pr<N>-gauntlet`). `panel.sh` senses the design panel from the diff and un-drafts at the end. It **never re-drafts** a ready PR on this path (the #671/#867 corruption hazard the existing guards protect against).
- **`scripts/jobs/common.sh`**: `design_only_paths` (mirrors `panel.sh`'s design-panel predicate, plus the `docs-design/` convention) and `gauntlet_record_for_pr` (PR-keyed idempotence, so two producers on one design PR converge on one record — closes the design's failure-boundary item 4).
- **Probe exception preserved:** probes are `role: builder` + a `gap-revealing prototype` marker → the unchanged builder path parks them draft; the design path defensively exempts the same marker.

### (b) Sensing — durable, deterministic, independent of the stager
- **`scripts/jobs/assert-design-pr-gauntlet.sh`** (new) senses the **evaluator's absence**: it independently re-derives the design PR and refuses to record the job complete (rc 1) while that PR has **no gauntlet record**. Wired into `gardener.sh`'s completion path; a block leaves the job in doin like a failed handoff (reaper retries). Fails toward not-wedging on inconclusive reads. No LLM — PR metadata + file paths + trusted journal records only. It catches even a future producer that bypasses the stager entirely.

### Verification (re-litigation test)
`scripts/jobs/test/design-pr-gauntlet-bypass-test.sh` (new, hermetic, passing) demonstrates against each historical board/PR shape: garden #7 (researcher-designer), endo-but-for-bots #809 (gardener), minion.town #41 (designer) each stage their gauntlet; the sensor **blocks** an uncovered design PR and **passes** a covered one; the valid **probe** stays draft with no gauntlet; an **ordinary correctly-staged** design PR is an idempotent no-op (including a second producer on the same PR); a non-design code PR stages nothing. The pre-existing `auto-gauntlet-handoff-test.sh` still passes (builder path intact).

### Docs
`roles/designer/AGENT.md` (norm + DoD: leave the PR draft, gauntlet auto-stages — don't hand-post), `skills/pr-creation-flow/SKILL.md` (Design-only-PR variant), `designs/auto-gauntlet-pr-reconciler.md` (Status: completion-edge slice landed; standing per-repo reconciler for out-of-band PRs remains future work).

**Landed:** commit `e1e2a3e467` on `main2` (rebased cleanly over a concurrent gauntlet.sh change). Cluster **closed** on `journal2` with `improved_by` set (verified from origin).

**Note / correction:** I initially edited the deployed garden root by mistake; I reversed every edit exactly and confirmed the root carries no stray changes before redoing all work in the job worktree.

**Follow-up (not blocking):** the standing per-repo reconciler + `jobs/pr-lifecycle/` index (design's fuller scope) would additionally cover a design PR with *no owning job* (out-of-band `gh pr create`, or a creator killed between PR-open and completion). All three cluster members had owning jobs, so the completion edge fully covers them; the reconciler is defense-in-depth left as future work. The sensor adds one read-only `gh pr view` per non-builder completion whose report names a PR — a modest, bounded cost accepted for the correctness gate.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-garden-design-pr-gauntlet-bypass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (12325641 cached reads)
- Output: 113694 tokens
- Cost: $11.3172505
- Wall-clock: 1542s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
