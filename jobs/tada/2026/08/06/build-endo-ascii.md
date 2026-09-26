Inbox empty. PR **#943** is a clean draft (base `llm-bfc91f5`, head `build/endo-ascii-7bit`, mergeable). The build stage is complete and ready for the gauntlet.

## Completion report

**Gating confirmed.** PR #836 (`@endo/sha256`) was **merged** (not merely closed) at `2026-08-06T14:39:04Z` into `llm-bfc91f5`; merge tip `0a85baf85`. Proceeded.

**What I built — `@endo/ascii` (`packages/ascii`), draft PR [endojs/endo-but-for-bots#943](https://github.com/endojs/endo-but-for-bots/pull/943)** (base `llm-bfc91f5`, head `kriscendobot:build/endo-ascii-7bit`):

- `src/encode.js` exports `encodeAscii(text, name?)`: maps ASCII text to a `Uint8Array` one code unit per byte, **asserts every code unit is in `0x00`–`0x7f`** (single `code > 0x7f` check, which also rejects surrogate halves), throwing `RangeError` with offset+code on the first out-of-range unit and `TypeError` on non-string input. Pure JS + `harden` — no `TextEncoder`/`node:`/host globals, so it runs under XS. Encode-only, dependency-light (runtime dep: `@endo/harden` only).
- Package shape mirrors `@endo/hex`/`@endo/sha256`: `package.json`, `LICENSE`, `SECURITY.md`, `README.md`, `index.js`/`encode.js` re-exports, the tsconfig trio + generated composite ref (root `tsconfig.composite.json` updated), 8 ava tests (encode, full 7-bit range incl. NUL/DEL, `0x80` boundary, Latin-1 with offset, non-BMP surrogate half, non-string, named diagnostic, subpath identity), and a changeset.
- **Switched `packages/sha256/test/_xs.js`** off the local `ascii` helper to `import { encodeAscii } from '@endo/ascii'`; added `@endo/ascii` as a sha256 **devDependency** (test-only). The XS bundler couldn't reach a devDependency, so `scripts/generate-test-xs.js` now passes `dev: true` to `makeBundle` (the test is a dev artifact; that flow applies to the entry package's devDependencies) — the correct fix rather than mis-declaring ascii as a runtime dep.

**Other `charCodeAt(0)` sites — none in scope.** The only genuine ASCII-text→bytes helper was sha256's. The rest are single delimiter/digit encoders or transforms, not general text→bytes helpers: `packages/netstring/writer.js`, `packages/syrup-frame/writer.js` (length-digit bytes), `packages/marshal/src/encodePassable.js` (offset transform), `packages/ocapn` fuzz seeds and `compartment-mapper/test/integrity.test.js` (`' '.charCodeAt(0)` fill). Left untouched.

**Verified locally (all green):** ascii `ava` (8), `tsc`, `eslint`, `prettier`, `tsc --build`; sha256 `ava` (16), `tsc`, `eslint`, and **`yarn test:xs` under `xst` consuming `@endo/ascii`**; `generate-composite-tsconfigs.mjs --check` reports no drift. `yarn.lock` churn is in its own `chore: Update yarn.lock` commit.

**Notes / deviations:**
- I initially opened the PR with a raw `gh pr create`; reconciled per builder norm by running `gardening/ensure-pr.sh`, which adopted #943 and recorded it on `work/build-endo-ascii` (needed `GARDEN_ENSURE_PR_LIST_LIMIT=600` — the repo has >200 open bot PRs, over the default marker-scan page cap).
- Created `llm-bfc91f5` on the fork (pointing at the upstream merge tip) so `ensure-project-worktree.sh` could fetch the base; harmless mirror, unused by the PR (base is upstream's `llm-bfc91f5`).

**Follow-up (out of specced scope):** no decode side was added; a symmetric `decodeAscii` (bytes→ASCII text with the same 7-bit assertion) is a natural follow-up if wanted — noted on the PR.

PR is draft and ready for the gauntlet (panel → fix-loop → un-draft).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-ascii.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4976181 cached reads)
- Output: 38584 tokens
- Cost: $4.5909024999999986
- Wall-clock: 657s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
