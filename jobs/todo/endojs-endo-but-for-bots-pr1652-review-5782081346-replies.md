---
posted_at: 2026-11-05T10:42:18Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: host=endolin-garden-ece02cb4
handler-budget-role: review
tier: minion
fallback-tier: mentor

# Post the RSVP for endojs/endo-but-for-bots PR #1652 review 5782081346

Host oros-studio-garden-ce242c49 holds a token that gets 403 on PR writes, so job
`endojs-endo-but-for-bots-pr1652-review-358defcf` pushed the design changes (head
4ca7b3319c) and relays its replies here. kriskowal asked for an RSVP on this review:
https://github.com/endojs/endo-but-for-bots/pull/1652#pullrequestreview-5782081346

Do only the following. Edit no project files. Every text below is bot-authored and final,
so post it verbatim. First list the thread's bot replies, and skip any reply or summary
that already exists, so a requeue does not post twice. Write each body to a file and pass
it as `--field body=@file` or `--body-file`, never on the command line.

## 1. Thread replies

For each reply, POST `repos/endojs/endo-but-for-bots/pulls/1652/comments/<thread>/replies`.

### Thread 4478343101 (answers comment 4478343101)

````markdown
Done in 964dd55004. A method that reveals a digest now names its algorithm (`sha256()`, `treeSha256()`), and the `TreeRef` and `BlobInfo` results are retired in rung 10.
````

### Thread 4478476350 (answers comment 4478476350)

````markdown
Both are in. 8be613c95a renames to `BlockStore`, `LogStore`, `MapStore`, `SetStore`, `BagStore`, and `Cell`, and adds a `Value` kind for the direct directory entry (my name; correct it freely).

a90c8b517a replaces the envelope with a locator file: a 256-bit marker every Endo writer refuses, plus an Ed25519 signature verified against the locator's `peerKey`.

`## Open questions` now asks how a tree gets a foreign peer's signature, and whether archives still need the manifest.
````

### Thread 4478490457 (answers comment 4478490457)

````markdown
Yes to both, in e6414aa25d. An edit needs an anchor for each line it touches, and an anchor's width depends on the file's line count, so the provider should supply anchors rather than the caller reading the whole file.

Added `readHashLines(startLine, endLine)`, `grepHashLines`, and `glorpHashLines`, and renamed to `editHashLines`.
````

### Thread 4478504470 (answers comment 4478504470)

````markdown
Yes, we can make do with just `snapshot`, and 918674a8f8 removes `identity()` and `ContentIdentity`. `expected` now takes a snapshot.

Snapshotting isn't strictly necessary to obtain an identity, since a provider could hash without retaining. But nothing in the design needs an identity without its content. The real cost falls on a native provider, which has to check content in where a token would only have hashed it. A caller that must not retain content can guard with a revision.
````

### Thread 4478504470 (answers comment 4478559585)

````markdown
Adopted your names in a9d10b6441, replacing `snapshot({ strict })`. `snapshot()` holds no capability and throws `UNSNAPSHOTTABLE_ENTRY` when it would have to. `capture()` collapses block to blob, directory to tree, and map store to copy map, and preserves all remaining capabilities by reference.
````

### Thread 4478518955 (answers comment 4478518955)

````markdown
Yes to both, in 7128aa0de9. `conflicts` is now a hardened array of copy records, so there is nothing to dispose. Each text conflict frames `left`, `base`, `right`, and `merged` as line ranges bracketed by hash-line anchors, and the `merged` anchors feed `editHashLines`.

Copy data can't stream, so an oversized conflict list throws `RESULT_TOO_LARGE` and the caller merges smaller subtrees.
````

### Thread 4478524547 (answers comment 4478524547)

````markdown
Done in e3e443338c, using `keep`, `drop`, and `insert`. Each target now gets one edit script that walks it from byte 0, and `insert` with a range reference covers what `copyRange` did. That also removed the overlap rule.
````

### Thread 4478568564 (answers comment 4478568564)

````markdown
Renamed in 52cea41fd0. I also folded `withResultBudget` into it as `narrow({ records })`: your reviewed `limitResults` carried records, and a budget is lowered the same way. Result budgets keep their own error, so say if you'd rather keep that method separate.
````

### Thread 4478586504 (answers comment 4478586504)

````markdown
Done in 5f47e22150: no method locks any part of a tree, the fastest of concurrent mutators commits, and the rest throw `PRECONDITION_FAILED` and may retry. `expected` covers only its receiver, so disjoint subtrees don't conflict. I also removed the last-writer-wins escape from `applyPatch`.
````

## 2. PR body

Replace the PR body with this text through `gh pr edit 1652 -R endojs/endo-but-for-bots --body-file`. It keeps the garden-job marker.

````markdown
## Description

This draft consolidates Endo's pet-name, mount, platform filesystem, storage, and agent-editing designs into one normative virtual-filesystem contract and first user-documentation draft. It distinguishes implemented, designed, and proposed behavior; specifies the view algebra, snapshot-based compare-and-swap, bounded read/search/edit/diff/patch/merge surfaces, reference-level splicing, signed locator-file format, and ownership boundaries; and records inconsistencies with recommended resolutions. The live design roadmap now indexes the design in M3, its dependency graph, and its estimates without double-counting existing filesystem work. Requested by kriskowal on 2026-11-05.

### Security Considerations

The design keeps authority on held CapTP references, separates client and mutability-controller facets, makes attenuations monotonic, and treats serialized locators as bearer secrets. Review should attend particularly to snapshot comparison across providers and to locator files, which a reserved marker classifies and a signature verified against the locator's own `peerKey` authenticates; a signed manifest separately authenticates whole archives.

### Scaling Considerations

The proposed `narrow` facet, streaming searches, streamable patches, range reads, and reference-level transforms prevent large values from being materialized in agent context. The build is phased so bounded reads and search can land before controller and archive work.

### Documentation Considerations

The design is itself the first draft of the user documentation.

### Testing Considerations

Documentation only. Implementation PRs carry the design's shared conformance suite.

### Compatibility Considerations

No runtime behavior changes in this PR. The proposed common interface preserves current spellings behind adapters while migrating public correctness checks from exposed hashes to snapshots.

### Upgrade Considerations

No deployment upgrade is required for this design PR. The ten-rung build ladder isolates future compatibility changes and retires aliases only after daemon, platform, exo-git, CLI, Chat, endopi, and agent-tool consumers migrate.

<!-- garden-job: design-endo-unified-virtual-filesystem-20261105 -->
````

## 3. Summary comment

Post this with `gh pr comment 1652 -R endojs/endo-but-for-bots --body-file`.

````markdown
@kriskowal RSVP for [your review](https://github.com/endojs/endo-but-for-bots/pull/1652#pullrequestreview-5782081346), at head 4ca7b3319c. Each thread has its own reply.

- **`{ algorithm, hash }`:** eliminated; methods name the algorithm (964dd55004).
- **Store names and `Cell`:** renamed, with a new `Value` kind for direct entries (8be613c95a).
- **Locator files:** reserved marker plus referent-peer signature (a90c8b517a).
- **Hash lines:** `readHashLines`, `grepHashLines`, `glorpHashLines`, `editHashLines` (e6414aa25d).
- **`snapshot` only:** `identity()` and `ContentIdentity` removed (918674a8f8).
- **`snapshot` and `capture`:** replace `{ strict }` (a9d10b6441).
- **Merge conflicts:** copy records framed by hash lines (7128aa0de9).
- **`keep`, `drop`, `insert`:** one edit script per target (e3e443338c).
- **`narrow`:** replaces `limitResults` and absorbs `withResultBudget` (52cea41fd0).
- **Compare-and-swap:** no locks, and `applyPatch` loses last-writer-wins (5f47e22150).

For you to decide, as these go beyond what you specified:

- The name `Value`.
- Folding budgets into `narrow`.
- Removing last-writer-wins from `applyPatch`.
- The two items in `## Open questions`: how a tree gets another peer's signature, and whether archives keep the manifest.

This is a design-only change. The deterministic probes and wording checks pass, and I ran no tests because there is no code to test. The queued panel round 4 will review this head.
````

Report the created comment IDs. If a post is denied here too, say so and do not emit the completion signal.
