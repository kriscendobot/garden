---
title: "ADR 0044: Execution provider custody and input scope"
source: docs/decisions/0044-action-dag-and-shared-cache.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Execution evidence names exact provider artifacts, and a separate immutable input scope plus bounded grant authorize each scoped launch without becoming acceptance.

The local phase runner does not wait for packaging-only providers at build intent or include their artifacts in compile requests; project assembly supplies them through explicit bindings, and a failed package provider still blocks project acceptance while independent compilation finishes. Execution evidence names the canonical provider artifact identities used, separately from built outputs; substitution changes that identity, and omitted or substituted admitted inputs are rejected, including on independent reopening. Empty-input legacy documents keep their identity, and absence is never evidence for a nonempty input set.

An immutable execution-input scope binds the project execution plan, consumer build plan and exact exports, compile-time providers, and locked runtime edges (including transitive ones reached through build/toolchain inputs, keeping original endpoints). Its identity changes with runtime artifacts or provider acceptance. The scope is input authority, not a grant: scoped execution also needs a bounded grant over scope, source tree, locked command contract, and runtime tool identities, revalidated before and after each entrypoint launch, rejecting blocked, revoked, expired, mismatched, or privilege-widened grants. Opaque accepted-node resume identities cannot bypass this check.

Generation-only edges consume exact public interfaces already admitted by the lock and create no provider-completion barrier; edges consuming generated artifacts keep accepted-provider barriers until phase-specific custody exists.

Source: [docs/decisions/0044-action-dag-and-shared-cache.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/decisions/0044-action-dag-and-shared-cache.md) at commit 2820f853.
