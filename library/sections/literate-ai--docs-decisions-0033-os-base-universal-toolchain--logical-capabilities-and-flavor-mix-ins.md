---
title: "ADR 0033: Logical capabilities and Flavor mix-ins"
source: docs/decisions/0033-os-base-universal-toolchain.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: A universal logical SBOM owns Python, Git, Git LFS, and a one-of coding-agent group, while selected language, package, build, accelerator, and OS Flavors contribute conditional mix-ins.

Node belongs to JavaScript Flavors, compilers to language Flavors, and build tools to their build Flavors rather than bloating the base. A Component or skill selects exactly the union of the mix-ins it needs, preserving one logical owner per capability.

Source: [docs/decisions/0033-os-base-universal-toolchain.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0033-os-base-universal-toolchain.md) at commit `fcc40bc6`.
