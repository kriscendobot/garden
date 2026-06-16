---
title: Revocation as chain break
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions
---

When the principal revokes a delegate's Handle (via HandleControl),
the chain at that link **breaks cleanly**:

> *All of Aifred's subordinates' epithet chains become unverifiable
> at the Aifred link. Bob verifying Jarvis's chain would find that
> the "(majordomo of Aifred)" link fails because Aifred's Handle is
> revoked.*

This is the same revocation-by-withdrawal mechanism described in
[[revocation-by-withdrawal]] — a Handle whose formula is removed
becomes structurally unreachable; the chain detection above is just
that property surfaced at the epithet-verification layer.
