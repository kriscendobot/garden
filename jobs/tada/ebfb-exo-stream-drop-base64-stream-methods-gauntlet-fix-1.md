Gauntlet FIX round 1 for endojs/endo-but-for-bots PR #1100 (`feat(exo-stream)!: use one stream method for byte streams`) is complete. I applied all five panel must-fix items, pushed as review-feedback follow-up commits, and drove CI to **GREEN** (27/27 checks, rc 0).

**What changed** (commits `4d262c6d2f` fix + `f8c9c2fa01` yarn.lock + `0b58c41563` prettier, on head branch `kriscendobot-exo-stream-drop-base64`):

1. **Byte-writer validation** (`exo-stream/bytes-writer-from-iterator.js`): `makeWriterPump` now gets a `M.byteArray(...)` `writePattern`, so a non-byte-array syn value (e.g. a stale base64 string) is rejected instead of coercing through `thawedBytes` to `Uint8Array(0)` (a silent truncated write). Corrected the panel's prescription, which as written (`M.byteArray()`) imposed the default 100 KB cap and **regressed large writes** (caught locally: `readFile`/256 KiB file writes failed). Added a `byteLengthLimit` option symmetric with `iterateBytesReader`, defaulting to unbounded so the check is type-only.

2. **Blob-vs-tree shape discrimination** (`daemon/mount.js`, `daemon/host.js`, `platform/from-mount-backend.js`, `space-file-explorer/file-explorer-fs.js`): the tests keyed on the now-generic `stream` name now require a read-side blob marker (`getInfo` or `readReturnPattern`) with `readPattern` absent — rejecting a generic `PassableReader`/`PassableWriter`/`HttpResponse` with the crisp shape error and dropping the false `asserts` claim. Added a regression test for the false-positive case.

3. **Type declarations** (`daemon/types.d.ts` + regenerated `agent-tools/fs-declarations.js`): `StreamNode<string,…>` → `Uint8Array` on `EndoReadable`/`ReadableBlobView`/`EndoMountFile`.

4. **Coverage** (`platform/test/blob.test.js` + `@fast-check/ava` dev-dep on platform & exo-stream): fast-check round-trip property over the multi-chunk `blobFromBytes` chunker.

5. **Docs/changesets**: corrected base64-era prose in two changesets, `zip.js` JSDoc, and `storeBlob` help text; named the removed `streamBase64()` identifier and the `stringLengthLimit`→`byteLengthLimit` rename; added the omitted `@endo/exo-http-client` and `@endo/endo-fs-exec` packages to the changeset.

Verified locally (private-cache install + native better-sqlite3 build): exo-stream 135, platform 335, space-file-explorer 80, daemon mount 77, agent-tools codegen-freshness, exo-http-client 36, exo-zip/exo-unzip all green; prettier + eslint clean. (Daemon integration suite couldn't run here only due to the Unix-socket-path-length limit of this deep worktree — an environment constraint, not the code; CI's daemon jobs passed.)

Per the stage contract, I stopped after CI reached terminal and did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-drop-base64-stream-methods-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 348 tokens (25355359 cached reads)
- Output: 112074 tokens
- Cost: $22.837308500000002
- Wall-clock: 3423s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
