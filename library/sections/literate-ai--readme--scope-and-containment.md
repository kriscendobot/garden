---
title: Current scope and containment boundary
source: README.md
source_repo: jordanhubbard/literate-ai
source_commit: 76f498a824f74ec94ee7d03500913025579fb15f
source_date: 2026-10-04
source_authors: [jkh]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: The reference implementation spans several languages, operating systems, and build systems and guards host execution with provenance checks, but explicitly does not claim to be a hardened operating-system sandbox for hostile generated code.

The Python 3.11+ implementation live-tests Python, C++17, Rust 2021, JavaScript, Swift, and composite Rust/JavaScript applications across macOS, Linux, and Windows. Make is the initialized-project default, while Bazel and CMake remain selectable policies rather than framework invariants.

This breadth is not a confinement guarantee. The README states that guarded host execution and strict provenance checks are present, but arbitrary hostile generated source is outside the current sandbox boundary. A consumer must therefore distinguish evidence-bound execution from hardened isolation.

Source: [README.md](https://github.com/jordanhubbard/literate-ai/blob/76f498a824f74ec94ee7d03500913025579fb15f/README.md) at commit `76f498a`.
