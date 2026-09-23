---
source: rust/dialog-capability/README.md
source_repo: dialog-db/dialog-db
source_commit: b4fb5ea9e23bfc515967353f485c3f19d00643be
source_date: 2026-02-12
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 3
status: current
---

> Abstract: The README for `dialog-capability`, dialog-db's Rust crate of capability-based authorization primitives — the *implemented* form of the `subject × command × policy` capability sketch that `notes/capability-sysstem.md` describes at design level. It introduces the capability **chain**: a root `Subject` (a resource identified by did:key, holding full authority `/`) narrowed through any number of `Attenuation` and `Policy` links down to an invocable `Effect`, with the accreted **ability path** (`/storage/get`) as the authorization semantics and prefix-inclusion (`/storage` includes `/storage/get`). The three key traits differ in what they constrain — `Policy` (parameters only), `Attenuation` (ability path plus parameters), `Effect` (path plus parameters, invocable, with an `Output`) — and an optional `ucan` feature makes the typed chains serialize to offline UCAN tokens. This is the crate the rest of dialog-db's authorization stack (`dialog-effects`, `dialog-operator`, `dialog-ucan`) builds on.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-chain-example](../sections/dialog-db--rust-dialog-capability-readme--overview-and-chain-example.md) | ucan-authorization, capability-security | current |
| [capability-space-and-ability-paths](../sections/dialog-db--rust-dialog-capability-readme--capability-space-and-ability-paths.md) | ucan-authorization, capability-security | current |
| [traits-policy-attenuation-effect](../sections/dialog-db--rust-dialog-capability-readme--traits-policy-attenuation-effect.md) | ucan-authorization, capability-security | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `b4fb5ea9` (2026-02-12), authored by Irakli Gozalishvili.
- The foundational authorization crate. The notes-level design counterpart is `notes/capability-sysstem.md` (subject/ability/policy) and `notes/scope-and-delegation.md` (the `Any`-rooted scope proposal); the domain-effects built on this crate are ingested from `rust/dialog-effects/README.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-9` cycle (2026-07-06), the first ingest of dialog-db's Rust crate docs.
