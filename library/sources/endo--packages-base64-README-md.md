---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/base64/README.md
source_line_range: 1-22
file_commit: dd24b13d838f045d8d54354a8d704af83718e0a8
file_commit_date: 2025-12-04
file_commit_author: Kris Kowal
ingested: 2026-06-16
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 355 designs-lane ingest. 22-line minimal-utility
  README. **TWENTIETH package** added to pivot cluster
  (nat + memoize + hex + lp32 + stream + eventual-send +
  exo + captp + pass-style + patterns + marshal + common +
  promise-kit + harden + errors + lockdown + init + ses +
  where + base64). Documentation-side closure for cycle 181's
  @endo/base64 source ingest.

  Single most structurally interesting move: §the-named-
  minimal-utility-README-shape — for a pure utility package
  with obvious purpose and inverse-pair API, the README is
  just heading-less intro + Install + Usage; §eight-shapes-
  of-README refines cycle 351's seven-shape categorization
  with minimal-utility (22 lines).

  Other tier-3 meta-patterns: §the-named-inverse-pair-as-
  API-shape (two-function round-trip for codec utilities);
  §three-shapes-of-utility-API-surface (barrel-index +
  single-noun-export + inverse-pair).

  §three-cycles-with-named-Uint8Array-as-byte-representation
  (315 lp32 + 318 hex + 355 base64) — @endo ecosystem
  convergence on Uint8Array as canonical byte type.

  Third conformant single-body section doc in post-refactor
  era (after cycles 353 + 354).

  Closes nine citation arcs: cycle 354 (1) + cycle 353 (2)
  + cycle 181 (174, base64 source ingest doc-side closure)
  + cycle 187 (168) + cycle 343 (12) + cycle 344 (11) +
  cycle 315 (40) + cycle 318 (37) + cycle 326 (29). Pushes
  citation-arc-closures-in-pivot to ONE-HUNDRED-SIXTY-SEVEN
  (163 + 4 net new).
---

22-line minimal-utility README for @endo/base64 (twentieth pivot-cluster package). §the-named-minimal-utility-README-shape; §eight-shapes-of-README extends cycle 351's seven-shape; §the-named-inverse-pair-as-API-shape; §three-shapes-of-utility-API-surface; §three-cycles-with-named-Uint8Array-as-byte-representation (315 + 318 + 355). Third authored-conformant single-body section doc in the post-refactor era. Nine citation arcs closed including 174-cycle arc to cycle 181 (@endo/base64 source comment-fragment).
