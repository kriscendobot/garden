---
title: §The preserved JSDoc typo — `type {Map<string, ZFile>}` missing the `@`
source-slug: endo--packages-zip-src-writer-js
section-slug: ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
source-repo: endojs/endo
source-path: packages/zip/src/writer.js
source-author: Endo project (collective)
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
---

Line 14: `/** type {Map<string, ZFile>} */`

§The-correct-JSDoc-tag-IS-`@type`-not-`type` — §the-`@`-prefix-IS-the-JSDoc-syntax-marker + §without-the-`@`-the-annotation-IS-effectively-a-no-op + §the-TypeScript-checker-ignores-this-comment.

§First-explicit-observation in library: **§a-preserved-JSDoc-typo (missing `@` on `type` annotation) — §the-typo-IS-evidence-of-imperfect-review + §the-discipline-of-running-`yarn lint`-and-`tsc --build`-from-the-project-CLAUDE.md (cycle 273's read-through) would-have-caught-this-but-didn't + §the-typo-persists-in-the-current-tree**.

§Two-cycles-with-preserved-typo-as-evidence (263 outliner-design-doc-2's `or something.f` + 280 writer.js's `type {Map<string, ZFile>}`):
- **Cycle 263** — typo IS evidence of design-fragment's-informal-status (a deliberate choice to keep the document as in-flight thinking).
- **Cycle 280** — typo IS evidence of imperfect review (the lint-and-tsc check should have caught this but didn't).

§First-explicit-observation in library: **§two-named-shapes-of-preserved-typo (deliberate-informal-status + imperfect-review-trace) — §the-typo's-status-depends-on-the-document's-genre**.
