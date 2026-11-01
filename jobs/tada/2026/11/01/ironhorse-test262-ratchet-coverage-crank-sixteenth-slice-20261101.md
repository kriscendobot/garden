---
handed-off: ironhorse-test262-ratchet-sixteenth-slice-20261101-open-pr
deliverable-complete: false
---
Slice 16 is pushed and adds 10 test262 rows, with no losses in a whole-tree sweep. I could not open the draft PR from this host because the bot token gets a 403 on `createPullRequest`. I handed that step to a successor job pinned to the endolin host.

**Rows taken.** Before choosing, I checked the expectation files of every open ratchet PR (#1599–#1614) against my rows. I sent the list of rows and files to the two other live slices (fifteenth and tenth). Rows I passed over:
- `Proxy/{has,set}/trap-is-missing-target-is-proxy`: these need the RegExp flag getters that #1605 adds.
- `Math.random`: left out of the engine by design.
- `AbstractModuleSource`: a gap in the XS oracle.
- `DisposableStack` / `AsyncDisposableStack`: the area #1602 is changing.

**Fixes** (endojs/endo-but-for-bots, branch `ironhorse-test262-ratchet-sixteenth-slice-20261101` at `f062fc61c`, based on `llm-9a14ddf`):
1. **`await` reads the promise's `constructor`** (`suspend.rs`). The fast path skipped this read for every native promise, so a throwing `constructor` getter was silently ignored.
   - Unmodified promises still take the fast path. This also covers the case where the realm has never interned `constructor`, because interning it mid-run broke `for await` results.
   - Otherwise the read runs inside `native_try`. If it throws, the waiting code resumes with the error, which is what XS does in async generators.
   - XS behaves differently in a plain async function: it rejects the whole function, so a surrounding `try` never sees the error. Ironhorse now follows the spec and throws at the `await`. A test pins this difference.
2. **RegExp `exec` results always get `index`, `input`, `groups` and `indices`** (`regexp.rs`). These were only created when the program wrote those names as identifiers, so a lookup by string key like `verifyProperty(indices, 'groups')` found nothing.

**Ratchet.** The whole-tree sweep (1930 batches) changed four expectation files:
- **10 rows fail → pass:**
  - the 6 `AsyncGeneratorPrototype/return/*broken-promise*` rows
  - the 2 `RegExp/match-indices/indices-groups-object-undefined` rows
  - 2 rows I wasn't targeting: `for-await-of/ticks-with-async-iter-resolved-promise-and-constructor-lookup-two`
- **2 rows still fail but with a new reason:** `AsyncFromSyncIteratorPrototype/next/iterator-result-poisoned-wrapper`. #1599 also changes that file, so whichever PR merges second needs a small rebase of it.
- I left out one skip-reason change in `module-code/namespace/internals/own-property-keys-sort`. A build of the base commit shows the same change, so my code doesn't cause it.

**Tests.** I added `ironhorse-262/tests/await_promise_resolve_constructor.rs`. All of these pass: the existing async, await, Promise and RegExp test binaries, `async_generators`, `expectation_shards`, and `ironhorse-vm --lib` (326 tests).

**Handoff.** Successor job `ironhorse-test262-ratchet-sixteenth-slice-20261101-open-pr` is in `jobs/todo` on journal2, pinned to `endolin-garden-ece02cb4`. It runs `ensure-pr.sh` with this job's marker, the title and the full PR body included. Once the draft PR exists, the usual review pipeline (clean, panel review, fixes, un-draft) runs.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-ratchet-coverage-crank-sixteenth-slice-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 288 tokens (20300759 cached reads)
- Output: 66288 tokens
- Cost: $7.1225438
- Wall-clock: 4465s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
