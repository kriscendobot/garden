---
ts: 2026-05-15T00:48:01Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/15/004045Z-dispatch-steward-5b2109.md
---

Opened draft PR
[endojs/endo-but-for-bots#256](https://github.com/endojs/endo-but-for-bots/pull/256)
on base `llm`, head `design/cli-edit-verb-tracking`, as the tracking
PR for `designs/cli-edit-verb.md`.

**Chosen shape: (c) initial-pass skeleton.**
Justification: the post-revision design is internally consistent (its
"Resolved during builder dispatch" section folded #204's 14 surfaced
gaps into normative sections, and the two remaining open questions
carry explicit best-guess proposals).
The design's own "Phase 1: API surface and wire envelope" maps
exactly to the deliverable a (c)-shape PR wants: land the
`EditPatch` / `EditOp` / `Anchor` / `EditResult` / `EditFailure` /
`AnchorMismatch` / `EditOptions` types, plus the module shape
(`splitLines`, `joinLines`, `computeLineHash`, `computeFileHash`,
`parseHashlineText`, `parseHashlineJson`, `validateEditPatch`,
`validateAnchors`, `applyPatch`), with runtime bodies stubbed to
reject "not implemented (Phase 2)".
The skeleton lives standalone (not yet wired into `EndoGuest`,
`EndoMount`, or the CLI) so the tracking diff stays tight.

**Canonical-path reference in PR body (load-bearing):**
> Tracking pull request for the `endo edit` verb design at
> [`designs/cli-edit-verb.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/cli-edit-verb.md).

The PR body cites the canonical path `designs/cli-edit-verb.md`
multiple times (in the leading paragraph, in the documentation
section, and in the leading `Refs` line) so the steward's next
design-to-PR scan will count this design as covered by an open PR.

**Drift-check observation:**
No pre / post-revision contradictions surfaced.
The "Resolved during builder dispatch" section is the receipt that
the design absorbed the prior implementation attempt's findings:
trailing-newline preservation, CRLF round-trip, payload LF
semantics, anchor uniqueness, empty / absent files, lock
granularity, permission taxonomy, file-size cap, mode-bit
preservation, CapTP revalidation, anchor hash-width mismatch,
`directoryRef` shape, and `EndoDirectory.edit` placement all pin
down in-line per the design's normative sections.
The two unresolved open questions (5: reapply search algorithm,
9: file-size cap) carry explicit best-guess proposals plus
the section pointer for kriskowal's bulk confirmation.

**Commits:**
- `9b3f63f19` feat(daemon): hashline edit-patch module skeleton.
  Adds `packages/daemon/src/hashline.js` (197 lines, stubbed exports
  with full JSDoc per the design) and
  `packages/daemon/src/hashline.types.d.ts` (148 lines, wire-shape
  types).

**Files added:**
- `packages/daemon/src/hashline.js`
- `packages/daemon/src/hashline.types.d.ts`

**No edits to PRs #162, #204, #153.**
No design-document edits.
No master-base work.
No changeset (additive skeleton with no observable downstream
behavior; phase 2 lands the user-visible surface).
`node --check` on the skeleton is clean; full `yarn lint` and
`yarn docs` were not run because dependencies are not installed in
this dispatch's worktree (a tracking-PR pre-flight pattern that
deserves a steward-level note about whether the design-to-PR
pipeline should `yarn install` per dispatch; see self-improvement
below).

Self-improvement: tracking PRs that scaffold real files (shape c)
need a dependency-install pre-flight if the full `yarn lint` /
`yarn docs` gate is to be enforced; the `pre-pr-checklist` skill
currently assumes `yarn` is on `PATH` and `node_modules` exists,
which is true for a per-dispatch worktree of a project that has
been installed but not for a freshly-cloned worktree triple where
`yarn install` has not run. The candidate fix is either (a) the
dispatch-prepare script bootstraps `node_modules` for project
worktrees that scaffold real code, or (b) the design-to-pr-pipeline
skill flags this constraint so the builder picks shape (b) when
the dependency-gate matters. Routing to liaison as a `message`
once observed in the wild a second time; this is the first
sighting.
