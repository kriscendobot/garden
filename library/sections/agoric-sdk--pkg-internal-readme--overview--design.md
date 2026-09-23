---
title: Design
source: packages/internal/README.md
source_repo: agoric/agoric-sdk
source_commit: 059a66a1ebec72f9f8015ff010fed5fc902ed907
source_date: 2025-09-16
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: The "deep imports only" rule is a bundle-size optimization for downstream `@endo/bundle-source` consumers — without it, importing one helper from internal pulls the whole package. The "may not depend on other repo packages except base-zone/store/cosmic-proto" rule is a hard internal-dependency boundary that contributors must respect.
parent: agoric-sdk--pkg-internal-readme--overview
---

It is meant to be a home for modules that have no dependencies on other packages in this repository, except for the following packages that do not theirselves depend upon any other @agoric packages and may be destined for migration elsewhere:

- [base-zone](../base-zone)
- [store](../store)
- [cosmic-proto](../cosmic-proto)

This package may not take dependencies on any others in this repository.

It must never export ambient types.

Source: [packages/internal/README.md](https://github.com/Agoric/agoric-sdk/blob/059a66a1ebec72f9f8015ff010fed5fc902ed907/packages/internal/README.md) at commit `059a66a1`.
