---
ts: 2026-05-18T00:49:32Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/17/233800Z-result-builder-6ff906.md
---

Panel review on PR #277 (`feat(daemon): EndoMount.followNameChanges live entry-name stream`, llm base). Implements `designs/filesystem-watchers.md`. Cleaner ran prior to this dispatch (no result entry but CI is 25/25 green; the cleaner's work is visible in the third commit, `test(daemon): stabilise watchDirectory buffer test on macOS FSEvents`, head `82857a817`).

Panel kind: code-panel (16 seats; mixed source + test + docs + changeset; design doc not touched).
Panel execution: in-band-fallback (no `Agent` / `Task` tool in scope; each seat written one block at a time against the per-seat role file, aggregated after all sixteen).
Aggregated and submitted as one formal `gh pr review --comment` (self-PR fallback per `panel-review/SKILL.md` § Pitfalls; PR author is the bot identity, so GitHub blocks `--request-changes`).
`@copilot` re-requested via `gh pr edit 277 --add-reviewer @copilot` alongside the seat write-up.

Verdict: **comment-only** (no in-scope must-fix).
Must-fix: 0.
Should-fix: 12. The full list is in the review body; headline items are (1) `assertConfined` ordering vs `watchDirectory` in mount.js, (2) missing Test Plan item 8 (daemon restart), (3) runtime-confinement test gap, (4) `MountNameChange` not exported, (5) `watchDirectory` events `kind` union wider than runtime, (7) snapshot-loop per-entry error robustness, (10) single-consumer contract on `watchDirectory.events`, (11) design status not promoted to In Progress.
Out-of-scope: 6 (pre-existing `M.interface().rest(arrayOf(string))` pattern, family-consistency note on `MountNameChange`, multiplexing deferral, type-change diff deferral, help-text shorthand, dual-`watcher` naming).

Un-draft status: `gh pr ready 277` ran; `isDraft: false`, `state: OPEN`. The PR is now in the maintainer's review queue.

Loop termination: the loop exits this round (no must-fix). The should-fix list is intended as a single targeted follow-up commit before the boatman ferries upstream; the recommended shape in the review body bundles items 1, 2, 3, 4, 5, 7, 9, 11 into one commit and replies to 6, 8, 10, 12 on the thread.

Next-stage owed: maintainer review of the un-drafted PR, or a `fix` dispatch if the maintainer wants the should-fix bundle landed before ferry. Per `pr-creation-flow/SKILL.md`, the chain terminates here for the bot side.

Formal review URL: posted on PR #277, submittedAt 2026-05-18T00:48:40Z, state COMMENTED.

Self-improvement: nothing this time. The judge role's in-band-fallback procedure (read each seat's role file, write the block before reading the next) worked smoothly for a 16-seat panel; the per-seat blocks landed at the size the role files target (~200-400 words each); aggregation dedup'd cleanly into the 12 should-fix + 6 out-of-scope partition above. The role's existing § In-band fallback already encodes the discipline. No structural lesson to route to liaison.
