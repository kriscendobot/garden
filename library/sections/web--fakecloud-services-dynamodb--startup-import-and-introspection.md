---
title: Startup import of AWS exports and introspection
source_kind: web
source_url: https://fakecloud.dev/docs/services/dynamodb/
source_content_sha256: 83ab143f76f067e464c8b77f3a923d999170e78ccac23e6ba3be333b8d4f3fb1
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

fakecloud can seed DynamoDB tables at startup from real AWS DynamoDB S3 exports (single-table or multi-table flags, idempotent per table, `DYNAMODB_JSON` only), and exposes a TTL tick and an on-demand canonical snapshot endpoint.

**Introspection:**

- `POST /_fakecloud/dynamodb/ttl-processor/tick` — expire items whose TTL attribute is in the past.
- `POST /_fakecloud/dynamodb/snapshot/save` — write current DynamoDB state as a canonical snapshot; optional body `{"dataPath": "<dir>"}` writes `<dir>/dynamodb/snapshot.json`, else the configured persistent store.

**Importing an AWS export at startup.**

- Single-table: `--dynamodb-import-path` (`FAKECLOUD_DYNAMODB_IMPORT_PATH`, the `AWSDynamoDB/<export-id>/` folder with `manifest-summary.json`) together with `--dynamodb-import-describe-table` (an `aws dynamodb describe-table` JSON dump).
- Multi-table: `--dynamodb-import-dir` (`FAKECLOUD_DYNAMODB_IMPORT_DIR`), one self-contained subdirectory per table, each with its own `describe-table.json`.
- Constraints: the two modes are mutually exclusive; imports are **idempotent per table** (an existing table of that name is skipped with a warning, never merged); tables are materialized straight into the store (not through `BatchWriteItem` or `ImportTable`); only `DYNAMODB_JSON` exports; every item must carry correctly-typed key attributes; an `itemCount` mismatch rejects the import; bad input aborts startup before any write. Works in either storage mode.

Cross-service delivery: Streams -> Lambda (event source mapping), DynamoDB -> Kinesis. Implementation crate: `crates/fakecloud-dynamodb`.

Source: [fakecloud docs/services/dynamodb](https://fakecloud.dev/docs/services/dynamodb/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
