---
title: Target profiles, Flavor-set locks, and the effective revision
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A TargetProfile supplies desired constraints independently of the base spec; resolution records every candidate and rejection into a digest-identified FlavorSetLock with no implicit host selection; base plus profile plus lock plus typed contributions derive an immutable EffectiveComponentRevision and an EffectiveSpecificationSet in which Flavor fragments may add but never weaken base requirements, and generated tests are rebuilt per effective recipe.

A request, workspace, release matrix, or downstream Component supplies a `TargetProfile` independently of the base specification:

```yaml
target:
  platform:
    os: windows
    architecture: x86_64
  implementation:
    language_ecosystem: rust
  accelerator:
    capability: compute.cuda
    optional: true
```

An optional constraint lets the resolver produce a CPU/no-accelerator realization when no compatible CUDA Flavor exists; it never pretends CUDA was selected.

`FlavorResolutionDecision` records every candidate, version/platform/capability/policy constraint, rejection, conflict, co-requisite, selected revision, and deterministic ordering. The `FlavorSetLock` contains the base revision, target profile, exact ordered Flavor revisions, resolution-policy identity, and a canonical digest. There is no implicit host-platform selection for reproducible operations; "build for this machine" is an explicit target-profile provider whose resolved values enter the lock.

```text
base ComponentRevision + TargetProfile + FlavorSetLock + typed Flavor contributions
  = EffectiveComponentRevision
```

The effective revision is a derived immutable view with its own identity; it does not fork or mutate the base. Source generation, evidence, validation, build authorization, bundles, cache aliases, and publication target the effective identity, and multiple effective revisions share base objects in CAS.

The `EffectiveSpecificationSet` is a manifest of manifests: the unchanged base `SpecificationSet`, each exact Flavor spec fragment, applicability and resolution decisions, diagnostics, and the effective-set digest. Base behavior and acceptance contracts apply to every Flavor set; Flavor fragments may add target behavior and acceptance scenarios but cannot remove, rewrite, or weaken base requirements. A target contradiction is a resolution/spec error requiring a new base revision or an explicitly reviewed compatibility exception.

Generated implementation tests follow the effective set rather than living in either catalog. A clean major rebuild consumes the base plus exact selected Flavor fragments and skills (together the recipe identity) and replaces implementation and `source/tests/manifest.json` together. Each generated case may cite only current non-acceptance documents from that recipe; changing a Flavor revision or role binding changes the recipe identity and invalidates the old suite, which is never patched or merged across effective revisions. Base and Flavor acceptance contracts stay authoritative and verifier-side.

Source: [docs/architecture/component-flavors.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-flavors.md) at commit `fcc40bc`.
