---
title: "Retained library bindings: current-authority readers"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: A family of guarded filesystem readers supplies the current values admission compares against: `read_retained_cargo_files` (pinned importer config/binding/plan/manifests with explicit absences), `read_retained_provider_generation` (current recipe map), `read_current_qualification_authority` (verifier from the current parity profile), `read_current_qualified_promotion` (authority head and audits, rechecked), the generation-closure snapshot, and `read_retained_provider_authority`, which composes them with the installed Standard binding under one combined guard.

`read_retained_cargo_files` implements the importer-file part of that resolver. It
uses `PinnedInputClosure` to read the project configuration, an explicitly supplied
reviewed binding reference, the pinned plan and every manifest/lock input. The
caller must select `before` or `after`; a missing reference means the corresponding
path must be absent, including dangling links. Existing path ancestors must be
ordinary directories. Revalidation checks both captured bytes and expected
absences, refusing concurrent file creation without deleting it. Binding/project
mismatches, duplicate binding fields, cross-platform path aliases and read-budget
overruns refuse. The reader creates no files and returns its custody guard for
composition with provider/tool/gate guards.

This file snapshot does not prove that the binding was reviewed: its exact blob
reference must already come from importing-maintainer authority. It also does not
resolve current provider recipes, measure native tools or derive full retained gate
authority. Those remaining filesystem observations must join the importer guard
before exposing the transactional consumer operation.

`read_retained_provider_generation` reopens current provider locks and catalogs
from an independently selected preparation request and logical provider/model.
It projects every node through the same model-selection and recipe code as
Standard, and returns an immutable complete recipe map with the existing input
custody guard. It does not require a coding executable or allocate a generation
workspace, cache or CAS. These are current recipe expectations for reopening;
they do not establish qualification. Promotion, installed lifecycle authority,
native tool observations and retained consumer gates still require composition.

`read_current_qualification_authority` reads the independently selected current
parity profile through a bounded regular-file input guard and derives its verifier
identity and case map from that profile and the current promotion's source snapshot
identity. Qualification execution, evidence recording and archive reopening share
the same derivation, preserving the existing record shape. Profile changes invalidate
custody and change the expected verifier; duplicate JSON fields and unsafe paths
refuse. This lookup needs no original source tree and runs no cases. The caller must
still resolve and guard the current promotion, profile selection and installed policy;
the candidate archive cannot supply those current expectations.

`read_current_qualified_promotion` reopens the provider's current authority head,
content-addressed promotion audits and qualification result from the filesystem.
It checks them against independently supplied current lock, generation closure,
verifier and policy authority, then checks the current head again. Its guard repeats
the reopening and compares the semantic evidence, rejecting invalidation, changed
audited inputs, substituted records and a concurrent head change. Reads append no
authority event and perform no cleanup. This guard must join the separate guards
for current generation, profile and installed policy: passing historical values as
current arguments does not establish their currency.

The current generation snapshot derives `ComponentGenerationClosure` from its
locked workflow/routing references and the verified promotion audit's selected
Flavor and forward-skill subsets. Every selected Flavor must have audited entries;
a nonempty subset for another Flavor cannot hide an omission. Audit files and
generation custody are rechecked around derivation. No historical closure is
required, and no workflow execution or model selection occurs in this operation.
The explicitly supplied qualification identity must still come from the reopened
result, and the derived closure must pass current qualified-promotion admission.

`read_retained_provider_authority` composes those current readers with the actual
project configuration and installed Standard binding observer. It derives the
qualification identity from reopened evidence, the verifier from the selected
current profile, and policy/distribution expectations from the installed authority.
Every recorded run must match the configured driver and measured distribution.
Its combined guard rechecks configuration, generation, profile, installed payload
and promotion, including installed bytes after promotion revalidation. It neither
advances a distribution pin nor creates runtime, workspace or cache state. The
importer still independently selects project, target, profile and logical model;
native commands/tools, library oracle, retained gates and transactional consumption
remain additional admission requirements.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 102–167).
