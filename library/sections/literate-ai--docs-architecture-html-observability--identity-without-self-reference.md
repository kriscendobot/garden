---
title: HTML observability: identity without self-reference
source: docs/architecture/html-observability.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, content-addressed-storage]
status: current
---

> Abstract: Because an HTML file cannot contain its own digest, embedded provenance carries render-input identities while the enclosing artifact record carries the file identity; render-input identity hashes only ordered source bindings, view, and renderer (never task IDs or timestamps), the emitter binds its modules and SRI-pinned assets into the template identity and inspects its own closed vocabulary, and an installed-wheel check refuses source checkouts or changed catalogs.

An HTML file cannot contain its own final digest, because inserting it changes the file. The embedded `litai-provenance` JSON therefore carries provenance and render-input identities, while the enclosing artifact record carries the completed file identity. Staleness compares current input/view/renderer identity with the retained one. Task IDs and wall-clock observations must not manufacture new render-input identities, and a schema-valid record alone proves none of these content relationships; the renderer must still prove deterministic output.

`render_inputs_identity` hashes exactly the ordered source bindings, view, and renderer through the canonical JSON identity helper, accepting no task/correlation metadata or timestamps. `HtmlProvenance.create` adds the supplied UTC observation and declared assets and hashes the provenance excluding its own identity; reading provenance re-checks both identities rather than trusting a caller digest. `HtmlArtifact.from_bytes` binds the byte sequence and size but does not attest that arbitrary bytes are safe, self-contained HTML; it checks the declared external-reference count against the asset list, and typed records reject unsafe portable paths, malformed instants, and invalid SHA-256/384/512 SRI encodings.

The emitter binds its implementation, inline-view and excerpt modules, presentation profile, and ordered asset declarations into the template identity, so an asset URL, kind, order, or SRI change cannot keep the same render-input identity. It inspects the completed document's closed element/attribute vocabulary, balanced structure, fragment links, exact inline stylesheet and script, JSON blocks, and external references before computing the artifact record. This is an assertion about its own template, not a sanitizer for arbitrary HTML. Visible strings are HTML-escaped; embedded JSON separately escapes HTML delimiters and JavaScript line separators. Identical inputs give identical bytes; a new observation changes provenance and bytes but not render-input identity.

The low-level byte API requires an explicit framework distribution identity, catalog release, and UTC observation; it does not discover installations. `adapters/html_framework.py` reuses the installed-wheel observer and requires the imported package and loaded modules to belong to that wheel's recorded payload, with both active schema catalogs matching its exact inventory and bytes. Source checkouts, editable or ambiguous installs, mixed import roots, and changed catalogs refuse with `render.surface_unavailable`; the check repeats before publication and is an in-process check, not OS isolation. `storage.ReferenceIndex` gained read-only snapshots that create no directories or lock files, keep CAS verification, reject writes, bound reads, and refuse observed publication drift rather than reporting a cache miss.

Source: [docs/architecture/html-observability.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/html-observability.md) at commit `fcc40bc`.
