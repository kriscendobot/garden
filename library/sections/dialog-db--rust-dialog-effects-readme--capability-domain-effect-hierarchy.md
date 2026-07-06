---
title: The capability-domain effect hierarchy
source: rust/dialog-effects/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, content-addressed-storage]
status: current
---

> Abstract: `dialog-effects` defines the concrete capability hierarchy types for dialog-db — the domain-specific attenuations, policies, and effects (built on `dialog-capability`'s `Subject`/`Attenuation`/`Policy`/`Effect` traits) that form the actual capability chains, one module per capability *domain*. Six domains are defined: **access** (authorization and delegation — `Prove` and `Retain`, rooted at a profile DID); **storage** (bootstrap-space operations used during setup before the operator is built, rooted at `did:local:storage`); **space** (operator-level space operations that open repositories after bootstrap); **archive** (content-addressed block storage — `Get`/`Put` by digest, rooted at a repository DID); **memory** (transactional memory cells for branch state — `Resolve`/`Publish`/`Retract`, rooted at a repository DID); and **credential** (credential read/write for identity persistence, rooted at `did:local:storage`). The effects are *structural types only* — storage providers in `dialog-storage` implement `Provider<Fx>` for each effect, cleanly separating the authorization shape from its execution. This is the implemented, per-crate form of the "seven capability domains" the `notes/repository.md` design references.

## Effects are structural

`dialog-effects` defines the domain-specific attenuations, policies, and effects that form capability chains. Each module corresponds to a capability domain. The effects are structural types only; storage providers in `dialog-storage` implement `Provider<Fx>` for each effect.

## access — authorization and delegation

```text
Subject (profile DID)
└── Access
    ├── Prove { principal, access, duration } → Proof
    └── Retain { delegation } → ()
```

## storage — bootstrap space operations (before the operator is built)

```text
Subject (did:local:storage)
└── Storage
    └── Location { directory, name }
        ├── Load → Credential
        └── Create { credential } → Credential
```

## space — operator-level space operations (after bootstrap, to open repositories)

```text
Subject (profile DID)
└── Space { name }
    ├── Load → Credential
    └── Create { credential } → Credential
```

## archive — content-addressed block storage

```text
Subject (repository DID)
└── Archive
    └── Catalog { name }
        ├── Get { digest } → Option<Vec<u8>>
        └── Put { digest, content } → ()
```

## memory — transactional memory cells for branch state

```text
Subject (repository DID)
└── Memory
    └── Space { name }
        └── Cell { name }
            ├── Resolve → Option<Vec<u8>>
            ├── Publish { content } → ()
            └── Retract → ()
```

## credential — credential read/write for identity persistence

```text
Subject (did:local:storage)
└── Credential
    └── Address { address }
        ├── Load → Credential
        └── Save { credential } → ()
```

Source: [rust/dialog-effects/README.md](https://github.com/dialog-db/dialog-db/blob/a898b5de44a29e5be30a1faa99f11ef7a5332d69/rust/dialog-effects/README.md) at commit `a898b5de`.
