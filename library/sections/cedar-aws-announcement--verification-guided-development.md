---
title: "Verification-guided development: a formally modeled engine"
source_kind: web-announcement
source_url: https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/
source_content_sha256: 0eb61f6668e777d6f6f9f1d5aa9e7c4e7da53eaa72b8671169197e58224a09c9
source_author: AWS
source_date: 2023-05-10
retrieved: 2026-09-04
ingested: 2026-09-04
ingested_by: scholar
topics: [policy-language-authorization]
status: current
---

Cedar's distinguishing engineering claim is **verification-guided development**: the authorization engine is formally modeled, safety and correctness properties are proved about that model with automated reasoning, and the model is rigorously tested to match the Rust implementation. This is the property that makes Cedar attractive as a trusted decision point — the reference monitor itself is argued correct — and it is a genuinely different assurance story from an ocap system, whose safety argument is structural (you cannot invoke authority you were never handed) rather than proof-of-a-policy-evaluator.

## Verification-guided development

Cedar follows a new verification-guided development process to give high assurance of its correctness and security: AWS formally models Cedar's authorization engine and other tools, **proves safety and correctness properties about them using automated reasoning**, and rigorously tests that the model matches the Rust implementation.

The engine is written in **Rust** and carries performance guarantees alongside the formal-methods guarantees. The reusable design intent (per AWS principal engineer Phil Estes, quoted in the accompanying article) was to build a checking capability that could be formally proven and kept *separate*, so that applications can plug the proven engine in rather than re-implementing authorization ad hoc: "What if we built an engine, and the checking capability that could be formally proven, separate, so that people could just plug that into applications."

Source: [Cedar, an open-source language for access control](https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/) (AWS What's New, 2023-05-10), retrieved 2026-09-04, `source_content_sha256` `0eb61f66`.
