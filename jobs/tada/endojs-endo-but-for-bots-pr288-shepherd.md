Inbox empty, all three commits are on `origin/feat/cbors-package`, and CI is fully green. The shepherd's definition of done is met.

---

## Shepherd report — endojs/endo-but-for-bots PR #288

**Result: CI driven to green.** 25/25 checks pass on head `3068415` ([green run](https://github.com/endojs/endo-but-for-bots/actions/runs/28754101165)). `next: none`.

The PR's first CI run had three distinct failures, each unmasked as the earlier one cleared (the `lint` job short-circuits `prettier && eslint && …`, and the `test`/`lint` jobs failed at the same root cause). Fixed in three atomic commits, each verified locally before pushing:

1. **`a5cfc13` — `fix(cbor-frame): group numeric separators`**: `unicorn/numeric-separators-style` errors in `packages/cbor-frame/src/head.js` and `test/cbor-frame.test.js`. Regrouped hex to 4-digit runs and decimals to 3-digit runs (`0xffffffff`→`0xffff_ffff`, `0x100000000`→`0x1_0000_0000`, `65540`→`65_540`). No value changes.
2. **`18d7d08` — `fix(ocapn): port netlayer-tcp-cbor test to the makeOcapn API`**: `packages/ocapn/test/netlayer-tcp-cbor.test.js` imported the removed `makeClient` export, which both tripped `import/named` (lint error) and crashed every ocapn test worker at import (`SyntaxError: does not provide an export named 'makeClient'` → whole `test` job red). Ported to the current single-network `makeOcapn({ codec, network, … })` API, mirroring the working `netlayer-tcp-syrup` sibling: `cborCodec`, a capture-wrapper netlayer with `framing: 'cbor'` plus a default-framing variant for the "cbor is the default" test, and `locator` in place of `swissnumTable`. Also fixed the file's two numeric separators.
3. **`3068415` — `fix(cbor-frame): sync SECURITY.md to the canonical repo copy`**: the new package's `SECURITY.md` diverged from the repo-canonical copy by a single `Github`→`GitHub`; `check-security-md.sh` (SECURITY.md-uniformity gate) requires byte-identical. Synced to canonical.

**Verification** (local, before each push): `eslint`, `prettier`, `tsc` (ocapn + cbor-frame), `check-security-md.sh`, `check-package-uniformity.mjs`, `build:types:check` all green; `cbor-frame` suite (32 tests) and the ported `netlayer-tcp-cbor` suite (3 tests) pass, the latter exercising the CBOR codec + tag-24 framing end-to-end through the test-only TCP netlayer.

**One flake handled:** after the fixes, `test (24.x, ubuntu-latest)` failed once on an unrelated `packages/chat` confined-render test (`token-autocomplete-confined … all names render as confined rows`, expected 3 / got 0) — not in this PR's diff, and green on the other three test shards plus both `cover` jobs on the same platform. Documented as a flake and re-ran the shard (`gh run rerun --failed`); it passed. No test was skipped or deleted.

**Posted** the required green-run summary comment: https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4887635455 (standing authorization on `endojs/endo-but-for-bots`).

**Follow-ups:** PR mergeState is `BLOCKED` only pending review (not CI) — ready for a maintainer review / merge job. The `chat` confined-render component tests are intermittently flaky (async render race) and may re-surface on future PRs; worth a separate stabilization pass, out of scope here.
