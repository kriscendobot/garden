---
title: Provider resolution: migrating Physics Workbench's Newton/PhysX choice
source: docs/architecture/provider-resolution.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The worked migration keeps mission policy downstream: Physics Workbench sample retains its Newton/PhysX capability catalog, Newton preference, PhysX fallback, required physics capabilities, and any Flavor override, but expresses them as one `physics` `provider_resolutions` declaration, locks and plans through `litai`, consumes `selected_provider`, and deletes its own generic sorting, fallback, sufficiency, override, and provenance code. Pin Literate AI to the exact upstream merge commit until a release carries `PROVIDER-001`; never an unpinned branch.

Physics Workbench sample keeps its physics policy downstream:

- provider IDs and capability declarations for Newton and PhysX;
- Newton as the preferred provider and PhysX in the fallback order;
- mission-required physics capabilities and mission-specific acceptance;
- any Flavor declaration that explicitly overrides the selected physics provider.

After consuming a Literate AI revision containing this contract, Physics Workbench sample should:

1. add one `physics` `provider_resolutions` declaration to the owning `component.md`, using Physics Workbench sample's Newton/PhysX capability catalog, required capabilities, Newton preference, and PhysX fallback order;
2. project any mission-selected physics Flavor override as that Flavor's `provider_overrides` entry rather than computing override provenance downstream;
3. run `litai lock ...`, review the selected provider/fallback or exact override provenance in its report, and commit the resulting current lock;
4. run `litai plan ...` and consume the `physics` result's `selected_provider` in downstream physics planning; and
5. delete generic candidate sorting, fallback traversal, capability-sufficiency, override-validation, and selection-provenance code from `physics_provider_resolution.py`.

Until a release contains the change, pin Literate AI to the exact merge commit of the upstream pull request. After release, replace that commit pin with the first released version containing `PROVIDER-001`; do not use an unpinned branch. Newton-first/PhysX fallback remains Physics Workbench sample mission authority and must not move into this framework.

Source: [docs/architecture/provider-resolution.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/provider-resolution.md) at commit `fcc40bc`.
