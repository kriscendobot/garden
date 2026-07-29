---
title: Time and validity bounds
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: UCAN distinguishes delegation, invocation, validation, and execution times. A chain's validity interval runs from its latest `nbf` to its earliest `exp`, but validators MAY check at several points and MUST validate at execution time. Bounds are integer UTC Unix seconds, subject to the JavaScript-safe-integer range, with short lifetimes and a ±60-second clock-drift buffer recommended.

A delegation can be valid when created yet expired when invoked. `nbf` is optional and defaults to the Unix epoch; a future value supports pre-provisioned authority. `exp` is recommended under least authority; `null` explicitly means no expiry, while a past expiry is invalid. Values outside `-2^53 + 1` through `2^53 - 1` are invalid.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
