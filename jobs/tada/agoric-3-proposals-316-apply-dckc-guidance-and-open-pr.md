Completion report:

## Job complete: agoric-3-proposals #316 — dckc's guidance applied, PR opened, dckc answered

All three of dckc's directives (garden issue #20) are done, entirely on the **kriscendobot fork** — no upstream `Agoric/agoric-3-proposals` contact.

**What I did**

1. **Fetched and included the `b1-<hash>.json` bundles** using `scripts/fetch-all-bundles.ts` (exactly as dckc directed). The script pulled 90 `MsgInstallBundle` txs → 84 unique bundles into `~/.agoric/cache`; I copied the referenced ones into each `submission/`:
   - `111:ymax-beta` — 3 bundles; `114:qstn-survey` — 3; `115:qstn-survey-2` — 2 (subset of 114's).
   - Verified each file's `endoZipBase64Sha512` matches its `b1-` filename, and that each proposal's eval-script bundle references exactly equal the committed `b1-*.json` set (no missing, no extras). The EVAL stage for 111/114/115 is now replayable.
2. **Documented the proposal 113 omission** in-code: added an "Omitted proposals" section to the top-level `README.md` (and the commit message) explaining that `113` is a `/ibc.core.client.v1.MsgRecoverClient` — an unsupported proposal type with no `dockerfileGen` stage that doesn't touch replayed state — alongside 117 (rejected) and 118 (text). Updated the three per-proposal READMEs to say bundles are now included.
3. **Opened the PR** on the fork: **kriscendobot/agoric-3-proposals#1** (base `kriscendobot/agoric-3-proposals:main`, head `add-proposals-111-116`, `isCrossRepository: false` — confirmed it does **not** target upstream).
4. **Replied to dckc** on garden issue #20 (comment `#issuecomment-4857266926`): acknowledged plainly that his guidance was wrongly ignored because he wasn't yet on the allowlist, summarized the changes, linked the PR, and cited exactly what I ran vs. didn't.

**Changed/pushed:** commit `0e7be80` on `add-proposals-111-116` (8 bundle files + 4 README edits). Reverted a yarn-install-induced `packages/synthetic-chain/package.json` change so it wasn't committed.

**Verification I ran:** the fetch script end-to-end; per-file hash check; referenced-vs-present bundle cross-check; `prettier --check` on changed markdown (clean).

**Follow-up / not done:** full Docker `synthetic-chain build`/`test` was **not** run — native `better-sqlite3` build is blocked in this environment — so on-chain EVAL-stage replay isn't locally proven. Stated openly in both the PR body and the dckc reply; PR review/CI welcome. PR #1 has no CI wired on the fork yet.
