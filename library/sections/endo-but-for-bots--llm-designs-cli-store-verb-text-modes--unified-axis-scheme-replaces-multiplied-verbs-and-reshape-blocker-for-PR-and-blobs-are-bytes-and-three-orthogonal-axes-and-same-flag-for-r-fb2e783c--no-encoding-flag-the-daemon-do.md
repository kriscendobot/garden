---
title: §No-encoding-flag-the-daemon-does-not-negotiate-codecs
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write
---

§All-text-input-and-output-is-UTF-8. §There-is-no-`--encoding`-flag. §Inputs-that-are-not-valid-UTF-8-in-text-modes-are-rejected-at-the-CLI-boundary. §When-a-CLI-touches-text-modes, §pick-one-encoding-and-reject-everything-else-at-the-boundary + §the-daemon-doesn't-negotiate-codecs + §validation-is-at-the-CLI-not-spread-throughout.

§Sibling-to-cycle-237's §undefined-sorts-greater-than-anything-else as §named-canonical-decision-about-input-shape (both designs make a single decision and refuse to negotiate). §Two-cycles-with-canonical-single-encoding-or-ordering-decision (cycles 237 + 240).
