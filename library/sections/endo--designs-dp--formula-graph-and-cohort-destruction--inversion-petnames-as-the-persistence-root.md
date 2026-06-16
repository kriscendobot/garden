---
title: "Inversion: petnames as the persistence root"
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

The petname database is a graph database mapping human-readable,
self-assigned names to capabilities — a tree of named paths mapped to
locators. As in E, a locator serves to re-establish connectivity. But
**here** a locator names a node in the **formula graph**, via which
the daemon resolves to the *latest incarnation* of the underlying
capability.

The petname database is not a layer on top of sturdy references; it
*is* the persistence system.
