---
title: "Retained library bindings: lifecycle, build, generated-test, and SBOM reopening"
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

> Abstract: Lifecycle reopening reconstructs every node, plan, schedule, and cache membership through the producer validators (sharing decoded duplicates to bound malicious expansion); build reopening requires exact process records and pre/post-manifest artifact tree identities; generated-test reopening checks every case once against a caller-projected current recipe; SBOM reopening revalidates CycloneDX graphs; and an independent library-acceptance check reopens the verifier-owned oracle's observations.

Lifecycle reopening reconstructs nodes, component/project plans, schedules, cache
memberships, context evidence and root integration through the existing producer
validators. Every reconstructed identity must match its pinned record. Repeated
references share one decoded object within the operation, bounding repeated
expansion of malicious duplicate references; lifecycle validators still reject
inconsistent membership. Run reopening also checks the existing execution-process
records against each exact build plan, execution phase, successful integer exit
status and retained text stdout/stderr. Multiple-entrypoint execution requires
every unit record and the exact aggregate observations, runtime set and output
maps. Missing records, rehashed substitutions or extra fields refuse before
product bytes. Build reopening also requires the exact build wrapper and command
process, or npm target/dependency/install/inventory/syntax-check records. Retained
npm manifest and lock bytes use the same bounded graph parser as the filesystem
loader; inventory and dependency membership must match that graph and build plan.
The filesystem loader still owns package-root discovery. Complete source/export
custody and command authorization remain separate checks.
Capture retains the existing artifact tree identity documents before and after
the build metadata manifest is written, plus that manifest's exact bytes. The
build observation commits to the former tree; artifact custody commits to the
latter. These distinct identities must not be compared as if they described the
same file set. Every reopened build requires the final tree to add exactly that
manifest to the observed tree, with unique valid file entries, matching resolved
SBOM bytes identity, and exact custody plan/export membership. The raw manifest
must retain its producer serialization and name the same tree and observation;
duplicate JSON keys and rehashed file substitutions refuse. Missing tree or
manifest records in any clean run block package bytes. Retention remains bounded
by the shared evidence budget. Complete custody verification still needs source
files, export path/byte relationships, and provider-material authority checks.
Generated-test reopening requires every original case record and attributed
observation, one matching successful process per suite/entrypoint, and exact
case results in retained text stdout. Missing/duplicate/failed cases, duplicate
JSON keys, foreign phases/plans/entrypoints, non-text outputs and extra fields
refuse. Multiple-entrypoint aggregates must reconstruct from the exact unit
records and observations. Product reopening requires a caller-projected current
recipe for every and only locked Component. Every clean run validates its suite
and exact case membership against that recipe, and both source candidate and
provenance must name the same recipe. A missing suite in a later run blocks all
package-byte reads. Producer capture reprojects each recipe through the
runtime's configured node-preparation adapter against guarded current locked
authority. It reuses generated-suite validation for recipe identity, permitted
specification references, invocation coverage and result shape, then checks every
retained case definition and exact per-entrypoint membership. A refusal prevents
retention of that run's product context. Source/artifact custody, command
authorization, root-package and parity process checks remain required before
complete importer admission.

Product reopening also projects each Component's managed CycloneDX graph from the
current lock, requires its retained graph record, and revalidates both raw source
and resolved BOMs against that graph. Resolved validation uses the exact retained
source bytes to check the lifecycle transition. Recomputed bindings must equal
the typed build evidence; missing documents, substituted Component identities or
misstated counts refuse before package bytes. This verifies dependency evidence;
source/artifact file-tree custody and execution authorization remain separate.

Independent library-acceptance reopening takes the current provider lock and
verifier-owned oracle supplied by the trusted caller. It requires their exact
Component/interface/import bindings and retained oracle, harness, case and expected
result records. The recorded observations must cover every exact case once and
bind the same root artifact, package plan/result and root test/execution evidence.
The native JavaScript fixture reopens an actual Node oracle's observations after
its package directory is removed, without executing the package again. These are
content and relationship checks; authenticating the provider and importing trust
remain separate obligations. Run-product reopening now composes the typed
lifecycle and independent library-oracle checks. The complete required-record
verifier must still add remaining stage checks and current provider authority
before durable publication or consumption.

Source: [docs/architecture/retained-library-bindings.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/retained-library-bindings.md) at commit `fcc40bc` (source lines 293–358).
