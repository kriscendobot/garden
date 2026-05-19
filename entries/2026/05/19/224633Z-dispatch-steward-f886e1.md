---
ts: 2026-05-19T22:46:33Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    issue: null
    role: source
---

# Dispatch: builder — update status on cli-store + cli-edit designs

Two maintainer-flagged design-doc status updates:

1. `designs/cli-store-verb-text-modes.md` (landed via PR #153 at
   `2026-05-12T02:38Z` as a reshape-blocker for PR #128). PR #128
   was CLOSED unmerged `2026-05-14T02:11Z`. User reports: *"We
   created a unifying model for store and cat verbs in the CLI"* —
   the implementation may have diverged from the original design.
   Find the actual implementation PR (probably merged to `llm`),
   reconcile the design with what shipped, and update Status +
   prose where the design diverged.

2. `designs/cli-edit-verb.md` — user believes implementation PR
   exists and may have merged. Find it; update Status line + any
   prose that the implementation revised.

Dispatch root: `/home/kris/dispatches/builder--4f6800` on `llm`.

**Builder's tasks**:

1. Read both design docs in full.
2. For each, find the implementing PR(s) by:
   - `gh pr list -R endojs/endo-but-for-bots --search "<keyword>" --state merged`
   - cross-reference `packages/cli/src/commands/*.js` history
   - check the design doc's referenced inline-review-comment URL
3. Compare design to current `origin/llm` state of relevant files.
4. Update each design doc:
   - Status header line (Proposed → Complete / In Progress / etc.)
   - Add or update a "Status" section noting the implementing PR
     and any divergence from the original design.
   - Where the implementation supersedes a design decision,
     revise the prose so the design reads as what shipped (not
     as a forward-looking proposal).
5. Update `designs/README.md` Status column for both rows.
6. Open one PR on `llm` titled like
   `docs(designs): mark cli-store + cli-edit complete (reflect shipped implementation)`
   citing both implementation PRs in the body.
7. Run `yarn lint:prettier --check` locally before pushing.

Per-action authorization: PR open + comments. Standing broad
authorization on endojs/endo-but-for-bots covers comment/PR ops.
PR opens go via `gh pr create -R endojs/endo-but-for-bots --base llm
--head <branch> --title "..." --body "..."`.

Report (under 400 words): implementation PRs found per design, brief
diff between design and shipped, the update PR's URL, prettier check.
