---
title: "Retained library bindings: run-product reopening of source, generator, and build records"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Run-product reopening first verifies canonical record membership and digests, binds the selected run to its lifecycle result, root graph, and export set, then requires each clean run to reconstruct its typed lifecycle and the exact source candidate/custody records, the generator's invocation/plan/stage/route records, the source-index and security-build records, and current typed command contracts for every locked Component, refusing rehashed substitutions before any package bytes are read.

A bounded reader verifies canonical unique record membership and every digest,
then reopens exact bytes or canonical JSON. Run-product reopening first binds the
selected run to its lifecycle result,
aggregate receipt, root graph/package, target, policy and project receipt. The root
graph and selected link must match the export set before package reads. Every
clean run must then reconstruct its complete typed lifecycle and derive the exact
source, index, build, SBOM, test, acceptance, cache and workspace memberships using
the producer's qualification validator. Accepted-node custody and generated source
tree/SBOM/test-suite bindings must agree. Reopening requires the exact retained
candidate document and source-custody record for each accepted node. Custody must
name that candidate, generation result, source tree, source BOM, managed graph
and generated suite without extra fields. Rehashed substitutions or missing
records in any run refuse before product bytes. This record binding does not
replace source-file inventory and byte verification. Producer capture opens the
existing candidate CAS read-only and preserves its exact generation manifest,
typed `SourceBundleClosure` root, all referenced source bytes, and final model-stage
record before retaining a product context. It checks manifest/candidate fields,
canonical records, the semantic path/size/digest tree, file integrity and shared
byte/record limits. Missing, changed or oversized input refuses capture.
The generator also retains its existing invocation, execution-plan, stage-request
and final route-decision payloads in CAS under their unchanged identities.
Capture preserves these canonical records with the shared byte/record limits;
missing authority payloads refuse capture. Every retained-product run then binds
the final stage and selected route to its accepted provenance, the invocation's
root/readiness identities, exact stage request and plan, source tree/bundle, and
planned coding-CLI request. The final plan stage must produce the tree and its
route must match the typed retained route decision. Provider-evidence membership
must agree; missing records, extra stage fields and rehashed substitutions refuse.
Each run also reopens its local source-index record, exact security build request,
build intent and historical grant. Component/source identities, classification,
compiler, privileges and declared outputs must agree with the realized build plan;
revoked grants or missing records refuse before package reads. The index's typed
file count includes auxiliary metadata and is not the semantic source-bundle count.
The caller must also supply current typed command contracts for every and only
locked Component. Each run binds its request's builder and sandbox, resolver,
build-system toolchain, compiler, runtime, export shapes and existing build/resolve
action names to those contracts. The exact contract, commands and per-entrypoint
command records must be retained. Missing authority, changed commands or rehashed
foreign tool/export bindings refuse before package reads. These comparisons do
not establish which argv was launched or authenticate measured executable bytes.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 199–238).
