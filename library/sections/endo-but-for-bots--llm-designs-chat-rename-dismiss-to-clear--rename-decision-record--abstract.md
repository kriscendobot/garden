---
title: Abstract
source: designs/chat-rename-dismiss-to-clear.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8e5058304b08a4ec590a8bdcc799f78b321d5726
source_date: 2026-05-20
source_authors: [Kris Kowal]
topics: [chat-ui, repository-governance]
status: current
notes: |
  **Status: Complete** upstream (PR #93, merged 2026-05-06). A bounded
  PR-merge decision record + post-implementation retrospective. The
  document's small size (75 lines, four subsections) is honestly
  captured as a single library section rather than padded to a
  three-section ingest. The retrospective is structurally interesting
  for three reasons: (1) explicit *deprecation-period alias* retention
  pattern on the CLI side; (2) chat-vs-CLI alias asymmetry (chat had
  not shipped the command pre-rename, so no deprecation surface
  needed there); (3) *roadmap calibration* — explicit git-blame
  analysis of active-development calendar with three implementation
  bursts separated by long unattended gaps (2026-03-17 / 2026-03-20 /
  2026-05-06).
parent: endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record
---

The §Status header records the document as **Complete** (PR [#93](https://github.com/endojs/endo-but-for-bots/pull/93), merged 2026-05-06, merge commit `31df9e3cf`). The rename replaces `dismiss-all` with `clear` across both the CLI and the Chat command bar. Four implementation details: (1) **CLI**: `packages/cli/src/commands/dismiss-all.js` → `packages/cli/src/commands/clear.js`; `packages/cli/src/endo.js` registers `.command('clear').alias('dismiss-all')` so the original name remains as a *hidden backwards-compat alias during the deprecation period*. (2) **Chat**: `packages/chat/command-registry.js` exports `clear` as the canonical command (immediate mode, `category: 'messaging'`, `context: 'inbox'`); `packages/chat/command-executor.js` dispatches `case 'clear'` to `E(powers).dismissAll()`. **The chat side did not retain a `/dismiss-all` alias** — chat had not yet shipped the command pre-rename, so no deprecation surface was needed there. (3) **Tab completion**: shortest-common-prefix advancement landed alongside the rename; *a follow-up audit would confirm it on the current chat-bar implementation*. (4) **Regression**: `packages/cli/test/clear-command.test.js` asserts the `clear|dismiss-all` pairing in `endo --help` and verifies that `endo dismiss-all --help` resolves through the alias. The underlying daemon power remains `dismissAll()` — *that is the internal interface, not the user-facing command name, and out of scope for the rename*. The §Roadmap calibration subsection performs git-blame on `llm` and finds: **active development 2026-03-03 → 2026-05-06 (65 calendar days)** with three brief authoring bursts separated by long unattended gaps. Design phase: 2026-03-03 (single commit `b6286fba4` *Add designs for minor fixes to chat command vocabulary* — same commit also introduced `chat-markdown-render.md`). Implementation phase: 2026-03-17 → 2026-05-06 (51 calendar days). Burst 1: 2026-03-17 `77d1eef37` (Chat-side rename). Burst 2: 2026-03-20 `6b49b03dd` (CLI rename). Burst 3: 2026-05-06 PR #93 commits `2a3ec3025` + `9272463a8` (keeping `dismiss-all` as alias; merged via `31df9e3cf`). The §Motivation cites two reasons: (a) **verbose-and-unfamiliar name** — *`clear` is the conventional term for this action (clearing an inbox, clearing notifications)*; (b) **tab-completion prefix-collision** — *`dismiss` and `dismiss-all` share a prefix, which makes tab completion in the chat command bar awkward — typing `/dismiss` and pressing tab cannot advance past the common prefix without an extra disambiguation step. Renaming `dismiss-all` to `clear` eliminates the collision entirely.*
