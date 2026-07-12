Inbox is empty. The builder stage is complete. Let me write the completion report.

## Completion report

**Job:** Build the Phase 5 follow-up of `endo-fs-from-git` in `endojs/endo-but-for-bots` (base `llm`) — a backend-supplied QID/hash hook on `@endo/platform`'s `wrapBackend`, wired so `Git.filesystemAt(ref)` regains git content-address identity.

**Draft PR:** [endojs/endo-but-for-bots#708](https://github.com/endojs/endo-but-for-bots/pull/708) — draft, base `llm-f7932ed` (frozen snapshot of `llm` per the fork's frozen-base convention), head `build/endo-fs-git-content-address-qid-hash`.

**Affected packages:** `@endo/platform`, `@endo/exo-git` (both `minor` in the changeset); tests in `packages/daemon`; design doc `designs/endo-fs-from-git.md`.

### What I did
- **`@endo/platform` `wrapBackend`** — added two optional `FsBackend` hooks probed by existence like the other optionals: `qidFor(path, kind)` (synchronous, sources the QID `pathId`) and `blobInfoFor(path)` (sources a `BlobRef`'s `{ algorithm, hash }` in `File.snapshot()`). Both fall back to the existing path-hash `synthQid` / SHA-256-over-bytes defaults when a backend omits the hook or returns `undefined`, so in-memory/node-fs/from-mount backings are unaffected. `makeBlobRefExo` gained an optional `infoOverride`; `getQid` kept its synchronous contract (a hard constraint — `readOnly` forwards it sync and 9p-server pipelines it).
- **`@endo/exo-git` `makeGitFsBackend`** — implemented both hooks from a synchronous mirror (`resolvedSync`) of the existing path-resolution cache, seeded with the root tree OID and populated as `resolvePath`/`list` resolve. QID `pathId` is the git object OID as a BigInt; `BlobRef` reports `algorithm: 'git-sha1'` with the git blob OID as its hash.
- **`Cursor` listing** — routed the entry-qid synthesis through the same `qidOf` (and populated the sync mirror per child during `list`) so a listing entry's `qid` matches a later `lookup(name).getQid()`. This avoids introducing a `Treaddir`→`Twalk` identity mismatch that the naive change would have created.
- Updated `designs/endo-fs-from-git.md` (Status, superseded blockquotes, Phase 5) to record the restored contract, and added a changeset.

### Evidence (real-execution)
- `@endo/platform` full suite: **269 passed** (incl. 3 new hook tests + no-hook fallback). `@endo/9p-server`: **51 passed**. `Git.filesystemAt` daemon tests: **18 passed** (incl. root/file OID QID, same-blob QID+`git-sha1` hash equivalence across paths and across refs, listing-entry-qid==getQid).
- **Regression evidence:** disabling the `qidFor` hook made all 3 new QID tests fail; restored and re-ran green.
- `tsc` and `eslint`: **0 errors** on every touched file across `platform`, `exo-git`, `daemon`.
- The **5 failing** tests in the full `daemon/test/git.test.js` run (askpass fake-git `report.json`, git `rerere` preimage, repo-identity) reproduce **identically on the untouched base** — pre-existing environmental failures, not from this change (confirmed by stashing my changes and re-running).

### Follow-ups
- Next gauntlet stages (panel → fixer loop → cleaner → un-draft) are the gardener's to run against #708; the builder does not run them.
- Still deferred per the design: `sha256`-object-format repo detection (`git-sha256`) and Phase 6 paged directory listing.
- Environmental note: `better-sqlite3`'s native build is blocked in this sandbox (noexec on the scratch FS); I installed with `--mode=skip-build`, which does not affect the JS-only packages under test here.
