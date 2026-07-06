---
source: notes/capability-sysstem.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 4
status: current
---

> Abstract: Dialog's capability-system design sketch — an object-capability / UCAN authorization layer replacing pluggable storage backends with platform capabilities provided by environments (Roc/Unison/Elm effects lineage). Four sections: the overview (effects as application-to-platform commands, ocap as the only viable non-centralized access model, the `subject x command x policy` definition); subject/ability/policy (each a UCAN-delegation field, modeled as nested `Access<Inner, Outer>` Rust types over a did:key repository subject); effects and providers (the `Effect`/`Provider` traits, the `.claim()` composition DSL, capability acquisition via trait-bounded environments); and the proposed concrete capability set (Archive get/put over Blake3 digests, Memory resolve/publish cells with CAS, the `Acquire` meta-capability). The Archive/Memory split is the capability-shaped restatement of the architecture overview's blob-store + mutable-pointer decoupling. NOTE: the upstream filename carries a typo ("capability-sysstem.md"); the slug preserves the actual path.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/dialog-db--notes-capability-sysstem--overview.md) | capability-security, ucan-authorization | current |
| [subject-ability-policy](../sections/dialog-db--notes-capability-sysstem--subject-ability-policy.md) | capability-security, ucan-authorization | current |
| [effects-and-providers](../sections/dialog-db--notes-capability-sysstem--effects-and-providers.md) | capability-security | current |
| [proposed-capabilities](../sections/dialog-db--notes-capability-sysstem--proposed-capabilities.md) | ucan-authorization, capability-security, content-addressed-storage | current |

## Provenance

- Repository default branch `main`, file at HEAD `f777fe7c` (2026-07-05), authored by Irakli Gozalishvili. The upstream path is `notes/capability-sysstem.md` (double-`s` typo in the filename); the section slugs preserve the path faithfully for idempotency.
- A design sketch (proposed, not fully implemented); the `dialog-capability`, `dialog-ucan`, `dialog-ucan-core`, and `dialog-varsig` Rust crates realize parts of it and are deferred to a follow-on `scholar-ingest-dialog-db` job.
