---
title: Documentation artifacts as Components: three layers and the document pair
source: docs/architecture/documentation-artifacts.md
source_repo: jordanhubbard/literate-ai
source_commit: 08ff70273a5462cf4d205b730f445a296cb3f067
source_date: 2026-10-03
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Maintained presentations and documents are modeled as Components: an inheritable document-pair capability Component, inheritable Google Workspace and Microsoft 365 ecosystem Flavors on the documentation.ecosystem axis, and non-inheritable project content; a pair has independently selectable narrative and presentation members, never mixing ecosystems, published through a capability manifest.

Maintained presentations and technical documents are modeled inside the Component system rather than beside it: the framework does not ask projects to trust a hand-maintained build script for artifacts whose whole argument is that readable specifications are the durable authority.

| Layer | Artifact | Inheritable |
| --- | --- | --- |
| Capability | `component://literate-ai/document-pair` | yes, carried into every initialized project |
| Ecosystem binding | `flavor://literate-ai/doc-google-workspace`, `flavor://literate-ai/doc-microsoft-365` | yes |
| Project content | a project's own terminal document Component | no |

The capability Component owns what a document pair *is* (members, access contract, general formatting requirements, authoring-package obligation) and owns no content. A terminal content Component requires `literate-ai.document-pair`, whose `documentation.ecosystem` slot selects Google (Doc + Slides) or Microsoft (Word on SharePoint/OneDrive + PowerPoint).

A pair has two independently selectable members, `narrative` and `presentation`; a consumer declares one or both, never a mixture of ecosystems. The realized pair is published through `LITAI_CAPABILITY_DOCUMENT_PAIR` as a manifest naming the ecosystem, each member's local artifact, its published location or `null`, and its resolved access record. Consumers bind to that manifest, never to provider layout.

Source: [docs/architecture/documentation-artifacts.md](https://github.com/jordanhubbard/literate-ai/blob/08ff70273a5462cf4d205b730f445a296cb3f067/docs/architecture/documentation-artifacts.md) at commit `08ff702`.
