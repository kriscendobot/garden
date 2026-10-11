---
title: "ADR 0047: Qualification and rollout"
source: docs/decisions/0047-native-cli-component-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [testing, agentic-sdlc]
status: current
---

> Abstract: Qualification requires schema and lock parity, realistic cross-platform CLI cases, complete delta enforcement, bound resources, substitution refusal, worker evidence, and an installed-wheel end-to-end fixture.

Implementation proceeds under the explicit maintainer acceptance recorded on
2026-09-25. Reconcile PR #484 by reimplementing reviewed slices against current
authority rather than merging it wholesale. Qualification must prove:

- authored Markdown, schemas, lock generation/validation and installed schema parity
  for the new Component and entrypoint kinds;
- single and multiple native CLI entrypoints with unambiguous ADR 0026 deployment-unit
  selection, plus targeted mixed-kind and malformed-kind refusals;
- help, invalid argv, standard input, file input, nonzero exit, stream and output-file
  cases on supported Linux, macOS and Windows targets;
- exact fixture modes and identities, complete filesystem-delta enforcement, binary
  artifacts, UTF-8 predicates, path/prefix collision and traversal refusal;
- timeout, process-tree termination, stdout/stderr and filesystem bounds;
- refusal of ambient executable substitution, changed packaged binaries, stale
  specifications/cases, changed target/Flavor selection and stale receipts;
- worker-owned execution with exact returned evidence and refusal of incompatible or
  changed workers; and
- a synthetic generated native CLI passing project validation, lock, build, test,
  package, independent acceptance and finalized receipt verification from an installed
  wheel.

Land in three reviewable slices: kind/schema/lock authority; local packaged acceptance
with the synthetic fixture; then worker and complete supported-platform qualification.
No slice may claim native CLI support from parser-only or mocked execution evidence.

Source: [docs/decisions/0047-native-cli-component-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0047-native-cli-component-acceptance.md) at commit `fcc40bc6`.
