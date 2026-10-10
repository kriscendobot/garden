---
title: Components, Flavors, and exact revisions
source: docs/architecture/domain-model.md
source_repo: jordanhubbard/literate-ai
source_commit: 2820f8535116c5bc0056232d7251e178f02016d1
source_date: 2026-10-01
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: A Component is a stable logical coordinate whose immutable revision binds exact specifications, skills, workflow policy, assets, source, and lineage; typed Flavors add target variation without weakening base requirements or mutating the Component definition.

A Component can represent a library, service, command, application, data transform, documentation generator, or workflow. Its coordinate is stable, while a revision is content-addressed and binds the normalized definition, exact SpecificationSet, authoring inputs, workflow and routing identities, and source identity when present. Operational timestamps remain events so they do not perturb deterministic identities.

Flavors contribute typed choices such as operating system, architecture, language, build system, toolchain, packaging, and deployment. Resolution produces an exact Flavor-set lock and effective Component revision. Arbitrary document merge and silent last-writer-wins are forbidden; conflicts must fail with an explanation, and a Flavor cannot remove base requirements or weaken security policy.

Source: [docs/architecture/domain-model.md](https://github.com/jordanhubbard/literate-ai/blob/2820f8535116c5bc0056232d7251e178f02016d1/docs/architecture/domain-model.md) at commit `2820f85`.
