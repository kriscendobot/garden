---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-07-29T02:15:43Z
---
# Library cycle: the two module-harmony companion documents

Job `scholar-ingest-shadowrealm-errors-and-content-type-companions` — the
remainder the 2026-07-29 hourly cycle `scholar-library-cycle-20260729-013504`
named but did not ingest. Both are new sources, so the idempotency check is
degenerate (no prior recorded anchor to compare); each records both the
`source_content_sha256` fetch anchor and the file-specific `source_commit`,
since both files have a real per-file git history worth pinning.

## Sources ingested (2, 3 sections)

- `tc39-module-harmony--shadowrealm-errors` — 1 section.
  `https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/errors.md`,
  sha256 `f96224a3dce4f6712929942f42d72d5e2cf78edbf2d69f95ec6c61d1a0fe80f4`,
  file commit `e191b135591e` (2023-01-26, Caridy Patiño). Fetched
  `source_fetched_via=direct`. Single-section ingest per `conventions.md`
  § Sectioning shapes (two pages, one H2 and one H3):
  `errors-crossing-the-callable-boundary`, topics `module-harmony` + `errors`.
  It is the detail behind the main explainer's one line that errors are
  "subject to stack censoring": total replacement by a fresh `TypeError`, a
  message composed from the original's `name`/`message` but re-composed from
  scratch on **every** crossing (so nested realms and re-entrancy accumulate
  nothing and leave no visible reference to the original), `[[ErrorData]]`-slot
  reads that user-land code must not be able to observe (host-cached values
  where those are accessors), and a generic message for thrown non-errors.
- `tc39-module-harmony--import-attributes-content-type-vs-file-extension` — 2 sections.
  `https://raw.githubusercontent.com/tc39/proposal-import-attributes/master/content-type-vs-file-extension.md`,
  sha256 `517bae82cc71751c9f0b557df479b01ee1cac0d720dbc2c468e324d496011d29`,
  file commit `9015a79a2c28` (2020-06-26, Sven Sauleau). Fetched
  `source_fetched_via=direct`. Sections
  `overview-why-the-extension-is-not-the-type` (the argument) and
  `analysis-cloudflare-content-type-measurements` (the evidence), topic
  `module-harmony`. This is what the README's "widespread mismatch between
  file extension and the HTTP Content Type header" claim stands on: 61.8% of
  `.js` served as `application/javascript` (20.1% empty, 2.5% `text/html`),
  67.6% of `.json` as `application/json` (14.7% `text/html`, 0.66% some
  JavaScript type — the direction that gets data evaluated as code).

Sectioning judgment worth recording: the two measurement tables are
**transcribed in full** rather than shape-summarized. `conventions.md`
§ *Shape, not content, for upstream meta-tables* exists to stop the library
mirroring a row set that drifts upstream at upstream's cadence; these rows are
a frozen 2019/2020 observation (the file's last commit is 2020-06-26) and the
numbers *are* the evidence, not an index of it. The rule does not apply.

## Pages touched

- `topics/module-harmony.md` — 3 section rows (inserter).
- `topics/errors.md` — 1 section row (inserter); the ShadowRealm boundary rule
  now sits beside the SES error-taming corpus, which is the cross-source
  adjacency the second topic tag was for.
- `concepts/module-harmony-intersection-surface.md` — 3 section rows
  (inserter), plus two in-place corrections to a block that had gone false:
  its "Module-harmony neighbors (adjacent proposals, **not yet ingested**)"
  heading and preamble, stale since the 2026-07-29 hourly cycle ingested all
  three, and the ShadowRealm bullet's "Stage 3" (the page's own Sections table
  already carried the Stage 2.7 correction). The import-attributes bullet's
  stage was corrected to 4 in the same pass.
- `sources/README.md` — 2 rows in the TC39 module-harmony table; the cluster
  preamble's "Still not ingested from these repos: …" sentence replaced with
  the record of this cycle. Nothing from these repos is now knowingly left
  un-ingested.
- `keywords.md` — 2 lines (errors-crossing-the-callable-boundary vocabulary;
  Content-Type-versus-file-extension vocabulary), both routed to
  `module-harmony-intersection-surface`.

All ten content files landed through `land-journal-edit.sh`; the five
whole-file replacements of existing pages carried `--base-blob` and none was
refused, so no peer edit was overwritten.

## Integrity gate (step 8) and regenerators (step 9)

- `library-link-check.sh --changed` on the staged commit: **OK**, every checked
  link resolves to a committed file.
- `regenerate-topics-counts.sh --check` before landing: stale counts (12 lines),
  no missing topic page — informational per the procedure, cured by step 9.
- `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` both landed
  as the final step (`sections/README.md`, `topics/README.md`).
- Re-run against the landed tip: `library-link-check.sh --source-slug` **OK**
  for both new clusters (including their `sections/README.md` rows), and
  `regenerate-topics-counts.sh --check` reports counts **current**.

## Follow-on jobs

None posted. The cycle's whole scope was the named remainder and it is done;
no deferred backlog.
