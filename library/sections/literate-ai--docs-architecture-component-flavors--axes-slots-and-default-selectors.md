---
title: Flavor axes, role slots, and project default selectors
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: Standard semantic axes (platform, accelerator, language ecosystem, UI framework, build system, toolchain, packaging, deployment, documentation) are filled through Component-declared slots with cardinality; slot IDs identify roles so a multi-language Component can bind one language per role, and project default selectors are ordered preferences that explicit selections override before any identity is computed.

Axes are semantic dimensions, not arbitrary labels. Initial standard axes: `platform.os`, `platform.architecture`, `accelerator`, `implementation.language-ecosystem`, `implementation.ui-framework`, `build.system`, `toolchain`, `packaging`, `deployment`, and `documentation.ecosystem`.

A base Component may declare only the abstract slots it accepts, with `exactly-one`, `zero-or-one`, `one-or-more`, or bounded cardinality and a capability contract; it need not list concrete Windows, CUDA, Python, or Rust details. Catalog policy can add standard slots externally when the base is entirely neutral.

Slot IDs, rather than axes, identify roles. Most Components have one slot per axis and may use an axis-wide target constraint. A multi-language Component may instead declare `backend-language` and `frontend-language` on the same language axis; its target must constrain each slot explicitly, and an axis-wide language constraint is rejected as ambiguous. This permits a Rust backend and JavaScript frontend without weakening either slot's exactly-one cardinality.

Project `default_flavor_selectors` are ordered preference inputs, not target mandates. They apply only on axes the Component declares; explicit request selectors apply afterward, and an explicit positive selection replaces a project preference at the same exclusive slot. A weak unqualified build-system preference binds every exclusive role on that axis; a slot-qualified alternative replaces one role, and unqualified `-bazel` removes all bindings without replacement. Either way the removed Bazel revision and skill are absent before effective-set, recipe, input-closure, and prompt construction. Full catalog discovery is identified separately for audit, so a rejected candidate cannot perturb derivation identity, and a preference absent from the supplied catalog is unavailable rather than ambient authority. `litai init` makes the policy portable by installing the exact pinned `make` Flavor/specification and build skill alongside its `+flavor://literate-ai/build-make` project default, without adding runtime enforcement.

Source: [docs/architecture/component-flavors.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-flavors.md) at commit `fcc40bc`.
