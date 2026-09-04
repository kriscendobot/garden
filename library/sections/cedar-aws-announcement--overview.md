---
title: "Cedar open-sourced: a policy language and authorization engine"
source_kind: web-announcement
source_url: https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/
source_content_sha256: 0eb61f6668e777d6f6f9f1d5aa9e7c4e7da53eaa72b8671169197e58224a09c9
source_author: AWS
source_date: 2023-05-10
retrieved: 2026-09-04
ingested: 2026-09-04
ingested_by: scholar
topics: [policy-language-authorization, capability-security]
status: current
---

Cedar is an open-source language and engine for expressing and enforcing fine-grained access-control **policies**, decoupled from application logic. Its authorization model is **policy-as-code**: rather than intertwining "is this user allowed to touch this resource?" with the application code that acts, Cedar externalizes the decision into policies a small embedded engine evaluates. It supports the two dominant enterprise authorization models — **role-based access control (RBAC)** and **attribute-based access control (ABAC)** — and answers each request as a permit/forbid decision over a *principal*, an *action*, and a *resource* (with request-time *context*). This is the ambient-authority, reference-monitor shape of access control: a central engine consults a policy set and adjudicates every request, the classic complement to the object-capability model the garden's existing corpus documents (see [[policy-vs-capability-authorization]]).

## What was announced

Today, AWS open-sourced the Cedar policy language and authorization engine. You can use Cedar to express fine-grained permissions as easy-to-understand policies enforced in your applications, and you can **decouple access control from your application logic**. Cedar supports common authorization models such as role-based access control and attribute-based access control.

Cedar is open-sourced under the Apache License 2.0 and includes the Cedar language specification and a software development kit (SDK). The SDK provides libraries for **authoring and validating policies, and authorizing access requests**.

The design goal Cedar's authors state is to balance three properties that usually trade off against one another: **expressiveness** (rich enough to state real policies), **performance** (millisecond decisions), and **analyzability** (policies you can reason about and formally check). The language and engine are not AWS-specific: anywhere an application needs to decide what an actor may do to a resource — anywhere RBAC or ABAC applies — Cedar is meant to plug in.

Source: [Cedar, an open-source language for access control](https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/) (AWS What's New, 2023-05-10), retrieved 2026-09-04, `source_content_sha256` `0eb61f66`.
