---
title: Single most structurally interesting move
section-slug: garden--CLAUDE-md--fourth-garden-source-ingested-and-named-project-instructions-shape-and-vocabulary-table-and-two-channel-message-bus-and-monitoring-safety-constraint-and-current-inventory
source-slug: garden--CLAUDE-md
url: https://github.com/kriskowal/garden/blob/main/CLAUDE.md
authors: [Endo project (collective; the garden's named-role-as-author convention; current-frontmatter authors = gardener + liaison + builder)]
status: (no explicit metadata table; YAML frontmatter declares created/updated/author)
ingest-cycle: 299
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 146
parent: garden--CLAUDE-md--fourth-garden-source-ingested-and-named-project-instructions-shape-and-vocabulary-table-and-two-channel-message-bus-and-monitoring-safety-constraint-and-current-inventory
---

**§the-named-two-channel-message-bus** combined with **§the-named-git-push-as-the-serialization-point** — the journal acts as the named *message bus* between agents, with two named channels: a per-role inbox (directed) and a job board (broadcast-with-race). The race-to-claim resolves via the remote's `git push origin journal` ordering, not via an explicit lock or queue server. **§the-named-git-as-the-coordination-primitive**.

This extends cycle 297's **§the-named-detached-HEAD-eliminates-the-branch-singleton-contention** to a broader pattern: the garden uses git's built-in primitives (atomic ref updates, push-rejection-on-non-fast-forward) for *all* its concurrency control. There IS no Redis, no PostgreSQL, no Kafka, no message-queue service. **§the-named-coordination-via-git-only-discipline**.

The pattern generalizes to any orchestration system that already has a shared git repo: free coordination primitive via the remote. Push success IS atomic; push rejection IS the "back-off" signal; the journal branch IS the durable record. §two-named-instances-of-leveraging-git-as-coordination across cycles (297 + 299).

§the-named-no-additional-infrastructure-required-discipline: the garden runs on bash + git + Claude Code. The two-channel message bus runs on the same git infrastructure that holds the journal. §the-named-zero-dependency-coordination.
