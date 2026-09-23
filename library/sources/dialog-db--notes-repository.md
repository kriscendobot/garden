---
source: notes/repository.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 5
status: current
---

> Abstract: The credentials-and-authorization model for a dialog-db repository (the file is titled "Credentials"). A three-layer identity model — account (optional persistent recovery identity, `Option<Did>`), profile (per-device ed25519 identity), operator (ephemeral session key deterministically derived from the profile) — maps onto the UCAN chain `Subject → Profile { profile, account } → Operator`. Authorization requires a delegation chain that is either **local** (`subject → profile → operator`, unrecoverable on device loss) or **recovered** (`subject → account → profile → operator`, or `subject → account → operator`). Effects are grouped into capability domains (`authority`, `archive`, `memory`, `credential`, `space`, `storage`, `access`) defined in `dialog-effects`. Profiles and repositories are both named spaces whose credential is a signer (68-byte multicodec keypair, owner) or verifier (34-byte public key, delegate), stored at `{name}/credentials/self` (native) or IndexedDB database `{name}` (web). Opening a repository is a `space::Load`/`space::Create` two-step, wrapped by `Repository::open()/.load()/.create()`; an operator is built via `Profile::open(name).derive(context).allow(cap).build(storage)`. Invocation authorization runs through `access::Prove` against a `CertificateStore`, delegations import via `profile.access().save(chain)`, and `authority::Identify` returns the current chain.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [identity-layers-account-profile-operator](../sections/dialog-db--notes-repository--identity-layers-account-profile-operator.md) | ucan-authorization | current |
| [authorization-chain-and-capability-domains](../sections/dialog-db--notes-repository--authorization-chain-and-capability-domains.md) | ucan-authorization, local-first-sync | current |
| [named-spaces-and-credential-format](../sections/dialog-db--notes-repository--named-spaces-and-credential-format.md) | ucan-authorization, content-addressed-storage | current |
| [opening-and-operator-setup](../sections/dialog-db--notes-repository--opening-and-operator-setup.md) | ucan-authorization | current |
| [authorization-delegation-identification](../sections/dialog-db--notes-repository--authorization-delegation-identification.md) | ucan-authorization | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `18c640a0` (2026-07-05), authored by Irakli Gozalishvili. Part of the `notes/` storage cluster added in that commit (alongside `memory-layout.md`, `subject-routing-options.md`, `space-and-storage.md`). The identity model here is the runtime realization of the capability sketch in `notes/capability-sysstem.md`.
- Ingested in the `scholar-ingest-dialog-db-remainder-6` cycle (2026-07-06), the storage cluster.
