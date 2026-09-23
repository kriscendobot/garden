---
title: Delegate
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--delegates-and-epithets
---

A **delegate** is an agent (Handle + agency) created by another agent,
carrying obligatory epithets about its relationship to its creator.
This is **attenuation applied to identity**: the delegate has the
powers its creator grants it (directory entries, service connections),
but it also carries claims it cannot shed.

In the existing architecture this is close to what already happens
when a Host creates a Guest — the Guest gets a Handle, a pet-name
directory, and mail powers, scoped by what the Host writes into its
directory. A delegate extends this by adding epithets to the Guest's
Handle.

The delegate's creator is its **principal**. The principal's Handle is
referenced in the delegate's epithets. This is **not configuration or
metadata** — it is a structural relationship that the delegate cannot
modify or remove, because the epithet is part of the Handle's formula
(set at creation, immutable to the evaluator).
