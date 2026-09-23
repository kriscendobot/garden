---
title: Storage core types — Location, Space, and Storage
source: notes/space-and-storage.md
source_repo: dialog-db/dialog-db
source_commit: 18c640a06797b62eb3c57f3aeedb016634a5da19
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization]
status: current
---

> Abstract: Storage is the runtime environment that routes capability effects to the correct backend providers via a two-level dispatch — first by subject DID (which space), then by capability (which provider within that space). Three core types: a **`Location`** combines a `Directory` (an enum of logical address categories — `Profile`, `Current`, `Temp`, `At(String)`) with a name, and each backend resolves a `Location` to its platform-specific path (the `StorageFx` sugar creates locations, e.g. `StorageFx::profile("alice")`). A **`Space<A, M, C, D>`** is a `#[derive(Provider)]` product of an archive, memory, credential, and certificate provider, generating capability dispatch (`archive::Get` → `archive`, `memory::Resolve` → `memory`, etc.). **`Storage<S: SpaceProvider>`** composes a `Loader` (space bootstrap via `storage::Load`/`storage::Create`) with a `Router` (DID-based dispatch for all other effects); platform defaults are `NativeSpace` over `FileSystem` and `WebSpace` over `IndexedDb`, chosen by `Storage::default()`.

## Overview

Storage is the runtime environment that routes capability effects to the correct backend providers. It uses a two-level dispatch: first by subject DID (which space), then by capability (which provider within that space).

## Core Types

### Location

A struct combining a directory kind with a name:

```rust
pub struct Location {
    pub directory: Directory,
    pub name: String,
}
```

`Directory` is an enum of logical address categories:

```rust
pub enum Directory {
    Profile,   // platform profile directory (~/Library/.../dialog/ on macOS)
    Current,   // working directory (.dialog/)
    Temp,      // temporary directory
    At(String) // custom path
}
```

Each backend resolves a `Location` to its platform-specific path. The `StorageFx` sugar creates locations:

```rust
StorageFx::profile("alice")   // Location { directory: Profile, name: "alice" }
StorageFx::temp("scratch")    // Location { directory: Temp, name: "scratch" }
```

### Space

A composed product of providers that routes capabilities to the correct backend:

```rust
#[derive(Provider)]
pub struct Space<A, M, C, D> {
    #[provide(archive::Get, archive::Put)]
    archive: A,

    #[provide(memory::Resolve, memory::Publish, memory::Retract)]
    memory: M,

    #[provide(credential::Load<Credential>, credential::Save<Credential>)]
    credential: C,

    #[provide(access::Prove<P>, access::Retain<P>)]
    certificate: D,
}
```

`#[derive(Provider)]` generates capability dispatch: `archive::Get` goes to `archive`, `memory::Resolve` goes to `memory`, etc.

### Storage

Composes a `Loader` (for space bootstrap via `storage::Load`/`storage::Create`) and a `Router` (DID-based dispatch for all other effects):

```rust
#[derive(Provider)]
pub struct Storage<S: SpaceProvider> {
    #[provide(storage::Load, storage::Create)]
    loader: Loader<S>,

    #[provide(archive::Get, archive::Put, memory::Resolve, ...)]
    router: Router<S>,
}
```

Platform defaults:
- **Native**: `NativeSpace` backed by `FileSystem` providers
- **Web**: `WebSpace` backed by `IndexedDb` providers

`Storage::default()` creates the platform-appropriate configuration.

Source: [notes/space-and-storage.md](https://github.com/dialog-db/dialog-db/blob/18c640a06797b62eb3c57f3aeedb016634a5da19/notes/space-and-storage.md) at commit `18c640a0`.
