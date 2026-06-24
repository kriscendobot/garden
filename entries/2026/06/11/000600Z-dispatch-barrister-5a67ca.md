---
ts: 2026-06-11T00:06:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: barrister
dispatch_root: /home/kris/dispatches/barrister--5a67ca
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4453991038
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675761105
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/11/001500Z-result-builder-5e0a82.md
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/10/234500Z-result-cleaner-a2f1d1.md
---

# dispatch: barrister — stage 2 of #403 gamut (first code panel)

Continuing the gamut on PR #403. Builder `5e0a82` subsumed
layers 2+3 (Layer 4 deferred with rationale). Cleaner
applied 3 hygiene commits including critical fix for builder's
accidental tool-envelope markers in README.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#403`, DRAFT, base
  `llm-c85d618`, head `feat/registry-capability` at
  `c0d348497b82be55a3e0975acdbe98f78d6a6818` (`c0d348497`).
  Dispatch-prepare picked up older `584d06da3` —
  **FETCH AND CHECKOUT `c0d348497` BEFORE STARTING**.
- **Substance**:
  - Builder commits (3): Phase 1 README rewrite + error
    constructor loosening; Phase 2 mvs-resolver + 12 tests;
    Phase 3 snapshot-mapper + 8 tests.
  - Cleaner commits (3): tool-envelope markers removed (the
    builder's accidental capture), section-symbol replacement,
    prettier reformat.
- **39 tests passing**, 90% statements / 81% branches
  coverage in `packages/exo-npm`.

## Cleaner-surfaced concerns for the panel

- **PR body deviates from upstream
  `.github/PULL_REQUEST_TEMPLATE.md`** (uses custom headings:
  `What now ships` / `Design departures` / `Test coverage`).
  Body has file callouts and PR-number citations. **Flagged
  for barrister; not rewritten by cleaner**.
- **Phase 4 (Layer 4 daemon-worker integration) deferred**
  to a follow-up PR per the builder. Rationale is in the PR
  body's "Design departures #3" section. The panel can
  weigh whether the deferral is appropriate vs whether the
  maintainer's "subsume the subsequent planning phases"
  framing intends all 4 phases in this PR.

## Task

You are the **barrister** (first code panel). Run the standard
panel-review discipline per
`garden/skills/panel-review/SKILL.md`. Compose your jury per
`garden/roles/barrister/AGENT.md`.

The panel's primary value here:

1. **Validate each landed layer** matches its design:
   - Layer 1 (already-shipped scaffolding; this PR's
     starting state).
   - Layer 2 (mvs-resolver per `designs/mvs-resolver.md`).
   - Layer 3 (snapshot-mapper per
     `designs/snapshot-mapper.md`).
2. **Assess the Layer 4 deferral**: does the maintainer's
   "subsume the subsequent planning phases" framing intend
   all 4 layers in this PR? Should Layer 4 be folded in, OR
   is the deferral defensible? Surface as
   `must-fix-loop` if the panel concludes Layer 4 must be in
   this PR; `acknowledge` or `follow-up` if the deferral is
   defensible.
3. **PR body redraft**: the cleaner flagged template-shape
   deviation + file callouts. Surface as `must-fix-loop`
   items for a body-only redraft.
4. **Test coverage validation** per
   `garden/skills/coverage-driven-testing/SKILL.md`: do the
   20 new tests across mvs-resolver + snapshot-mapper cover
   the algorithm's failure modes? Saboteur-style: can you
   imagine mutations that pass the tests but break behavior?
5. **Design-departure review**: the builder documented three
   decisions (kept `string` not `Uint8Array` at exo
   boundary; deferred compartment-mapper extension point;
   deferred `@registry` HostFormula slot wiring as Phase 4).
   Validate each.

Render verdict per `panel-review` skill as top-level comment
on PR #403.

## Authorizations (per-action, forwarded by liaison)

- **Compose and dispatch jurors** via Agent tool (fall back
  to in-band as prior panels did).
- **Post the consolidated verdict** as a top-level comment
  on PR #403. Standing.
- Do NOT push commits.

## Out of scope

- Do NOT push to the branch.
- Do NOT touch the design branch's prior commits.
- Do NOT request review or un-draft.

## Deliverable

A `result` entry under `journal/entries/2026/06/11/` naming:

- Panel composition.
- Per-juror verdict summary.
- Per-layer validation outcome.
- Layer 4 deferral assessment.
- PR-body redraft items.
- Consolidated verdict per `panel-review` taxonomy.
- The PR comment URL.
- **Recommended next stage** (most likely fixer for the
  PR-body redraft + any other must-fix-loop items; possibly
  builder if Layer 4 needs subsuming).
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the next stage and tears down your
dispatch root on return.
