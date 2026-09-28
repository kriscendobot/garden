---
title: Positioning and conformance claims
source_kind: web
source_url: https://fakecloud.dev/llms.txt
source_content_sha256: 7da0553629fa56a54689e661b91e2675fc06b469e00242984b086d40e06b553d
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

fakecloud is a free, AGPL-3.0, Rust local AWS emulator on one port (4566) with no account or auth token; it claims 105 services, 7,508 operations, and 248,557/248,557 passing Smithy-generated conformance variants.

fakecloud describes itself as a free, open-source local AWS cloud emulator written in Rust. It runs on a single port (4566), requires no account or auth token, and aims for 100% behavioral parity with real AWS "across every service, every operation, and every cross-service integration." It positions itself as an open-source alternative to LocalStack, which (per the page) went proprietary in March 2026.

Claims as published at retrieval:

- **Approach is depth-first:** a service is added when it passes the full Smithy-model test variants and cross-service wire-ups, "not when the API surface looks filled in."
- **Footprint:** single static binary (~19 MB), ~300 ms startup, ~10 MiB idle memory; no Docker needed to run fakecloud itself (Docker is needed for the services that run real backing infrastructure: Lambda, RDS, ElastiCache, ECS, EC2 instances).
- **Scale:** 105 AWS services, 7,508 operations, "true 100% Smithy conformance — 248,557/248,557 generated test variants pass on every commit," no flake margin and no skipped services. The roadmap is driven by real-project demand.
- **30+ cross-service integrations:** S3 notifications, SNS fan-out, EventBridge rules, DynamoDB Streams, CloudWatch Logs subscriptions, Cognito triggers, API Gateway to Lambda, Step Functions task integrations, SES inbound to S3/SNS/Lambda.
- **Real execution where it matters:** Lambda runs real code via Docker across 23 runtimes (Node.js 16 through 24 included); RDS runs real PostgreSQL/MySQL/MariaDB/Oracle/SQL Server/Db2; ElastiCache runs real Redis/Valkey/Memcached.
- **Authorization semantics:** multi-account, SCPs, ABAC tag conditions, permission boundaries, session policies, KMS key policies, and bucket policies with full Allow/Deny/NotPrincipal semantics.
- **Provider-drift check:** CI runs upstream `hashicorp/terraform-provider-aws` `TestAcc*` suites against fakecloud.
- **License:** AGPL-3.0, free for commercial use.

Reading note (scholar): "100% conformance" is a claim about request/response *shape* against AWS's Smithy models; the parity matrix ([web--fakecloud-parity--conformance-versus-behavior-parity](web--fakecloud-parity--conformance-versus-behavior-parity.md)) is explicit that behavior parity varies per service. Treat the headline numbers as vendor self-report.

Source: [fakecloud llms.txt (agent-oriented project summary)](https://fakecloud.dev/llms.txt), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
