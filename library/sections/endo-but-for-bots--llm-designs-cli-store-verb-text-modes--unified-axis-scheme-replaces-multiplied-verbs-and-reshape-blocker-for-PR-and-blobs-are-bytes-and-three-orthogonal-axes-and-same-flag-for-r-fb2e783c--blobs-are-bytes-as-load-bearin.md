---
title: §Blobs-are-bytes as load-bearing maxim
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

§Decisions-section opens with §Blobs-are-bytes — the maxim is §attributed-to-a-specific-PR-review-comment (PR #153 discussion_r3213469481): "Blobs are bytes." §When-a-maxim-is-load-bearing, §quote-it-verbatim-from-the-PR-review-and-cite-the-comment-id-by-link.

§Three-cycles-with-PR-discussion-link-as-named-provenance (cycles 238 + 239 + 240). §The-PR-discussion-link is now a recurring named-provenance shape. §When-a-named-decision-resulted-from-a-PR-discussion, §link-to-the-comment-id-not-just-the-PR-number — §the-comment-id-anchors-to-the-specific-sentence + §the-PR-number-anchors-only-to-the-larger-context.

§No-content-type-on-blobs: §the-daemon-does-not-store-charset-content-type-or-text-vs-blob-mode-on-blobs. §When-data-has-out-of-band-metadata, §the-metadata-stays-out-of-band (in pet name, in consumer's expectation, or in a sibling formula). §Three-named-places-for-out-of-band-metadata (pet-name + consumer-expectation + sibling-formula). §When-a-store-supports-many-data-types, §pick-the-narrowest-uniform-representation-and-name-the-out-of-band-metadata-locations.

§The-`--text`-and-`--blob`-split is §intentionally-narrow: §`--text`-is-for-primitive-string-values + §it-does-not-absorb-a-file-into-a-blob-with-text-metadata. §When-a-flag-could-be-overloaded-to-add-metadata, §refuse-the-overload + §point-the-user-at-the-explicit-blob-path-with-downstream-UTF-8-decode.
