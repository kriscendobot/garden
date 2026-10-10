---
title: "Retained library bindings: parity observations, driver binding, and the library oracle"
source: docs/architecture/retained-library-bindings.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [testing, agentic-sdlc]
status: current
---

> Abstract: Parity observations decode strict UTF-8 JSON and compare by qualification's canonical semantic digest (type-preserving, whitespace/key-order insensitive); product reopening requires the caller's current Standard driver, current qualification profile (verifier, case map, exact commands, zero exits, output bounds), current recipes, provider lock and verifier-owned library oracle, plus packaged-test and smoke records, while stating that historical integrity grants no execution permission.

Filesystem parity observations decode strict UTF-8 JSON with unique object keys
and finite numbers. They use qualification's existing semantic JSON digest, which
supports finite floats and integers beyond artifact JSON v1's signed 64-bit range.
Baseline/generated results compare by that canonical content identity, preserving JSON types (including boolean versus number and integer
versus floating-point representation), while ignoring whitespace and object-key
order. Malformed results retain their raw output bytes and a false validity flag.
The producer also retains the existing baseline `SourceInventory` document under
its already-checked snapshot identity, with the shared evidence size limit. Parity
reopening restores that record through the existing inventory parser and checks its
identity before accepting observations. The inventory describes paths, file digests,
classifications and exclusions; it does not include original file contents or prove
which original bytes a process executed.
Producer capture rechecks current provider authority, Standard binding and the
independent oracle after all package reads and before exposing retained packages
or evidence. A failed final check clears scratch references and exposes neither.
Product reopening also requires the caller's current typed Standard driver.
Every run's driver, lifecycle-policy and framework-distribution identities must
match that binding; agreement between historical runs is insufficient. The driver
contract reconstructs its own identity from the two pinned authority identities.
The caller remains responsible for independently resolving and guarding the current
binding; this comparison does not observe an installed distribution by itself.
Product reopening requires the caller's current qualification profile and its
minimum clean-run count. It reconstructs the verifier identity and complete case
map, reopens the profile/provider/map/parity/case records, and verifies every
baseline/generated observation's exact command (including unexpanded generated
path placeholders), integer zero exit status and true JSON-validity flag. Raw
stdout/stderr must fit the profile's output bound; the same strict parser and
canonical result comparison recompute each passing parity claim. This verifies
baseline/generated equivalence; independent expected-result acceptance remains a
separate oracle gate. Source-baseline custody, actual launcher/invocation proof
and importer trust still require completion.
Historical record integrity does not grant execution permission: attributable
execution-time validity, current execution policy and importer trust remain required. Current tool/route policy admission and verification of any referenced
provider attestation remain required. These
are the existing generator records, not a new source serialization. Every clean
run reopens that source closure through the same verifier before product reads,
without a filesystem or generation provider. Referenced byte lengths must match;
the source BOM and generated suite must occupy their declared paths with the
candidate's exact identities. Missing manifest/tree/file/stage records, false
sizes and rehashed path substitutions refuse. Full generation-stage authority
verification remains required. The caller supplies the current provider
lock and verifier-owned library oracle. Every clean run must reopen its root
package acceptance, exact harness, cases and observed results against those inputs
before the selected run's typed acceptances and pinned package bytes are returned.
Library packages also require their existing packaged-root generated-test and smoke
execution process records, bound to the exact package plan with integer zero status
and retained text stdout/stderr. Packaged tests must pass every current root suite
case exactly once; duplicate JSON fields, extra/failed/missing cases, foreign plans
and blank smoke output refuse. This verifier applies to library packages with no
product entrypoints. It does not prove invocation custody, native execution or
independent acceptance by itself. Existing
embedded receipt evidence-set commitments are recomputed rather than assuming
every digest names a standalone payload.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 239–291).
