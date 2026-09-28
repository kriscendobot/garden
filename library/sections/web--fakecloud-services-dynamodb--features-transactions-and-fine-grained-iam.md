---
title: Features, transactions, and fine-grained IAM
source_kind: web
source_url: https://fakecloud.dev/docs/services/dynamodb/
source_content_sha256: 83ab143f76f067e464c8b77f3a923d999170e78ccac23e6ba3be333b8d4f3fb1
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, policy-language-authorization]
status: current
---

fakecloud's DynamoDB claims all 57 operations with conditional transactions, full expression support, synthesized ConsumedCapacity, and, under `FAKECLOUD_IAM=strict|soft`, per-operation authorization including the fine-grained keys `dynamodb:LeadingKeys` and `dynamodb:Attributes` plus table and stream resource policies.

"fakecloud implements 57 of 57 DynamoDB operations at 100% Smithy conformance." Supported features (lightly condensed):

- **Tables** — CRUD, GSI/LSI, billing modes, tags, resource-based policies on tables and streams (`PutResourcePolicy` / `GetResourcePolicy` / `DeleteResourcePolicy` with `ExpectedRevisionId`).
- **Items** — GetItem, PutItem, UpdateItem, DeleteItem, BatchGetItem, BatchWriteItem.
- **Transactions** — TransactGetItems, TransactWriteItems with conditional checks.
- **Query and Scan**, **PartiQL** (ExecuteStatement, BatchExecuteStatement, ExecuteTransaction).
- **Update expressions** — SET, REMOVE, ADD, DELETE with `size`, `attribute_exists`, `begins_with`, `contains`, `attribute_type`. **Condition expressions** — "full operator support with correct type coercion".
- Global tables, backups, streams (delivery to Lambda/Kinesis), TTL via a tick endpoint, S3 exports/imports (recorded).
- **ConsumedCapacity + ItemCollectionMetrics** on every data-plane op when requested, synthesized from serialized item size with AWS's 4 KB read / 1 KB write rounding.
- **IAM enforcement** — "with `FAKECLOUD_IAM=strict` (or `soft`), every DynamoDB and DynamoDB Streams operation is authorized against the caller's policies using the actions and resource ARNs AWS uses", including the batch action on every table in a batch, the per-item action on each table in a transaction, `PartiQLSelect`/`Insert`/`Update`/`Delete`, tag conditions, and "fine-grained access control through `dynamodb:LeadingKeys`, `dynamodb:Attributes`, `dynamodb:Select`, `dynamodb:ReturnValues`, `dynamodb:ReturnConsumedCapacity`, `dynamodb:EnclosingOperation` and `dynamodb:FullTableScan`; and table and stream resource-based policies, whose explicit Deny wins."
- **Cross-account `TableName` ARNs** for the data-plane and describe/update/delete/tag/stream-read operations AWS allows cross-account; transactions stay atomic across accounts. PartiQL, backups, PITR, TTL, and import/export do not resolve another account's table.

Protocol: JSON (`X-Amz-Target`). The page does not describe the shape of `TransactionCanceledException.CancellationReasons`; see the minion.town fit addendum for a source-level check.

Source: [fakecloud docs/services/dynamodb](https://fakecloud.dev/docs/services/dynamodb/), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
