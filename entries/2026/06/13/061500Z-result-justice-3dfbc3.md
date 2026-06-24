---
ts: 2026-06-13T06:15:00Z
kind: result
role: justice
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/justice--3dfbc3/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/13/060622Z-result-fixer-6beb46.md
  - entries/2026/06/13/055700Z-dispatch-fixer-6beb46.md
  - entries/2026/06/12/061200Z-result-justice-5a1c37.md
  - entries/2026/06/12/055700Z-result-barrister-821970.md
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482896738
  - https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4482982987
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697671329
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697694059
---

# result: justice — round-3 code panel on #438 (gap-routed fix verified; PR stays DRAFT pending maintainer re-routing on cascade residual)

Re-run of the code panel on head `4b2055c22` after fixer `6beb46`
applied the kriskowal-directed routes on both Material gaps. The
fix shapes are correct; the panel returns clean (zero
`must-fix-loop`); the cascade-residual disposition surfaces a gap
between the round-1 panel's "single root cause" estimate and the
empirical 3-of-39 yield, which the orchestrator escalates to the
liaison for maintainer re-engagement. The PR stays DRAFT.

## Pre-dispatch state check

`gh pr view 438 -R endojs/endo-but-for-bots --json state,isDraft,mergedAt,headRefOid`:
`state=OPEN`, `isDraft=true`, `mergedAt=null`,
`headRefOid=4b2055c222339221a0dec8313f6d5211553a4f12`. Proceeded.

Project worktree was at the stale `4dc641a27`; fetched
`origin/chore/tsgo-lint-types` and checked out `4b2055c22` per the
brief.

## Panel composition

`panel-hints.sh --base a619bea05` (round-2 head, the prior verdict's
head) on the fixer's three-commit delta recommended 13 of 26 seats:

- Always-on core (9): assessor, typist, stylist, packager, archivist,
  prover, saboteur, integrator, corner-prober.
- Always-fire (2): scribe, releaser.
- Path-triggered (2): gateway (root `package.json` change), migrator
  (dependency change in `package.json`).
- Suppressed (15): benchmarker, breaker, changeset-auditor, curator,
  fast-checker, pruner, surfacer, engine-realist, locksmith, purist,
  spec-keeper, warden, wire-watcher, copyeditor, pedant.

Justice-side overrides: none. The round-1 MFL raisers (stylist,
scribe) are in the recommended set. The round-1 spec-keeper add
does not re-fire on this delta (no new documented-intent claim in
the fixer's commits).

Final composition: 13 seats.

## Execution mode

Panel kind: code-panel. Panel execution: **in-band-fallback**. The
`Agent` / `Task` tool was not in scope (verified by `ToolSearch`
on `select:Agent`); each seat ran as a single in-band block per
`skills/panel-review/SKILL.md` § In-band fallback. `@copilot`
fire-and-forget reviewer-add ran alongside.

## Verification of gap routes

### Gap 1: harden fix shape (commit `842dcae20`) — correct

Verified by direct inspection of `packages/harden/make-hardener.js`:

- Arrow `const isPrimitive = val => ...` is gone.
- `@type {(val: unknown) => val is ...}` JSDoc is gone.
- Replaced by function declaration `function isPrimitive(val) { ... }`
  with `@param {unknown} val` + `@returns {val is (undefined | null | boolean | number | bigint | string | symbol)}`.
- Body's discriminator is byte-identical: `!val || (typeof val !== 'object' && typeof val !== 'function')`.
- New JSDoc prose explains the function-decl-vs-arrow predicate
  attachment rule.

Shape matches the panel's round-1 diagnosis and the maintainer's
"please try this" directive precisely. The fix is the
maintainer-directed option (a) applied to the specific site the
panel called out.

### Gap 2: tsgo nightly pin (commits `0202cefce` + `4b2055c22`) — correct

Verified by direct inspection of `package.json` and `.yarnrc.yml`:

- `package.json` carries `"resolutions": { "@typescript/native-preview": "7.0.0-dev.20260612.1" }`.
- `.yarnrc.yml` catalog still floats at `^7.0.0-dev.0`; the
  resolutions block overrides the float per the AGENTS.md-documented
  fix-forward + resolutions-fallback policy.
- Lockfile commit `4b2055c22` is a pure `yarn.lock` change per the
  yarn-lock-separate-commit discipline.
- CI [run 27458613522](https://github.com/endojs/endo-but-for-bots/actions/runs/27458613522)
  confirms the Go-runtime panic on `typecheck-all` is gone; the
  step now exits with a single conventional `TS1003` error in
  `ocapn/src/syrup/codec.js:218` (pre-existing, unrelated to tsgo).

The fixer's bisect (`20260425.1` through `20260611.2` all panic;
`20260612.1` resolves) is empirically sound. The "pin forward, not
back" framing is a structural correction to the round-1 panel's
"hold-back to a known-good earlier nightly" framing; no known-good
earlier nightly exists in the visible range.

Shape is correct. The pin is the smallest reversible workaround
for an upstream defect that the separate investigator (`1d8bb6`)
is tracking on `microsoft/typescript-go`.

## Cascade-residual disposition (the load-bearing finding)

The fixer's `corepack yarn typecheck-packages` re-survey clears 3
of the originally-failing 39 packages with the harden fix alone
(harden itself + 2 direct consumers whose only error was the
cascaded TS2322 from harden). 36 workspaces remain failing on
diverse JSDoc precision issues across at least five distinct
arrow-vs-predicate sites (`pass-style/src/passStyle-helpers.js`,
`eventual-send/src/local.js`, `promise-kit/src/memo-race.js`,
`ses/src/commons.js`) and three independent error classes
(TS2775 implicit-`this`, TS2344 `unknown` parameter narrowing,
TS2749 value-used-as-type, TS2339 missing-property, TS2578 unused
`@ts-expect-error`).

This empirical 3-of-39 yield falsifies the round-1 panel's "single
root cause" estimate. The 36-package residual is not one cascade
from one root cause; it is at least five distinct cascades plus
three independent error classes.

**Disposition: `acknowledge`** for the panel (the panel does not
have authority to re-route the maintainer's decision; the fixer
applied the directive honestly and the residual is real).
**Escalate next: liaison** for maintainer re-engagement on the
re-routing question.

The panel's recommended forward shape (which the maintainer's
re-routing may accept or decline):

1. Extend option (a) "fix root cause" to the four other
   arrow-vs-predicate sites; cost-to-clear is the same favorable
   shape cited for the harden site.
2. Per-package follow-up PRs for the non-predicate error classes.
3. Option (b) "documented exclusion list" for whatever long-tail
   residual remains after shapes (1) and (2).

## Disposition counts

- `must-fix-loop`: 0
- `summary-fix`: 0
- `follow-up`: 2 (cascade-residual re-routing; pre-existing `TS1003`
  in `ocapn/src/syrup/codec.js:218`)
- `acknowledge`: 11
- `drop`: 0

Plus 1 follow-up appended to the new ledger for the
`sentence-per-line-md` probe scoping (gardener-side fix; surfaces
through the fixer's pre-push-gates run, not through this round's
panel).

## CI status

CI [run 27458613522](https://github.com/endojs/endo-but-for-bots/actions/runs/27458613522):

- `lint` (contains `typecheck-all` and `typecheck-packages`):
  **fail** on a single line (`packages/ocapn/src/syrup/codec.js(218,43): error TS1003: Identifier expected.`)
  rather than the previous Go-runtime panic. `typecheck-packages`
  was skipped due to fail-fast on the prior step.
- `build`, `cover`, `check-action-pins`, `test-hermes`,
  `test-ocapn-guile-interop`, `test-ocapn-python`, `test-xs`,
  `test262 (22.x, 24.x; ubuntu-latest)`, `viable-release`,
  `zizmor`: pass.
- `test (22.x, macos-15)`: fail (orthogonal macos test flake; not
  on this PR's surface). `test (22.x, ubuntu-latest)`,
  `test (24.x, macos-15)`: in progress.

The Go-runtime panic is gone, confirming Gap 2 landed.

## Loop termination

The panel terminates clean. No `must-fix-loop` dispositions remain;
no fixer-loop iteration follows.

## PR-state contract: DRAFT pending maintainer re-routing

Per the brief's "If next: fixer: don't un-draft", the symmetric
case "If next: liaison for re-routing: don't un-draft" applies:
the maintainer's re-engagement is a pre-condition for un-draft per
the PR body's *Design departures and gaps* enumeration. The
justice does **not** un-draft, does **not** push, does **not**
re-request review of kriskowal (the fixer's reply already
re-requested review per [issue comment 4697694059](https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697694059)),
and does **not** post a `summary-fix` job (no summary-fix items).

## Post-loop actions

| Action | Status |
| --- | --- |
| Submit disposition-tagged review | done (`--comment`; review [4496917244](https://github.com/endojs/endo-but-for-bots/pull/438#pullrequestreview-4496917244)) |
| `@copilot` reviewer-add | done (idempotent re-request) |
| Post `summary-fix` job | skipped (no summary-fix items) |
| Append followup ledger | done (new file `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--438.md`; three items: cascade-residual re-routing, `TS1003` in `ocapn`, `sentence-per-line-md` probe scoping) |
| Write gardener proposed-rule message | skipped (no proposed-rule findings this round) |
| Dispatch appellate | skipped (orchestrator policy on this stage was not invoked; routing-pending state pre-empts appellate's purpose) |
| `gh pr ready 438` | suppressed; PR stays DRAFT pending maintainer re-routing |

## Recommended next stage

**escalate next: liaison** for maintainer re-engagement on the
cascade-residual question. The round-1 panel's "single root cause"
estimate was quantitatively off; the empirical 3-of-39 yield from
applying option (a) at the harden site alone surfaces the need for
a re-routing call. The maintainer's three forward shapes (extend
option (a) to four other sites; per-package follow-ups for
non-predicate classes; option (b) exclusion list for long-tail)
are enumerated in the followup ledger as the load-bearing item.

The liaison's job: post the cascade-shape evidence to the PR or
the bulletin and surface the re-routing question to the maintainer.
After re-routing, the chain resumes per the maintainer's call (a
new fixer dispatch on the picked shape, then a justice round 4).

## Self-improvement

The cascade-shape estimation lesson the fixer surfaced is real
and load-bearing: the builder probe's `gap-revealing-build` skill
output named the harden site as the dominant cause without
enumerating the *other* sites in the repo that exhibit the same
pattern. The panel's round-1 verdict accepted that framing and
estimated "most of the 39 packages would clear from one root-cause
fix". The empirical yield was 3 of 39.

A small probe-side discipline would have caught this: at probe
time, after identifying a root cause at site X, grep the repo for
the same syntactic shape (`const \w+ = .* => .*; */\*\*[^*]*@type {.*=>.*val is`)
to enumerate all sites that exhibit the pattern. The
`gap-revealing-build` skill's structured-gap-report could call for
"sites in the repo that exhibit the same root cause pattern" as an
enumerated field, not just "dominant site". The fixer's
self-improvement line on `entries/2026/06/13/060622Z-result-fixer-6beb46.md`
already surfaces this to the liaison.

Self-improvement: nothing additional this time (the fixer's
self-improvement line already addresses the upstream
probe-side lesson; the panel's lens here was the downstream
"believe the probe's framing" lens, which inherits the same
correction).
