---
title: Significant roadmap projects
source_kind: web
source_url: https://fakecloud.dev/docs/parity
source_content_sha256: ee0e08c4fd9a477add0cf8f22d9a97e65951f9f48472c04429eb6154da0166db
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation]
status: current
---

Gaps fakecloud can implement but that are large projects: an Athena SQL engine, the WAFv2 managed-rule framework, full Cognito WebAuthn attestation, ECR cross-registry replication, a Glue job runner, a full API Gateway v1 VTL evaluator, the CloudFront edge-function pipeline, CloudWatch Metrics persistence, and Bedrock Knowledge Base ingestion; plus not-yet-shipped services such as X-Ray, AppSync, and Amplify.

"These are gaps that fakecloud can implement but represent significant engineering projects rather than incremental fixes."

| Project | Scope |
|---|---|
| Athena full SQL engine | DataFusion-backed parser and executor (WHERE, GROUP BY, aggregates, joins, subqueries, window functions; Parquet and JSON SerDes over S3). Today every query returns a synthesized one-row result. |
| WAFv2 ManagedRuleGroup framework | Rule expansion engine plus OWASP-style stand-in rules evaluated against real request headers and bodies. |
| Cognito WebAuthn full attestation verification | CTAP CBOR parser and signature chains for `packed`, `fido-u2f`, `android-key`, `tpm` (`packed` alone is the smaller batch). |
| ECR cross-registry image replication | Real OCI v2 copy with cross-account auth and region routing. |
| Glue full job runner | Spark-style execution with partition-aware reads and JDBC connectors. |
| API Gateway v1 full VTL evaluator | `$util.*`, loops, conditionals, escapes — full Velocity Template Language. |
| CloudFront full edge function pipeline | Origin shield, cache-key transforms, in-path CloudFront Functions / Lambda@Edge. |
| CloudWatch Metrics persistence layer | Metrics, alarms, and dashboards survive server restarts. |
| Bedrock Knowledge Base ingestion lifecycle | Chunking and retrieval pipeline (the embedding model stays out of scope). |

Services listed as not yet shipped, with their AWS operation counts: AWS X-Ray (38), AWS AppSync (74), AWS Amplify (37), Amazon Textract (25), Amazon Transcribe (44), AWS Shield (36), Amazon Comprehend (85), Amazon Translate (19). The project asks contributors to open an issue first to scope any of these.

Source: [fakecloud parity matrix](https://fakecloud.dev/docs/parity), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
