---
ts: 2026-05-21T06:45:12Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--7ceafb/project
---

Subsumed #102 (`design/chat-voice-command-parser`) into #101 (`feat/chat-voice-input`) per kriskowal's 2026-05-21T06:34Z request. Voice input and the voice command parser design now ship as one PR for combined evaluation.

**Subsume strategy: cherry-pick (not merge commit).** #102's three commits are purely additive (only `designs/README.md` row + `designs/chat-voice-command-parser.md` body), with zero file overlap against #101's diff (which only touches `packages/chat/` and adds the design pointer to its README). Cherry-pick produces a linear history where the design lands as three commits after the existing voice-input commits, reading top-to-bottom as a continuous feature build; a merge commit would have added a useless merge node without conflicts. Three cherry-picks applied clean, no conflict resolution.

**Commits added on top of f22adcd6c (previous head of #101)**:

- `00c4c8df7` design(chat): voice command parser (cherry-pick of f107017ca)
- `6da615ceb` design(chat): handle escape and enter in voice command parser (#102 review) (cherry-pick of dcbf092ad)
- `c4ebd8f5f` fixup(design): "simpler per se" copy edit on voice command parser (#102) (cherry-pick of e21343291)
- `fc363c2ee` docs(chat): replace cross-PR voice-design citation with in-tree path (new fixer commit: rewrites `packages/chat/README.md` "Voice Input" section to point at `designs/chat-voice-command-parser.md` rather than PR #102, and removes the reciprocal "see PR #101" line from the design's problem statement; both readings now describe a single in-tree feature)

**Files in the combined diff vs `origin/llm` (six total)**: `designs/README.md`, `designs/chat-voice-command-parser.md`, `packages/chat/README.md`, `packages/chat/chat-bar-component.js`, `packages/chat/index.css`, `packages/chat/voice-input.js`.

**Pre-push gates (diff-only)**: Prettier clean on all six files (project-wide `yarn install` not run in dispatch worktree; CI's matrix will validate the lint/typecheck path the gate cannot reach without install). Probes scoped to our added lines pass: no ASCII banners introduced, no `packages/**` PR citations introduced (the README citation that did exist was rewritten in `fc363c2ee`), no inline-import JSDoc introduced. The pre-existing `#44` reference in the design's `## Prompt` section (a blockquote of historical maintainer feedback) is in `designs/`, outside the `no-pull-citations` probe's `packages/**` scope, and is appropriately load-bearing context for that section.

**Force-push result**: `f22adcd6c..fc363c2ee  HEAD -> feat/chat-voice-input`. Push accepted with `--force-with-lease`.

**PR #101 description**: rewritten via `gh pr edit 101 --body-file` to describe both deliverables, with the "Description" block now naming voice input (plumbing) and the parser design (the four-phase plan whose phase 1 is what this PR's voice-input code implements). Security / Scaling / Documentation / Testing / Compatibility / Upgrade sections updated to cover both surfaces. The body explicitly frames the flat-text path that lands here as phase 1 of the parser design's plan, with phases 2 to 4 as follow-up work once the design is reviewed.

**#102 close**: `gh pr close 102 --comment "Subsumed into #101 per kriskowal request; voice input + command parser features integrated for combined evaluation."` accepted; #102 state is now `CLOSED`.

The steward picks up the gauntlet (cleaner → judge → fixer-loop → un-draft) from `fc363c2ee` on #101.

Self-improvement: a recurring soft pattern (twice in this dispatch) was the gate driver scanning the whole tree rather than the diff because the upstream tracking branch (`origin/llm`) has hundreds of unrelated paths differing from `master`. The probes use `origin/$base...HEAD` as their fallback diff base, which is the right shape, but in this branch's case the "diff" still reduces to six files because three-dot diff scoping does work; the driver's full-tree scan is a separate code path. A useful future probe-driver improvement: when the auto-detected upstream is a long-divergent integration branch like `llm`, scope the per-probe loop to `git diff origin/$base...HEAD --name-only` rather than walking the working tree. Logged here rather than as a message because the gardener owns gate-driver evolution and the pattern is one dispatch of evidence; surfacing as a message would be premature.
