---
ts: 2026-05-15T04:17:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/15/035900Z-message-liaison-f1bfe3.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 248
    role: source
---

# Dispatch: designer drafts `compartment-mapper-import-attributes` (sibling to #248)

Dispatch root: `dispatches/designer--a39803/`. Project worktree on `endojs/endo-but-for-bots@llm`.

## The directive

Liaison forwarded at `035900Z-message-liaison-f1bfe3.md`: the maintainer asked at `designs/ses-import-attributes.md` line 63 (*Out of scope*):

> Please inform the steward that they should dispatch a designer for this case as well.

The "case" is the compartment-mapper-side propagation of import attributes through `package.json` resolution — the follow-up design that consumes the SES surface PR #248 lands.

## Per-action authorization

- Push a single new branch `design/compartment-mapper-import-attributes` to the bot fork.
- Open a draft PR against base `llm` per the design-PR pattern (designs base on llm, not master).
- Read PR #248's design at `designs/ses-import-attributes.md` (on `design/ses-import-attributes` branch, near-merged).
- Read `packages/compartment-mapper/src/link.js`, `packages/compartment-mapper/src/import-archive.js` for the current resolver shape.

## Task

Author `designs/compartment-mapper-import-attributes.md` (slug per the liaison's suggestion). The design picks up where #248's SES-surface design stops and traces import attributes through the compartment-mapper's `package.json` resolver to the archive read/write paths.

Surface to cover per the liaison's brief:

- `packages/compartment-mapper/src/link.js` — synthetic-importHook construction
- archive read/write paths
- `package.json` resolution boundary
- propagation rule: when a `package.json` exports condition or import declaration carries an attribute (per the SES proposal #248), how does the compartment-mapper's link step preserve and forward it through to module record construction?

Out of scope:

- The SES surface itself (already covered by #248).
- Implementation (this is a design dispatch; the implementation builder is a separate later engagement).

Standard design document shape per existing `designs/ses-import-attributes.md` (or a sibling reference like `designs/break-dev-dependency-cycles.md`). Frontmatter table with Created, Author, Status, Source. Sections: *What is the Problem Being Solved?*, *Background*, *Proposal*, *Phases* (if any), *Open questions*, *Not yet implemented*, *Status*.

## Out of scope (dispatch-level)

- No implementation; this is design-only.
- No edit to #248's design.
- No master-base work.
- No changeset entry.

## Commits

- One commit on `design/compartment-mapper-import-attributes` (off `llm`) with the new design file.
- Conventional-commit message: `design(compartment-mapper): propagate import attributes through package.json resolution (sibling to #248)` (or designer's tighter phrasing).
- Push at end; open draft PR.
- PR body cross-references #248 with the canonical path `designs/ses-import-attributes.md`.

## Report

≤ 500 words. PR number, design's open-question list (the ambiguities the designer surfaced for maintainer review), surface coverage summary, and one-line `Self-improvement: ...`.
