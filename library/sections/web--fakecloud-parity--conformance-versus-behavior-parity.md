---
title: Conformance versus behavior parity
source_kind: web
source_url: https://fakecloud.dev/docs/parity
source_content_sha256: ee0e08c4fd9a477add0cf8f22d9a97e65951f9f48472c04429eb6154da0166db
source_authors: ["faisca (fakecloud project)"]
source_date: 2026-09-28
ingested: 2026-09-28
ingested_by: gardener
topics: [cloud-emulation, testing]
status: current
---

The parity matrix separates Smithy *conformance* (request/response shapes, field names, error codes — claimed 100%) from per-service *behavior parity*, reported as Control plane / Data plane columns (Full, Partial, None) plus a Known-limitations column.

The parity matrix is "service-by-service behavior parity: what is real, what is synthesized, and what is not yet implemented." It restates the headline: 105 services, 7,508 operations, 248,557/248,557 Smithy-generated variants passing on every commit.

The page draws the distinction explicitly. Conformance checks request/response shapes, field names, and error codes against AWS's own Smithy models. Behavior parity varies by service: some services run real infrastructure (Postgres, Redis, Docker containers), some run a real control plane but return synthesized data for complex queries, and a few have control-plane-only coverage with no data-plane enforcement.

Under "What 100% conformance means": the generated suite "guarantees that field names, types, required/optional flags, error codes, and HTTP signatures are identical to AWS. It does not guarantee that every operation behaves exactly like AWS in all edge cases — that is what the Data plane and Known limitations columns describe." Some limitations are "outside the Smithy conformance boundary (the shape is correct, but the behavior is simplified)."

Each matrix row therefore gives: service, op count, protocol, **Control plane** (Full / Partial), **Data plane** (Full / Partial / None), and **Known limitations** free text. A consumer judging fit should read the Data plane column and the limitations text, not the conformance headline.

Source: [fakecloud parity matrix](https://fakecloud.dev/docs/parity), retrieved 2026-09-28. Derived summary of vendor documentation; treat claims as the project's self-report.
