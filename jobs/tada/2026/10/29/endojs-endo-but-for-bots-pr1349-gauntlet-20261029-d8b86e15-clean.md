**Clean stage for endojs/endo-but-for-bots#1349: no changes needed (head `d8b86e15`)**

Nothing needed changing, so I pushed no commits, made no edits and created no checkout.

- **PR state:** open and not a draft. It targets frozen base `master-ebc7904` from the in-repo branch `build/hardened-text-codecs-shim`.
- **CI:** all 14 checks finished green on the current head, including `cover`, `lint`, `test-xs`, `test-hermes`, `test262` and the four node/OS test runs. `ci-wait-merge.sh --no-merge` returned rc 0 (`total=14 failed=0 → CI GREEN`).
- **Coverage:** I read the PR's two new source files, `src/encapsulate-host-constructor.js` and `src/tame-text-codecs.js`. Each code path already has a test in the PR:
  - **Codec missing on the host:** `text-encoder-missing.test.js`, `text-decoder-missing.test.js`, and the `_xs-missing-text-codecs` XS fixture.
  - **Host not affected:** the existing `text-codecs.test.js`.
  - **Codec whose prototype is not an object:** `text-codec-primitive-prototype.test.js`.
  - **Chromium-style `caller`/`arguments` properties that lockdown can't remove:** `text-encoder-decoder-restricted-properties.test.js` and `text-codec-restricted-property-shapes.test.js`.
  - **Prototype frozen, non-extensible, or with a locked `constructor`:** `encapsulate-host-constructor.test.js`.
  - **Calling the constructor without `new`, and its `length`/`name`/`prototype` properties:** also `encapsulate-host-constructor.test.js`.
- **Dead code:** none. Both new modules are used by `lockdown.js` and `src-xs/lockdown-shim.js`, and every helper in them is called.

Follow-ups: none from this stage. The gauntlet can move on to the panel review.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261029-d8b86e15-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (241831 cached reads)
- Output: 2151 tokens
- Cost: $0.47446619999999995
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
