---
source_kind: source-cluster
source_repo: endojs/endo
source_path: packages/base64/{index.js,atob.js,btoa.js,decode.js,encode.js,shim.js,src/common.js}
source_line_range: ~90 lines across 7 files
file_commit: 7325bbe15f481275da6d5faf7445cc16b72ada82
file_commit_date: 2026-04-30
file_commit_author: Kris Kowal
ingested: 2026-06-16
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 356 chat-lane ingest. 7-file entry-point cluster of
  @endo/base64. Adjacent forward pair with cycle 355 README.
  TWELFTH complementary-lens re-ingest of cycle 181's earlier
  @endo/base64 source comment-fragment ingest. Fourth
  authored-conformant single-body section doc in post-refactor
  era.

  Single most structurally interesting move: §the-named-
  Object-freeze-not-harden-in-pre-lockdown-modules-with-
  named-rationale — index.js opens with substantial comment
  block explaining WHY Object.freeze is used at module-
  evaluation time rather than @endo/harden (the shim path
  via @endo/init/pre.js must not pull in @endo/harden which
  would install a fallback before SES lockdown runs). §the-
  named-pre-lockdown-shim-path-must-not-import-harden as
  tier-3 meta-pattern.

  §the-named-mixed-forwarder-and-implementation-cluster —
  base64 cluster has THREE shapes mixed: single-line
  forwarders to src/ (decode.js + encode.js) + thin
  implementations at top level (atob.js + btoa.js wrapping
  src/ functions) + aggregator with rationale (index.js).
  Structurally different from cycle 346's all-forwarders SES
  cluster AND cycle 344's all-rungs init cluster. §three-
  shapes-of-tiny-files-orchestration (rung-as-entry-point +
  stability-via-thin-forwarder + mixed-forwarder-and-
  implementation) extending cycle 346's two-shapes.

  Other tier-3 meta-patterns: §the-named-conditional-
  install-discipline (three-cycles 187 + 343 + 356); §the-
  named-greek-wordplay-as-discipline-naming (monodu64
  reverse-mapping name); §the-named-named-reverse-mapping-
  with-etymological-rationale; §the-named-substrate-with-
  primitive-plus-platform-wrapper-pair (base64 exports both
  encodeBase64/decodeBase64 primitives AND atob/btoa
  platform-compatible wrappers).

  Closes eight citation arcs: cycle 355 (1) + cycle 352 (4)
  + cycle 181 (175, base64 source first ingest as
  comment-fragment; TWELFTH complementary-lens re-ingest) +
  cycle 187 (169) + cycle 343 (13) + cycle 344 (12) + cycle
  346 (10) + cycle 326 (30). Pushes citation-arc-closures-
  in-pivot to ONE-HUNDRED-SEVENTY-TWO (167 + 5 net new).
---

7-file entry-point cluster of @endo/base64 (cycle 356 chat-lane). TWELFTH complementary-lens re-ingest of cycle 181's earlier source ingest. Single most structurally interesting move: §the-named-Object-freeze-not-harden-in-pre-lockdown-modules-with-named-rationale — index.js's comment block explains the FULL pre-lockdown shim discipline. §the-named-mixed-forwarder-and-implementation-cluster + §three-shapes-of-tiny-files-orchestration extends cycle 346's two-shapes with a THIRD shape. §the-named-conditional-install-discipline (three cycles 187 + 343 + 356). §the-named-substrate-with-primitive-plus-platform-wrapper-pair. Eight citation arcs closed including 175-cycle arc to cycle 181 (twelfth complementary-lens).
