---
title: MST structure, key depth, and node encoding
source_kind: web
source_url: https://atproto.com/specs/repository
source_content_sha256: bb8ddfacbc2864bdff6d917764da33c0263f4226363878c13cf5abe0979dd249
source_authors: [Bluesky Social PBC]
source_date: 2026-07-28
retrieved: 2026-07-28
ingested: 2026-07-28
ingested_by: scholar
topics: [content-addressed-storage, data-structures, persistence]
status: current
---

> Abstract: The concrete Merkle Search Tree atproto uses: keys are byte arrays, a key's depth is the count of leading binary zeros in its SHA-256 hash divided by two (fanout 4), nodes carry left links plus prefix-compressed TreeEntry arrays, and the whole shape is deterministic from the current key-to-CID mapping regardless of insertion history. This is the property that makes an MST a candidate canonical tree hash: "The MST data structure should be fully reproducible from such a mapping of bytestrings-to-CIDs, with exactly reproducible root CID hash."

## The mapping and its determinism

> "At a high level, the repository MST is a key/value mapping where the keys are non-empty byte arrays, and the values are CID links to records. The MST data structure should be fully reproducible from such a mapping of bytestrings-to-CIDs, with exactly reproducible root CID hash (aka, the `data` field in commit object)."

> "The overall structure and shape of the MST is deterministic based on the current key/value content, regardless of the history of insertions and deletions that lead to the current contents."

Merkle Search Trees were originally described in Alex Auvolat and Francois Taiani, "Merkle Search Trees: Efficient State-Based CRDTs in Open Networks", SRDS 2019. The atproto spec notes you do not need to read the paper to implement MSTs as atproto uses them.

## Node shape and key depth

> "Every node in the tree structure contains a set of key/CID mappings, as well as links to other sub-tree nodes. The entries and links are in key-sorted order, with all of the keys of a linked sub-tree (recursively) falling in the range corresponding to the link location. ... Each key has a depth derived from the key itself, which determines which sub-tree it ends up in."

The depth computation, with SHA-256 and "prefix zeros" counted in 2-bit chunks for a fanout of 4:

1. Hash the key (a byte array) with SHA-256, binary output.
2. Count the number of leading binary zeros in the hash, and divide by two, rounding down.
3. The resulting positive integer is the depth of the key.

Worked examples from the spec: `2653ae71` is depth 0, `blue` is depth 1, `app.bsky.feed.post/454397e440ec` is depth 4, `app.bsky.feed.post/9adeb165882c` is depth 8.

Node data schema fields:

| Field | Type | Meaning |
|---|---|---|
| `l` ("left") | CID link, nullable | "link to sub-tree Node on a lower level and with all keys sorting before keys at this node" |
| `e` ("entries") | array, required | "ordered list of TreeEntry objects" |
| `e[].p` ("prefixlen") | integer, required | "count of bytes shared with previous TreeEntry in this Node (if any)" |
| `e[].k` ("keysuffix") | byte array, required | "remainder of key for this TreeEntry, after 'prefixlen' have been removed" |
| `e[].v` ("value") | CID link, required | "link to the record data (CBOR) for this entry" |
| `e[].t` ("tree") | CID link, nullable | "link to a sub-tree Node at a lower level which has keys sorting after this TreeEntry's key" |

> "Within every node, keys (byte arrays) are compressed by eliding common prefixes ... The compaction scheme is mandatory, to ensure that the MST structure is deterministic across implementations."

## Emptiness and pruning rules

An empty repository is a single MST node with an empty entries array, and that is the only case where a tree may contain an empty leaf node. "The top of the tree must not be a an empty node which only points to a sub-tree. Empty intermediate nodes are allowed, as long as they point to a sub-tree which does contain entries. In other words, empty nodes must be pruned from the top and bottom of the tree, but empty intermediate nodes must be kept, such that sub-tree links do not skip a level of depth."

## Key mining as a denial-of-service vector

> "The efficiency of the MST data structure depends on key hashes being relatively randomly dispersed. Because accounts have control over record keys, they can mine for sets of record keys with particular depths and sorting order, which result in inefficient tree shapes, which can cause both large storage overhead, and network amplification in the context of firehose event streams. To protect against these attacks, implementations should limit the number of TreeEntries per Node to a statistically unlikely maximum length. It may also be necessary to limit the overall depth of the repo, or other parameters."

Anyone considering an MST as a canonical tree hash for a different system inherits this: adopting the structure means adopting a fanout, a depth policy, and the key-mining mitigations.

Source: [https://atproto.com/specs/repository](https://atproto.com/specs/repository), content SHA-256 `bb8ddfac`.
