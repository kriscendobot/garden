---
title: TypeScript Usage (overview)
source: docs/typescript.md
source_repo: agoric/agoric-sdk
source_commit: ffed404d
source_date: 2026-02-04
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [typescript-conventions]
status: current
---

> Abstract: Agoric-sdk's TypeScript conventions. Referenced from endo's AGENTS.md as the canonical typescript-conventions source. Soft-flag overlap with endo--agents--typescript-usage (same rules, different repo's framing).

# usage of TypeScript

Our use of TypeScript has to accommodate both .js development in agoric-sdk (which could not import types until TS 5.5) and .ts development of consumers of agoric-sdk packages (which could always import types). For .js development, we have many ambient (global) types so that we don't have to precede each type reference by an import. For .ts development, we want exports from modules so we don't pollute a global namespace. We are slowly transitioning away from ambient types.


Source: [docs/typescript.md](https://github.com/agoric/agoric-sdk/blob/ffed404d/docs/typescript.md) at commit `ffed404d`.
