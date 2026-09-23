Gauntlet complete. Inbox empty, panel verdict on record, PR un-drafted and CLEAN.

## Completion report: gauntlet on endojs/endo-but-for-bots #708

**Outcome:** PR #708 ("feat(exo-git): restore content-address QID/hash to `Git.filesystemAt`") driven clean → panel → one fixer round → un-draft. Now **ready-for-review**, `mergeStateStatus: CLEAN`, all 23 checks green on the new head.

**Panel (code, 19 diff-emphasized seats).** Verdict: **PASS** after one fixer round. The change is correct and its headline invariants are proven end-to-end against real git OIDs (daemon `Git.filesystemAt`: QID `pathId` = git object OID; same blob at two paths and across two refs → one QID + one `BlobRef` hash). No blocking correctness defect. Local real-execution evidence: `@endo/platform` 270 tests, `@endo/exo-git` 3, daemon `Git.filesystemAt` 18/18, tsc + eslint + prettier clean. (Two unrelated daemon `reword`/`status` merge tests fail locally on a git `rerere` "Recorded preimage" step — environmental, not in the PR diff, and green in CI.)

**Fixer round (commit `6f8d893`, pushed to the PR head branch, CI re-verified green):**
- `wrap-backend.js`: re-`harden` the backend-supplied `Qid` at the exo/CapTP boundary; probe `qidFor`/`blobInfoFor` via optional chaining instead of an `any`-cast that erased their `| undefined` returns.
- `git-filesystem.js` `qidFor`: guard `BigInt('0x'+oid)` so a malformed OID degrades to the `synthQid` fallback instead of throwing into the sync `getQid` getter (honors the module's own never-throw contract).
- Added the missing test for the "hook present but returns `undefined` for an extant path" fallback half (previously only the absent-hook half was covered).
- `backend-types.js`/`cursor-exo.js`: inline `import()` JSDoc (+ stray `.ts`) → `@import` block refs.
- De-bannered two new decorative comments.
- `designs/endo-fs-from-git.md`: fixed the stale adapter path (`exo-git`, not `daemon`), corrected Phase 5/6 deferral labeling, and documented the exo-layer full-width OID vs the 9p uint64 `qid.path` fold plus the no-evict-on-success stability invariant.

Panel verdict posted as a formal review (`--comment`; the PR author `kriscendobot` equals the review identity, so GitHub blocks `--approve`/`--request-changes` — verdict preserved in the body).

**Follow-ups (non-blocking, recorded in the posted review):** bound `resolvedSync` if ever exposed to untrusted repos; reconcile the `Qid` interface (`path?` vs runtime `pathId`, make it `Passable`-assignable); fast-check property for the equivalence invariant; document the hash-string encoding (hex vs base64) in the `{algorithm,hash}` contract.
