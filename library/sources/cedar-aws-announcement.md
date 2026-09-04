---
source_kind: web-announcement
source_url: https://aws.amazon.com/about-aws/whats-new/2023/05/cedar-open-source-language-access-control/
source_content_sha256: 0eb61f6668e777d6f6f9f1d5aa9e7c4e7da53eaa72b8671169197e58224a09c9
source_author: AWS
source_date: 2023-05-10
retrieved: 2026-09-04
ingested: 2026-09-04
ingested_by: scholar
section_count: 3
status: current
notes: "AWS 'What's New' announcement of Cedar's open-sourcing. Fetched live and reachable via direct curl (source_fetched_via=direct); idempotency anchor is source_content_sha256 over the live response body, not a git SHA. The page is mostly AWS site chrome; the announcement body is the three sections captured here."
---

AWS's 2023 announcement that it open-sourced the **Cedar** policy language and authorization engine (Apache 2.0). Cedar externalizes fine-grained access control from application logic into policies a small, embeddable, **formally-verified Rust engine** evaluates, supporting RBAC and ABAC over a principal / action / resource / context request. It ships both as a managed service (Amazon Verified Permissions, with central policy storage and cross-application audit) and as local/offline open-source libraries for authoring, validating, and evaluating policies. This is the ambient-authority, reference-monitor complement to the garden's object-capability corpus — see [[policy-vs-capability-authorization]] and [[cedar-policy-language]].

| Section | Topics | Status |
|---------|--------|--------|
| [Cedar open-sourced: a policy language and authorization engine](../sections/cedar-aws-announcement--overview.md) | policy-language-authorization, capability-security | current |
| [Verification-guided development: a formally modeled engine](../sections/cedar-aws-announcement--verification-guided-development.md) | policy-language-authorization | current |
| [Amazon Verified Permissions, central policy storage, and offline use](../sections/cedar-aws-announcement--verified-permissions-and-local-use.md) | policy-language-authorization | current |
