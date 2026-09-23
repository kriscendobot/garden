---
title: The layer stack — durable and transient query sources
source: notes/layered-rule-resolution.md
source_repo: dialog-db/dialog-db
source_commit: 00b43561a10383175a7f794fee7cb0894b0222e7
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: A concept query reads from a stack of **layers**, each providing both **facts** and **deductive rules**, unioned the same way. There are two layer kinds: a **durable layer** (one per branch in scope — facts from the branch's committed tree, rules from `db.rule/*` facts on that tree) and a **transient layer** (the per-query `Changes` overlay from `.with(...)` and a transaction's pending writes — facts and rules both from the in-memory batch). `QueryEnv` (`repository/branch/session.rs`) composes the stack, holding the branches plus overlay and implementing `Provider<Select>` (facts) and `Provider<SelectRules>` (rules); a transaction query is just a single-branch `QueryEnv`, so committed and mid-transaction reads share one implementation and cannot diverge.

A concept query reads from a stack of **layers**, each providing both **facts** and **deductive rules**. Facts are unioned across a branch's tree, any joined branches, and the per-query overlay; rules are resolved the same way. This note records how that works and why.

## Layers

Each layer in the stack is a query source:

- **Durable layer** — one per branch in scope. Facts come from the branch's committed tree; rules come from `db.rule/*` facts on that tree.
- **Transient layer** — the per-query `Changes` overlay (`.with(...)` and a transaction's pending writes). Facts and rules both come from the in-memory batch.

`QueryEnv` (`repository/branch/session.rs`) composes the stack: it holds the branches + overlay and implements `Provider<Select>` (facts) and `Provider<SelectRules>` (rules). A transaction query is just a single-branch `QueryEnv`, so committed and mid-transaction reads share one implementation and cannot diverge.

Source: [notes/layered-rule-resolution.md](https://github.com/dialog-db/dialog-db/blob/00b43561a10383175a7f794fee7cb0894b0222e7/notes/layered-rule-resolution.md) at commit `00b43561`.
