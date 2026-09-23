---
title: Plumbing-only GitStore and the fs shim
source: packages/workshop-backend/src/git-store.ts
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/workshop-backend/src/git-store.ts
source_line_range: "76-398, 577-588"
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
comment_subject: GitStore as pure plumbing over a virtual fs shim mapping loose-object paths to a collection, presenting commits as flat path-to-text maps and diffing by oid
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [content-addressed-storage, persistence]
status: current
---

Abstract: `GitStore` is a git object database over a `gitObjects` collection that is *plumbing only*: it reads and writes blobs, trees, and commits by oid and knows nothing about refs — callers (gadget records, blueprint records, chat pins) track which commits matter. Files are presented as flat `path -> text` maps whose `/`-bearing paths map to nested trees, so stored history stays interoperable with real git tooling. `isomorphic-git`'s only storage interface is a filesystem, so a virtual fs shim maps loose-object paths onto the collection and rejects everything else, never silently accepting unintended writes; the shim implements all ten `PromiseFsClient` methods (only five are exercised) with contract subtleties verified against isomorphic-git 1.40, including that missing files must reject with `code: "ENOENT"`. `changedPaths` compares two commits by oid — equal subtrees short-circuit without descending and no blob content is read — which is the cheap way to ask which files differ. Only regular-file blobs (modes 100644/100755) are supported; symlinks and submodules are rejected rather than misread.

## Plumbing, not porcelain

`GitStore` reads and writes blobs/trees/commits by oid and knows nothing about refs — callers track which commits matter. Construct one per Overseer instance and reuse it: it carries isomorphic-git's parse cache. `writeFilesAsCommit(files, options)` writes a `path -> text` map as a commit; all objects are content-addressed, so rewriting identical content is a cheap no-op that produces the same oids. `readCommitFiles(oid)` is the inverse, flattening nested trees to `/`-joined paths.

## The virtual fs shim

`isomorphic-git`'s only storage interface is a filesystem, so `makeGitObjectsFs` gives it a virtual one that maps loose-object paths (`/git/objects/xx/yyyy...`) onto the `gitObjects` collection and rejects everything else, so the store never silently accepts writes it did not intend. Non-object paths would be a deliberate schema extension.

Contract subtleties, verified against isomorphic-git 1.40:

- All ten `PromiseFsClient` methods must exist even though only `readFile`/`writeFile`/`stat`/`mkdir`/`readdir` are ever exercised for object-database work — `bindFs` binds every one unconditionally.
- The promise-style detection probe calls `readFile()` with no arguments and requires a promise back; `async` methods satisfy this by returning a rejected promise rather than throwing synchronously.
- Missing files must reject with `code: "ENOENT"`: `FileSystem.exists()` rethrows anything else, and `discoverGitdir` / `FileSystem.read` / `FileSystem.readdir` tolerate rejections. `mkdir` accepts and ignores (directories don't exist in this store) so the mkdirp fallback can't fail; the packed-object probe lists `objects/pack`, which is always empty since no packfiles are stored.

## Diff by oid, not content

`commitFileOids(oid)` reads a commit's tree as a `path -> blob oid` map without touching blob content. `changedPaths(a, b)` returns the set of paths whose content differs between two commits' trees (added, removed, or changed), compared by oid — equal subtrees short-circuit without descending, and no blob content is ever read. `undefined` on either side means an empty tree, so a one-sided call lists a commit's whole tree. The oid-level tree walk and the content-level walk apply the same mode restriction, so the two views can never disagree about which paths exist.

Only regular-file blobs (modes `100644`/`100755`) are supported; symlinks and submodules — never written, but an imported history could contain them — are rejected rather than misread. `buildTreeNode` validates path shape (no empty segments, `.`, or `..`; a path cannot be both a file and a directory).

## Commit identity

`commitIdentityForAuthor` derives a git commit identity from a chat author: the display name becomes the commit name, and the profile ID the email. Profile IDs are typically email addresses; in username/password mode they may be bare usernames, which become `<username>@localhost` — a placeholder convention until users can customize their commit identity.

Source: [packages/workshop-backend/src/git-store.ts](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/packages/workshop-backend/src/git-store.ts) at commit `1ef6020a`.
