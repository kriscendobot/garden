---
ts: 2026-06-03T00:32:32Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/001640Z-dispatch-liaison-ab6f0e.md
  - entries/2026/06/03/003049Z-result-fixer-ab6f0e.md
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
---

# result: garden #3 pre-dispatch grep-gate pattern landed; new head 1ddf76235

User asked for a fixer to address kriskowal review `4414266979`
(meta-feedback about implementing pre-dispatch grep gates).
Fixer `ab6f0e` closed cleanly.

## Outcome

- **New head**: `1ddf76235` on `design/driver` (4 commits atop
  prior `1c7e27a2`).
- **Commits**:
  - `cbe89f4b` `feat(scripts/checks): pre-dispatch grep-gate
    harness + two example gates` — 9 files.
  - `594bede5` `test(checks): smoke tests + CI wiring` — 5
    files.
  - `f82fda05` `design(driver): step 0 of pre-CI gauntlet` — 1
    file.
  - `1ddf7623` `fix(scripts/checks): widen bench-engines-rename
    exclusion` — 1 file.
- **PR comment**: `4608074313`.

## Gates landed

1. **`bench-engines-rename`** — whole-tree literal grep
   (`git grep -nF '.bench-engines'`), excluding the gate's own
   subdirectory, the runner index, and the smoke test. Current
   tree firing: clean (0 matches).

2. **`double-space-sentence-separator`** — diff-scoped
   (default `GATE_BASE_REF = merge-base HEAD main`), awk over
   added lines, regex `\.  ?[A-Z]` with a 22-token allowlist
   (Latin shorthand, salutations, abbreviations). Current
   firing: 25 files in the design/driver branch diff against
   main — all multi-sentence physical lines following
   established prose house style on the branch.

## Tests

- New `tests/checks/run.sh`: 24/24 PASS.
- Existing `tests/driver/run.sh`: 27/27 PASS (no regression).
- Shellcheck `-S warning` clean on all new scripts.

## Judgment calls (fixer-noted)

- Short allowlist on double-space gate (only repeat-use tokens,
  not one-off sentences).
- Runner exits non-zero on any firing even after a `claude`
  dispatch so the caller knows a follow-up happened.
- Exclusion list on `bench-engines-rename` narrowed to
  runner-index + smoke test (kept tight).
- CI workflow extended in-place rather than parallel.
- No mass-rewrap of the 25 existing-prose-style firings on
  `double-space-sentence-separator`; volume guidance from the
  brief was: surface the count rather than rewrap the branch's
  already-reviewed prose. Maintainer can decide separately.

## Fixer's self-improvement note

> Surface "first-PR backlog" tension to liaison as a candidate
> addition to `skills/pre-dispatch-grep-gate/SKILL.md` § Notes.

Translation: a diff-scoped gate firing on a large initial-PR-
diff produces high false-positive volume against already-reviewed
prose, while the same gate is useful for small follow-up PRs.
This is a natural tension worth documenting in the skill. Worth
queueing for the next gardener-shape touch on the skill file.

## Teardown

`dispatches/fixer--ab6f0e` torn down.

## Steward queue post-engagement

- **garden #3** scripts/ pivot + pre-dispatch grep gates landed
  at `1ddf76235`; awaits maintainer reassessment.
- **#387** ferried upstream to endo#3294 at `983551383`;
  gibson042 APPROVED; awaits upstream merge.
- **#394** missed asks carried at `c29678f5f`; Git-backed CAS
  pivot stays deferred.
- **#388** UDS→sock rename being picked up by contractor
  (separate orchestrator); not steward scope.
- **#401** at `46ba16528`; awaits reassessment.
- **#403** CHANGES_REQUESTED; awaits scoping.
- **#393** stack-wide directive; awaits scoping.
- **#244** retconned; awaits kmkmbp2021 boatman.

## Standing follow-ups for the steward

1. **Garden-meta style guide directive** (from #394 review
   4414303711): maintainer noted "For the gardener, the style
   guide should recommend positive examples, only." Awaits a
   gardener dispatch on `kriskowal/garden` (style guide for
   hex / magic-number examples). Not started.
2. **Grep-gate skill § Notes addition**: document the
   first-PR-backlog tension per the fixer's self-improvement
   note. Smaller; can be a gardener follow-up or merged into
   ask 1.
