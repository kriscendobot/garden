---
source: designs/exo-zip-package.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 11d04c95476c942651faf4c3296ac52ee6e6b025
source_date: 2026-05-08
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Fortieth-comment-style design ingest (cycle 157). 429-line
  *Proposed* status design by Kris Kowal *(prompted)*,
  created 2026-05-08. **§Source named in metadata**: PR #128
  inline review comment ([discussion_r3205653903]). Last
  touch commit `11d04c95` 2026-05-08 by Kriscendo Bot.

  §Design-as-formalized-review-comment lifecycle: the
  maintainer's review comment on `packages/cli/src/commands/
  checkin.js:36` became the design seed. §inline-comment-
  becomes-traceable-design discipline.

  §Load-bearing-context: PR #128's anti-pattern — extracting
  the zip into a temporary directory and then walking that
  directory. §Three-costs frame (tmpdir+cleanup / doubled I/O
  / conflated concerns). §Enumerate-the-costs methodology.

  §Desired-shape preview: single-call `await E(agent).
  storeTree(makeExoZip(zipBytes), parsedName)`. §show-the-
  collapse pattern (before/after code snippets demonstrate
  value before implementation details).

  Single most structurally interesting move: §asymmetric-by-
  design read/write API. *The package is asymmetric on
  purpose*. **Read side**: daemon's `storeTree` consumes
  ReadableTree over CapTP; CLI must hand a remotable → exo
  adapter is the only bridge. **Write side**: CLI has direct
  access to the daemon's readable-tree exo and can walk it;
  *No `WritableTree` interface exists in
  platform/src/fs/interfaces.js*. §don't-invent-WritableTree-
  just-for-symmetry discipline; §write-side-no-WritableTree-
  interface observation. §Asymmetry-is-real-and-load-bearing.

  §Inline-is-fine-until-multiple-uses maintainer guidance
  (quoted from review #4255618212). §wait-for-second-
  consumer-before-extracting-a-helper discipline. §authority-
  trail discipline (design cites the review).

  §Eight-Design-Decisions + §Three-Resolved-Questions
  structured at end. §resolved-questions-not-open-questions
  distinction: questions were *resolved inline by the
  maintainer*; resolutions folded into design body; trail
  preserved. §captured-resolution-trail discipline. §three-
  step-design-lifecycle (open question → review resolution →
  folded into design body).

  §Three-component package skeleton with §explicit-
  dependency-list. §pure-ECMAScript-no-Node-builtins
  discipline (loadable in XS / browsers / SES realms).
  §Portability-as-constraint.

  §Lazy-materialisation discipline (Design Decision 3):
  *A 10 000-entry archive should not allocate 10 000 exos at
  makeExoZip time*. §grouping-pass-produces-child-factories.
  §amortize-allocation-over-lookups. §lazy-evaluation-as-
  correctness-not-optimization observation.

  §Hostile-input-rejection-at-construction discipline:
  empty path components and `.` / `..` segments rejected at
  makeExoZip time, not at lookup. §fail-fast-at-construction
  + §security-check-at-the-entry-point pattern.

  §Reuse-platform-interface-not-daemon-interface (Design
  Decision 2): platform's smaller `ReadableTreeInterface`
  (no sha256, no help) keeps package free of daemon
  dependencies. §minimal-interface-conformance-keeps-
  dependencies-narrow. §which-side-of-CapTP-determines-the-
  interface discipline. §Interface-asymmetry-tracks-
  ownership-asymmetry.

  §Single-chunk-streamBase64 acceptable (Design Decision 5):
  @endo/zip buffers each entry's decompressed bytes in
  memory. §no-API-change-needed-for-future-chunking. §forward-
  compatible-by-iterator-shape discipline.

  §Uint8Array-not-stream input (Design Decision 7) with
  §three-constraint-combination rationale: (1) @endo/zip
  needs central-directory bytes at end-of-file with random-
  access; (2) no seekable-stream concept exists in @endo;
  (3) inventing seekable-stream is out of scope. §defer-
  streaming-zip-until-seekable-stream-exists. §future-
  compatibility-via-overload.

  §Separate-package-not-sibling-export (Design Decision 8):
  *@endo/zip is deliberately dependency-free*; folding
  adapter in would entrain Passable/exo machinery. §package-
  cleanliness-as-design-constraint. §don't-pollute-a-clean-
  package discipline (parallel to cycle 142's passStyle-
  helpers.js avoiding SES dependency by duplicating
  isTypedArray).

  §Uint8Array-not-Buffer (Design Decision 6) per project
  portability rules.

  §Reshape-blocker-for-PR-128 explicit dependency. §design-
  documents-its-downstream-impact pattern.

  §Three-phase-implementation with §S-sized-phases (all small;
  phases 1+2 bundle in one PR; phase 3 follows). §small-S-
  phases-can-bundle observation.

  §Cluster-citations: cycle 151's app-sharing-milestone
  Pillar 3 cites this design's exo-zip family as substrate.
  §daemon-checkin-checkout primary consumer. §daemon-weblet-
  application defines the interface this conforms to.

  Cycle 157 was nominally papers-lane (cycle 156 was
  comments — milestone tick at 50+ consecutive papers-lane
  blocks). Papers-lane blocked 51+ consecutive cycles. Cycle
  157 pivoted to designs-lane.
---

> Abstract: `exo-zip-package.md` (429 lines, *Proposed*) is a
> **§design-as-formalized-review-comment** by Kris Kowal
> *(prompted)*. Source named in metadata: PR #128 inline
> review comment.
>
> §Load-bearing-context: PR #128's anti-pattern of extracting
> zip to tempdir then walking. §Three-costs frame.
>
> §Desired-shape: single-call collapse. §show-the-collapse
> pattern (before/after demonstration).
>
> **Single most structurally interesting move**: §asymmetric-
> by-design read/write API. *Asymmetry is real and load-
> bearing* — read side needs an exo adapter; write side has
> no WritableTree interface to dual. §don't-invent-
> WritableTree-just-for-symmetry; §write-side-no-WritableTree-
> interface observation.
>
> §Inline-is-fine-until-multiple-uses maintainer guidance.
> §wait-for-second-consumer-before-extracting-a-helper.
>
> §Eight Design Decisions + §Three Resolved Questions.
> §captured-resolution-trail discipline. §three-step-design-
> lifecycle (open question → review resolution → folded).
>
> §Lazy-materialisation + §hostile-input-rejection-at-
> construction + §reuse-platform-interface-not-daemon-
> interface + §single-chunk-streamBase64 + §Uint8Array-not-
> stream + §separate-package-not-sibling-export + §pure-
> ECMAScript-no-Node-builtins + §Uint8Array-not-Buffer.
>
> §Reshape-blocker-for-PR-128. §Three-phase-implementation
> with §S-sized-phases.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail](../sections/endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail.md) | exo, daemon, marshal | current |

Tight 429-line *Proposed* design with eight Design Decisions
+ three Resolved Questions. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  11d04c95` (branch `origin/llm`) via the local bare-clone.
- Created 2026-05-08 / status *Proposed*. Author Kris Kowal
  *(prompted)*.
- Last touch commit `11d04c95` 2026-05-08 by Kriscendo Bot:
  *design(exo-zip): in-memory ZIP as exo readable-tree*.
- Source: PR #128 inline review comment
  ([discussion_r3205653903](https://github.com/endojs/endo-but-for-bots/pull/128#discussion_r3205653903)).
- **Fortieth-comment-style design ingest.**
- Cycle 157 was nominally **papers-lane** (cycle 156 was
  comments — milestone tick at 50+ consecutive papers-lane
  blocks). Papers-lane has been blocked for **51+
  consecutive cycles**. Cycle 157 pivoted to designs-lane.
- One cohesion-honest section.
