---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: scholar
handler-timeout: 7200
---
Ingest https://orib.dev/gefs.pdf into the library per
`journal/library/conventions.md`, with particular care to CROSS-REFERENCE the
garden's existing CASK and virtual-file-system material.

MAINTAINER REQUEST (kriskowal, 2026-09-18): "especially taking care to
cross-reference topics relevant to CASK and virtual file system modeling."

## The source

`https://orib.dev/gefs.pdf` — Ori Bernstein's paper on GEFS, a Plan 9 file system.
Fetch it read-only via the sanctioned `fetch-source.sh` path. Expect a PDF: if the
text does not extract cleanly, say so explicitly and record what you could and
could not read, rather than paraphrasing from memory or from secondary sources. A
partial, honestly-bounded ingest beats a confident one built on a bad extraction.
If it turns out to be paywalled, redirected, or otherwise not the document
expected, stop and report rather than substituting something else.

## Why the cross-reference matters, and what to hook into

The garden already holds a substantial body on content-addressed storage and
chunked block structure, largely from CASK. This ingest is valuable mainly for
where GEFS AGREES, DIVERGES, or SOLVES SOMETHING DIFFERENTLY. Do not write a
standalone summary that sits unconnected beside the existing material.

Existing anchors to read FIRST and then relate to (verify each still exists):

- Topic `library/topics/content-addressed-storage.md`, concept
  `library/concepts/content-addressed-storage-backend.md`.
- CASK block and chunking material — the closest neighbors:
  `concepts/rabin-chunking.md`, `concepts/cask-blob-cat.md`,
  `concepts/cask-block-backbones.md`, `concepts/caskdir-directory-format.md`,
  and the sections `cask--blob-design--content-defined-chunking-and-random-access`,
  `cask--dir-design-v2--goals-and-rabin-chunked-entries-tree`,
  `cask--sorted-array-design--rabin-chunked-structure-and-stability`,
  `cask--parallel-arrays--rabin-bounded-sorted-indexes`.
- CASK garbage collection and snapshots:
  `sections/cask--gc-concurrent-design--snapshot-gc-with-quarantine`.
- CASK roots and naming: `concepts/cask-caskhead-root.md`,
  `concepts/cask-named-typed-pointer.md`, `concepts/cask-entry-type-capability.md`.
- Probabilistic tree prior art already in the library:
  `sections/dialog-db--notes-architecture-overview--probabilistic-btrees-and-segments`.
- Endo-side persistence and naming, for the VFS-modeling half:
  `concepts/formula-graph.md`, `concepts/formula-persistence-thesis.md`,
  `concepts/formula-scheme.md`, `concepts/crdt-in-formula-persistence.md`.

## Questions the ingest should let a later reader answer

Draw these out where the paper supports them, and say plainly where it does not:

1. On-disk structure. What tree or index does GEFS use, and how does that compare
   with CASK's Rabin-chunked sorted arrays and entries tree, and with dialog-db's
   probabilistic B-trees? Where the shapes differ, what does each buy?
2. Chunking and dedup. Does GEFS do content-defined chunking at all? If it does not,
   that ABSENCE is itself the interesting finding against CASK's Rabin approach —
   record it as such rather than omitting it.
3. Snapshots, copy-on-write, and GC. How does GEFS reclaim space and keep snapshots
   consistent? Relate to CASK's snapshot GC with quarantine.
4. Crash consistency and durability. What does it promise, and by what mechanism?
5. VFS MODELING — the part the maintainer flagged. What is GEFS's file/directory
   abstraction, and how does it name and resolve things? Relate that to how the
   garden models a virtual file system capability-wise: Endo's formula graph and
   naming scheme, pet names versus content addresses, and the read-only directory
   and blob-range attenuation work now in flight (`ebfb#1304` read-only directory
   attenuation, `#826` ReadableBlob range attenuation). Where GEFS's model assumes
   ambient authority over a namespace and the garden's assumes attenuable
   references, NAME THAT DIFFERENCE — it is the most useful thing this ingest can
   surface, and the least likely to be obvious later.
6. What, if anything, GEFS does that a capability-oriented store could adopt, and
   what it does that is structurally incompatible with one.

## Output

Follow `journal/library/conventions.md` exactly: sectioned source-index entries,
new or updated topic and concept files, and the master README / `keywords.md`
index updates. Add cross-links in BOTH directions — the new material should point
at the CASK and Endo concepts, and those concepts should gain a pointer back —
so a later reader arriving from either side finds the comparison.

Stay inside the scholar's bounds: library, projects, and entries only. No role,
skill, or doc edits; if you find a structural lesson about the conventions
themselves, route it per `skills/self-improvement` and stop that line.

If the evidence fans out past this job's budget, write what is supported, post a
follow-on scholar job for the remainder, and complete rather than overrunning.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-18T21:48:19Z
