---
ts: 2026-06-14T07:44:34Z
kind: result
role: gardener
host: endolinbot
project: garden
refs:
  - entries/2026/06/14/073600Z-dispatch-gardener-aa3d6f.md
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4701061078
---

# result: gardener — relax shepherd's surgical-fix constraint (cross-reference cleanup; primary edit landed concurrently)

## What happened

The maintainer's directive on kriscendobot/agoric-sdk #5 was dispatched to this gardener (aa3d6f) and to at least one concurrent gardener in parallel. The concurrent gardener landed the primary `roles/shepherd/AGENT.md` relaxation as commit `7687bc42` on garden `main` approximately 72 seconds before this dispatch's first push attempt; that commit retired the prior surgical-fix-scope constraint, re-anchored the escalation criterion on impasse, and added impasse / safety-guardrail categorization to the *Hard escalation points* section.

This dispatch's attempt to land the same shepherd edit was rejected as a non-fast-forward and conflicted on rebase (both edits touched the same operating-norm bullets). The right move was to abandon the duplicate shepherd edit and land only the complementary cross-reference cleanup the concurrent gardener did not touch.

## Before / after

### `roles/shepherd/AGENT.md`

No this-dispatch edit (the concurrent gardener's `7687bc42` is the canonical relaxation). Summary of what landed in that commit:

- *Operating norms* headline rewritten from "Take initiative to get all tests passing" to "Pursue all tests passing in CI by whatever means necessary, until reaching genuine impasse or success" with the verbatim maintainer quote.
- *Hard escalation points* restructured into three Impasse rows (design decision needed, structural decision needed, missing context) and three Safety guardrail rows (never silently delete a failing test, never bypass safety checks, never push outside the PR's scope). Closing paragraph retires the prior "more than ~5 files or multi-module" framing limit.
- *Escalation classification* `next: fixer` row re-anchored on *contextual* impasse rather than scope-of-fix; verdict noted as less common under the new framing.
- Frontmatter `updated: 2026-06-14`.

### `roles/conductor/AGENT.md` (this dispatch's only landed edit)

Step 4 sub-rule rewritten. **Before:**

> **Failing**: do NOT merge. Stall with reason `ci red: needs shepherd`; the next steward cycle dispatches a shepherd. Out-of-scope failures (multi-file refactor, public-API change, test deletion) stall `ci needs fixer`.

**After:**

> **Failing**: do NOT merge. Stall with reason `ci red: needs shepherd`; the next steward cycle dispatches a shepherd. The shepherd's own escalation classification routes onward to fixer / weaver / designer / liaison as needed (per `roles/shepherd/AGENT.md` § Escalation classification: name the next role); the conductor does not pre-classify the failure. (The prior "Out-of-scope failures stall `ci needs fixer`" sub-rule was retired 2026-06-14 alongside the shepherd's surgical-fix-scope retirement; the shepherd now handles multi-file refactor in-scope.)

The prior pre-classification by failure shape (multi-file refactor → fixer) relied on the shepherd's now-retired surgical-fix scope. With the shepherd's new "whatever means necessary until impasse" framing, multi-file refactor is in-scope for the shepherd; the shepherd's own escalation verdict is the authoritative routing signal. The retired sub-rule is cited inline so a reader of older journal entries can match prior conductor stall reasons to the new flow. Frontmatter `updated` bumped to `2026-06-14`.

## Cross-reference grep results

- `roles/COMMON.md`: only mention of shepherd is the per-role authorization line ("a CI-fix push is implicit; posting a green-run-URL comment is a per-action authorization") which does not reference scope. No edit needed.
- `skills/`: nine skills mention shepherd (`worktree-per-pr`, `process-documents`, `reactji-acknowledgment`, `pr-ci-watch`, `pr-handoff`, `model-selection`, `monitor-endo`, `node-lts-window-watch`, `at-mention-surveillance`); grep for `shepherd.*surgical|shepherd.*scope|shepherd.*5 file|shepherd.*small.*fix|shepherd.*architect` returns no matches. No edit needed.
- `roles/steward/AGENT.md` § Shepherd → fixer auto-pickup chain: references "above the fixer's surgical-fix scope". That phrase characterizes the *fixer's* domain (which the dispatch brief explicitly says to leave alone), not the shepherd's prior constraint. No edit needed.
- `roles/conductor/AGENT.md` step 4: edited as above.

## Commit

- Garden `main` SHA: **`183efbfd`** ("roles(conductor): drop pre-classification of failing-CI stall after shepherd surgical-fix retirement").
- Predecessor SHA: `7687bc42` (concurrent gardener's primary shepherd relaxation).

## Concurrency note

This is the second concurrent-gardener collision in recent memory (the prior one being the same-day shepherd directive that landed identically-titled commits from two dispatches racing). The dispatch brief did not flag the concurrency risk because the orchestrator had no way to know a second gardener was in flight. Mitigation pattern that worked here: rebase on the remote, observe the equivalent commit, reset to the remote, and salvage only the complementary edit the other dispatch missed.

Self-improvement: when a gardener dispatch's primary edit is preempted by a concurrent gardener landing the same lesson first, abandon the duplicate edit and land only the cross-reference cleanup the other dispatch missed. Do not re-land the primary edit even if your wording is preferable; the journal already records both gardeners' framings via the dispatch entries, and double-landing the same lesson under two commits churns the file twice. Worth a Note from the field on `roles/gardener/AGENT.md` if a third instance occurs.
