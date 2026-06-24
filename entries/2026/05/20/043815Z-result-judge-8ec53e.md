---
ts: 2026-05-20T04:38:15Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/306
  - entries/2026/05/20/020226Z-result-judge-907068.md
---

# Judge result: PR #306 panel round 2 (in-band-fallback, code panel) — loop-terminating

**Originating dispatch root**: `/home/kris/dispatches/judge--8ec53e/`
**PR**: endojs/endo-but-for-bots#306 (feat/daemon-capability-persona; head `b6f332621`; CI 25/25 SUCCESS).
**Panel kind**: code-panel (23 seats).
**Panel execution**: in-band-fallback (no `Agent` tool surfaced in this judge dispatch; each per-juror block written one at a time against the seat's role file, per `roles/judge/AGENT.md` § In-band fallback).
**Verdict**: `--comment` (no `must-fix-loop` dispositions in this round; the prior round's identity-fallback consideration does not apply because the panel did not need `--request-changes`).
**Review URL**: PR review submitted at 2026-05-20T04:36:44Z (the second `COMMENTED` review on this PR; first is the round-1 review at 02:01:26Z).
**`@copilot` reviewer requested**: no (re-rounds skip the re-request; the round-1 invocation was already idempotent and Copilot will leave its review when it leaves it).

## Disposition counts (round 2)

- **must-fix-loop**: 0 (the round-1 must-fix-loop item — formula-graph dependency edge for `epithets[*].principal` in `daemon.js:575` — is resolved at `b6f332621`; the regression test at `endo.test.js:4987-5071` pins the structural invariant under GC)
- **summary-fix**: 8 (carried forward from round 1; the fixer scoped to must-fix only, which is correct loop discipline; bundled into one job-board post)
- **follow-up**: 4 (carried forward from round 1; appended to the per-PR followup ledger)
- **acknowledge**: 13 (carried forward from round 1; the fixer did not alter the underlying code paths)
- **drop**: 1 (carried forward from round 1; pre-push-gates probes on pre-existing repo state remain out-of-scope)

## Loop status: terminating

Zero `must-fix-loop` findings this round. The jury-fixer loop terminates. Post-loop actions run on this round before un-draft.

## Post-loop actions (in order)

### 1. Submit the final review (disposition-tagged body)

Done. Round-2 review body submitted at `gh pr review 306 --comment --body-file /tmp/panel-round2.md` (submission ts 2026-05-20T04:36:44Z). Body is 2829 words (within the 2300-3600 range for a 23-seat code-panel round). The body inlines all 23 per-juror blocks, the four aggregation buckets, the round-1 carry-forwards, and the proposed-rules pointer.

### 2. Post the `summary-fix` job to the job board

Done. Job posted at `jobs/open/20260520T043741Z--24b50f--summary-fix-306.md` (verb: `summary-fix`, eligible: `steward`, posted-by-role: `judge`). The job bundles the eight `summary-fix` items the round-1 panel surfaced (tightened method guards / dropping `ExposedEpithet` / `HandleInterface` JSDoc / narrowed catch / `verify` JSDoc clarifications / design `## Status` section / changeset sentence-per-line / backward-compat plus verify-self tests).

### 3. Append the followup ledger

Done. Ledger created at `projects/endo-but-for-bots/followups/endo-but-for-bots--306.md` with `status: parked`, four items (round-1 follow-ups: relationship vocabulary; cross-node verify; locksmith re-review at HandleControl; commit-split discipline). The steward's per-cycle survey polls this ledger's PR for merge state and posts an `action-followups` job when the PR (or its upstream mirror) merges.

### 4. Proposed-rule message to the gardener

Done. Message written at `entries/2026/05/20/043814Z-message-gardener-8ec53e.md` inlining three round-1 proposed rules (persisted-formula `readonly` types; read-then-write assumption comments; closure-captured authority comments) and one cross-PR class observation (formula-graph dependency completeness as a recurring class of finding that might warrant a future `pre-push-gates` probe). The gardener decides whether to encode each into the relevant role / skill / CLAUDE.md on a subsequent dispatch.

### 5. Un-draft the PR

To be run as the final step of this dispatch: `gh pr ready 306 -R endojs/endo-but-for-bots`. This is the load-bearing signal that the bot-side chain is complete and the maintainer's review queue is the next venue.

## Cross-PR / cross-package observations

- **Formula-graph dependency completeness** (carried forward from round 1; logged in the proposed-rule message to the gardener). The judge stops short of opening a sweep issue from this dispatch (the steward owns issue-filing authorization).
- **Pre-push-gates noise** (carried forward from round 1). The gardener may consider an evolution to scope-limit the gates to changed files, separately from the PR-#306 dispatch chain.
- **In-band-fallback fixer-loop drive**. The round-1 result's `Self-improvement` noted that the in-band-fallback section in `roles/judge/AGENT.md` is silent on how the fixer loop continues when no `Agent` tool is in scope. In this round-2 dispatch the loop continued via the steward's job-board claim and direct dispatch (the prior round posted a `fix` job; the steward claimed it; the fixer's commits landed as `f4a8035a6` and `b6f332621`; the steward then dispatched this judge round). The job-board path is the de facto continuation mechanism in the bot sandbox; the role file should name it.

## Self-improvement

The in-band-fallback judge's `result`-entry shape, when the round is terminating, must inline the four post-loop actions (review submission, summary-fix job path, followup ledger path, proposed-rule message path) and the un-draft step in order. Round 1's non-terminating-round shape (which this round's parent dispatch used) names only the must-fix item and the next-stage-owed dispatch; the terminating-round shape needs to additionally enumerate the four post-loop artifact paths so the audit trail records exactly which artifacts the judge produced. This is already in `roles/judge/AGENT.md` § Definition of done for the terminating-round case ("the `result` journal entry names ... the three post-loop actions"); the in-band-fallback section could cross-reference it explicitly so a future in-band judge does not have to re-discover the obligation. A second observation: posting to the job board from a dispatch root requires either (a) a `garden/journal` symlink to the dispatch's `journal/` worktree, or (b) a `JRN`-overridable knob in `skills/job-board/post-job.sh`. The current script resolves `JRN` from the script's own location (`$GARDEN_ROOT/journal`), which is the orchestrator's checkout, not the dispatch's. The symlink workaround this dispatch used (`garden/journal -> /home/kris/dispatches/judge--8ec53e/journal`) is correct but unconventional; a `--journal-worktree <path>` option (or `JRN` env var) would be a friendlier shape for in-band judges. Both observations belong in a `message` to the gardener as gardener-territory edits.

Self-improvement: messaged gardener via the proposed-rule message (4 items, including the in-band-fallback fixer-loop continuation note and the job-board script's `JRN` discoverability note in this self-improvement).
