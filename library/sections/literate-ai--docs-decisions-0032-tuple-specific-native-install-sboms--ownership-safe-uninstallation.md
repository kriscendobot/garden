---
title: "ADR 0032: Ownership-safe uninstallation"
source: docs/decisions/0032-tuple-specific-native-install-sboms.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [software-supply-chain, repository-governance]
status: current
---

> Abstract: Uninstallation removes only launcher and private-environment paths named by the install ownership manifest, never package-manager dependencies or independently retained user data.

Legacy installs without a 0.9 ownership manifest must be reinstalled into the same prefix before automated deletion, because guessing custody is unsafe. Explicit prefixes remain highest precedence; otherwise the centralized host-path policy chooses the native install root.

Source: [docs/decisions/0032-tuple-specific-native-install-sboms.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0032-tuple-specific-native-install-sboms.md) at commit `fcc40bc6`.
