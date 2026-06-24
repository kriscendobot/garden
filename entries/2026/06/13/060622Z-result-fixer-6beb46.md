---
ts: 2026-06-13T06:06:22Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--6beb46/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/13/055700Z-dispatch-fixer-6beb46.md
  - entries/2026/06/12/052621Z-result-builder-4ef77c.md
  - entries/2026/06/12/055700Z-result-barrister-821970.md
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697671329
  - https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697694059
---

# result: fixer 6beb46 — applied panel routes for Gap 1 + Gap 2 on #438

Both gaps from the kriskowal directive on issue comment `4697671329`
addressed in 3 commits on `chore/tsgo-lint-types`.

## Branch tips

- Pre: `a619bea05` (docs(agents): one sentence per line in new tsgo
  section)
- Post: `4b2055c22` (chore: Update yarn.lock)

## Gap 1: fix root cause in `@endo/harden`

Commit `842dcae20` (fix(harden): declare isPrimitive as a function so
its val is predicate attaches).

**Diagnosis.** The arrow form
`const isPrimitive = val => ...` with a `@type {(val: unknown) => val
is ...}` JSDoc cannot carry a type predicate under tsgo's strict mode.
A type predicate is a property of a function's own return type, not a
property of the variable the function is assigned to. Assigning an
arrow whose body returns `boolean` to a variable typed as a predicate
signature fails with TS2322
(`Signature '(val: unknown): boolean' must be a type predicate`).

**Fix.** Converted to a function declaration with `@param` and
`@returns` JSDoc so the predicate attaches to the function itself and
the body proves it:

```js
/**
 * @param {unknown} val
 * @returns {val is (undefined | null | boolean | number | bigint | string | symbol)}
 */
function isPrimitive(val) {
  return !val || (typeof val !== 'object' && typeof val !== 'function');
}
```

**Cascade re-survey** via `corepack yarn typecheck-packages`:

- Pre-fix failing workspaces: 39 (per builder 4ef77c).
- Post-fix failing workspaces: 36.
- Net: 3 workspaces cleared (`@endo/harden` itself and 2 consumers
  whose only `lint:types` error was the cascaded TS2322 from
  harden).

The remaining 36 workspaces fail on diverse JSDoc precision issues
that the panel's "single root cause" diagnosis did not anticipate.
Sample of the dominant patterns:

- TS2775 implicit-`this` assertion call-targets across
  `compartment-mapper`, `marshal`, `pass-style`, `ses` (the largest
  contributor, dozens of sites in `compartment-map.js` alone).
- TS2344 `unknown` not assignable to `object` constraint in
  `eventual-send/src/E.js`.
- The same arrow-vs-predicate pattern in
  `pass-style/src/passStyle-helpers.js`, `eventual-send/src/local.js`,
  `promise-kit/src/memo-race.js`, and `ses/src/commons.js`. These are
  semantically the same fix as the harden one (turn the arrow into a
  function declaration); each is a per-file change and would
  individually clear its own consumer cascade.
- TS2749 value-used-as-type (`'ModuleSource' refers to a value, but
  is being used as a type here`) in `ses` and `eventual-send/src/E.js`.
- TS2339 missing-property assertions in test paths
  (`isFake` on `Harden` in several `ses` tests).
- TS2578 unused `@ts-expect-error` directives in `pass-style`.

These are per-package follow-ups, each one or two commits scoped to a
single file or error class, not in the dispatch's scope. The brief
explicitly said "If a residual set remains, those need per-package
JSDoc fixes (one commit per package or one commit per logical
category)" and bounded the fixer to `packages/harden/` + root
`package.json` / `.yarnrc.yml`.

## Gap 2: pin a working tsgo nightly

Commit `0202cefce` (chore(deps): pin `@typescript/native-preview` to
`7.0.0-dev.20260612.1`) + commit `4b2055c22` (chore: Update
yarn.lock).

**Bisect.** Tested 9 nightlies from `20260425.1` forward through the
broken `20260611.2`:

| Version | Result |
| --- | --- |
| `7.0.0-dev.20260425.1` | PANIC |
| `7.0.0-dev.20260501.1` | PANIC |
| `7.0.0-dev.20260515.1` | PANIC |
| `7.0.0-dev.20260521.1` | PANIC |
| `7.0.0-dev.20260601.1` | PANIC |
| `7.0.0-dev.20260605.1` | PANIC |
| `7.0.0-dev.20260609.1` | PANIC |
| `7.0.0-dev.20260610.1` | PANIC |
| `7.0.0-dev.20260611.2` | PANIC (the version builder hit) |
| `7.0.0-dev.20260612.1` | **OK** (no panic; 1 unrelated TS1003 in `ocapn`) |

Every preceding nightly back to April 25 panics on the unified
`typecheck-all` compilation with the same Go-runtime trace
(`getParameterNameAtPosition: index out of range [2] with length 2`
inside the relater). The defect is long-standing on this nightly
line; the panel's "(c) earlier nightly" option does not have a
known-good target in the visible range.

Released the same day as the broken `20260611.2`, the
`20260612.1` nightly resolves the panic. `corepack yarn typecheck-all`
now completes; the only error it surfaces is a pre-existing
`TS1003: Identifier expected` in `packages/ocapn/src/syrup/codec.js:218`
that is unrelated to tsgo (a JSDoc syntax issue our `tsc` 6 also
flags). So the pin is forward, not back.

**Mechanism.** `resolutions` block added to root `package.json`:

```json
"resolutions": {
  "@typescript/native-preview": "7.0.0-dev.20260612.1"
}
```

This overrides the catalog's `^7.0.0-dev.0` float (kept as-is so the
AGENTS.md-documented fix-forward + resolutions-fallback policy
remains intact). `corepack yarn install --immutable` reconciles
cleanly with the new lockfile; the lockfile churn ships in its own
commit (`4b2055c22`) per the project's yarn-lock discipline.

**Local verification.**

- `corepack yarn workspace @endo/harden lint:types` — clean.
- `corepack yarn typecheck-all` — completes; 1 unrelated `TS1003` in
  `ocapn/src/syrup/codec.js`.
- `corepack yarn typecheck-packages` — 36 failing workspaces (the
  residual JSDoc cascade described above; same shape as builder
  4ef77c minus the 3 harden-cascade clearances).

The separate investigator dispatch (`1d8bb6`) is tracking the
upstream defect on `microsoft/typescript-go`. Their report will
inform whether the bisect from `20260612.1` forward stays clean.

## pre-push-gates result

`pre-push-gates.sh --summary` ran against the project. `yarn format`
and `yarn lint --fix` auto-fixed 3 paths each (cosmetic re-staging
into the harden and resolutions commits). All probes pass except
**sentence-per-line-md**, which flags three pre-existing lines on
`AGENTS.md` (lines 54, 58, 69) that this PR does **not** touch.
Verified via `git blame master-4a04d07`: those lines are authored by
Turadg Aleahmad on 2026-03-21, before this branch existed. The probe
matches any `.md` changed file diff-from-master and AGENTS.md was
changed earlier in the branch (by the cleaner / fixer 6abce3 +
89bfcd), so its pre-existing lines come into the probe's view; this
is a probe-side limitation, not a regression from this dispatch.

Per the brief: *Do NOT touch source outside `packages/harden/` and
the root `package.json` / `.yarnrc.yml`.* So the AGENTS.md
sentence-per-line cleanup is parked.

## PR-side actions

Reply on directive comment `4697671329`:
<https://github.com/endojs/endo-but-for-bots/pull/438#issuecomment-4697694059>

Re-request review from `kriskowal` succeeded. `requested_reviewers`
on PR #438 now includes `kriskowal`.

The PR remains DRAFT per the brief's *Out of scope* (the gamut
continues via justice re-run after the maintainer's next response).

## Recommended next stage

**justice re-run** on the gamut. The justice's brief should include:

- The 3 commits applied (harden fix + tsgo pin + yarn.lock).
- The cascade-residual observation: harden-fix alone clears only 3 of
  39 packages; the remaining 36 are independent JSDoc precision
  issues. The panel's "single root cause" framing was an
  underestimate. The justice's panel may want to route a follow-up
  *fix-cascade* dispatch (or accept the PR with documented residual
  per option (b) "exclusion list") rather than expecting another
  fixer round to clear them.
- The 1 unrelated `TS1003` in `ocapn/src/syrup/codec.js:218` that
  `typecheck-all` newly surfaces (now that the panic is gone). May
  warrant a single-file follow-up fix or a panel-side acknowledge.
- AGENTS.md's pre-existing sentence-per-line violations (lines 54,
  58, 69) that the pre-push gate now flags because AGENTS.md is in
  the changed-file set; either justice routes a cleanup or the
  appellate appeals it.

## Self-improvement

The panel's diagnosis that a single root cause dominates the JSDoc
cascade was directionally right (the *kind* of issue is similar
across files: arrow-with-`@type`-predicate vs. function-declaration
with `@returns`-predicate) but quantitatively off: there are at least
5 distinct sites of the same pattern (harden, pass-style,
eventual-send/local, promise-kit/memo-race, ses/commons), each in its
own package, and the cascade from each is local to its package's
consumers. The single-root-cause framing led the brief to expect
~36 of 39 packages to clear from one harden fix; the actual yield
was 3. Future builder probe reports on cascade-shaped failures
would benefit from naming each *site* of the root cause across the
repo, not just the dominant site; the panel's routing then has
calibrated expectations on the yield.

Self-improvement: surface the cascade-shape estimation lesson back to
the builder role (gap-revealing-build skill) via a message to the
liaison; the `gap-revealing-build` skill's structured-gap-report
format could call for "sites in the repo that exhibit the same root
cause pattern" as an enumerated field, not just "dominant site".
