---
title: Formulas as construction recipes
source: designs/daemon-persistence.md
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_commit: aefc1b87da0cebd09184668effa264fe25e1c0b5
source_date: 2026-03-08
source_authors: [Kris Kowal]
source_pr: endojs/endo#3121
source_pr_state: draft
topics: [daemon, persistence, capability-security]
status: current
parent: endo--designs-dp--formula-graph-and-cohort-destruction
---

Each formula records two things:

1. How to arrive at a live reference for a capability.
2. How to construct the capability's dependencies.

A formula is **not a snapshot of state**. It is a recipe for producing
state. The system persists *construction*, not content.
