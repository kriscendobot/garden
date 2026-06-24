---
title: §the-named-job-board-claim-race as named-coordination-shape (first-explicit-observation)
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

> "A producer posts a job to `journal/jobs/open/` via `skills/job-board/post-job.sh`; eligible consumers race to claim via `skills/job-board/claim-job.sh`. The git push to `origin/journal` is the serialization point; rejected claims back off without retry."

**§the-named-producer-consumer-pattern-via-git**: posting + claiming. **§the-named-back-off-without-retry**: if your push IS rejected, you give up + move on. **§the-named-no-retry-no-deadlock**: rejected claims don't queue up; they just disappear.

§the-named-`/clear`-survival-property: "survives `/clear` of the consumer between jobs because the per-job substance never enters the consumer's parent context." **§the-named-context-window-decoupling-via-job-board**.
