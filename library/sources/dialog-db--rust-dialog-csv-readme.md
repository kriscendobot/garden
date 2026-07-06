---
source: rust/dialog-csv/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: The README for `dialog-csv`, dialog-db's CSV import/export bridge for artifacts. It implements the `Exporter`/`Importer` traits from `dialog-artifacts`, serializing a branch's `{the, of, is, cause}` facts to and from flat CSV. It documents the five-column row format — `the` (attribute), `of` (entity URI), `as` (value type), `is` (value), `cause` (optional base58 causal reference) — and the fixed value-type set (`text`, `natural`, `integer`, `boolean`, `float`, `bytes`, `entity`, `attribute`, `record`), then shows three usage modes: `branch.export(CsvExporter::from(file))`, `branch.import(CsvImporter::from(file))`, and standalone `CsvExporter`/`CsvImporter` over any writer/reader.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--rust-dialog-csv-readme--overview.md) | datalog-query, content-addressed-storage | current |
| [usage](../sections/dialog-db--rust-dialog-csv-readme--usage.md) | datalog-query, local-first-sync | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- The interchange crate of the dialog-db storage cluster; it serializes the same `{the, of, is, cause}` artifacts the query engine (`rust/dialog-query`) and repository (`rust/dialog-repository`) operate on.
- Ingested in the `scholar-ingest-dialog-db-remainder-12` cycle (2026-07-06).
