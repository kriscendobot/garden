---
ts: 2026-06-12T05:35:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: barrister
dispatch_root: /home/kris/dispatches/barrister--7d0508
prs:
  - repo: endojs/endo-but-for-bots
    pr: 438
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4687787530
  - https://github.com/Agoric/agoric-sdk/pull/12721
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/052621Z-result-builder-4ef77c.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/12/053300Z-result-cleaner-8a9446.md
---

# dispatch: barrister — stage 2 of #438 gamut (first code panel for tsgo migration)

Continuing the gamut on the tsgo migration PR. Builder
`91fa4a` (result `4ef77c` per cleaner reference) landed 7
commits opening DRAFT PR. Cleaner `8a9446` made PR-body
copy-edits only; head SHA unchanged at `4dc641a27`.

**Builder's two design departures** documented in PR body,
each with 3 routing options:

1. **tsgo strict-mode JSDoc cascade**: 39/49 packages fail
   under tsgo, most cascading from
   `packages/harden/make-hardener.js:155` missing a type
   predicate. Options:
   - Fix the root cause (hardener type predicate + downstream
     JSDoc).
   - TODO-exclude affected packages.
   - Hold the CI gate until JSDoc gaps are closed.
2. **tsgo crashes on unified `typecheck-all`**: Go runtime
   panic in tsgo's relater on `7.0.0-dev.20260611.2`
   (upstream bug). Options:
   - Pin to an earlier tsgo dev version.
   - Skip `typecheck-all` until tsgo fixes the relater
     panic.
   - Hold gate.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#438`, DRAFT, base
  `master-4a04d07`, head `chore/tsgo-lint-types` at
  `4dc641a27...`. CI: `lint` FAIL (intentional, the
  documented gaps); rest mostly green/in-progress.

## Task

You are the **barrister** (first code panel). Run the
standard panel-review discipline per
`garden/skills/panel-review/SKILL.md`. Compose your jury
per `garden/roles/barrister/AGENT.md`. The builder
explicitly suggested the panel-hints emphasize routing on
the design departures.

Primary panel value:

1. **Validate the 7-commit ladder** matches upstream
   #12721's analogous shape (modulo the documented
   deviations).
2. **Route the two design departures** — the maintainer
   (kriskowal) is the ultimate arbiter, but the panel
   should give an opinion on which of the 3 options is
   most appropriate for each gap. Surface as
   `must-fix-loop` if the panel concludes a specific
   route, `acknowledge` if the maintainer's call is
   essential.
3. **Validate upstream-mirror fidelity**: does this PR
   correctly model #12721? Are there parts of #12721 that
   should have been included but weren't, OR included but
   shouldn't have been?
4. **PR body adequacy**: the cleaner copy-edited prose
   but didn't restructure. Is the body complete enough for
   the maintainer to make routing decisions?
5. **Spec-coverage**: no test surface change (build
   tooling), but is the CI gate appropriately scoped?

Render verdict per panel-review skill as top-level
comment on PR #438.

## Authorizations (per-action, forwarded by liaison)

- **Compose and dispatch jurors** (fall back to in-band
  as prior panels did if scope constrained).
- **Post the consolidated verdict** as a top-level
  comment on PR #438. Standing.
- Do NOT push commits.

## Out of scope

- Do NOT push to the branch.
- Do NOT request review or un-draft.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/`
naming:

- Panel composition.
- Per-juror verdict summary.
- Per-design-departure routing recommendation.
- Consolidated verdict.
- The PR comment URL.
- **Recommended next stage** (likely fixer to address
  routed must-fix-loop items, OR justice if no
  must-fix-loop items survive).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the
orchestrator. The orchestrator dispatches the next stage
and tears down your dispatch root on return.
