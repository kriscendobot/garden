Inbox empty. This was a read-only confirmation directive — no garden or project source changes required.

## Completion report

**Job:** attention directive on kriscendobot/agoric-sdk PR #7 — maintainer (kriskowal) asked: *"Please confirm the analogous changes were merged upstream."*

**Preflight:** Ran `pr-feedback-preflight.sh kriscendobot/agoric-sdk 7 4932487371 kriskowal` → exit 0 (PROCEED; no peer resolution). Comment body treated as untrusted data.

**What I verified (read-only, via GitHub API against `agoric/agoric-sdk`):**

- **PR #7's two original fixes ARE merged to upstream `master`:**
  - `8b9a80dbd chore(internal): optimize hex decoding init` — the XS-safe bounded-loop build of the 484-entry `decodings` Map.
  - `6e8b14654 fix(internal): only accept well formed hex in Node mode` — the Bufferish `byteLength * 2 !== hex.length` validation (also updates `test/hex.test.js`).
  - Both are ancestors of `master` (`compare master...<sha>` → `behind`), and the live `packages/internal/src/hex.js` source on `master` carries both the bounded `for` loop and the Node-mode length check.
  - The upstream ferry PR that carried them, **Agoric/agoric-sdk#12766** (`ferry/internal-hex-xs-safe`), is still **open** with its benchmark commits unmerged, but the two substantive fixes landed on `master` independently.
- **The later re-scope (consume `@endo/hex`, drop the in-tree codec) is NOT upstream:** code search for `endo/hex` across `agoric/agoric-sdk` = 0 hits; `packages/internal/package.json` has no `@endo/hex` dep; `master` still ships the full in-tree codec. That slim-down remains a fork-only experiment on PR #7.

**Output:** Posted the confirmation as an in-thread reply on the fork PR #7 (own fork, permitted) — https://github.com/kriscendobot/agoric-sdk/pull/7#issuecomment-4932512507.

**Scope discipline:** No interaction with upstream `agoric/agoric-sdk` (no comments/reviews/PR ops/links) — verification was purely read-only API reads. No garden `main2` changes and no project-repo mutations were needed, so nothing was committed or pushed.

**Follow-ups:** None required. Optional context for the maintainer: upstream ferry PR #12766 is still open (benchmark commits unmerged) even though its two fixes already landed on `master`; if a tidy upstream close is wanted, that's a separate authorized decision.
