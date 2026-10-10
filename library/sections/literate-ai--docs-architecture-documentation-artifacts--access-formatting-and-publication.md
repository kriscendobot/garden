---
title: Document access contracts, verifiable formatting, and authorized publication
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

> Abstract: Every realized document member carries an explicit audience/principals/permission/link-sharing record that a provider may narrow but never widen, with no credentials anywhere and fail-closed tenant conflicts; formatting rules are mechanical so an oracle can check them; authoring yields a portable local artifact and package with no MCP dependency, and publication is a separate, authorized, Flavor-owned step with read-back verification.

**Access is contract, not deployment.** Every realized member carries explicit `audience`, `principals`, `permission`, and `link_sharing`. A provider may narrow but never widen the declared audience; publication to any external destination needs explicit authorization; no credential material may appear in the manifest, authoring package, or repository. Where tenant policy forbids the declared audience, the provider fails closed and leaves the member unpublished.

**Formatting is verifiable.** The general requirements are deliberately mechanical so an independent oracle can evaluate them without human judgment: exact surface geometry with no escaping element, complete per-page notes on a presentation, a heading hierarchy with no skipped levels on a narrative, preserved editable native objects, no unresolved placeholders, and every consequential claim traceable to the authoring package's factual ledger. Flavors contribute the concrete mapping (Drive sharing states and Slides notes placeholders; SharePoint link types and PowerPoint notes slides) without touching content authority, claims, audience, or approval state.

**Portable authoring, optional publication.** The agent-facing authoring skill has no mandatory MCP or collaboration-service dependency. Its portable result is an editable local artifact, a deterministic authoring package, and mechanical acceptance evidence. A generated package must declare and lock any Node or Python format libraries and isolate their closure under ignored `OBJ_DIR`; missing tools are detected before work, and installation needs user authorization and never mutates a global environment.

Publication begins only after local acceptance and belongs to the selected Flavor: unauthorized means manifest location `null`; the Google binding owns `gcloud` detection, optional authorized install guidance, `gcloud auth print-access-token`, exact-resource update, access mapping, and exported round-trip verification; the Microsoft binding owns connector or Graph-client discovery, device-code/browser authentication, tenant-policy handling, upload, and download verification. A non-interactive worker reports missing login as a prerequisite and never waits for an interaction it cannot relay.

Source: [docs/architecture/documentation-artifacts.md](https://github.com/jordanhubbard/literate-ai/blob/08ff70273a5462cf4d205b730f445a296cb3f067/docs/architecture/documentation-artifacts.md) at commit `08ff702`.
