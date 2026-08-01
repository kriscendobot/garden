---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T21:30:32Z
---
---
kind: result
role: spec-keeper
repo: kriscendobot/finbot
project: finbot
---

# spec-keeper -- PR kriscendobot/finbot#6 (round 5)

Reviewed the worktree diff `origin/main...HEAD` (head f43b20e) at
scratch/project-wt-finbot-pr6-panel-r5-55da45b5.

## Verdict

request-changes

## Findings

### 1. must-fix -- `audit()` still throws on a hostile step accessor; `hashProposal` reads by plain [[Get]]

`packages/pipeline/auditor.js:304` calls `hashProposal(steps)` outside any
try/catch, and `packages/pipeline/planner.js:31-39` reads `s.source`, `s.dest`,
`s.side`, `s.asset`, `s.qty`, `s.price`, `s.notional` by plain [[Get]]. Every
other read the PR adds goes through `readOwn` so that "a hostile proxy trap owes
a verdict, not an exception" (auditor.js:515), and the module header now claims
"every fail-closed branch below is reachable" (auditor.js:44). The
reproducibility invariant is the hole. Confirmed by running it:

```
audit({ proposal: { steps: [{ side:'buy', asset:'ATOM', notional:1, price:1,
        get qty() { throw new TypeError('hostile step accessor'); } }],
        proposal_hash:'deadbeef', cited_forecasts:['f'], cited_analyses:['a'] },
  portfolio:{cash:100,balances:{ATOM:1}}, prices:{ATOM:1},
  forecast:{p05Equity:1000,horizon:5}, currentTick:1, oracleReadings:[] })
-> THREW OUT OF audit(): TypeError hostile step accessor
```

This is the executor's unwrapped fire-time re-audit path, so the caller gets an
exception where the contract promises a rejected verdict. `safeSteps` bounds the
array but not the elements. Fix: canonicalize each step's seven fields through
`readOwn` before hashing (or hash a `readOwn`-built snapshot). No honest plan's
hash changes, because a data-property step reads identically.

[rule: roles/jurors/spec-keeper/AGENT.md, Operating norms, Primordial
preservation -- "flags every `.method()` call on a value that comes from outside
the module's trust boundary, even when the surrounding code assumes the
primordial"]

### 2. should-fix -- `sanitizeLabel` misses the implicit bidi marks it says it scrubs

`auditor.js:877-893` scrubs U+202A..U+202E and U+2066..U+2069 but not U+200E
(LRM), U+200F (RLM), or U+061C (ALM). Its own docstring and the ooda-cycle call
site (ooda-cycle.js, `forecastBody`) name "bidi controls" as the threat. Per
UAX #9 (Unicode Bidirectional Algorithm) section 2, the implicit directional
marks LRM/RLM/ALM are directional formatting characters alongside the embeddings
and isolates already covered, and CVE-2021-42574 (Trojan Source) enumerates all
three. Confirmed: `sanitizeLabel('A‎B')`, `'A‏B'`, `'A؜B'` all
pass through unchanged, while `'A‮B'` scrubs to `'A?B'`.
`test/auditor-data-sufficiency.test.js:345` enumerates
`[0x0a,0x0d,0x85,0x9b,0x2028,0x2029,0x202e,0x2066]` -- a subset -- so the suite
passes with the gap open. Add the three code points and the cases.

[rule: roles/jurors/spec-keeper/AGENT.md, Operating norms, Spec citation -- an
implementation that cites a standard is expected to match it]

### 3. should-fix -- the exported bare-count overload mints a descriptor the gate always rejects

`computeDataSufficiency` is exported from `./forecaster` and documents a
bare-count overload ("The bare-count overload trusts a caller that already
counted its own window"), which returns `worstAsset: null`. The auditor's gate
(auditor.js:1079) rejects any descriptor with `historyReturns > 0` and no
nameable worst asset. Confirmed:

```
computeDataSufficiency({ frames: 8, horizon: 4 })
-> {"historyFrames":8,"historyReturns":7,"worstAsset":null,"horizon":4,"coverageRatio":1.75}
audit(..., { dataSufficiencyMinCoverage: 0.5 })
-> forecast-data-sufficiency: pass=false, "claims 7 observed return(s) without a
   nameable worst-covered asset; the gate cannot be evaluated (fails closed)"
```

Coverage 1.75 against a threshold of 0.5, rejected. `project()` never takes that
path today, so nothing in-tree breaks, but two exported surfaces landing in one
PR contradict each other. Either drop the overload from the published contract
or let the gate accept `worstAsset: null` when the descriptor is otherwise
self-consistent.

[proposed-rule: when a PR exports a producer and a consumer of the same
descriptor, every documented producer output shape must be one the consumer
accepts, or the shape is removed from the producer's contract]

### 4. comment-only -- the primordial-capture discipline is applied unevenly

`forecaster.js:14-18` captures `Object.getOwnPropertyDescriptor`, `Object.hasOwn`,
`Number.prototype.toFixed`, `Reflect.apply`, and `Array.isArray` with an explicit
rationale ("this module measures caller-supplied oracle frames before the
dependency graph happens to import a lockdown shim"), and `round12` routes
`toFixed` through `reflectApply`. In the same PR, `auditor.js`'s `formatCoverage`
calls `value.toFixed(3)` / `value.toExponential(3)` directly and `sanitizeLabel`
uses `.codePointAt` / `.push` / `.slice` / `.join` directly, in the same
pre-lockdown import window; both are now promoted to the package entry point as
the single rendering rule. Either capture there too, or the `round12` rationale
overstates what the codebase actually holds to.

### 5. comment-only -- undocumented third parameter

`countObservedFramesAndReturns(frames, observed, length = safeLength(frames))`
in `forecaster.js` has a JSDoc block declaring only two `@param` tags. There is
no `tsconfig.json` in the repo so nothing checks it today, but the same file
carries two `@overload` blocks for `round12` and an explanation of why they
cannot be collapsed, so the omission is out of keeping.

## Read and accepted

- The `Array.isArray` revoked-Proxy citation is accurate: ECMA-262 IsArray
  (7.2.2) step 3.a performs `ValidateNonRevokedProxy`, which throws a `TypeError`.
  `isArraySafe` is the right total wrapper and the fail-closed direction argued
  for it holds.
- `hasOwn(descriptor, 'value')` rather than `'value' in descriptor` is exactly
  right (`in` is `HasProperty`, which walks `Object.prototype`), and
  `test/ownness-prototype-independence.test.js` pins it.
- The lexicographic tie-breaks in `worstAssetPersistence` and
  `measureHistoryCoverage` are correctly justified as engine-invariant: String
  relational comparison is code-unit-wise per spec, unlike `localeCompare`,
  which is locale- and ICU-build-dependent. The hash stability argument is sound.
- `describeThreshold` uses `String(value)` rather than a template literal, which
  is the only form that does not throw on a Symbol threshold. Deliberate and
  correct.
- `formatCoverage`'s `toExponential(3)` is deterministic across engines: with
  `fractionDigits` supplied, ECMA-262 fixes `n` exactly, so
  `assert.equal(formatCoverage(3e-4), '3.000e-4')` is not a brittle assertion.

Self-improvement: nothing this time.
