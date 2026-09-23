---
title: Single most structurally interesting move
section-slug: endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise
source-slug: endo--packages-zip-src-format-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/format-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/format-reader.js
total-lines: 479
ingest-cycle: 296
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-format-reader-js--symmetric-reverse-pipeline-and-Zip64-rejection-with-security-rationale-and-findLast-deliberately-not-used-and-named-strike-a-compromise
---

**§the-explicit-comment-against-`reader.findLast(signature.CENTRAL_DIRECTORY_END)`** with **§the-named-tool-IS-available-but-deliberately-not-used** — cycle 292's buffer-reader.js EXPOSES `findLast` as a method explicitly named "for zip's end-of-central-directory record". But cycle 296's format-reader.js **deliberately doesn't use it**, naming three named justifications:

1. **The spec-prescribed method** (named via the comment as the convention).
2. **The named threat-model** ("undesirable, attackable ambiguities").
3. **The named organizational position** ("Agoric is not comfortable supporting").

The result: cycle 292's tool exists but cycle 296's code declines to use it. **§the-named-tool-IS-available-but-the-named-implementation-IS-narrower-than-the-tool-permits**. The discipline IS to *provide a tool* (cycle 292) AND *deliberately not use it for security reasons* (cycle 296) — and to *document the choice in the consuming code*, not just in the tool's docs.

This generalizes to any security-sensitive parser: the library may expose lenient parsing tools, but specific consumers may deliberately use stricter parsing for threat-model reasons. The discipline IS to *name the choice at the consumer site*, not at the tool site. **§the-named-restriction-IS-the-consumer's-responsibility-not-the-library's**.

§the-named-decoupling-of-tool-from-policy: the tool (findLast) IS general; the policy (don't use it for finding end-of-central-directory record because of attack ambiguities) IS specific to this file. The cycle 292 buffer-reader.js doesn't need to know that cycle 296 format-reader.js declines to use one of its methods; the declination IS documented at the consumer.

§the-named-meta-discipline: cycles 292 and 296 together form a *named pedagogy* about *when to use library tools and when not to*. The reader IS expected to recognize that "the library provides X, but we don't always use it" — a more nuanced posture than "the library IS the API".
