Inbox empty, worktree removed, push landed. Work complete.

---

**Completion report — `improve-fetch-source-pdf-text-extraction`**

Added a deterministic PDF→text path to `scripts/jobs/fetch-source.sh` so paper-PDF ingestion no longer needs an agent to hand-extract text. Landed on `main2` (commit `af452bba1`) via an isolated worktree off `origin/main2` per the garden-infra norm; rebased onto the current tip and pushed.

**What changed**
- `scripts/jobs/fetch-source.sh`:
  - Detects a PDF deterministically — the `%PDF` magic on the fetched bytes (reliable across all three fetch paths: direct/mirror/wayback), or a `Content-Type: application/pdf` response header. To support the header signal, the shared `_curl` now dumps response headers via `-D` to a temp file cleaned up by an `EXIT` trap.
  - On a detected PDF, extracts text via `python3` + `pypdf` (poppler's `pdftotext` is absent in the sandbox; pypdf 6.13.3 is present) into an adjacent artifact: a trailing `.pdf` is replaced with `.txt`, otherwise `.txt` is appended. The raw PDF bytes stay at the output path.
  - New manifest fields: `source_is_pdf=true`, `source_text_path=<abs>`, `source_text_bytes=<n>`.
  - Extraction is **non-fatal**: a missing interpreter or an unparseable PDF logs a warning and skips only the text artifact; bytes, hash, and exit code are unchanged. Header doc (WHAT IT DOES, manifest list, a WHY-PDF-TEXT note) updated.
- `scripts/jobs/test/fetch-source-test.sh`: added a real minimal-PDF fixture (pure-ASCII, known text "Hello PDF body") and a `STUB_DIRECT_FILE` stub capability for binary bodies. New cases 15 (end-to-end extraction: `source_is_pdf`/`source_text_path`/`source_text_bytes`, `.pdf`→`.txt` adjacency, extracted-text content, raw-bytes retention) and 16 (non-PDF emits no PDF fields). **52 passed, 0 failed.**
- `roles/scholar/AGENT.md` § PDF/source-acquisition step: now points at `source_text_path` and explicitly says do not hand-run `pypdf`/`pdftotext`.

**Verification**
- Full test suite green (52/52). Also ran a live smoke against the real fixture exercising the Content-Type-header detection branch independently of magic and the no-extension `.txt` naming — manifest and `.txt` produced correctly, raw bytes preserved. The non-fatal path is confirmed by existing case 13 (fake `%PDF` magic that pypdf can't parse).
- Shellcheck shows only pre-existing warnings (GARDEN_TAG SC2034, the test's SC2046/SC2015 idioms); my additions introduce none.

**Follow-ups / notes**
- I did not touch `journal/library/conventions.md` § PDF/source acquisition: it lives on the `journal2` branch, not `main2`, and the job scoped the doc update to the script header + scholar role. If desired, a `scholar-*` cycle could later add a one-line note there that `source_text_path` is now produced by the script.
- The unit-test stub ignores curl's `-D`, so it exercises the `%PDF`-magic detection path; the Content-Type branch is covered by the live smoke above rather than the hermetic suite.

Self-improvement: the worktree already carried the sibling `improve-fetch-source-stub-detection` work (sections renumbered, cases to 14) that the deployed root lacked — confirming the garden-infra norm of building off `origin/main2` rather than the deployed checkout; reading the worktree copy before editing avoided clobbering that in-flight feature.
