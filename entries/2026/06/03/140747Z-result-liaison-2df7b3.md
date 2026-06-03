---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--2df7b3
ts: 2026-06-03T14:07:47Z
ref_id: 2df7b3
---

# Cycle 157 result — exo-zip-package.md (fortieth-comment-style design ingest)

Cycle 157 of the librarian arc. Nominally papers-lane (cycle 156 was
comments — milestone tick at 50+ consecutive papers-lane blocks);
papers-lane has been blocked for **51+ consecutive cycles**.
Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/exo-zip-package.md` — 429-line *Proposed*
status design by Kris Kowal *(prompted)*, created 2026-05-08.
Source named in metadata: **PR #128 inline review comment**
([discussion_r3205653903](https://github.com/endojs/endo-but-for-bots/pull/128#discussion_r3205653903)).
Last touch commit `11d04c95` 2026-05-08 by Kriscendo Bot.

## Structural moves captured

- **§Design-as-formalized-review-comment lifecycle**: the
  maintainer's review comment on `packages/cli/src/commands/checkin.js:36`
  became the design seed. §inline-comment-becomes-traceable-design
  discipline.

- **§Load-bearing-context**: PR #128's tempdir-then-walk anti-pattern.
  §three-costs frame: tmpdir+cleanup / doubled I/O / conflated
  concerns. §enumerate-the-costs methodology.

- **§Desired-shape preview** with §show-the-collapse pattern
  (before/after code snippets).

- **Single most structurally interesting move**: §asymmetric-by-design
  read/write API. §asymmetry-is-real-and-load-bearing — write side
  has no `WritableTree` interface to dual. §don't-invent-
  WritableTree-just-for-symmetry; §write-side-no-WritableTree-
  interface observation.

- **§Inline-is-fine-until-multiple-uses maintainer guidance**
  (quoted from review #4255618212). §wait-for-second-consumer-
  before-extracting-a-helper discipline; §authority-trail.

- **§Eight Design Decisions + §Three Resolved Questions**.
  §resolved-questions-not-open-questions distinction.
  §captured-resolution-trail discipline. §three-step-design-
  lifecycle (open question → review resolution → folded into
  body).

- **§Lazy-materialisation discipline** (Design Decision 3):
  §grouping-pass-produces-child-factories; §amortize-allocation-
  over-lookups; §lazy-evaluation-as-correctness-not-optimization.

- **§Hostile-input-rejection-at-construction**: §fail-fast-at-
  construction + §security-check-at-the-entry-point.

- **§Reuse-platform-interface-not-daemon-interface** (Design
  Decision 2): §minimal-interface-conformance-keeps-dependencies-
  narrow; §which-side-of-CapTP-determines-the-interface;
  §interface-asymmetry-tracks-ownership-asymmetry.

- **§Uint8Array-not-stream input** (Design Decision 7) with
  §three-constraint-combination rationale; §defer-streaming-
  zip-until-seekable-stream-exists; §future-compatibility-via-
  overload.

- **§Separate-package-not-sibling-export** (Design Decision 8):
  §package-cleanliness-as-design-constraint; §don't-pollute-a-
  clean-package (parallel to cycle 142's passStyle-helpers
  avoiding SES dependency).

- **§Reshape-blocker-for-PR-128**: §design-documents-its-
  downstream-impact pattern.

- **§Three-phase-implementation** with §S-sized-phases; §small-S-
  phases-can-bundle.

## Cluster citations

- **Cycle 151's app-sharing-milestone** Pillar 3 explicitly cites
  this design's `exo-zip / exo-unzip` family (PR #160) as the
  §streaming-clone-substrate.
- **`daemon-checkin-checkout`** — primary consumer of `makeExoZip`.
- **`daemon-weblet-application`** — defines the
  `ReadableTreeInterface` this design conforms to.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-exo-zip-package`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail.md`
- **Topics**: exo, daemon, marshal
- **Library totals**: 661 sections from 202 source documents
- **Lane rotation**: nominally papers-lane (51+ consecutive blocks);
  pivoted to designs-lane

Cycle 157 closes. Schedule next wake 1500s for cycle 158.
