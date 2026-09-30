---
orchestration-failed: true
---
orchestration-failed: true

## Fix round 1 — PR #1392 (endojs/endo-but-for-bots) — resumed

**Prior work confirmed intact.** An earlier claimant of this job had already applied and pushed all round-1 panel must-fix items before this attempt began (3 commits on `build/sturdyref-pass-style-recognition`, verified present at HEAD `b8c830e71b`):

- `fix(pass-style): trust only a frozen SturdyRef global, and ask it last` (`62ce9dfd75`) — resolves the ambient-global trust-ordering must-fix (locksmith, warden, purist, spec-keeper, wire-watcher, breaker's prototype-forgery finding): brand check now runs only after every other pass-style classification declines, requires the global/constructor/prototype to be frozen, and requires `getPrototypeOf(inner) === SturdyRef.prototype`.
- `fix(marshal): reject rank-ordering a SturdyRef with a clear error` (`e9503183cb`) — resolves the `rankOrder.js` raw-`TypeError` must-fix (assessor, typist, migrator, purist, corner-prober, engine-realist, wire-watcher): rank lookups now route through a `getPassStyleRank` guard that throws a clean `Fail`.
- `docs(pass-style): name the SturdyRefObject type and document the sturdyRef style` (`b8c830e71b`) — resolves typist's type/runtime-drift must-fix (renamed to `SturdyRefObject`, matching `Symbol.toStringTag` added to `@endo/sturdyref`'s typedef, type-test added), integrator's stale-README must-fix, and archivist's broken `designs/sturdyref-shim-contract.md` reference.
- PR title/body already conform (integrator's must-fix #2): no invented "## Stack index" heading, no stack-numbering in the title.

I re-verified this round: worktree clean, no uncommitted changes, branch head unchanged since last check.

**CI is now terminal and RED** (confirmed via `gh pr view --json statusCheckRollup`: 0 pending, 1 failing, `mergeStateStatus: UNSTABLE`). The sole failure is `test (24.x, ubuntu-latest)`: a `fast-check` property-test failure in `packages/patterns/test/copySet.test.js:146` (`copySet › setIsSuperset`), with a counterexample involving nested-array keys sharing a leading remotable. This does not touch any SturdyRef code path — `arb-passable.js` has no `sturdyRef` leaf yet (a `follow-up`, not a must-fix, per fast-checker), so this test never generates a SturdyRef. It reads as a latent/pre-existing `copySet` rank-cover bug independent of this PR's diff, but confirming that against the base branch was out of scope/budget for this fix stage.

No further changes were applied this round — the stage bound is "apply must-fix once, don't re-loop." Per the RED branch of the stage instructions, no `fix=done`.

**Follow-up needed:** the driver should determine whether `copySet › setIsSuperset` is a pre-existing flake (rerun CI) or a real regression before scheduling panel round 2 / un-draft.

<!-- gauntlet-stage-result: fix=still-pending -->

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer3-pass-style-20260930-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 214 tokens (13474033 cached reads)
- Output: 56148 tokens
- Cost: $7.073695599999997
- Wall-clock: 5019s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
