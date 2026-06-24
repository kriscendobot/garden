---
ts: 2026-05-19T02:34:50Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: target
---

# Dispatch: fixer on #288 PR title + description update

Second directive from kriskowal on PR #288 at `02:33:50Z`:
*"Please update the title and description. Please revise your standing
instructions as a fixer to always check the PR description and title
match the changes."*

Dispatch root: `/home/kris/dispatches/fixer--e3d95e` on `feat/cbors-package`. Fixer's task is
the (a) part — update PR title and description to reflect the renamed
package `@endo/cbor-frame` (PR title is still
`feat(cbors): add @endo/cbors package for CBOR byte-string framing`;
body still references the old name). The (b) part (role-file revision)
is meta-evolution and routes via a separate `message` to liaison.

Per-action authorization carried by this dispatch: PR title and body
edits via `gh pr edit -R endojs/endo-but-for-bots 288 --title ... --body ...`,
and a reply on the kriskowal comment thread acknowledging the
addressing edit. Both are within the standing broad authorization on
`endojs/endo-but-for-bots` extended by the maintainer's direct
request just now.
