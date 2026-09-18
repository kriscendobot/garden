---
title: Mapping the file system onto Bεtrees — a single flat key-value store of data/entry/up keys, qid-based path walking, and range-scan directory listing
source: "GEFS: A Good Enough File System (Ori Bernstein)"
source_kind: paper
source_authors: [Ori Bernstein]
source_year: 2023
source_venue: "Plan 9 file-system paper (orib.dev/gefs.pdf; IWP9 2023 inferred)"
source_url: https://orib.dev/gefs.pdf
source_pdf_sha256: 83a3b21a9abd34227f46cc9f2d93be228889d419031dcb6eb46b30443057cf1e
ingested: 2026-09-18
ingested_by: scholar
topics: [file-systems]
status: current
---

Abstract: GEFS records **all** file-system state in a *single flat key-value store* — no directory structures, no indirect blocks, no other traditional structures. A file system is a snapshot tree pointing at per-snapshot **metadata trees**, and within a metadata tree three key kinds carry everything: **data keys** (file qid + block-aligned offset → data block pointer), **entry keys** (containing-directory qid + file name → stat struct), and **up keys** (directory qid → parent's key, so `..` walks resolve). A path walk is performed by *constructing keys*: start at the root (parent qid `~0`, name `/`), look up its qid, then repeatedly concatenate the next walk element to the current qid to form the next entry key. Because the Bεtree is sorted, all keys for one directory sort together, so **listing a directory is a range scan** over keys prefixed by the directory's qid, and a file's data blocks are likewise grouped for sequential reads. This is GEFS's file/directory abstraction and its naming/resolution model — the part most directly comparable to how the garden models a virtual file system.

## The key-value schema

A GEFS file system consists of a snapshot tree, which points to a number of file-system trees. The snapshot tree tracks snapshots (covered in the snapshots section). Each snapshot points to a single GEFS **metadata tree**, which contains all file-system state for a single version of the file system. GEFS is somewhat unusual in that all file-system data is recorded within a single flat key-value store; there are no directory structures, no indirect blocks, and no other traditional structures. Instead there are three key-value pair kinds:

- **Data keys.** Store pointers to data blocks. The key is the file **qid** concatenated to the block-aligned file offset. The value is the pointer to the data block being looked up.
- **Entry keys.** Contain file metadata. The key is the qid of the *containing directory* concatenated to the name of the file within that directory. The value is a stat struct containing the file metadata, including the qid of the directory entry.
- **Up keys.** Maintained so that `..` walks can find their parent directory. The key is the qid of the directory; the value is the key for the parent directory.

## Walking, listing, reading, writing

Walking a path starts at the root, which has a parent qid of `~0` and a name of `/`. The QID of the root is looked up, and the key for the next step is constructed by concatenating the walk element with the root qid. This produces the key for the next walk element, which is looked up in turn, and so on until the walk completes. If a path element is `..` instead of a name, the up key is inspected instead, to find the parent link of the directory.

Because a Bεtree is a sorted data structure, **range scans are efficient**, so listing a directory is a range scan of all keys that start with the qid of the directory entry. Reading from a file is similar but with less iteration: the qid is known, so the block key is formed by concatenating the file qid with the read offset, looked up to find the block address, and the block is read and returned. Writing begins, in the general case, by looking up the existing block so it can be modified; but if a write fully covers a data block, a **blind upsert** of the data is done instead — and, atomically along with it, a blind write of the version-number increment, mtime, and muid. Stat and wstat both construct and look up the directory-entry keys, either upserting modifications or reading the data back directly.

*(The paper illustrates the schema with a worked example — a hierarchy `foo/bar`, `foo/baz/meh`, `quux`, `blorp` where `blorp` contains `hello world`, rendered as a concrete set of data/entry/up keys. The exact key bytes were rendered in a figure font that did not extract cleanly from the PDF; the schema above is the recoverable substance.)*

## Cross-reference (editorial, not in the source) — the ambient-namespace vs attenuable-reference difference

This is the difference the maintainer flagged as the most useful thing to surface. GEFS names things by **qid** (a Plan 9 unique file id) inside a **single ambient namespace**: any holder of the metadata tree can construct the key for any path by concatenating qids and names and walk the whole tree — authority is *ambient over the namespace*, exactly as in a classical file system. There is no notion of handing someone a reference to *one subtree* or *one file range* that cannot be widened by naming a different key.

The garden models a virtual file system the opposite way — **capability-first**. Endo's formula graph (concept [[formula-graph]], [[formula-persistence-thesis]]) names durable objects by *formula identity* (a recipe for reconstructing a reference and its dependencies), and pet names are per-agent bindings to formula ids, not ambient paths into one shared tree; you hold what you were introduced to, and nothing more. The in-flight attenuation work makes the contrast concrete: read-only directory attenuation (`endojs/endo-but-for-bots#1304`) hands out a directory reference whose holder can read/traverse but not write, and ReadableBlob range attenuation (`#826`) hands out a reference to *a byte range of one blob*. In GEFS terms, those are "a key subrange you may read but not upsert to, and cannot escape by naming a sibling qid" — a shape GEFS's ambient qid namespace does not express. CASK's cell capabilities (concept [[cask-entry-type-capability]], sections `cask--cell-capabilities--*`) reach for the same attenuable-reference model on a content-addressed store (read-only cells, path descriptors). **Name the difference plainly: GEFS assumes ambient authority over a namespace; the garden assumes attenuable references.** A GEFS-style flat qid keyspace is a fine *substrate*, but resolution-by-key-construction is the thing a capability-oriented store must not expose directly — it would let any holder widen its own authority.

Source: [GEFS: A Good Enough File System (Ori Bernstein)](https://orib.dev/gefs.pdf), fetched 2026-09-18 (PDF SHA-256 `83a3b21a`).
