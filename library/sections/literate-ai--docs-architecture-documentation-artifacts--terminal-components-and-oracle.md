---
title: Terminal document Components and the executable acceptance oracle
source: docs/architecture/documentation-artifacts.md
source_repo: jordanhubbard/literate-ai
source_commit: 08ff70273a5462cf4d205b730f445a296cb3f067
source_date: 2026-10-03
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A document Component that provides no capability is terminal: citable but not forkable, composable, or resolvable as a dependency; an independent oracle script checks the realized pair from the manifest and OOXML alone, a mutation suite proves it rejects each violation, and lifecycle generation of the repository's own deck remains an explicit, hand-built exception.

**Terminal Components.** A document Component that provides no capability is *terminal*: its content is bound to one project's factual ledger, so inheriting it would carry claims into contexts where they no longer hold. It cannot be forked as a template, composed as a provider, or resolved as a dependency (resolution fails closed for lack of an exported capability). Terminal is not private: it stays citable by Component URI and its published locations stay linkable. `component://literate-ai/literate-ai-overview` is the repository's terminal document Component; it requires the pair capability, declares only a `presentation` member, and is absent from the project template.

**Boundary of authority.** Generation authority for the build source is `skills/specification-to-source/document-pair/SKILL.md`. The agent-facing method `skills/agent/author-presentations-and-documents/SKILL.md` is cited by these Components rather than pinned as a generation input: it governs how an agent works, not what the generator emits.

**The acceptance contract executes.** `scripts/verify_document_pair.py` is the independent oracle. It reads the capability manifest, the realized artifacts, the authoring package, and the consuming declaration, and nothing else; it imports no framework code and never consults the build program, so a defect in either cannot make the oracle agree. Geometry, page count, and notes coverage are read straight from the OOXML package. The builder emits a `literate-ai/document-pair-manifest@1` into `OBJ_DIR` and `regenerate.sh` runs the oracle; a vanilla worker bootstraps pinned `python-pptx`/`python-docx` via `make doc-toolchain-bootstrap` without a Codex presentations plugin (plugin discovery remains a fallback until three-OS visual parity closes). Holding no publication authorization, the build records `published_location: null`.

"An oracle that has never failed is a rubber stamp": `tests/critical/test_document_pair_oracle.py` mutates a conforming realization once per scenario (widened audience, credential material, unauthorized publication, undeclared member, missing artifact, missing package element, missing notes page, element outside the surface, surface disagreeing with the declaration, unresolved placeholder) and requires each rejected, with a control asserting the unmutated realization is accepted.

**Stated gap.** Lifecycle build-source generation is not yet wired for the terminal overview Component; its deck comes from the hand-maintained `build_deck.py` in its authoring package using a project-local, content-pinned OOXML toolchain under `OBJ_DIR`. The contract, declaration, and oracle are real; lifecycle generation is not yet. This is an explicit exception for the repository's own deck, not a requirement on derived projects.

Source: [docs/architecture/documentation-artifacts.md](https://github.com/jordanhubbard/literate-ai/blob/08ff70273a5462cf4d205b730f445a296cb3f067/docs/architecture/documentation-artifacts.md) at commit `08ff702`.
