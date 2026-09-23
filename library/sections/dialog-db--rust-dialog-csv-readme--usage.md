---
title: Usage — export/import a branch, or use the exporter/importer standalone
source: rust/dialog-csv/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync]
status: current
---

> Abstract: The three ways `dialog-csv` is used. Against a repository branch, `branch.export(CsvExporter::from(file)).perform(&operator)` writes all of the branch's artifacts to a CSV file, and `branch.import(CsvImporter::from(file)).perform(&operator)` reads a CSV file back into the branch — both terminating in `.perform(&operator)` like every other Dialog effect. Without a repository, `CsvExporter` and `CsvImporter` are usable directly over any `writer`/`reader`: `exporter.write(&artifact).await?` then `exporter.close().await?` to emit, and an `importer.next().await` async-iterator loop yielding `Result<Artifact>` to consume. This is the reference for how artifact interchange composes with the repository's operator-authorized effect chain.

## Usage

### Export a branch to a CSV file

```rs
let file = tokio::fs::File::create("artifacts.csv").await?;
branch
    .export(CsvExporter::from(file))
    .perform(&operator)
    .await?;
```

### Import a CSV file into a branch

```rs
let file = tokio::fs::File::open("artifacts.csv").await?;
branch
    .import(CsvImporter::from(file))
    .perform(&operator)
    .await?;
```

### Standalone usage without a repository

```rs
// Export
let mut exporter = CsvExporter::from(writer);
exporter.write(&artifact).await?;
exporter.close().await?;

// Import
let importer = CsvImporter::from(reader);
while let Some(result) = importer.next().await {
    let artifact = result?;
    println!("{artifact}");
}
```

Branch-level export/import runs through `.perform(&operator)` — the same operator capability environment that authorizes commits and queries (see [[repository-branch-remote]]). The standalone `CsvExporter`/`CsvImporter` need no operator because they read and write artifacts directly, outside any repository.

Source: [rust/dialog-csv/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-csv/README.md) at commit `a898b5de`.
