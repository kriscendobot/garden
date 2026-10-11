---
title: "ADR 0047: Native CLI acceptance gap"
source: docs/decisions/0047-native-cli-component-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Native command-line programs do not implement the portable JSON application ABI, yet generic Components reject the authored native kind and a draft proposal leaves ambient executables and filesystem changes under-specified.

The portable application contract intentionally accepts one JSON argument and emits one
JSON result. A native command-line program instead owns ordinary argument vectors, exit
status, standard streams, file inputs and output artifacts. Reclassifying such a
program as `portable-application` would misstate its public interface, while classifying
it as a generic Component currently makes project validation reject its authored
`native-cli-application` kind before lifecycle work can begin.

Draft PR #484 demonstrates a useful direction: a distinct Component and entrypoint kind
plus verifier-owned cases. It is not current authority. The draft describes its
argument model as POSIX despite supported Windows targets, admits executable paths from
ambient environment variables, reads those executables outside accepted dependency
custody, and validates only named output files rather than the complete filesystem
delta. It also lacks a synthetic end-to-end Component proving locks, selected native
Flavors, packaged executable custody and receipt invalidation.

Source: [docs/decisions/0047-native-cli-component-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0047-native-cli-component-acceptance.md) at commit `fcc40bc6`.
