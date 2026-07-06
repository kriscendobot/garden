---
id: repository-branch-remote
aliases: [repository, branch, remote, upstream, push, pull, set_upstream, dialog-repository, RepositoryExt, git-like interface, version control for data, transaction commit, remote fallback, branch revision history, same name same identity]
topics: [local-first-sync, ucan-authorization]
---

# repository-branch-remote

Dialog-db's git-like model over structured data, implemented in the `dialog-repository` crate: **repositories** with branches, remotes, push/pull, and merge, but over `{the, of, is, cause}` claims instead of files. A **repository** has its own Ed25519 keypair, named branches, and remotes, and is *deterministically derived* from `(profile, name)` — the same name under the same profile always yields the same repository identity, so repositories are addressable by human-readable name without a registry. A **branch** carries revision history: each `branch.transaction().assert(..).commit()` folds a batch of semantic triples into a new revision. A **remote** is registered with `repo.remote("origin").create(<address>)` (an `impl Into<SiteAddress>` — `Ucan` or `S3`), its branch opened and bound as a local branch's **upstream** via `main.set_upstream(remote_main)`; thereafter `push()` and `pull()` synchronize the branch, and — the key local-first ergonomic — **queries against an upstreamed branch replicate missing blocks on demand**, so reads are lazily synced without an explicit `pull()`. Opening has three modes: `.open()` loads-or-creates (`Repository<Credential>`), `.load()` loads-or-fails (`Repository<Credential>`), `.create()` creates-or-fails (`Repository<SignerCredential>`, proving owner authority). Cross-repository sync uses `.subject(other_repo.did())` to target a different repository at the same site. Every operation terminates in `.perform(&operator)`, the capability environment that authorizes and routes it.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--rust-dialog-repository-readme--overview](../sections/dialog-db--rust-dialog-repository-readme--overview.md) | The git-like-for-structured-data framing; claims as `{the, of, is, cause}`; same-name→same-identity. |
| [dialog-db--rust-dialog-repository-readme--usage-walkthrough](../sections/dialog-db--rust-dialog-repository-readme--usage-walkthrough.md) | The end-to-end fluent lifecycle: storage → profile → operator → repo → branch → commit → query → remote → push/pull. |
| [dialog-db--rust-dialog-repository-guide--repository-and-branch-modes](../sections/dialog-db--rust-dialog-repository-guide--repository-and-branch-modes.md) | Repository/branch open/load/create modes and the `Credential` vs `SignerCredential` return-type split. |
| [dialog-db--rust-dialog-repository-guide--writing-semantic-triples](../sections/dialog-db--rust-dialog-repository-guide--writing-semantic-triples.md) | `branch.transaction().assert(..).commit()` folding triples into a branch revision. |
| [dialog-db--rust-dialog-repository-guide--syncing-remotes-and-upstream](../sections/dialog-db--rust-dialog-repository-guide--syncing-remotes-and-upstream.md) | Remote registration, `set_upstream`, push/pull, `.subject(did)` targeting, on-demand block replication. |
| [dialog-db--rust-dialog-repository-guide--collaboration-ucan-delegation](../sections/dialog-db--rust-dialog-repository-guide--collaboration-ucan-delegation.md) | Sharing a repository across profiles via UCAN delegation (Alice sets up / invites Bob / Bob joins). |

## See also

- [[dialog-db]] — the local-first database this crate is the top-of-stack interface for.
- [[profile-account-operator]] — the identity layers a repository is derived from and authorized by.
- [[signer-verifier-credential]] — the credential type the open/create modes return, encoding owner vs delegate.
- [[ucan-delegation]] — how repository access is shared across profiles without sharing keys.
- [[subject-routing]] — how a remote's `SiteAddress` + subject DID resolve to the site backing a repository.
- [[dialog-query-rust-api]] — the typed concept/rule query surface a branch exposes.
