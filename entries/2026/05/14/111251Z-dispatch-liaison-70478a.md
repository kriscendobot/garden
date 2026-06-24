---
ts: 2026-05-14T11:12:51Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/14/110438Z-message-liaison-f197bc.md
  - entries/2026/05/14/110129Z-dispatch-judge-044181.md
---

# Dispatch: gardener encodes judge's in-band-fallback procedure

Dispatch root: `dispatches/gardener--70478a/`. Small engagement (first one under the new short dispatch-root scheme).

## The lesson

The judge subagent dispatched by the steward against PR #135 (dispatch `044181`) discovered its tool surface did not expose `Agent` (or `Task`) — `ToolSearch` for "Agent", "task spawn", and "subagent dispatch" returned nothing. The judge's procedure assumes it can dispatch each of the twelve juror seats as its own subagent for panel honesty (a foreperson who also reviews biases the aggregation toward its own findings).

The judge ran the panel **in-band** as a compensating measure: each juror block was written against its role file's primary surface only with the secondary-overlap slice called out explicitly; deduplication ran after all twelve blocks were written; the must-fix list was extracted only after a final read-through. The verdict was submitted as a single formal `gh pr review`. Acceptable for this PR's iteration, but loses the panel-honesty property.

## Posture decision (liaison)

The role is the contract; the harness varies. **Fix the role**, not the harness. Encode the in-band-fallback as a documented procedure in `roles/judge/AGENT.md` so future judge dispatches know what to do when `Agent` is absent.

Reason: the garden's design philosophy puts discipline in role files. The harness is a runtime variable (which version of Claude Code, what tool restrictions the dispatch carries, whether nested-Agent is permitted by the host environment). A role file that adapts to its tool surface is more robust than one that assumes a specific tool exists.

The harness side may still warrant investigation — *why* did this judge subagent lack `Agent`? — but that is a parallel concern routed via a `notes-from-the-field` row, not a blocker for the role's documentation.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/judge/AGENT.md`, `skills/pr-creation-flow/SKILL.md` § Jury composition, `skills/panel-review/SKILL.md`, and the judge's surfacing message at [`entries/2026/05/14/110438Z-message-liaison-f197bc.md`](110438Z-message-liaison-f197bc.md).

2. **Add an *In-band fallback* section to `roles/judge/AGENT.md`.** Procedure:
   - At the top of every judge dispatch, the judge tries `Agent` (or `Task`). The check is one ToolSearch call or one `Agent` invocation attempt; if it returns nothing or errors out as "tool not available", the judge is in-band-fallback mode.
   - In-band-fallback mode: the judge writes each juror's findings *as if* it were that juror, one seat at a time, in the seat's own role-file order (or alphabetical for stable output). Each block is written against the seat's role file's primary surface only — the secondary-overlap slice is called out explicitly so the aggregation step can dedupe deliberately.
   - Aggregation happens after all twelve blocks are written, not concurrently.
   - The verdict is one formal `gh pr review` exactly as the multi-seat-dispatch case.
   - The judge's `result` entry names the mode used (multi-seat-dispatch vs in-band-fallback) so future readers can audit panel honesty.

3. **Surface a `notes-from-the-field` row in `roles/judge/AGENT.md`** dated 2026-05-14 citing PR #135's judge dispatch (`044181`) as the precipitating evidence, and naming the in-band-fallback path as the documented response.

4. **Update `skills/pr-creation-flow/SKILL.md` § Jury composition** with a one-line acknowledgment of the in-band-fallback path so the orchestrator (liaison or steward) reading the skill knows the judge can adapt.

5. **Add a one-line `notes-from-the-field` row to `skills/dispatch-worktree/SKILL.md`** dated 2026-05-14 capturing the harness observation: "subagents dispatched by the orchestrator do not necessarily inherit the `Agent` tool; roles that depend on nested dispatch must declare an in-band-fallback path." This is a cross-cutting note for any future role that might depend on nested dispatch (currently only the judge; the gardener might add others).

## Out of scope

- No edit to the harness or to the Claude Code configuration. The why-no-Agent investigation is a separate concern; this engagement is the role-side adaptation only.
- No PR edits on external repos.
- No re-dispatch of the judge against PR #135. The judge already submitted its verdict in-band; the fixer-loop continues normally.

## Commits

- One commit on `main` covering the judge role file + the pr-creation-flow note + the dispatch-worktree notes-from-the-field row (the change is one logical unit).

Push at end. Journal result entry.

## Report

≤ 200 words: the new section's structure, one-line confirmation that the next judge dispatch (with or without `Agent`) follows a documented path, one-line `Self-improvement: ...`.
