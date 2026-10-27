**Clean stage report: endojs/endo-but-for-bots PR #1349 (head `91cca8a551`)**

I pushed nothing: the PR was already in the right shape, so this stage was a no-op.

- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All 16 checks passed at the current head. The PR is open, not a draft, and based on `master-6ee3fda`.
- **Coverage:** I read the new source against its tests in my own isolated checkout. Every branch in the two new files has a matching test:
  - `tame-text-codecs.js`:
    - codec missing on the host: `text-encoder-missing.test.js`, `text-decoder-missing.test.js`
    - host constructor has no own `arguments` property (left alone): the existing codec tests
    - prototype is a primitive: `text-codec-primitive-prototype.test.js`
    - the replacement path: `text-encoder-decoder-restricted-properties.test.js`
  - `encapsulate-host-constructor.js`: the constructor rejects calls without `new`; it rejects a frozen prototype, a locked prototype with no own `constructor`, and a `constructor` that can't be redefined; it keeps the `length`, `name` and `prototype` attributes; and it constructs normally. All of these are in `encapsulate-host-constructor.test.js`.
  - The new `onShimStartCompartment` callback in `repairIntrinsics` is exercised through the XS lockdown shim and the updated `_xs.js` harness.
- **Dead code:** none. `lockdown-shim.js` no longer imports the import-time `ShimStartCompartment`, but `src-xs/compartment.js` still needs to export it because `compartment-shim.js` uses it.

Follow-ups: none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-91cca8a5-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (243540 cached reads)
- Output: 2051 tokens
- Cost: $0.483032
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
