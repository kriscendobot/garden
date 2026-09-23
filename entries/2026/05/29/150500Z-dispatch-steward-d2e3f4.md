---
ts: 2026-05-29T15:05:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: designer
dispatch_root: /home/kris/dispatches/designer--d77cfc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/343
---

# dispatch: designer — respond to kriskowal CHANGES_REQUESTED on #343

Maintainer (kriskowal in steward terminal session 2026-05-29T15:04Z):
*"Please respond to https://github.com/endojs/endo-but-for-bots/pull/343"*

PR #343 (`design(gateway): overarching @endo/gateway package
integrating the gateway/weblet/Noise cluster`) is kriscendobot-authored,
not DRAFT, reviewDecision=CHANGES_REQUESTED (kriskowal at 14:21:49Z
with empty review body).

Note on slot: #343 was in the contractor's claimed slot
`summary-fix-343` from earlier today (slot file
`20260529T022628Z--endolinbot--general-contractor--e7a0--234bf0--summary-fix-343.md`).
The contractor's summary-fix work was a different category; this new
maintainer feedback supersedes — explicit user directive routes the
work to the steward.

## Inline comments

| Comment ID  | Path                            | Line | Disposition |
|-------------|---------------------------------|------|-------------|
| 3324924389  | designs/endo-gateway.md         | 1    | Main work: review old design, merge useful material into new `gateway-package.md`, then remove the old document and update references |
| 3324935450  | designs/gateway-package.md      | 123  | Forward-pointer: propose how to handle the @endo/platform/ws factoring (separate design PR, placeholder section in current design, or future-dispatch note); the steward will dispatch the actual @endo/platform/ws designer in a follow-up cycle if needed |

Re-fetch the full bodies via
`gh api repos/endojs/endo-but-for-bots/pulls/343/comments` — the table
above truncates.

## Task

1. **Address comment 3324924389** (the substantive one):
   - Read `designs/endo-gateway.md` end-to-end.
   - Identify material worth bringing forward to
     `designs/gateway-package.md` (concepts, decisions, terminology
     not already covered in the new design).
   - Edit `designs/gateway-package.md` to incorporate that material.
   - Remove `designs/endo-gateway.md`.
   - Search the repo (`git grep -l 'endo-gateway.md'`) and update any
     references to point to `gateway-package.md` or the appropriate
     section.
   - Update `designs/README.md` to remove the row for the old design
     and refresh totals.

2. **Address comment 3324935450** (the forward-pointer):
   - Reply on the inline thread with one of:
     - A placeholder section added to `gateway-package.md` describing
       the planned `@endo/platform/ws` factoring (preferred — keeps
       the design current).
     - An acknowledgement that the steward will dispatch a follow-up
       designer (if the placeholder is out of scope).
   - Don't dispatch the @endo/platform/ws designer yourself; surface
     to the steward in your result entry whether a follow-up dispatch
     is warranted.

3. **Inline thread replies** for each.
4. **Push** to `design/gateway-package` (bot has direct push access).
5. **Top-level summary comment** linking each thread to the
   addressing change per `pr-review-thread-replies/SKILL.md` and
   `review-feedback-followup-commits/SKILL.md`.
6. **Re-request kriskowal review** after CI green — use the working
   `echo '{"reviewers":["kriskowal"]}' | gh api ... --input -` shape,
   NOT `-f reviewers='[...]'` (returns HTTP 422).

## Per-action authorizations (forwarded)

- Push to `endojs/endo-but-for-bots:design/gateway-package` under
  kriscendobot identity. Authorized.
- Reply on each inline review thread. Authorized.
- Post the top-level summary comment. Authorized.
- Re-request kriskowal review after CI green. Authorized.
- Delete `designs/endo-gateway.md`. Authorized.
- Edit `designs/gateway-package.md` and any references to the old
  design. Authorized.

## Not authorized

- Modifying any non-design file substantively (this is a design-only
  PR; stay in `<project>/designs/`).
- Re-drafting the PR (already un-drafted).
- Closing the PR.
- Dispatching a separate `@endo/platform/ws` designer yourself
  (surface the question to the steward for a separate dispatch
  decision).

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/designer--d77cfc/garden/roles/COMMON.md`
2. `/home/kris/dispatches/designer--d77cfc/garden/roles/designer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md`
4. `garden/skills/review-feedback-followup-commits/SKILL.md`
5. Other skills the designer names just-in-time.

Project worktree starts at `project/` on `design/gateway-package`
(detached HEAD at `41b1d400f`).

## Report

A `result` journal entry. Include: new head SHA after push, list of
edited sections in `designs/gateway-package.md` and any references
updated outside `designs/`, the disposition of `designs/endo-gateway.md`
(removed/merged), the top-level summary comment ID, re-request-review
status, inline thread reply IDs, and a recommendation on whether the
steward should dispatch a separate `@endo/platform/ws` designer
follow-up.
