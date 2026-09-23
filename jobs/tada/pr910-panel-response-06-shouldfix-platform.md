All work complete and verified. Writing the completion report.

---

## Completion report — PR #910 child 06/10: should-fix findings in the `platform` slice

**Repo/PR:** endojs/endo-but-for-bots #910 (kept DRAFT; not merged, not un-drafted, panel not re-run).
**Follow-up commit:** `cf29cfd77` pushed to `feat-readableblob-range-attenuation` (regular push, no force — siblings not stranded).
**Checklist:** all 17 dispositions landed on `origin/journal2` (`artifacts/pr910-panel-findings.md`, via the isolated-clone CAS `land-journal-edit.sh`).

I worked against the current branch state (children 02–05 already landed the must-fix/daemon/git-docs commits, which had renamed identifiers and made `end` optional), not the checklist's stale file:line citations.

### Fixed (15)
- **PLAT-14** — `compose` now clamps `composedStart` to the receiver's end too, so a nested range past-the-end yields an *empty* interval, not an inverted one that surfaced as a late `EINVAL`/overflow.
- **PLAT-15 + PLAT-26** (one rewrite) — `lineByteSpan` scans once for only the two bounding LF offsets (early-exit) and returns `[from, to]` directly; the reversing `[min,max]` swap is gone (prover's unreachability, no untestable defense left) and it no longer materializes every LF offset.
- **PLAT-16** — derived `streamBase64` reads the selection in bounded sub-windows (`streamWindowBase64`) instead of buffering the whole window; `range(0n, huge).streamBase64()` now streams within a one-chunk memory bound. Non-final windows are multiples of 3 so concatenated base64 stays byte-exact. This is the chunked read PLAT-03's must-fix disposition deferred to me.
- **PLAT-17** — `json()` wraps parse failures in a located `@endo/errors` message naming the label and `[start,end)` interval.
- **PLAT-18** — `RangeSource` typedef moved to `types.ts`, `@import`ed back.
- **PLAT-20** — `makeBlobRangeMethods` snapshots + `harden`s the source record once; `readWindow`/`hashBytes` can't be swapped under an issued blob.
- **PLAT-21** — documented the deliberate SnapshotBlob `range`/`textRange` exclusion (identity surface vs. attenuation surface).
- **PLAT-22** — `BASE64_CHUNK_RAW_BYTES` + `encodeBase64Chunks` exported once from `blob-range.js`; `blob-ref.js` verbatim copies deleted.
- **PLAT-23** — `selected` → `readSelectedBytes`. **PLAT-24** — `drainBytesReader` → `drainBlobBytes(blobRef,…)` (+ cross-ref comment).
- **PLAT-27** — added prover's `textRange` equivalence corpus test. **PLAT-28/29** — deleted the duplicate + subsumed tests; dropped the vacuous `instanceof Uint8Array` that pinned the test helper.
- **PLAT-30** — refreshed stale `fetch`-naming comments (interfaces/helpers/cas); confirmed `makeBytesReaderFromBytes` is *not* dead (used by `cached-fs.js`), so corrected the attribution rather than deleting.

### Refuted / declined with reasoning (2)
- **PLAT-19** — declined. Removing the `>MAX_SAFE_INTEGER` bound from `assertOffset` would move a predictable *eager* `EINVAL` to a *deferred* per-read failure; that eager rejection is a tested contract in **both** platform and daemon (`mount.test.js:246`), and the bound is fail-fast defense-in-depth (every producer re-narrows via `toSafeNumber`), not a portability wall. Relaxing it belongs with the first >int53 producer, which doesn't exist yet.
- **PLAT-25** — declined memoization in the shared maker (consistent with PLAT-05): source-agnostic, and a live source's digest can change between calls. Documented the per-call O(n) cost; per-immutable-producer memoization is a scoped follow-up.

### Verification (all local, per pre-push-gates)
- platform: `tsc` clean, `eslint` 0 errors, **331 tests pass** (incl. the new corpus test and the >1-chunk `streamBase64` round-trip).
- daemon: `tsc` clean, **97 mount/conformance tests pass** — exercises the windowed `streamBase64` and compose-clamp over the *live* `EndoMountFile` producer.
- git backend, exo-git, agent-tools: `tsc` clean; git backend tests pass.

### Follow-ups (deferred, noted for siblings/future)
- Per-immutable-producer `getInfo`/second-read memoization (PLAT-05/25).
- PLAT-06's deeper options (re-resolve lines per read, or reject `textRange` on live faces) remain architectural.
- PLAT-30's daemon mirror `bus-manager-rust-xs-powers.js:157` is xref-daemon (sibling slice).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-panel-response-06-shouldfix-platform.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (11173733 cached reads)
- Output: 95391 tokens
- Cost: $10.007234500000001
- Wall-clock: 1406s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
