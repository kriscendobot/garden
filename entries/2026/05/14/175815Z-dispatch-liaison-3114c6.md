---
ts: 2026-05-14T17:58:15Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/061347Z-dispatch-liaison-63f3ef.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 226
    role: source
  - repo: endojs/endo
    pr: 3255
    role: target
---

Re-ferry `endojs/endo-but-for-bots#226` to `endojs/endo#3255`. First ferry (single-commit squash) opened #3255 on 2026-05-12; turadg's CHANGES_REQUESTED review on the same day asked for an aliasing approach instead of suppression. The fixer at `entries/2026/05/14/061347Z-dispatch-liaison-63f3ef.md` carried the feedback to #226 (commits `1e4f819a` rewrote the first commit body to "alias eslint-plugin-import to import-x@4", then fixer pushed `f38d828b` lint cleanups and `5ea8d7e7` yarn.lock). The upstream PR at head `41c6bd4a92` still has the original "migrate to" approach; this re-ferry brings it up to date.

**The shape changed.** The bot-side title is now `feat(eslint-plugin): alias eslint-plugin-import to import-x@4`, replacing the original `feat(eslint-plugin): migrate to eslint-plugin-import-x`. The diff scope and rationale changed too: per turadg, no migration is needed at the consumer level; the `eslint-plugin-import` name is aliased to `eslint-plugin-import-x` via the package map, so `import/*` rule names still resolve. The upstream PR title and body should be rewritten to match the new shape. This is *not* a "frame for the upstream audience" cosmetic; the upstream reviewer's own feedback drove the reshape, so the upstream PR should describe the work that addresses the feedback.

**Source**: `endojs/endo-but-for-bots#226`, branch `feat/migrate-eslint-plugin-import-x`, head `5ea8d7e725149e5498336ee48d0c92089dbdc899`. State OPEN, MERGEABLE. CI: 25 SUCCESS, 1 FAILURE (`test (20.x, macos-15)`, the recurring macOS-15 timeout flake; not substantive). Base on master at `c2fc02eb8`.

**Upstream**: `endojs/endo#3255`, branch `kriskowal-eslint-plugin-import-x`, current head `41c6bd4a92950f032b7a742c2be187d4aa13f322`. State OPEN, CHANGES_REQUESTED by turadg (one inline comment on `.changeset/migrate-eslint-plugin-import-x.md`). The branch was initially force-pushed by the first ferry; no third-party pushes since.

**Human**: `Kris Kowal <kris@cixar.com>`. **identity_switch_authorized: true** (user asked for the ferry; standing pattern).

**Dispatch root**: `/Users/kris/garden/dispatches/boatman--ferry-eslint-import-x-226--20260514-175634--3114c6/`. Project worktree on `endojs/endo:kriskowal-eslint-plugin-import-x` (detached at `41c6bd4a9`).

**Boatman direction**:

- Recompute from upstream/master: diff `c2fc02eb8..feat/migrate-eslint-plugin-import-x` (the bot-side base-to-head) applied to current `upstream/master` (now 19 commits ahead of the bot-side base; the same CI-workflow-only advance pattern seen on the #75 / #109 / #223 re-ferries).
- Squash to a single commit (or, if the changeset story benefits from a second commit, two). Author + committer `Kris Kowal <kris@cixar.com>`; zero bot trailers; verify with `git interpret-trailers --parse`.
- Force-push to `kriskowal-eslint-plugin-import-x`. The current tip `41c6bd4a9` will be replaced; turadg's discussion comment (`r3229246963` on `.changeset/migrate-eslint-plugin-import-x.md`) is anchored on a file path that no longer exists in the new shape (the changeset will be renamed to reflect the alias approach), so the thread anchor is expected to detach. That is fine: the comment was already addressed by the bot-side reshape, and the upstream comment we route through the steward will say so.
- **Update the upstream PR title and body** to reflect the new alias shape. Use `gh pr edit 3255 -R endojs/endo --title ... --body ...`. The new title should mirror the bot-side title (`feat(eslint-plugin): alias eslint-plugin-import to import-x@4` or a frame-for-upstream variant). The body should describe the new approach per `pr-formation`: no garden references, no bot framing, no fork-only issue numbers; behavior over diff. Title/body edits are PR attribute changes, not comments, so the boatman handles them directly under `identity_switch_authorized`.
- **Identity discipline**: any explanatory PR comment on `endojs/endo#3255` (e.g., "reshaped per turadg feedback, see new commit") routes via `message`-to-`steward` per the rule landed at `cac9cbb`. Source-side cross-link comment on `endojs/endo-but-for-bots#226` is fine to post directly under the bot identity (the standing authorization on the garden's own repo).
- Apply the upstream's `CONTRIBUTING.md` and PR-template conventions per the `pr-formation` skill (template headings: Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade; no checklists; no file-by-file callouts).

**Expected report**: upstream PR head SHA after force-push, attribution-verified, source-side cross-link comment URL, message-to-steward (proposing the explanatory comment body for #3255 if any is warranted), title/body change applied (or a note that the current title/body still fits), journal `result` entry, one-line `Self-improvement: ...`. If anything blocks (e.g., the diff does not apply cleanly to current upstream/master, or the changeset story splits across two commits non-obviously), `message`-to-liaison and stop.
