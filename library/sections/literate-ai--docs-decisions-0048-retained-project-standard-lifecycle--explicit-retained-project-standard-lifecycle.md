---
title: "ADR 0048: Explicit retained-project Standard lifecycle"
source: docs/decisions/0048-retained-project-standard-lifecycle.md
source_repo: jordanhubbard/literate-ai
source_commit: 8fbe58f9b78fcba279cba09385121545e9ba9b7d
source_date: 2026-10-02
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, capability-security]
status: current
---

> Abstract: An opt-in retained-project mode binds a complete reviewed input closure, read-only plan, locked action graph, full acceptance inventory, distinct retained-origin receipt, and separately authorized packaging and release.

Add an explicitly selected retained-project execution mode to the Standard lifecycle.
It must have a distinct typed admission record and receipt origin. Existing generated
and small retained-source modes retain their current behavior and fail-closed gates.
No adopted project opts in implicitly, and execution never advances conversion stage.

A reviewed manifest declares the complete input closure, including source, binary
assets, build/test/documentation definitions, dependency locks, SDK/toolchain identities,
platform filters, and the applicable test and package inventories. Every member binds
its canonical relative path, byte length, executable mode, digest and ownership role.
Declared entry/per-file/aggregate byte limits are positive, enforced, and bound to the
plan; capture streams large files into content-addressed storage rather than loading
the project into one text dictionary. Missing, extra, changed, colliding or redirected
inputs fail admission. Links and special files are rejected until a separate explicit
contract qualifies their custody. Mutable caches and credentials are never inputs.
External dependencies are admitted by exact identities and manifests; linking an
ambient checkout or finding an installed SDK does not qualify it.

Read-only planning validates project/Component/Flavor/lock authority and the existing
conversion record without executing build tools or acquiring unreviewed dependencies.
The resulting plan names its exact input, target, worker/toolchain, command-profile,
output, resource-limit and acceptance identities. Execution requires acknowledgment
of that identity plus the existing host/worker authorization. Any changed plan input
requires a new review; the ordinary regenerative release route continues to reject
unqualified conversion authority.

Standard execution materializes an isolated immutable input snapshot and runs the
locked build profile and complete declared test/documentation inventory. Staging,
generation, native compilation and dependency acquisition are explicit graph inputs
and actions; root command names are not evidence of stage coverage. Existing Standard
validation, artifact/SBOM custody, containment, acceptance, cache invalidation and
receipt verification remain mandatory. Failures, missing suites, unauthorized skips,
missing artifacts or changed post-execution inputs prevent acceptance. Retained-project
receipts must bind original test identity/skip policy and packaged-payload provenance
when the project's contract requires them. A baseline exception is not a test pass.

Packaging consumes only the accepted closure through the selected existing package
provider. A separately authorized release can publish that retained-origin artifact
only after its current receipt and original release-authority policy pass. Such a
receipt never asserts regenerative source authority or permits a conversion-stage
transition. Ordinary receipts and retained-project receipts cannot substitute for one
another. Legacy repository commands may adapt argv/exit status to these public verbs;
they may not invoke an independent build/test/publication acceptance path.

Source: [docs/decisions/0048-retained-project-standard-lifecycle.md](https://github.com/jordanhubbard/literate-ai/blob/8fbe58f9b78fcba279cba09385121545e9ba9b7d/docs/decisions/0048-retained-project-standard-lifecycle.md) at commit `8fbe58f9`.
