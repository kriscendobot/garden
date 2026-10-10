---
title: "Retained library bindings: producer capture and evidence publication"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, content-addressed-storage]
status: current
---

> Abstract: Optional producer capture retains package bytes and lifecycle/oracle/parity payloads before qualification scratch is discarded, under one synchronized recorder (256 MiB, 100,000 records; overruns refuse rather than drop); `--retained-evidence-store PATH` writes the canonical archive to the local immutable store and reopens it, publication failure blocks admission, orphaned CAS objects are never deleted, and authority/oracle drift mid-run refuses.

Optional producer capture now retains immutable package bytes and existing lifecycle,
root-package, component-stage, oracle and parity payloads before qualification
scratch is discarded. One synchronized recorder bounds unique records and bytes
across concurrent component producers. Raw SBOM, generated-suite and harness bytes
retain their original identities. npm replay retains its existing process/build
observations, target/source authority and exact dependency-evidence files under
the same recorder bounds. Captures become visible only after every run
succeeds and fits the aggregate budget; failure releases runtime references and
exposes no partial capture. The public qualification CLI enables this capture only when the caller supplies
`--retained-evidence-store PATH` for a library root. It writes the bounded canonical
archive to the existing local immutable evidence store, verifies stored bytes and
reopens the lifecycle result before deleting owned scratch. The selected store must
be outside scratch and the retained source baseline. The successful result and result file retain the exact archive
blob reference, qualification identity and each run's export-set identity. The
limit is 256 MiB, including archive overhead, and 100,000 records; exceeding either
refuses rather than dropping evidence. No endpoint is provisioned or uploaded to.

Publication failure prevents qualification admission. Final current-authority,
source-baseline and promotion checks still run. A later failure may leave an
unreferenced immutable CAS object, which is not removed because another transaction
could reference it. Persisted transport bytes do not authorize consumer admission;
the importing maintainer's binding and current evidence checks remain required.

Before exposing retained captures, the producer rechecks its prepared authority
snapshot, installed Standard distribution/policy and verifier-owned acceptance
oracle. Final qualification admission repeats those checks and reopens the current
promotion evidence before writing qualification records. Mid-run harness, oracle,
distribution or promotion-evidence drift refuses admission. These checks do not
replace the remaining required-stage verification and durable bundle transaction.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 169–197).
