## Completion report: build-agoric-internal-hex-20260628

**Done.** Built and opened a DRAFT PR patching the `@agoric/internal` hex codec on the bot fork, and posted the link on garden issue #9.

**PR:** https://github.com/kriscendobot/agoric-sdk/pull/7 — DRAFT, fully fork-internal (`base` and `head` both `kriscendobot/agoric-sdk@master`, `isCrossRepository: false`). Nothing pushed to or opened against upstream `Agoric/agoric-sdk`.

**The defect (confirmed against the file):** the validation divergence the job described. `makePortableHexCodec().decodeHex` throws `Invalid hex string: ${hex}` on odd-length and non-hex input, but `makeBufferishHexCodec().decodeHex` delegated straight to `Buffer.from(hex, 'hex')`, which silently drops invalid input (ignores an odd-length trailing nibble, stops at the first non-hex char). So the same module's `decodeHex` accepted/rejected the same string differently depending on whether `Buffer` was present (verified empirically: `Buffer.from('zz','hex')`→0 bytes, `'abc'`→1 byte, `'abxc'`→1 byte, all no-throw).

**The fix** (`packages/internal/src/hex.js`): in the Bufferish codec, reject odd-length input up front, then after the parse confirm the whole string was consumed (`buf.byteLength === hex.length / 2`) — a shorter result means a non-hex char was silently dropped — throwing the identical error. O(1) checks, fast path unchanged for valid input.

**Tests** (`packages/internal/test/hex.test.js`, new): pins both codecs to identical accept/reject behavior on valid lowercase/uppercase/mixed-case, odd-length, and non-hex input, plus round-trip and an explicit cross-codec agreement test.

**Verification:** 43 new tests pass (ava); ESLint clean on both files; the changed code type-checks clean. Two pre-existing `tsc` errors remain in the unrelated `src/chain-utils.js` (`@agoric/cosmic-proto` generated submodule types) — they come from the sandbox running install with `enableScripts: false` (codegen skipped), not from this change, and resolve in CI. Noted as such in the PR body.

**Follow-up:** commented the PR link + one-line summary on https://github.com/kriskowal/garden/issues/9#issuecomment-4824993118, stating it is DRAFT on the bot fork awaiting review. Did not close the issue (submitter does that).

**Cleanup:** scratch worktree torn down, temp files removed. Inbox was empty throughout.

**Self-improvement / reusable note:** running agoric-sdk package tests in this sandbox works without a full mutable install — `node .yarn/releases/yarn-4.12.0.cjs install --immutable` (cache is local, ~6s), then run tests via `node node_modules/ava/entrypoints/cli.mjs <file>` and type-check scoped with `node node_modules/.bin/tsc -p packages/<pkg>/tsconfig.json --noEmit`. Expect a non-fatal install error (`better-sqlite3` native build) and two `chain-utils.js` cosmic-proto `tsc` errors as standing sandbox artifacts to filter out, not regressions. Worth a line in a future agoric-sdk local-verify reference if the garden does more `@agoric/*` package work.
