---
ts: 2026-06-05T04:46:13Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f1c59f
prs:
  - repo: endojs/endo-but-for-bots
    pr: 57
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/57
  - https://github.com/endojs/endo-but-for-bots/pull/57#discussion_r3142207495
---

# dispatch: fixer — #57 prefer `*b0b5cafe` example (positive-hex pattern)

Maintainer review `4175819493` (CHANGES_REQUESTED,
2026-06-05T04:44:46Z), single inline at
`packages/marshal/docs/smallcaps-cheatsheet.md:13` (comment
`3142207495`):

> Prefer example `*b0b5cafe`

Same positive-hex-example pattern kriskowal landed earlier
(per memory rule against lewd-hex examples like
`0xcafebabe`). Replace the current example in that line
with `*b0b5cafe`.

## Target

- PR: endojs/endo-but-for-bots#57
- Branch: `kriskowal-marshal-binary`
- Head: `59bb8bc21`
- Title: `feat(marshal,pass-style): admit immutable ArrayBuffer
  through codecs`.

## Procedure

1. Read `packages/marshal/docs/smallcaps-cheatsheet.md` line
   13 (and surrounding context).
2. Replace the current hex example with `*b0b5cafe`.
3. Sweep nearby lines for other hex-like examples that might
   carry the same connotation (use judgment; the maintainer
   asked specifically about line 13 but adjacent examples may
   share the issue).
4. Commit (regular append):
   ```
   docs(marshal): prefer b0b5cafe in smallcaps-cheatsheet example
   ```
5. Push.
6. Reply on inline `3142207495`.

## Per-action authorizations

- Edit `packages/marshal/docs/smallcaps-cheatsheet.md`
  (and possibly other docs if the sweep finds related).
  Authorized.
- One regular-append commit + push. Authorized.
- Inline reply. Authorized.

## Not authorized

- Modifying source code (just the docs).
- Force-pushing.
- Un-drafting / merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--f1c59f/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--f1c59f/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`

Project worktree at `project/` on
`kriskowal-marshal-binary` (head `59bb8bc21`).

## Report

A `result` journal entry. Include:

- Old → new text at line 13.
- Any other lines swept.
- New head SHA.
- Inline reply ID.
