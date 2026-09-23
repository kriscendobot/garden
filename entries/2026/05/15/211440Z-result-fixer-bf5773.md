---
ts: 2026-05-15T21:14:40Z
kind: result
role: fixer
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 265
    role: target
refs:
  - entries/2026/05/15/221100Z-dispatch-steward-bf5773.md
  - https://github.com/endojs/endo-but-for-bots/pull/265#issuecomment-4463665243
  - https://github.com/endojs/endo-but-for-bots/pull/265#issuecomment-4463704582
---

# Result: PR #265 rebased + jcorbin sandbox / 9p corrections incorporated

## Pre / post rebase SHAs

- Pre-rebase (origin/design/endopi): `4fbb9dc79`.
- Post-rebase, pre-design-update: `d77f3277b`.
- Post-rebase + design correction (new tip): `32799a923`.
- New base: `origin/llm` at `c72d2a31f`.

## Rebase conflicts

One conflict file: `designs/README.md`. Two hunks inside it:

1. Header *Last updated* line and the *Recently added or revised* /
   *See also* recent-additions paragraph. `origin/llm` had the M½
   project-hygiene groom (the *Last updated: 2026-05-14* line referencing
   the new M½ milestone); the endopi raft commit had its own *Last
   updated: 2026-05-15* line and a *See also* paragraph leading with
   endopi. Resolved by merging both: kept the M½ milestone note in the
   *Last updated* line (rolled to *2026-05-15* with both updates cited),
   kept endopi as the lead entry in *Recently added or revised*, and
   merged the rest of the list back in unchanged.
2. *Totals* row at the bottom of the Summary table. `origin/llm`'s row
   reflected the M½ groom recount (106 designs); the endopi raft's row
   reflected the +9 endopi designs without the groom's status reshuffle.
   Resolved by recounting against the post-rebase summary table:
   29 Complete/Implemented, 17 In Progress, 44 Not Started, 16 Proposed,
   3 Active, 4 Reference, 2 Deprecated, 1 Draft, 1 Superseded (118
   designs).

No other conflicts. The endopi raft's 9 new design files (under
`designs/endopi-*.md`) and the endopi.md genie-extension commit replayed
clean.

## Corrected passages (paraphrase)

Two changes in `designs/endopi.md`, both inside the *Genie: Pi inside
Endo* analysis added in `d77f3277b`:

1. *Mapping* table, *Capability confinement* row. Replaced the bwrap-on-
   Linux phrasing with: `packages/sandbox`'s primary driver today is
   podman; bwrap is also present; additional drivers for macOS / Windows
   are anticipated. Wording remains under the "intent (per jcorbin)" and
   "not yet present in main" framing.
2. § *What Genie's existence tells us*, point 3 (*The confinement story
   is the open question*). Same sandbox-driver correction in the prose,
   plus a new paragraph crediting jcorbin's 9p filesystem server angle:
   rather than implementing a `vfs-endo` backend for genie's vfs-holding
   tools, implement a 9p filesystem server that exports endo's
   filesystem space. A 9p server is reachable from both genie's existing
   `vfs-node` implementation (mounted 9p export) and from normal system
   command tools inside the sandbox (mounted 9p export inside the
   sandbox), so one interface covers both consumers instead of two
   parallel backends. Recorded as the open question alongside the
   sandbox-driver question.

Header addendum note added to record the third-pass scope.

## Ack comment

Posted at <https://github.com/endojs/endo-but-for-bots/pull/265#issuecomment-4463704582>.
Comment text names commits `32799a923` (rebase + design correction;
single tip), the one conflict and its resolution, and the two
corrections.

## Mergeable state

PR #265 now reports `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE`
(UNSTABLE here means a CI run is still in flight on the new head, not a
merge blocker).

Self-improvement: nothing this time.
