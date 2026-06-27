Done. The change is committed and pushed to `origin/main2` (commit `797907141`), verified, and the deployed root tree is clean.

---

**Completion report — `improve-fetch-source-stub-detection`**

**What I did:** Moved the recurring "read the fetched body before counting a page as a source" check into `scripts/jobs/fetch-source.sh` as a deterministic, non-fatal advisory, and added test coverage. Committed and pushed to `origin/main2` (`797907141`).

**What changed:**

`scripts/jobs/fetch-source.sh`
- After the existing hash/byte-count step, added a step-5 stub-suspect detector that runs **only when the fetched bytes are HTML** (sniffed by `*.htm(l)/*.xhtml` extension or a `<!doctype html>/<html>/<head>/<body>` signature in the first 1 KB — so PDFs, which start with `%PDF`, and other binaries are excluded).
- Flags a suspect when any of: body under `FETCH_SOURCE_STUB_BYTE_THRESHOLD` (default **512** bytes); placeholder markers present (`to be written` / `to be done` / `***`, case-insensitive); or a near-empty `<body>…</body>`.
- Emits two new manifest fields on stdout alongside the existing `source_*` lines: `source_stub_suspect=true|false` (always) and `source_stub_reason=<text>` (only when true).
- **Exit code unchanged** — purely advisory, so 200-with-stub pages are flagged but PDFs and legitimately short pages are never blocked. Added a new `FETCH_SOURCE_STUB_BYTE_THRESHOLD` config var and updated the header docs (manifest, config, and a "WHY THE STUB ADVISORY" rationale citing the `object-lambda.html` trap).

`scripts/jobs/test/fetch-source-test.sh`
- Added 5 hermetic cases (10–14): HTML placeholder marker → suspect; tiny HTML body → suspect; substantial real article → not suspect (and no reason line); short non-HTML PDF → not suspect/never blocked; padded `<head>` + empty `<body>` → suspect. **Full suite: 42 passed, 0 failed.**

**Verification:** Ran the suite from the `/home/kris` tree (42/42) on the exact bytes that were committed. Committed via an isolated worktree off `origin/main2` (per the shared-tree-concurrency norm) with explicit pathspecs, pushed `HEAD:main2`, then restored the deployed root's working tree so the change arrives cleanly on the next deliberate deploy rather than lingering as a dirty-tree wedge.

**Follow-ups:**
- Consumer side: the scholar / job consumer should now read `source_stub_suspect` before ingesting (e.g. `[ "${source_stub_suspect:-false}" = true ]`). If the scholar's ingest skill and `library/conventions.md` § PDF/source acquisition document the manifest fields, a small doc update there would close the loop end-to-end. Not blocking — the advisory is live regardless.
- Test harness note (pre-existing, not introduced here): `fetch-source-test.sh` invokes the script directly and uses a fixed shared `TR=/home/kris/.garden-fetch-source-test`; it must run from a non-`noexec` location (the `/home/kris` tree), since the sandbox blocks direct execution from `/tmp` tmpfs. Worth a future cleanup to a per-run temp dir and `bash "$FETCH"` invocation if the suite is ever run from elsewhere.
