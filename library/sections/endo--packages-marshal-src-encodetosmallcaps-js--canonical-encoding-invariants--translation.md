---
title: Translation
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "138-187"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps must produce a canonical JSON encoding (equal passables must JSON.stringify-equal), the copyRecord key-sort that achieves it, and the canonical-JSON aspiration the current implementation falls short of"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants
---

| Smallcaps idiom | Adjacent vocabulary |
|---|---|
| "canonical encoding" | "deterministic serialization" in some adjacent docs; "byte-stable" in hash-anchor contexts |
| "copyRecord enumeration order" | "iteration order" or "key order" in JS standard vocabulary |
| "canonical-JSON" | the RFC 8785 (JCS) idiom; smallcaps does not implement JCS but its goals overlap |

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L138-L187) at commit `e56bf00f`.
