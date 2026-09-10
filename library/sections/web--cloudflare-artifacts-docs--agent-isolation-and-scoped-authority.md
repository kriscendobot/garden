---
title: Agent isolation and scoped authority
source_kind: web
source_url: https://developers.cloudflare.com/artifacts/llms-full.txt
source_content_sha256: d81d8779a3e3a3b645c62b871ca8c06e35acfc66ccfde4986186904f06cb9996
source_authors: ["Cloudflare, Inc."]
source_date: 2026-08-25
ingested: 2026-09-10
ingested_by: gardener
topics: [agent-workspaces, capability-security, cloudflare-workers-agent-hosting]
status: current
---

The documented agent pattern is one repository per agent, session, user, or application, often forked from a reviewed baseline. This separates failures, diffs, review, deletion, and cleanup. Branches remain appropriate when collaborators share one repository lifecycle; a shared repository should not serve as a queue for unrelated autonomous agents.

Repository names should incorporate a stable workflow identifier to prevent collisions. Namespaces provide the broader ownership, environment, jurisdiction, and request-rate boundary. Cloudflare advises sharding hot workloads across namespaces rather than indefinitely growing one default namespace.

Read credentials are intended for clone, indexing, and review. Write credentials are for sessions that must push. Both are repository-scoped, and the recommended form is the shortest practical lifetime with a fresh token per session. Harness metadata can travel separately from working-tree content on Git notes refs.

Supporting pages: [Best practices](https://developers.cloudflare.com/artifacts/concepts/best-practices/), [Namespaces](https://developers.cloudflare.com/artifacts/concepts/namespaces/), and [Authentication](https://developers.cloudflare.com/artifacts/guides/authentication/).

Source: [Cloudflare Artifacts complete documentation](https://developers.cloudflare.com/artifacts/llms-full.txt), retrieved 2026-09-10.
