---
posted_at: 2026-11-01T15:05:22Z
role: builder
requires: host=endolin-garden-ece02cb4
arc: ironhorse-test262-ratchet
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Open the draft PR for the ironhorse test262 ratchet sixteenth slice on endojs/endo-but-for-bots. The PAT on oros-studio-garden-ce242c49 cannot call createPullRequest (403), so this job is pinned to endolin. Its only task is to open the PR; do not modify either branch.

- Head branch (already pushed): `ironhorse-test262-ratchet-sixteenth-slice-20261101` @ `f062fc61c` (verify with `git ls-remote`; if it has moved, use the current tip and say so).
- Frozen base: `llm-9a14ddf` @ `9a14ddf660912ed624e2d9047671d43e3a2f0cec`.
- Make a project checkout with `ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots ironhorse-test262-ratchet-sixteenth-slice-20261101`, cd there, and run:

    ensure-pr.sh ironhorse-test262-ratchet-coverage-crank-sixteenth-slice-20261101 endojs/endo-but-for-bots ironhorse-test262-ratchet-sixteenth-slice-20261101 llm-9a14ddf --draft --title "fix(ironhorse-vm): await reads the promise constructor; RegExp results carry index/input/groups (test262 ratchet slice 16: +10)" --body-file <file holding the text between the BODY markers below, verbatim>

  The marker key is the ORIGINAL job base (`ironhorse-test262-ratchet-coverage-crank-sixteenth-slice-20261101`), so a PR that already exists is adopted rather than duplicated.
- Report the PR URL.

=====BEGIN BODY=====
<!-- garden-arc: ironhorse-test262-ratchet -->

Refs: kriscendobot/garden#51

## Description

Sixteenth slice of the Ironhorse test262 coverage crank: **+10 rows fail → pass, no losses**.

#### `Await` reads the promise's `constructor` (`ironhorse-vm/src/interp/suspend.rs`)

`Await` and an async generator's `return` resolve their operand with `PromiseResolve(%Promise%, value)`, and that reads `value.constructor` on a native promise. `schedule_native_await` took the fast path for every native promise without making that read. So a promise whose `constructor` getter throws was adopted as though nothing had gone wrong, and a getter with side effects never ran.

- The fast path is kept, unmetered, only when the read could not run guest code and must yield `%Promise%`: the promise has no own `constructor`, its `[[Prototype]]` is `%Promise.prototype%`, and that prototype's `constructor` is still the original data property. If the realm has never interned `constructor`, no guest code can have changed it, so the fast path is also taken without interning. (Interning it mid-run moved the ids a sparse realm hands out next, and that broke `for await` results.)
- In every other case the `Get` runs under `native_try`. A result other than `%Promise%` takes the general capability path, as XS does. A throw rejects a fresh promise that the awaiter waits on, which mirrors `fxAsyncGeneratorStep`'s `mxCatch`, so the body resumes with a throw completion.
- **Known XS departure:** in a plain async function, XS's `fxStepAsync` rejects the function's own promise when this read throws, so a surrounding `try` never sees the error. ECMA-262 `Await` throws at the `await` itself, and Ironhorse now does that (V8 agrees). Under an async generator, XS and Ironhorse agree. A test pins the departure.

#### RegExp exec results always carry `index`, `input`, `groups` (`natives/regexp.rs`)

The cached ids for these properties, and for `indices` under `d`, were filled only from names that the program spells as identifiers. A test that only probes `verifyProperty(indices, 'groups', …)` by string therefore found no `groups` property at all. `regexp_exec_inner` now seeds the ids with `intern_static_key`, as `@@search` and `@@replace` already do. All four are boot keys, so no metered slot is minted.

#### Ratchet

I swept the whole tree (1930 batches, `--jobs 10`, 60 s case timeout, test262 `be13516f`) and diffed against the committed shards. Four shard files changed:

- **10 rows fail → pass**:
  - `built-ins/AsyncGeneratorPrototype/return/return-{state-completed,suspendedStart}-broken-promise.js`, `return-suspendedYield-broken-promise-try-catch.js` (sloppy and strict)
  - `built-ins/RegExp/match-indices/indices-groups-object-undefined.js` (sloppy and strict)
  - `language/statements/for-await-of/ticks-with-async-iter-resolved-promise-and-constructor-lookup-two.js` (sloppy and strict)
- **2 rows fail → fail with a new reason**: `built-ins/AsyncFromSyncIteratorPrototype/next/iterator-result-poisoned-wrapper.js`. The row now gets further and fails on the iterator-close count. endojs/endo-but-for-bots#1599 also touches this shard, so whichever PR lands second takes a trivial shard rebase.
- **No losses.**
- I left out one unrelated drift, `language/module-code/namespace/internals/own-property-keys-sort.js` (skip → skip, `unsupported-opcode:module:static-linking` → `module:compiler-byte-divergence`). A build of the base commit reproduces it locally, so this change does not cause it.

I did not take these rows:

- `built-ins/Proxy/{has,set}/trap-is-missing-target-is-proxy.js`: they depend on the `RegExp.prototype` flag getters from endojs/endo-but-for-bots#1605.
- `Math.random`: omitted by design.
- `AbstractModuleSource`: an oracle `$262` gap.
- `DisposableStack`/`AsyncDisposableStack`: the endojs/endo-but-for-bots#1602 area.

### Security Considerations

None. These are engine semantics fixes to match the spec. They add no authority or interface. The new constructor `Get` runs under the same `native_try` fence that other natives use when they call guest code.

### Scaling Considerations

An await on an unmodified native promise stays on the unmetered fast path, with two property-chain probes added. Only a promise whose `constructor` lookup is non-default pays a metered `Get` and the general capability path, the same cost that XS charges.

### Documentation Considerations

None.

### Testing Considerations

- New `rust/engine/ironhorse-262/tests/await_promise_resolve_constructor.rs`: dual-run agreement for await and async-generator `return` with broken, counting, overridden and subclass constructors; RegExp result properties probed by string key; the pinned XS departure.
- All existing `ironhorse-262` async, await, Promise and RegExp test binaries pass, as do `expectation_shards` and `ironhorse-vm --lib` (326 tests).

### Compatibility Considerations

None outside guest-observable spec conformance.

### Upgrade Considerations

None.

<!-- garden-job: ironhorse-test262-ratchet-coverage-crank-sixteenth-slice-20261101 -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
=====END BODY=====
