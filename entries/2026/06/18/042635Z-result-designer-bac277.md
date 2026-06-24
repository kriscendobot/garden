---
ts: 2026-06-18T04:26:35Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: "*"
short_id: bac277
refs:
  - dispatches/designer--bac277
  - entries/2026/06/18/041346Z-result-researcher-1f66eb.md
---

# Result: designer dispatch on fs-interface-reconciliation

Opened `endojs/endo-but-for-bots#464` (DRAFT, base `llm`), landing
`designs/fs-interface-reconciliation.md` on branch
`design/fs-interface-reconciliation`.

PR: https://github.com/endojs/endo-but-for-bots/pull/464
File: `designs/fs-interface-reconciliation.md` (686 lines)

## Headline shape

**MountInterface names win.** The catalog adopts `has`, `list`,
`lookup`, `write`, `remove`, `move`, `makeDirectory`, `readOnly`,
`snapshot`, `help` verbatim from the existing `MountInterface` plus
`stat`, `makeFile`, `writeText`, `streamBase64`, `text`, `json`,
`append`, `writeBytes` from the existing daemon-mount + platform-fs
surfaces. Four methods are new: `subDir` (the future-VFS method
platform-fs deferred), `streamRead` (opt-in range I/O),
`followNameChanges` (per filesystem-watchers PR #277), and `copy`
(already on platform-fs Directory).

Total: 24 methods. Conformance matrix lists IMPLEMENTED / ABSENT /
DEFERRED cells across five backings (mount, scratch-mount, endo-fs
in-memory, CAS, endo directory / name hub).

`@endo/endo-fs` stays diverged with catalog name aliases alongside
its existing `create` / `unlink` / `rename` / `mkdir`. endo-fs's
DESIGN.md §2.1 was honest that its guards are not unifiable with
platform/fs's (different contracts); this design honors that.

## Unified method catalog (final list)

Reading: `has`, `list`, `lookup`, `stat`, `streamBase64`, `text`,
`json`, `streamRead`.

Mutation: `write`, `writeText`, `writeBytes`, `append`, `remove`,
`move`, `copy`, `makeDirectory`, `makeFile`.

Attenuation: `readOnly`, `subDir`.

Snapshot: `snapshot` (returns SnapshotBlob / SnapshotTree per
platform-fs shape, not endo-fs's BlobRef).

Observation: `followNameChanges`.

Discoverability: `help`, `__getMethodNames__` (auto from makeExo).

Deliberately NOT in catalog: `OpenFile.read / write`, `Cursor`,
`Lock`, `Xattrs`, `NodeWatcher` (endo-fs cap-FS surface, stays on
endo-fs); `identify` / `locate` / formula-system `followNameChanges`
(formula-system surface, per platform-fs stops-at-filesystem-boundary);
`chmod` / `chown` / POSIX mode bits (future PosixFs companion cap).

## Sync versus async choice

**All methods return Promise.**

Rationale: the catalog must cross CapTP without re-shaping. Daemon
caps reach the chat viewer over CapTP; even a same-process memfs cap
returned to the daemon goes through `E(cap).method()` which is
eventually-resolving. A "sync" surface available only on a
same-process backing introduces a foot-gun: callers write code
against the sync surface, ship it, and break the moment the cap is
handed across a CapTP boundary. endo-fs DESIGN.md §4.10 settled this
for its own surface: pipelining via `Promise.all` / `M.await`
collapses N control-flow-independent calls into one round-trip; this
is the right answer for the catalog too. A backing whose state is
in the local process (memfs) is free to resolve its returned
promises synchronously where the spec allows, but the surface
signature is `Promise<T>`.

## Open questions surfaced (eight)

1. Adopt MountInterface names verbatim or supersede with new names?
   This design picks verbatim. Maintainer confirmation requested.
2. Sync versus async — confirm async is correct. Async chosen per
   above; maintainer confirmation requested.
3. Migration speed — big-bang versus gradual? This design picks
   gradual. Maintainer preference requested.
4. `@endo/endo-fs`'s future — retire / re-export / keep diverged?
   This design keeps endo-fs diverged with catalog aliases.
   Maintainer direction requested. If retire/merge, would file
   tracking issue as a follow-up after this design lands.
5. The library gaps researcher flagged (no `@endo/endo-fs` library
   section; no `name-hub-as-vfs-backing` concept page). These are
   librarian / scholar tasks, not blockers; to be filed as journal
   `message` entries after this design lands.
6. `subDir` confinement lifetime — `subDir` exo method (transient,
   no formula) vs `provideSubMount` host method (formula-bearing,
   survives restart). Both proposed; naming overlap is real but
   lifetime difference is the discriminator. Maintainer confirmation
   requested.
7. Should `followNameChanges` parity extend to CAS? CAS is
   immutable; design chose absent over immediately-terminating empty
   stream. Maintainer confirmation requested.
8. Streaming substrate for `streamRead` — `@endo/exo-stream` (chosen)
   versus `daemon-message-streaming`'s `streamReply` / `streamSend`.
   Maintainer confirmation requested.

## What this design IS

It is the **future-VFS-layer** that both `platform-fs.md` and
`daemon-capability-filesystem.md` defer to. platform-fs Decision
explicitly defers `subDir()` "to a future VFS layer that composes
`@endo/platform/fs` primitives." daemon-capability-filesystem is
flagged Reference (not directly implemented) and its three-layer
architecture (Guest Dir/File + VFS Namespace + Backends) is the
broader vision this design realizes the catalog half of.

## What this design is NOT

It is **not** a unified guard for endo-fs and platform/fs. The two
guards stay separate (endo-fs DESIGN.md §2.1 already settled that:
the contracts diverge). It is also not the cap-FS surface (range
I/O, OpenFile, Cursor, Lock, Xattrs, NodeWatcher); those stay on
endo-fs for the 9P / FUSE / OS-bridge consumers.

## Concurrent-orchestrator check

Re-polled `gh pr list --search "fs-interface OR
filesystem-interface OR platform-fs in:title" --state open` before
PR open. No concurrent fs-interface-reconciliation work; nearest
related are #277 (filesystem-watchers; this design cites it as the
`followNameChanges` row), #135 (mount Phase 4 sub-mounts; this
design names `provideSubMount` as the formula-bearing realization
of `subDir`), and #432 (daemon-move-transfer-negotiation; this
design's `move` defers to that design's six-tier negotiation).

Self-improvement: nothing this time.
