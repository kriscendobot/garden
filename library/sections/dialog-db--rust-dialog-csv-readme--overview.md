---
title: Overview — CSV interchange for Dialog artifacts (the/of/as/is/cause)
source: rust/dialog-csv/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, content-addressed-storage]
status: current
---

> Abstract: `dialog-csv` is the CSV import/export bridge for Dialog artifacts. It implements the `Exporter` and `Importer` traits from `dialog-artifacts`, so a branch's `{the, of, is, cause}` facts can be serialized to and deserialized from CSV files. Each row is one artifact with five columns — `the` (attribute/predicate, e.g. `user/name`), `of` (entity/subject URI, e.g. `user:alice`), `as` (value type), `is` (value), and `cause` (an optional base58 causal reference). The `as` column selects one of a fixed set of value types: `text`, `natural`, `integer`, `boolean`, `float`, `bytes` (base58), `entity` (URI), `attribute` (namespace/name), and `record` (base58). CSV is thus a flat, human-readable interchange format that preserves the full fact structure — the same `{the, of, is, cause}` shape the query engine and repository operate on — for round-tripping artifacts in and out of a Dialog branch.

## Overview

`dialog-csv` provides CSV import/export for Dialog artifacts. It implements the `Exporter` and `Importer` traits from `dialog-artifacts`, enabling artifacts to be serialized to and deserialized from CSV files.

### CSV format

Each row represents a single artifact with five columns:

| Column  | Description                       | Example      |
|---------|-----------------------------------|--------------|
| `the`   | Attribute (predicate)             | `user/name`  |
| `of`    | Entity (subject URI)              | `user:alice` |
| `as`    | Value type                        | `text`       |
| `is`    | Value                             | `Alice`      |
| `cause` | Causal reference (base58, optional) |            |

Supported value types: `text`, `natural`, `integer`, `boolean`, `float`, `bytes` (base58), `entity` (URI), `attribute` (namespace/name), `record` (base58).

The `the`/`of`/`is`/`cause` columns mirror the fact model the whole stack shares (see [[fact-triple]]); the extra `as` column makes the value's type explicit so a flat text file can round-trip a typed value.

Source: [rust/dialog-csv/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-csv/README.md) at commit `a898b5de`.
