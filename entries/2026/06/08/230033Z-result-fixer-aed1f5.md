---
ts: 2026-06-08T23:00:33Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--aed1f5/project
refs:
  - entries/2026/06/08/225600Z-dispatch-fixer-aed1f5.md
---

Refreshed PR endojs/endo-but-for-bots#131 (`feat/chat-inventory-dnd`) title and description per the maintainer's directive to "state the record of what has changed" and "omit details of the process of building the change."

Title: `feat(chat): inventory drag-and-drop, cancel, and type badges` (was `feat(chat): inventory drag-and-drop, cancel, type badges (re-opened from #41 under the bot)`). The re-open parenthetical is process detail and is dropped; the substance reads cleanly as a feature line.

Body: rewritten section-for-section against the upstream PR template (`Description`, `Security`, `Scaling`, `Documentation`, `Testing`, `Compatibility`, `Upgrade`). The substance covers:

- absolute-coordinate drag rooted at top-level powers, enabling up-tree moves the prior subtree-scoped proxy could not
- explicit "Link here / Move here" context menu replacing the hidden Alt-key modifier; Move uses the daemon's atomic move rather than client-side copy-then-remove
- hub-only drop gating with leaf rows falling through to the containing list and the top-level background as a root-move zone
- immutable items are non-draggable
- two-step cancel revealed on row hover
- formula type badge derived from the locator URL's `type` parameter
- sidebar action-button overlay polish (floating buttons with a hover backdrop, optical-centered cancel glyph)

The body omits the re-open-under-bot pattern, the "forwarded comments" boilerplate, the cc/refs to #41 in the body proper (kept a single `Refs: #41` per the template), the commit-list as a process trail, and any file callouts or methodology naming. The `cc @kriskowal` line is dropped; the maintainer is already the standing reviewer for this fork.

Posted a top-level acknowledgment comment on #131 (https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4654313965) naming the refresh and what the new body covers.

No commits pushed to the branch (out of scope per dispatch brief). Other PRs untouched.

Authorizations exercised: `gh pr edit` (title + body), `gh pr comment` (acknowledgment reply) — both per dispatch brief.

Self-improvement: nothing this time. The pr-formation skill's "no file callouts," "behavior over diff," "no methodology leak," and template-section discipline mapped cleanly onto this refresh; the four-part body order generalized naturally into the multi-section template (the same content fits both shapes).
