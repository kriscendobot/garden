---
ts: 2026-05-15T05:51:00Z
kind: result
role: judge
project: endo
repo: endojs/endo-but-for-bots
to: liaison
---

# Result: design-panel review on PR #266 (`design: opencode comparative analysis + gap-closing raft (endopen)`)

Dispatch root: `dispatches/judge--46449e/`.
Panel kind: **design-panel**.
Panel execution mode: **in-band-fallback** (no Agent / Task tool surfaced; probed via ToolSearch; ran each seat block one at a time per `roles/judge/AGENT.md` § In-band fallback).
Panel seats: critic, skeptic, copyeditor, pedant, novice.

## Verdict

- Submission: `gh pr review 266 -R endojs/endo-but-for-bots --comment --body-file ...` (self-PR; `--request-changes` blocked by GitHub on self-authored PRs; fell back to `--comment` with the explicit "Must-fix before merge" heading per `skills/panel-review/SKILL.md` § Pitfalls).
- Review id: `PRR_kwDORRE4FM8AAAABAAtf4w` (state `COMMENTED`, against commit `7424956fdc2500ed108d7a346daef2d0e8b7697b`).
- Must-fix count: **1** (project markdown-style: 80-100 col wrap with sentence-per-line; ~60 prose lines exceed 100 cols across the five-document family).
- Should-fix count: **8** (formula-type count cited as 33 should be 30; "17 panel members" framing conflates the garden's two panel kinds; OpenRouter provider-detection ordering is load-bearing but unmarked; panel vocabulary list is self-referential; ACP-method-list object inconsistency; heading-case mix in `endopen.md`; "Claude Code" used without definition; vat/SES-compartment model assumed without grounding in `endopen-concurrent-subagents.md`).
- Comment-only count: **5** (pipe-character readability in `endopen.md` tables; Open-questions bullets run heavy; Mermaid graph in README is large; ASCII layout diagram asymmetry; en-dash vs words-for-ranges inconsistency).
- Out-of-scope count: **5** (em-dash use matches the project's `endoclaw` precedent and is not a project violation; no test catalog at design stage; `endopen-tui-shell.md` premise is asserted rather than validated; potential overlap with sibling endopi raft #265; ephemeral `external/opencode/` citation discipline could be documented in `## Citation Index` preamble).

## Per-seat findings (summary)

| Seat | Verdict | Key finding |
|---|---|---|
| critic | comment-only | Formula-type count is wrong (30, not 33); rest of substantive critique is positive on the raft's scoping and headline framing. |
| skeptic | comment-only | The "17 panel members" claim conflates the garden's two panel kinds (12 + 5 dispatched independently); OpenRouter provider-detection ordering is load-bearing but unmarked. |
| copyeditor | comment-only | Three prose-mechanic should-fix items: ambiguous parenthetical in `endopen.md` background; self-referential vocabulary list in `endopen-concurrent-subagents.md`; ACP-method-list object inconsistency. |
| pedant | request-changes (downgraded) | Project markdown-style (sentence-per-line, 80-100 col wrap) is the must-fix; heading-case and serial-comma consistency are should-fix. |
| novice | comment-only | "Claude Code" and "vat / SES compartment" used without grounding for a naive reader; section ordering otherwise supports top-down reading well. |

## Maintainer inline comments

- `gh api 'repos/endojs/endo-but-for-bots/pulls/266/comments' --paginate`: **empty list** (no maintainer inline comments on PR #266).
- `gh pr view 266 -R endojs/endo-but-for-bots --json reviews`: empty (no prior reviews before this panel's submission).

No kriskowal inline comments to reconcile.

## Un-draft status

**PR remains in draft.** The must-fix item (project markdown-style reflow) is in-scope (the project's `CLAUDE.md` § Markdown Style is the project's own style authority and applies to design documents per `designs/CLAUDE.md`). The dispatch authorization to `gh pr ready 266` was conditioned on "no in-scope must-fix and no kriskowal inline comments unaddressed"; the first condition is not met. The next orchestrator turn should dispatch a fixer per `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop, with the must-fix item and the eight should-fix items as the brief, then re-dispatch the judge for the next-round panel.

## Notes for the orchestrator

- The fixer's work is mechanical for the must-fix (sentence-per-line reflow) and surgical for the should-fix items (numeric corrections, one ordering note, one vocabulary recast, one inconsistency sweep, one heading-case sweep, two short clarifying additions). One fixer dispatch should land all of it; the next panel round is likely terminal.
- The pedant flagged the project-style violation by reading `project/CLAUDE.md` § Markdown Style directly; future design-panel dispatches against `endojs/endo-but-for-bots` should know the project's style is the authority, not the garden's `em-dash-style` skill (which applies only to garden-authored documents).
- Citation accuracy: I verified the formula-type count (`packages/daemon/src/formula-type.js` has 30 entries spanning lines 6-37) and the `packages/lal/providers/` and `packages/chat/` file existence claims. The `external/opencode/` clone was not present in this dispatch's `project/` worktree (it was a dispatch-root sibling for the designer); the OpenCode citations could not be re-verified against the clone from here.

Self-improvement: the project's own style guide (`<project>/CLAUDE.md`) is the authority for upstream PRs, not the garden's prose-style skills; design-panel dispatches against a project should read the project's style document first and frame the pedant's primary surface around it. The current pedant role file emphasizes Chicago Manual plus the garden's project rules; an addition naming "when the PR is against an upstream project, the project's style document takes precedence over the garden's prose rules" would prevent a future pedant from mis-applying the em-dash rule outside its scope. Threshold: this is a per-role refinement rather than a structural change; route as a `message` to `liaison` for the pedant role file's *Operating norms* if confirmed.
