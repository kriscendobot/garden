---
title: §the-named-two-channel-message-bus (first-explicit-observation)
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

> "Holds the garden's transcript and acts as the **two-channel message bus** between agents: a per-role inbox (`journal/inboxes/<host>/<role>.md`; drained via `skills/inbox-drain/SKILL.md`) for directed communication, and a **job board** (`journal/jobs/`; contract at [`journal/jobs/README.md`](journal/jobs/README.md); skill at [`skills/job-board/SKILL.md`](skills/job-board/SKILL.md)) for work items that any eligible consumer can race to claim via git push as the serialization point."

**§two-named-channels-in-the-message-bus**: per-role-inbox + job-board. **§the-named-two-channel-shape**: inbox IS *directed* (one named recipient); job-board IS *broadcast-with-race* (any eligible consumer).

§the-named-git-push-as-the-serialization-point: the race-to-claim resolves via the remote's git-push-ordering, not via an explicit lock. **§the-named-git-as-the-coordination-primitive** — sibling-pattern to cycle 297's §the-named-detached-HEAD-eliminates-the-branch-singleton-contention; both patterns offload coordination to git's own primitives.

§the-named-concurrent-stewards-across-hosts-and-within-one-host-are-both-honored: §the-named-no-coordination-required-beyond-git.
