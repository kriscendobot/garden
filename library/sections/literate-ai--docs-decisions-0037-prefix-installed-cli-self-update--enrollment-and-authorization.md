---
title: "ADR 0037: Self-update enrollment and authorization"
source: docs/decisions/0037-prefix-installed-cli-self-update.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain]
status: current
---

> Abstract: Self-update is inert unless the launcher, absolute prefix, v2 manifest, private interpreter, and explicit enrollment all prove custody of the same prefix.

Completing prefix installation grants standing authority to replace only that prefix from the defined release channel. Existing v1 manifests do not enroll. CI, evidence runs, re-executed children, and `LITAI_NO_SELF_UPDATE=1` disable the path, while test prefixes opt out by default.

Checkout, editable, pip, pipx, Homebrew, APT, and WinGet installations retain their own upgrade authorities.

Source: [docs/decisions/0037-prefix-installed-cli-self-update.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0037-prefix-installed-cli-self-update.md) at commit `fcc40bc6`.
