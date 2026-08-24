---
title: Bundled formats and administrative curation
source: docs/blueprints.md
source_repo: cloudflare/cloudflare-os
source_commit: 69c39d5037609b7efe8e2ed7e704e86bb1ce7002
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [reusable-app-blueprints, agent-workspaces]
status: current
---

Cloudflare OS separates a Blueprint's self-declared presentation from an administrator's decision to feature it as a standard document format.

A Blueprint may declare an output grouping, nouns, and an icon, but this grants no status. Admin configuration promotes selected Blueprints into menu formats and may override their presentation on every instantiation path.

Deployments may bundle `.gadget` archives and JSON sidecars as data. Bundled Blueprints use stable readable IDs, have no owning User DO, and take output presentation from the sidecar. A manifest fingerprint triggers installation when content or presentation changes, but promotion occurs only once so upgrades do not undo later administrator choices.

Source: [docs/blueprints.md](https://github.com/cloudflare/cloudflare-os/blob/69c39d5037609b7efe8e2ed7e704e86bb1ce7002/docs/blueprints.md) at commit `69c39d50`.
