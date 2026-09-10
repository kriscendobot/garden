# Cloudflare Artifacts as an Endo Git and filesystem backing

| | |
|---|---|
| **Created** | 2026-09-10 |
| **Updated** | 2026-09-10 |
| **Author** | gardener |
| **Status** | Analysis |

## Finding

Cloudflare Artifacts fits Endo best as a managed Git remote and immutable Git
object service behind Endo's existing capability surfaces. It should not replace
Endo's `Filesystem` abstraction or the daemon's formula and pet-name stores.

The narrow first integration is a Cloudflare Worker host adapter:

1. Hold the namespace-level Artifacts binding only in trusted host code.
2. Represent one selected Artifacts repository as an Endo `GitRemote`
   capability with fixed repository, ref, and read or write policy.
3. Implement a Worker-compatible `GitBackend` with isomorphic-git over an Endo
   `Filesystem` adapter. Continue using the existing `makeGitFsBackend` and
   `wrapBackend` path for `Git.filesystemAt(ref)`.
4. Keep mutable, uncommitted working-tree state in a separate `FsBackend`.
   A commit and successful push are the boundary at which Artifacts has made
   that state durable.

This preserves Endo's separation between content authority, versioning,
network credentials, and historical reads. It also avoids making a vendor's
account-scoped binding part of the guest authority model.

## What Cloudflare Artifacts provides

Artifacts is a managed Git service whose unit is an isolated repository. Each
repository has its own history, refs, remote URL, credentials, and lifecycle.
Repositories live in namespaces, can be imported or forked, and are intended to
scale to one repository per agent or session. Cloudflare documents synchronous
replication across multiple data centers plus asynchronous copies to object
storage and snapshots.

The service has three access surfaces:

| Surface | Useful operations | Boundary |
|---|---|---|
| Git-over-HTTPS | clone, fetch, pull, push | Full Git data path; short-lived repository read or write token |
| REST | repository lifecycle plus commit, tree, blob, and file reads | Cloudflare API token and account path |
| Worker binding | repository lifecycle, fork/import, token management, log, commit, and tree reads | Configured namespace binding; no file mutation or blob-read method |

The Git protocol supports upload-pack versions 1 and 2. Push uses receive-pack
version 1. Some optional fetch filters are absent. The object read APIs expose
Git SHA-1 commit, tree, and blob identities.

Artifacts is in closed beta. Published limits include 10 GB per repository and
1 TB per account by default. Operations and retained storage are billable on
Workers Paid after included quantities. These are prototype constraints, not a
stable portability contract.

Cloudflare sources:

- [Product page](https://www.cloudflare.com/products/artifacts/)
- [Technical overview and durability](https://developers.cloudflare.com/artifacts/concepts/how-artifacts-works/)
- [Git protocol](https://developers.cloudflare.com/artifacts/api/git-protocol/)
- [Worker binding](https://developers.cloudflare.com/artifacts/api/workers-binding/)
- [isomorphic-git Worker example](https://developers.cloudflare.com/artifacts/examples/isomorphic-git/)
- [ArtifactFS](https://developers.cloudflare.com/artifacts/guides/artifact-fs/)
- [Limits](https://developers.cloudflare.com/artifacts/platform/limits/)

## Comparison with Endo's current stack

Endo's implementation already separates concerns that Artifacts presents as one
managed product.

| Concern | Endo | Cloudflare Artifacts | Relationship |
|---|---|---|---|
| Live content | A confined mutable `Filesystem` or `EndoMount` | No mutable-file API in the Worker binding | Endo still needs a working-tree backing |
| Versioning | `Git`, derived from an authorized mount | Git repository service | A portable backend can join them |
| Network and credential | Separately granted `GitRemote` | HTTPS remote plus repo-scoped token | Strong alignment if the token remains host-held |
| Historical read | `Git.filesystemAt(ref)` returns a read-only `Filesystem` | Commit/tree/blob reads by Git OID | Strong alignment through `GitBackend` |
| Storage adapter | `FsBackend` under `wrapBackend` | REST reads or Git protocol | Add an adapter, not a new guest interface |
| Content identity | Git OID-backed QID and `BlobRef` with `git-sha1` | SHA-1 commit/tree/blob identifiers | Direct identity mapping |
| Durable daemon state | Formula, pet-name, and capability state | Repository state only | Keep these stores separate |
| Isolation | Capability confinement and attenuation | Repository, token, and namespace boundaries | Provider isolation complements but does not replace capabilities |

The current Endo historical adapter is already shaped for this substitution.
`makeGitFsBackend({ backend, treeOid })` consumes `GitBackend` operations for
tree resolution, listing, and blob bytes. It exposes immutable history through
`wrapBackend`, preserves Git object identity in QIDs and `BlobRef`s, and rejects
mutation. The shipped native backend reaches these objects with a local Git
executable. A Worker implementation can supply the same backend contract without
changing the public `Filesystem` API.

The broader Endo roadmap also states that files are edited through the content
capability, Git records the edits, `GitRemote` alone crosses the network, and
historical views cannot mutate. Artifacts reinforces this split. Its Worker
binding manages repositories but does not edit their files; Cloudflare's own
write example adds a temporary filesystem and isomorphic-git before pushing.

Endo sources at the inspected `llm` revision:

- [`FsBackend` seam](https://github.com/endojs/endo-but-for-bots/blob/1b130df7e1de3f5690dbb067f7d88a9de3a8f41e/designs/endo-fs-backend-seam.md)
- [`Git.filesystemAt(ref)` design](https://github.com/endojs/endo-but-for-bots/blob/1b130df7e1de3f5690dbb067f7d88a9de3a8f41e/designs/endo-fs-from-git.md)
- [Git capability design](https://github.com/endojs/endo-but-for-bots/blob/1b130df7e1de3f5690dbb067f7d88a9de3a8f41e/designs/daemon-git-capability.md)
- [Version-controlled filesystem roadmap](https://github.com/endojs/endo-but-for-bots/blob/1b130df7e1de3f5690dbb067f7d88a9de3a8f41e/designs/daemon-git-next-steps.md)
- [`makeGitFsBackend` implementation](https://github.com/endojs/endo-but-for-bots/blob/1b130df7e1de3f5690dbb067f7d88a9de3a8f41e/packages/exo-git/src/git-filesystem.js)

## Adapter shape

### Control plane

A trusted Worker owns the configured Artifacts binding. It selects a namespace
and repository, then mints an Endo capability for that one repository. Guest code
does not receive the binding because the binding can enumerate, create, import,
fork, and delete repositories across its namespace.

An `ArtifactsRepository` host object can retain opaque repository identity and
offer narrowly guarded operations:

- read repository metadata;
- derive a read-only historical `Filesystem` at a pinned ref;
- derive a `GitRemote` whose allowed refspecs and operation set are fixed;
- create a short-lived provider token internally when transport begins.

The token should remain inside the `GitRemote` implementation. Passing an
authenticated URL into a sandbox, as Cloudflare's generic Sandbox SDK example
does, transfers an extractable credential to that sandbox. Endo should do that
only when the sandbox is deliberately being granted direct remote authority.

### Historical read plane

There are two plausible prototypes:

1. Implement the current `GitBackend` contract using isomorphic-git. Fetch the
   requested objects into the backend's filesystem, then reuse
   `makeGitFsBackend` unchanged.
2. Implement only the historical subset with Artifacts REST commit, tree, and
   blob reads. Resolve paths lazily and cache OIDs as the existing Git filesystem
   backend does.

The first prototype exercises more of the existing `Git` and `GitRemote` stack.
The second can be smaller for read-only viewers, but it must use REST for blob
bytes because the published Worker binding has `readTree` and `readCommit` but no
`readBlob`. It also introduces one HTTP request per uncached object unless the
adapter batches or caches aggressively.

Both approaches can preserve the existing identity rules: tree and blob OIDs
become QID path identities, and blob references use `git-sha1`. The current Endo
design's deferred Git SHA-256 detection remains deferred because the Artifacts
API currently documents SHA-1 objects.

### Mutable working tree

Artifacts is the commit store, not the live `Filesystem`. A Worker-side daemon
still needs an `FsBackend` for mutable state. Choices include:

- an in-memory backend for a single request or short transaction;
- a Durable Object-backed filesystem for uncommitted state that must survive
  isolate eviction;
- a sandbox or container filesystem when native tools need ordinary paths.

The Worker-compatible Git backend should adapt that same Endo `Filesystem` to
the promises-style filesystem interface isomorphic-git expects. The operation
then has an explicit sequence: read or fetch a base ref, edit through Endo file
capabilities, stage and commit through `Git`, and push through `GitRemote`.

Acknowledging an edit before either durable working-tree storage or a successful
commit and push would overstate durability. Concurrent sessions should pin their
expected base OID and treat a rejected non-fast-forward push as a merge or retry
decision, not as an invisible last-writer-wins update.

### Related infrastructure

ArtifactFS is useful outside a Worker isolate. It performs a blobless clone,
mounts through FUSE, and hydrates blobs on demand. A Cloudflare Sandbox or other
container can use it when tools require a POSIX-looking tree and a full clone is
too slow. It is not the Endo adapter inside a Worker, and it should remain behind
an `FsBackend` or materialization boundary so FUSE paths do not become guest
authority.

Artifacts push events can wake a Workflow or Worker that asks the daemon to
refresh a ref. The event is a change notification, not authorization to read or
merge the repository. The receiving host must resolve the repository through its
existing retained capability.

## Prototype sequence

1. Build an isomorphic-git filesystem shim over the in-memory Endo `Filesystem`
   backend and run a local Git init/add/commit/read-history test without
   Cloudflare.
2. Add an `ArtifactsGitRemote` transport with a fixed repository and ref policy,
   keeping the short-lived token inside the host adapter.
3. In a deployed Worker with beta access, create or fork a repository, commit one
   file through Endo's mutable filesystem, push it, and reopen the commit through
   `Git.filesystemAt(ref)`.
4. Exercise two writers from one base and require one push to reject. Verify the
   caller receives a structured conflict rather than losing either tree.
5. Measure request count and latency for a wide tree and large blobs. Decide
   whether object caching, REST historical reads, or a sandbox with ArtifactFS is
   the appropriate bulk path.

The success criterion is behavioral: the same Endo guest code can receive a
confined mutable workspace, commit and push through separately granted Git
authority, and inspect the resulting immutable ref without learning a provider
token or account-wide namespace capability.

## Decision

Prototype the portable `GitBackend` and `GitRemote` path first. It reuses Endo's
landed filesystem adapter and keeps Cloudflare at the host boundary. Defer a
direct Artifacts REST `FsBackend` until measurements show that fetching through
isomorphic-git is too expensive for historical browsing. Do not use Artifacts as
the daemon's formula or pet-name store, and do not model individual remote file
writes as durable before a commit reaches the repository.
