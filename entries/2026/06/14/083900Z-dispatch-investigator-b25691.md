---
ts: 2026-06-14T08:39:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: investigator
dispatch_root: /home/kris/dispatches/investigator--b25691
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701213702
---

# dispatch: investigator — chat vs goblin-chat overlap analysis per kriskowal directive

Per kriskowal's 2026-06-14T07:55Z directive on PR #440:

> Please check again whether `chat` has any relevant overlap
> with `goblin-chat`.

Weaver `ec2e49` just rebased PR #440 onto `llm` (head
`f01499f1a`), so `packages/chat/` is now reachable. This
investigator does the overlap analysis to inform the cut 3
builder's strategy.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, DRAFT, base `llm`,
  head `feat/formula-inspector` at `f01499f1a8bf581e9e344f4460f0a04dd532f62c`.
- Both `packages/chat/` (from `llm`) and
  `packages/goblin-chat/` (from `master`) should be present
  in the rebased worktree.

## Task

In your `project/` worktree on `feat/formula-inspector`
(FETCH and checkout the rebased head):

1. **Enumerate both packages**:
   - `ls packages/chat/`
   - `ls packages/goblin-chat/`
   - For each, get package.json (name, version, exports,
     deps, scripts).
2. **Compare file structure**:
   - Per-file diff or list (which files exist in chat,
     which in goblin-chat, which match by name).
3. **Compare entry points / public APIs**:
   - What does each package export?
   - Are the export shapes compatible? Adjacent? Disjoint?
4. **Identify the "Value modal" / "formula view" surface**:
   - The merged design `designs/formula-inspector.md`
     references `packages/chat/value-component.js` and
     proposes adding `formula-view-component.js` +
     `formula-view-registry.js`.
   - Does `goblin-chat` have analogous components? If so,
     what are they called?
5. **Assess overlap**:
   - Are these two implementations of the same UI concept?
     Drop-in replacements? Diverged forks?
   - What's the migration path (if any) between them?
6. **Recommend a cut-3 implementation strategy**:
   - Option A: implement cut 3 directly in `packages/chat/`
     (now that it's reachable on llm) — the design's
     home.
   - Option B: implement cut 3 in `packages/goblin-chat/`
     (the master-side package; what was originally
     surfaced by builder 256add) — the implementation
     trunk's home.
   - Option C: implement in both (mirror).
   - Option D: defer + escalate the deeper goblin-chat vs
     chat question.

## Authorizations

- **Read-only on the project**.
- **Post a comment on PR #440** at-mentioning `@kriskowal`
  with the overlap analysis + recommendation.

## Out of scope

- Do NOT do the cut-3 build itself (separate builder
  dispatch after the analysis).
- Do NOT modify either package's code.

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Per-package summary (file count, exports, key components).
- Overlap matrix (file-by-file, exports).
- Whether they're forks / siblings / disjoint.
- The cut-3 implementation strategy recommendation
  (which option + rationale).
- The PR comment URL.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator.
