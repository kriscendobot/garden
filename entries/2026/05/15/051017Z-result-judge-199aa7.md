---
ts: 2026-05-15T05:10:17Z
kind: result
role: judge
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/judge--199aa7
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source
to: liaison
refs:
  - entries/2026/05/15/045800Z-result-fixer-e037f1.md
---

# Result: code-panel review on #75 (kriskowal-random-chacha12, post-fixer gamut continuation)

PR: `endojs/endo-but-for-bots#75`, `feat(random,chacha12): factor @endo/random from @endo/chacha12 [resync to actual/kriskowal-random-chacha20]`, **non-draft**, branch `kriskowal-random-chacha12` against `master`, head `9e3a77276` (the post-fixer SHA from `entries/2026/05/15/045800Z-result-fixer-e037f1.md`).

- **Panel kind: code-panel** (twelve seats). File-list discrimination: the round's diff is one test file under `packages/random/test/`, and the broader PR touches `packages/random/src/`, `packages/chacha12/src/`, and other source paths; code-panel selected per `roles/judge/AGENT.md` § Panel-kind discrimination.
- **Panel execution: in-band-fallback.** Probed via `ToolSearch` (`select:Agent,Task`, then `subagent dispatch task spawn`); no `Agent` or `Task` tool surfaced to this judge dispatch. Each seat's per-juror block was written one at a time against `garden/roles/<seat>/AGENT.md`, then aggregated per `roles/judge/AGENT.md` § In-band fallback.
- Twelve seats: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker.
- `@copilot` added as additional reviewer alongside the panel (`gh pr edit 75 --add-reviewer @copilot`, fire-and-forget); idempotent on re-rounds.

## Verdict

`COMMENTED` (self-PR fallback; the authenticated identity `kriscendobot` is also the PR author, so `--approve` is blocked by GitHub). The body carries the explicit `## Aggregated verdict` and `### Must fix before merge` (empty) headings so the dispatch matrix keys on the panel's actual verdict per `skills/panel-review/SKILL.md` § Pitfalls. Submitted via `gh pr review 75 -R endojs/endo-but-for-bots --comment --body-file ...` at 2026-05-15T05:09:55Z against commit `9e3a77276`.

Counts:
- must-fix (in-scope): 0
- should-fix (in-scope): 0
- out-of-scope / follow-up: 2 (forward-looking rotation tests cited in the new test's comment, and a complementary `random(zeroSource) === 0` low-end bracket)

## Per-seat verdicts

- assessor: comment-only. With every byte `0xff`, `randomUint53` returns `2**53 - 1` (`lo = 0xFFFFFFFF`, `hi21 = 0x1FFFFF`); multiplied by `2**-53` yields `1 - 2**-53` exactly. Control flow unchanged.
- typist: comment-only. JSDoc `@param {Uint8Array} out` consistent with `RandomSource`; `// @ts-check` discipline preserved.
- stylist: comment-only. `maxSource` is crisp; rename from `oneSource` is motivated, not gratuitous; `0xFF` to `0xff` matches package convention.
- packager: comment-only. One conventional commit, one file, no yarn.lock churn, no autofix conflation. Existing changeset bumps remain correct.
- archivist: comment-only. Comment-block accurately describes the test's claim and its deliberate looseness; README and module JSDoc unchanged.
- prover: comment-only. Test is load-bearing on `POW2_M53`; reddens on any multiplier substitution. Strictly more robust than the prior `oneSource` form.
- curator: comment-only. No public-surface change in this round's diff.
- migrator: comment-only. Test-only diff; no downstream caller affected, no peer-dep cascade owed.
- locksmith: comment-only. No production capability boundary crossed; `maxSource` is a local closure.
- warden: comment-only. No `globalThis`, prototype, or intrinsic touch; `harden(random)` unchanged; SES-aware ava entry preserved.
- saboteur: comment-only. Four attacks walked, four mitigated. Maximum-byte boundary is exactly the assertion the test makes.
- breaker: comment-only. Multiplier invariant pinned; endianness invariant is deliberately split to the pre-existing golden-vector test; mask invariant pinned; `harden` and capability invariants unchanged.

## CI context

28 / 28 green at panel time (re-checked just before submission): the matrix completed during the panel run. `test-ocapn-guile-interop` (the gating signal called out in the dispatch brief), the full `test (*, ubuntu-latest)` and `test (*, macos-15)` shards, `test262`, `test-xs`, `test-hermes`, `test-async-hooks`, `cover (18.x/20.x/24.x, ubuntu-latest)`, `viable-release (18.x/20.x/24.x, ubuntu-latest)`, `browser-tests`, `build`, `lint`, `check-action-pins`, `zizmor`, `test-ocapn-python` all `pass`. `mergeable: MERGEABLE` against `master`.

## Loop status

**Loop terminated.** No in-scope must-fix. Per the dispatch brief and the bulletin's "Awaits maintainer ferry" framing, the PR was already non-draft on entry to this dispatch, so no `gh pr ready 75` is owed. The judge's final act on a successful loop in this configuration is the formal review submission (above).

The PR is in the maintainer's queue / on the ferry waiting list. Next stage at the orchestrator's discretion: typically the boatman ferries upstream once the maintainer authorizes (per the bulletin pre-staged authorizations).

## Submission details

- Review URL: see `gh pr view 75 -R endojs/endo-but-for-bots --json reviews` (latest entry, `submittedAt: 2026-05-15T05:09:55Z`, `state: COMMENTED`, `author: kriscendobot`).
- Body word count: ~1300 words, within the 1200 to 2000 range `roles/judge/AGENT.md` and `skills/panel-review/SKILL.md` specify for the twelve-seat code-panel default.
- `reviewDecision` on PR #75 remains `CHANGES_REQUESTED` (carried over from prior maintainer review state; a self-`COMMENTED` review does not flip the decision in either direction). The panel's verdict lives in the body.

## Originating

This dispatch ran in `/home/kris/dispatches/judge--199aa7/`. The orchestrator (liaison, running the gamut continuation per the maintainer's `/home/kris/dispatches/judge--199aa7/journal/entries/2026/05/15/043200Z-dispatch-liaison-e037f1.md` "run the gamut again" framing) sent the dispatch with the fixer's result path and the CI gating signal inlined.

Self-improvement: the in-band-fallback procedure in `roles/judge/AGENT.md` worked smoothly on a small-diff round; reading each seat's role file before writing its block kept the seat lenses honest, and the per-seat blocks deduped naturally on aggregation since every seat returned comment-only on a one-file test substitution. No standing field update warranted; the procedure already says what to do on a clean round. One observable: when the diff is this small, the per-seat blocks repeat "no production code touched" in slightly different phrasings; a future judge could compress the in-band aggregation by leading with a one-line "diff scope: one test file, +14 / -8" and then having each seat speak only to the slice still in its remit. Optional refinement; not load-bearing on this round's correctness.
