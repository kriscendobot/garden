---
ts: 2026-05-15T04:58:38Z
kind: result
role: cleaner
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/cleaner--924af9/project
refs:
  - entries/2026/05/15/042000Z-result-builder-a232cc.md
  - entries/2026/05/15/031826Z-result-cleaner-06e7fc.md
---

# Result: coverage pass on `packages/ses` for PR #263 (hardened-url-shim)

## Branch / head

`feat/hardened-url-shim`, head advanced from `beb0d4e6a` (builder) to `9acdcc4f0` (cleaner +1 commit).

PR `mergeable: MERGEABLE`, `mergeStateStatus: UNSTABLE` (CI mixed; not `CONFLICTING`). Still draft. Cleaner did not un-draft.

## Coverage gap analysis

Same lens as the sibling text-codecs cleaner (entry `031826Z-result-cleaner-06e7fc.md`): the production change is a declarative permits table plus a six-line sampling pass. "Coverage" means: which named permit entries are observable as functioning after `lockdown()` exercises the permits tables against the host's `URL` / `URLSearchParams`.

The builder's 19 tests already exercised:

- presence on the start compartment, universal identity across compartments
- `Object.isFrozen` on both constructors and prototypes and the iterator prototype
- the URL prototype's named accessors as **getters** (origin, protocol, username, password, host, hostname, port, pathname, search, hash; href via round-trip)
- `searchParams`, `JSON`-`roundtrip` of the search params graph
- all URLSearchParams data methods and all four iteration methods plus `@@iterator`
- `URL.parse`, `URL.canParse`, `createObjectURL` / `revokeObjectURL` cauterization
- `@@toStringTag` on all three prototypes (URL, URLSearchParams, iterator)
- the iterator prototype's `next` is frozen and unwritable (the load-bearing cross-compartment claim)

Un-exercised permit entries before the cleaner pass:

- `[[Proto]]: '%FunctionPrototype%'` on both `URL` and `URLSearchParams` (constructor inheritance)
- `[[Proto]]: '%IteratorPrototype%'` on `%URLSearchParamsIteratorPrototype%` (the seeded anonymous intrinsic)
- `constructor` reverse-link on `%URLPrototype%` and `%URLSearchParamsPrototype%`
- `toString: fn` on `%URLPrototype%` (only exercised implicitly via the round-trip test that re-reads `.href`; never via the explicit `url.toString()` or `URL.prototype.toString` method reference)
- `toJSON: fn` on `%URLPrototype%` (never exercised; `JSON.stringify(url)` relies on it to produce a string instead of `{}`)
- the **setter half** of each `accessor` (get + set) on the ten URL prototype properties: the builder exercised every accessor as a getter but never assigned through one. A permits regression that demoted any of `href` / `protocol` / `username` / `password` / `host` / `hostname` / `port` / `pathname` / `search` / `hash` from `accessor` to `getter` would silently cut the setter.

## Cleaner commit

`9acdcc4f0 test(ses): cover URL [[Proto]], constructor, toString/toJSON, accessor setters`

Adds 5 tests to `packages/ses/test/url.test.js`:

1. `URL and URLSearchParams inherit from Function.prototype`: asserts `Object.getPrototypeOf(URL) === Function.prototype` and the same for `URLSearchParams`.
2. `URLSearchParams iterator prototype inherits from %IteratorPrototype%`: asserts the seeded anonymous intrinsic's `[[Proto]]` equals the shared `%IteratorPrototype%` reached via `Object.getPrototypeOf(Object.getPrototypeOf([][Symbol.iterator]()))`, plus that the shared prototype carries `@@iterator` (the property that makes a bare iterator usable in for-of / spread).
3. `constructor reverse-link is preserved on URL and URLSearchParams prototypes`: asserts `URL.prototype.constructor === URL`, the same for URLSearchParams, and that instance `.constructor` walks back to the same identity.
4. `URL.prototype.toString and toJSON are preserved`: asserts both are functions, exercises `url.toString()` and `url.toJSON()` round-trip, and asserts `JSON.stringify({u: url})` produces the URL-as-string output (which relies on `toJSON`).
5. `URL prototype accessor setters mutate the instance after lockdown`: assigns through each of the ten accessor setters in turn and reads the result back via the matching getter.

## Regression evidence (per skills/regression-evidence)

Verified each new test fails when its target permit entry is removed or demoted:

| Test | Mutation applied to permits.js | Result with mutation |
| --- | --- | --- |
| URL/URLSearchParams [[Proto]] | change URL `'[[Proto]]'` from `'%FunctionPrototype%'` to `'%ObjectPrototype%'` | lockdown rejects, test file fails to load (uncaught exception) |
| iterator [[Proto]] | change iterator-prototype `'[[Proto]]'` from `'%IteratorPrototype%'` to `'%ObjectPrototype%'` | lockdown rejects, test file fails to load |
| constructor reverse-link | remove `constructor: 'URL'` from `%URLPrototype%` | test fails: `URL.prototype.constructor` no longer points to `URL` |
| toString / toJSON | remove `toString: fn` and `toJSON: fn` from `%URLPrototype%` | test fails: `Removing intrinsics.%URLPrototype%.toString` / `.toJSON`, then `typeof URL.prototype.toString` is no longer function |
| accessor setters | demote `href` from `accessor` to `getter` | lockdown rejects (asymmetric permit vs the host's get+set descriptor), test file fails to load |

Each mutation was applied, the suite re-run, and `permits.js` restored from a saved copy before the next mutation. The final restore was verified with `diff` against the saved copy.

## Test count

24 tests in `url.test.js` (19 builder + 5 cleaner) plus 2 in `url-missing.test.js`. Full ses suite: **525 tests passed**, 2 known failures (pre-existing, unrelated), 2 skipped.

## Pre-PR checklist

- `npx corepack yarn ava` in `packages/ses`: green (525 passed).
- `npx corepack yarn lint` in `packages/ses`: surfaces the same two pre-existing TS2300 errors (`Duplicate identifier 'Compartment'`) as the builder's run, plus a **real new lint error** in the builder's production code (see *Production-side reds* below).
- `npx corepack yarn format` at the monorepo root: re-flowed one multi-line literal in the cleaner's new test; included in the cleaner commit.
- No `yarn.lock` change (no new deps).
- No dead-code deletion: the PR is purely additive (data entries in the declarative permits table plus a six-line sampler); there is no production code that the cleaner could legitimately delete.

## CI status on cleaner's HEAD (`9acdcc4f0`)

24 jobs pass, 2 jobs fail, 1 macos-15 runner still queued (`test (24.x, macos-15)`, slow runner pool; the matching 18.x / 20.x / 22.x macos-15 jobs already passed so the test outcome is not in doubt).

## Production-side reds (both are real, both are out of scope for the cleaner)

Two failures, both originated in the builder's production change to `get-anonymous-intrinsics.js` and `permits.js` and unrelated to the cleaner's test additions. Neither is pre-existing infra red.

**1. `lint` (fail, 2m17s):**

> `packages/ses/src/get-anonymous-intrinsics.js:188:37  error  Polymorphic call: "[[NewExpression]].entries". May be vulnerable to corruption or trap  @endo/no-polymorphic-call`

The builder's sampling line `new globalThis.URLSearchParams().entries()` triggers `@endo/no-polymorphic-call`. The same file already carries five `// eslint-disable-next-line @endo/no-polymorphic-call` comments (lines 146, 150, 161, 165, 171) for analogous host-shape sampling. The fix is a one-line disable comment above the new sampling line. The builder's *Pre-PR checklist* missed this because `yarn lint` short-circuits on the pre-existing TS2300 from `lint:types` and never runs `lint:eslint`; running `yarn lint:eslint` directly reproduces the error.

**2. `browser-tests` (fail, 1m52s, Chromium):**

> `TypeError: Cannot delete property 'arguments' of function URL() { [native code] }` at `cauterizeProperty` (ses.umd.js:4327:16)

Exactly the same root cause as the sibling PR #259 (text-codecs). Chromium V8's native `URL` constructor carries non-configurable own `arguments` / `caller` that `cauterizeProperty`'s `delete obj[prop]` cannot remove, aborting lockdown in the browser. The fix that landed on PR #259 (commit `b2a3657fc`, `fix(ses): tolerate undeletable arguments/caller on native function intrinsics`) extends `cauterizeProperty`'s tolerate-undeletable escape hatch from `prototype` to also include `arguments` / `caller` on functions. That fix is on `feat/hardened-text-codecs-shim` and not yet merged to master, so PR #263 (branched from master) does not have it. The builder's report stated the escape hatch was "already in place" but that is true only on the sibling branch, not on master.

Two options for a fixer to consider, both already discussed in the prior cleaner's PR #259 result:

- After PR #259 merges to master, weave PR #263 onto the new master tip; the fix arrives transitively.
- If PR #263 needs to ship before PR #259 merges, cherry-pick `b2a3657fc` onto `feat/hardened-url-shim`. The cauterize-property fix is general (it skips any native function's undeletable `arguments` / `caller`, not specifically TextEncoder / TextDecoder), so it covers URL as well.

The accompanying changeset entry for the cauterize-property fix is `ses: patch` and would need to land alongside the cherry-pick (or come transitively from PR #259's merge).

## Pre-existing infra red

None. The TS2300 errors in `types.d.ts` and `dist/types.d.cts` are real lint output but did not gate the `lint` CI job, which still ran `lint:eslint` and failed only on the polymorphic-call error. Both reds named above are PR-specific production bugs, not infra.

## Out of scope

- The `lint` and `browser-tests` fixes: production-code changes that the cleaner does not author per `roles/cleaner/AGENT.md` § Operating norms ("the cleaner does not fix production bugs"). Both belong to a fixer dispatch before the judge.
- The `Date`-style split, the XS `URL` polyfill, and the Phase 3 downstream `createObjectURL` audit: out of scope per the builder's prior report.

## Whether the judge dispatch is owed next

**No.** Per `skills/pr-creation-flow/SKILL.md` and the *Definition of done* on the cleaner role: "`gh pr checks` is green on the cleaner's HEAD". Two real reds remain, both production-side. The orchestrator should dispatch a **fixer** next (not the judge) to address the polymorphic-call lint nit and the cauterize-property cherry-pick / weave, drive CI to green, then dispatch the judge.

If the orchestrator prefers to wait for PR #259 to merge and then weave #263 onto the new master, both reds are likely to resolve in one rebase (the polymorphic-call disable comment is a separate one-line fix the fixer can land in the same dispatch).

## Self-improvement

Nothing this time, but one observation worth surfacing: the same Chromium-native-`arguments`/`caller` hazard struck PR #263 exactly as it struck PR #259, and the builder's *Self-improvement: nothing this time* note explicitly stated the escape hatch "was already in place from #259 and required no further extension here", which proved to be wrong because #259's fix is on a separate branch not yet on master. The general lesson (don't assume a sibling PR's hot fixes are visible from a base branch that hasn't received them yet) is already covered by `skills/verify-upstream-state-before-pinning/SKILL.md` and by general worktree-per-pr hygiene; the specific lesson (when two sibling PRs each tame a host intrinsic on a Chromium-shaped native function, the cauterize-property escape hatch is the shared dependency) is narrow enough that it doesn't warrant a new skill entry. If a third sibling lands (e.g. `crypto`, `Blob`, `EventTarget`) and the same trap snaps shut a third time, a *Notes from the field* row on `skills/coverage-driven-testing/SKILL.md` or on a new `chromium-native-function-cauterize` skill becomes warranted.
