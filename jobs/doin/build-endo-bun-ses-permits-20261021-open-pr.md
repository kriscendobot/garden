---
role: builder
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Open the draft PR for build-endo-bun-ses-permits-20261021 (PR-create handoff)

Repo: endojs/endo-but-for-bots. The predecessor job `build-endo-bun-ses-permits-20261021` finished the work and pushed head branch `bun-ses-permits` (tip `8b11aebbb`, stacked on the Bun probe PR https://github.com/endojs/endo-but-for-bots/pull/1516 head `2b7550456`). The frozen base `master-ebc7904` already exists on the fork. It could not open the PR because host oros-studio-garden-ce242c49's PAT gets 403 on `createPullRequest`.

Your only task: open the DRAFT PR. Do not change the code.

1. Confirm `origin/bun-ses-permits` still exists and its tip is `8b11aebbb` or a descendant.
2. Write the body below (between the `~~~~` fences, exclusive) to a file.
3. From a project worktree (`ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots bun-ses-permits`), run:
   `scripts/jobs/gardening/ensure-pr.sh build-endo-bun-ses-permits-20261021 endojs/endo-but-for-bots bun-ses-permits master-ebc7904 --title "fix(ses): permit Bun's URLSearchParams length and toJSON; measure the Bun lane" --body-file <file>`
   Use the predecessor's job base so the `garden-job` marker matches it.
4. Post one comment on https://github.com/endojs/endo-but-for-bots/pull/1516 pointing at the new PR as the successor that settles Gap 3, and name the new PR in your completion report so the gauntlet is staged.

~~~~
Refs: #1516 (Bun probe). This branch stacks on the probe head `2b7550456` and settles its Gap 3 (the SES permit for Bun's `URLSearchParams` additions) with a security analysis, then re-measures the Bun lane.

## Description

On Bun 1.4.3, `lockdown()` throws before any test runs. Bun adds two members to `URLSearchParams.prototype` that the SES permits do not list. Lockdown removes unpermitted members, and one of these is non-configurable, so deleting it throws. This PR:

1. Permits Bun's `URLSearchParams.prototype.length` and `URLSearchParams.prototype.toJSON` in `packages/ses/src/permits.js`, with a comment that both are Bun-only. It also adds a test that checks both members are frozen and scoped to the receiver after lockdown. The test passes on Node, where both members are absent.
2. Fixes a CommonJS interop difference that broke every Babel-based module transform under Bun (`@endo/module-source`, `@endo/parser-pipeline`).
3. Fixes two defects in the probe's Bun launcher that hid results.
4. Makes the Bun CI job required for the 27 packages that pass every configuration, and runs the full matrix as an advisory step.

**The second property**

The probe's reverted two-property permit was **`URLSearchParams.prototype.toJSON`**, alongside `length`.

| Property | Shape in Bun 1.4.3 | WHATWG URL Standard | Safari / WebKit | Classification |
| --- | --- | --- | --- | --- |
| `length` | accessor, getter only, non-enumerable, **non-configurable** | absent | absent (maintainer checked: `undefined`; WebKit's `URLSearchParams.idl` declares only `size`) | **Bun-only** |
| `toJSON` | data property, function, writable, enumerable, configurable | absent | absent (not in WebKit's `URLSearchParams.idl`) | **Bun-only** |

Both come from Bun's own WebCore bindings (`src/jsc/bindings/webcore/JSURLSearchParams.cpp` in oven-sh/bun), not from JavaScriptCore. Bun declares `length` and `size` with the same native getter, `jsURLSearchParamsPrototype_getLength`, which returns `jsNumber(thisObject->wrapped().size())`. `toJSON` calls `getInternalProperties`, which builds a new plain object from the receiver's entries.

**Security analysis**

The maintainer's test: permit only if the value is innocuous and cannot be abused to share state or communicate between compartments. The checks below ran under Bun 1.4.3 after `lockdown()` with this permit.

**`URLSearchParams.prototype.length`**

- *Shape.* An accessor with a getter and no setter. The property is non-configurable as Bun installs it, and after lockdown the prototype is frozen. A compartment cannot redefine it (`TypeError`).
- *Value.* The getter returns a number (a primitive): the count of the receiver's entries. It shares its native implementation with the standard `size` getter, and `params.length === params.size` holds.
- *What it reads.* Only the receiver's internal entry list. Calling it on anything other than a `URLSearchParams` throws `TypeError`, so it cannot be pointed at another object.
- *State and channels.* The getter function's own properties are only `length` and `name`, and lockdown freezes it. A compartment that tries to store a property on it gets `TypeError`, and a second compartment sees nothing. The value tells a holder what `size` already tells it, about an object it already holds.
- **Verdict: passes.** The member is innocuous. The function is reachable only from the shared prototype, holds no state, and is frozen after lockdown, so it cannot carry mutable state or a channel between compartments.

**`URLSearchParams.prototype.toJSON`**

- *Shape.* A data property holding a function. After lockdown it is non-writable and non-configurable, and the function is frozen. It has no `prototype` property and throws when called with `new`. Replacing it from a compartment throws `TypeError`.
- *Value.* Each call returns a **new** plain object. Its keys are the receiver's names; each value is a string, or a new array of strings for a repeated name. It also carries a non-enumerable `Symbol.toStringTag` string. Two calls return distinct objects, and mutating a result does not change the receiver or later results. The result's prototype is the shared, frozen `Object.prototype`, the same as any object literal. Bun writes keys with `putDirect`, so a `__proto__` name becomes an own data property and does not change the result's prototype.
- *What it reads.* Only the receiver's entries. A non-`URLSearchParams` receiver throws `TypeError`.
- *State and channels.* Like `length`: the function's own properties are `length` and `name`, it is frozen, and a stored property cannot reach another compartment. It discloses nothing that iterating the receiver with `entries()` does not.
- **Verdict: passes.** The returned object is a new, unshared value, and the function holds no state. The only effect is that `JSON.stringify(params)` produces the entries instead of `{}` on Bun.

Both properties pass, so both are permitted. The permits are optional, like every other SES permit: on hosts without these members (Node, XS, browsers) the permit has no effect.

**Other gaps between Bun's intrinsics and SES**

After this permit, lockdown on Bun 1.4.3 finishes and reports only removals of configurable members:

| Removed member | Origin | Effect |
| --- | --- | --- |
| `%IteratorPrototype%.chunks`, `.windows`, `.includes`, `.join` | JavaScriptCore (TC39 iterator proposals); not Bun-specific. Whether Safari ships them was not checked. | Removed cleanly; no failure |
| `%WrapForValidIteratorPrototype%[@@toStringTag]` | JavaScriptCore | Removed cleanly; no failure |
| `%URLSearchParamsPrototype%[nodejs.util.inspect.custom]`, `%URLPrototype%[nodejs.util.inspect.custom]` | Bun's Node compatibility; Node removes the same symbol | Removed cleanly; no failure |

No other intrinsic stops lockdown. The `URLSearchParams.prototype.length` non-configurability was the only fatal gap.

**Measurements**

All runs used Bun 1.4.3 on linux-arm64, the full `yarn test:bun` launcher, and AVA's child-process mode.

| State | Configurations passing | Packages passing every configuration |
| --- | --- | --- |
| Probe head `2b7550456` (no permit) | 19/109 | 8/47 |
| + `URLSearchParams` permit only | 28/109 | — |
| + launcher `-C` → `--conditions` fix | 57/109 | 25/47 |
| + `@babel/traverse` interop fix (this PR) | **65/109** | **27/47** |

In the final run, 6,616 test results passed and 226 failed, summed over all configurations. A second run limited to the 27 green packages passed 61/61 configurations.

The probe's earlier 56/110 count came from AVA's worker-thread mode. That mode does not pass `nodeArguments` to Bun, so the `endo` and `lockdown` configurations ran without the `ses-ava:endo` export condition. The counts above use child-process mode, where the condition is applied.

**Green packages (27):** `@endo/base64`, `@endo/bytes`, `@endo/cache-map`, `@endo/chacha12`, `@endo/chacha12-fast-check-test`, `@endo/check-bundle`, `@endo/cjs-module-analyzer`, `@endo/errors`, `@endo/evasive-transform`, `@endo/far`, `@endo/goblin-chat`, `@endo/hex`, `@endo/immutable-arraybuffer`, `@endo/import-bundle`, `@endo/init`, `@endo/lp32`, `@endo/nat`, `@endo/netstring`, `@endo/ocapn-noise`, `@endo/panic`, `@endo/path-compare`, `@endo/random`, `@endo/stream`, `@endo/syrup-frame`, `@endo/trampoline`, `@endo/where`, `@endo/zip`.

**Fixes beyond the permit**

- **Launcher `-C` flag.** The shared AVA configurations pass `nodeArguments: ['-C', '<condition>']`. In child-process mode AVA forwards that flag to Bun, which accepts only `--conditions=<condition>` and exits with `Invalid Argument '-C'`. The Bun preload now rewrites the flag in `child_process.fork`'s `execArgv`. This change alone took the count from 28 to 57 configurations.
- **AVA stack parsing.** AVA's `serialize-error.js` calls `callSite.file.startsWith` on every parsed frame. JavaScriptCore reports frames such as `at processTicksAndRejections (native)` with no file, so whenever a test failed, AVA crashed with `undefined is not an object (evaluating 'file.startsWith')` and hid the real failure. The preload makes `stack-utils` skip file-less frames. This is a candidate upstream AVA fix.
- **`@babel/traverse` default import.** `@babel/traverse` is CommonJS marked `__esModule`. Node binds the default import to `module.exports`, whose `default` is the traverse function. Bun binds it to the traverse function itself, so `const { default: traverseBabel } = babelTraverse` produced `undefined`. That broke `ModuleSource` and, through it, `ses` module loading, `@endo/compartment-mapper`, `@endo/import-bundle`, `@endo/bundle-source`, `@endo/nat`, and `@endo/daemon`. The fix uses `babelTraverse.default || babelTraverse`, the idiom `@endo/evasive-transform` and `ses/scripts/hermes-transforms.js` already use, and imports `Hub` and `NodePath` by name. Failure counts dropped: `ses` 144 → 24, `@endo/compartment-mapper` 874 → 31, `@endo/module-source` 140 → 2 per configuration. `@endo/import-bundle` and `@endo/nat` became fully green.

**Triage of the remaining failures**

| Family | Packages | Classification |
| --- | --- | --- |
| Error instances carry own `line`, `column`, `sourceURL` (JavaScriptCore) and `originalLine`, `originalColumn` (Bun only); pass-style rejects them as "extra unpassed property" | `@endo/pass-style`, `@endo/marshal`, `@endo/patterns`, `@endo/ocapn` | **Real portability bug.** The `line`/`column`/`sourceURL` part also applies to Safari. Fixing it in pass-style would turn green the largest remaining group. |
| Tests assert V8's exact error-message text (`Invalid value used as weak map key`, `Cannot assign to read only property …`, `… is not a function`, TDZ wording) | `@endo/memoize`, `@endo/common`, `@endo/exo`, `@endo/eventual-send`, `@endo/module-source` (2), `@endo/captp` (1), `ses` (several) | **Engine difference in tests only.** Match the error type instead of V8's wording. |
| Typed arrays: JavaScriptCore throws on `Object.seal`/`freeze` with elements, and `isSealed` after `preventExtensions` differs | `@endo/harden`, `ses` (`float-arrays`) | **Engine difference.** Needs a design decision for harden on JavaScriptCore. Also likely to affect Safari. |
| `globalThis.gc` is undefined (Bun exposes `Bun.gc`) | `@endo/promise-kit`, `@endo/captp`, `@endo/ocapn` | **Bun quirk** in the test harness. |
| Node-resolution parity assertions, Node-specific error snapshots | `@endo/compartment-mapper` (31) | **Engine and runtime difference by design.** These tests assert Node's behavior. |
| Stack-trace line-number assertions | `@endo/bundle-source` (2) | **Engine difference.** |
| `worker_threads` `this.postMessage` is undefined | `@endo/parser-pipeline` (8) | **Bun quirk.** |
| `endo` binary not on `PATH` | `@endo/cli` (7) | **Harness.** The launcher bypasses Yarn's command environment. |
| Domains, HTML-comment evasion, V8 `CallSite` properties | `ses` | **Bun quirk / V8-only tests.** |
| `--exclude` expectation in the `not` configuration | `@endo/ses-ava` (1) | **AVA incompatibility.** |
| Two-minute timeouts, cause not established | `@endo/stream-node` (3 configurations), `@endo/ocapn` (3) | **Undetermined.** Probably a difference in Bun's stream or socket handling. These six runs take about 12 minutes of the full matrix. |
| `write EPIPE` at daemon start | `@endo/daemon` (2) | **Undetermined.** Probably Bun's child-process I/O. |

**Recommendation: the Bun CI job**

**Gate it.** Make the Bun job required for an explicit list of green packages, and run the full matrix as a non-blocking step. This PR implements that in `.github/workflows/ci.yml`.

The evidence:

- The green set is reproducible. The same 27 packages passed in two consecutive runs: the full-matrix run and a run limited to those packages, 61/61 configurations.
- A required full-matrix job would fail on every PR for reasons unrelated to the PR (the 20 packages in the triage table), so people would learn to ignore it.
- Advisory-only would let a regression in a package that already passes on Bun land unnoticed. Bun matters to users in its own right, so a protected subset has value now.
- The full matrix costs about 12 extra minutes just in the six timeout runs. It is cheap to keep as an advisory step and expensive to wait on.

Extend the allowlist as fixes land. The pass-style Error-property fix and the test-message cleanup are the largest next gains.

### Security Considerations

This PR permits two host-provided members of a shared intrinsic, with the analysis above. Both are frozen after lockdown, scoped to the receiver, and stateless. `toJSON` returns a new object on every call. On hosts without the members, nothing changes.

### Scaling Considerations

No runtime cost. CI adds a required Bun step over 27 packages and an advisory full-matrix step.

### Documentation Considerations

The permit comment records that the members are Bun-only. Changesets describe the `ses` and `@endo/module-source`/`@endo/parser-pipeline` fixes. No document yet claims Bun support.

### Testing Considerations

`packages/ses/test/url.test.js` gains a test for the frozen, receiver-scoped shape of both members. On Bun the file fails at lockdown without the permit (`failed to delete intrinsics.%URLSearchParamsPrototype%.length`) and passes with it. On Node the members are absent and the test passes vacuously. Node `yarn test` passes for `@endo/module-source` and `@endo/parser-pipeline`. Eslint and prettier are clean on the changed files. The deterministic pre-push probes pass.

### Compatibility Considerations

On Node, XS, and browsers there is no observable change. On Bun, `lockdown()` now succeeds and `JSON.stringify(new URLSearchParams(…))` keeps Bun's behavior.

### Upgrade Considerations

None.

<!-- garden-job: build-endo-bun-ses-permits-20261021 -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
~~~~

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-21T07:23:27Z
