The 2026-06-27 scholar cycles hit the same trap twice: the erights GitHub Pages mirror serves stub pages (e.g. `elang/intro/object-lambda.html`, a literal "***to be written, but see…") at HTTP 200, so reachability ≠ ingestable content. Today the scholar must manually read the fetched body to notice this; the lesson keeps recurring ("a scholar must read the fetched body before counting a page as a source"). Move that check into `scripts/jobs/fetch-source.sh`: after the bytes are fetched and hashed (it already computes `source_bytes` and the sha), when the content is HTML, deterministically flag stub-suspects — body under a small byte threshold, or matching stub markers ("to be written", "to be done", "***", a near-empty `<body>`) — and emit a new `source_stub_suspect=true` (with a short reason) on stdout alongside the existing `source_*` fields. This is a non-fatal advisory the scholar/job consumer reads before deciding to ingest, so a 200-with-stub page no longer counts as a usable source and need not be rediscovered each cycle. Keep it advisory (exit code unchanged) so PDFs and legitimately short pages aren't blocked.

---
claim:
  host: endolinbot
  gardener: 15
  claimed_at: 2026-06-27T21:51:26Z
