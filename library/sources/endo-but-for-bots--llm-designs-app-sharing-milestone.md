---
source: designs/app-sharing-milestone.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 26467aa2a377c35e6eac63ba15402d66c3f57a27
source_date: 2026-06-01
source_authors: [Aaron (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-seventh-comment-style design ingest (cycle 151).
  256-line *Proposed* status milestone design by Aaron
  *(prompted)*, created 2026-06-01. **Second Aaron-authored
  design** ingested (after cycle 143's familiar-app-ui-
  hosting). Last touch commit `26467aa2a` 2026-06-01 by
  Claude: `docs(designs): reconcile app-sharing milestone
  with in-flight PRs`.

  **Coordination document, not a primary spec.** Sequences
  existing slices and identifies *connective tissue*. The
  §milestone-not-bucket discipline: a *cut* across M1-M3, not
  a new category of work.

  Single most structurally interesting move: §end-to-end-
  make-a-thing-send-it-run-it framing as the product
  narrative. The cut produces one demonstrable flow rather
  than a complete-each-milestone-linearly march.

  §three-pillars: (1) distribute the chat app as a
  downloadable; (2) connect to peers via deep-link URL; (3)
  make and share runnable apps with sandboxed UI. §user-
  experience-as-pillar-anchor discipline — pillars defined by
  what the user does, not what the engineering team builds.

  §verified-current-state methodology — *audit-before-spec*
  with §3-paragraph-form per pillar (Complete pieces + single
  missing piece + optional in-flight reconciliations).
  §file-path-and-PR-citation density throughout; the document
  reads as *live map* of codebase + tracker.

  §Pillar-1-adopts-familiar-release.md discipline (the
  governance move): *This pillar is already an active
  workstream — defer to it, do not restate*. §adopt-existing-
  plan-don't-compete-with-it; §two-designs-must-not-define-
  the-same-thing-twice invariant; §named-deferral move (cite
  the owning design + scope-handoff). §macOS-arm64-first MVR
  inherited scope. §swarm-of-G-item-PRs catalog: ten PRs
  listed implementing G1/G4/G5/G7/G8/G13/G14/G15/G16.

  §Pillar-2-daemon-ready-shell-missing: three Complete +
  one Missing. §template-for-the-missing-piece — `localhttp://`
  already works in Familiar, so `endo://` is the same pattern
  applied; §similar-shape-as-precedent reduces design risk.

  §Pillar-3-run-and-serialise-exist-transfer-and-UI-missing:
  two Complete + three Missing. The Missing pieces are owned
  by §three-new-designs introduced by this milestone
  (`familiar-deep-link-invitations`, `endo-app-sharing`,
  `familiar-app-ui-hosting` = cycle 143's design). §reconcile-
  don't-duplicate posture for in-flight work: explicit refs
  to `familiar-run-apps-vfs.md` (PR #241) + exo-zip/exo-unzip
  (#160) + exo-stream (#330) + daemon git-tree archive
  (#367). §parallel-substrate-acknowledgment.

  §four-phase plan with §exit-criterion-per-phase: P0 (signed
  installer) → P1 (deep-link invite) → P2 (app handle +
  sandboxed UI + share remote ref) → P3 (clone & share with
  cloneable policy). §user-flow-as-completion-gate. §P3-
  honors-cloneable-policy with §transport-handles-integrity
  discipline (no per-blob hashing; OCapN-Noise provides
  integrity).

  §one-paragraph-tells-the-whole-story Exit Criterion ties
  pillars to one flow: *non-developer installs signed
  Familiar, clicks endo:// invite, confirms+names peer,
  receives shared app as remote-ref or independent copy with
  partial-sandbox UI*.

  §Related-in-flight-PRs catalog (20+ PRs by pillar) with
  §genuinely-net-new-vs-substrate distinction: *The two
  genuinely net-new pieces — `endo://` deep-link invites and
  the streaming clone helper + zip-backed receiver — have no
  open PR; everything else below is substrate to reconcile
  against rather than re-invent*. §minimize-new-work-
  maximize-leverage.

  §raw-doc-URLs-not-durable caveat: *they point at the PR
  head branches as they stand on 2026-06-01; if a branch is
  rebased or merged the link may move. The PR link is the
  durable anchor*. §two-anchor-policy (PR durable; raw-doc
  convenience).

  §Aaron-authored-pair observation: both Aaron designs (cycle
  143 + this) touch Pillar 3 (UI sandboxing + the milestone
  coordinating Pillar 3 with others). Suggests Aaron's domain
  is *app-sharing + UI hosting*. The library now records
  three distinct attribution shapes: Kris Kowal *(prompted)*,
  Joshua T Corbin *(evoked)*, Aaron *(prompted)*.

  §coordination-doc-as-graph-edge role: this single document
  touches *dozens* of prior cycles' work; more outbound
  references than original content. The §milestone-as-
  clustering-event observation.

  Cycle 151 was nominally papers-lane (cycle 150 was comments
  — milestone tick at 9th pass-style file). Papers-lane has
  been blocked for 45+ consecutive cycles. Cycle 151 pivoted
  to designs-lane.
---

> Abstract: `app-sharing-milestone.md` (256 lines, *Proposed*)
> is a **milestone coordination document** by Aaron
> *(prompted)* — the second Aaron-authored design after
> cycle 143's familiar-app-ui-hosting. Created 2026-06-01.
>
> **Single most structurally interesting move**: §milestone-
> not-bucket — *it is a cut, not a new bucket of unrelated
> work*. The §end-to-end-make-a-thing-send-it-run-it product
> narrative makes the cut coherent.
>
> §Three-pillars (downloadable installer / deep-link peer
> connect / runnable+shareable apps with sandboxed UI) with
> §user-experience-as-pillar-anchor discipline.
>
> §Verified-current-state methodology — *audit-before-spec*
> with file paths + PR refs throughout.
>
> §Pillar-1-adopts-familiar-release.md — the governance move:
> *defer to existing plan, do not restate*. §two-designs-
> must-not-define-the-same-thing-twice invariant.
> §macOS-arm64-first MVR scope.
>
> §Pillar-2 + §Pillar-3 each decomposed into Complete +
> Missing. §reconcile-don't-duplicate for parallel-angle
> work (familiar-run-apps-vfs / exo-zip / exo-stream).
>
> §Four-phase plan with §exit-criterion-per-phase + §user-
> flow-as-completion-gate. §P3-honors-cloneable-policy with
> §transport-handles-integrity.
>
> §Genuinely-net-new-vs-substrate distinction in the 20+ PR
> catalog: only two pieces genuinely new; everything else is
> substrate-in-flight.
>
> §Aaron-authored-pair touching Pillar 3 (UI + coordination).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline](../sections/endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline.md) | daemon, agent-conventions, chat-ui | current |

Tight 256-line *Proposed* milestone design. One cohesion-
honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  26467aa2a` (branch `origin/llm`) via the local bare-clone.
- Created 2026-06-01 / status *Proposed*. Author Aaron
  *(prompted)*.
- Last touch commit `26467aa2a` 2026-06-01 by Claude:
  `docs(designs): reconcile app-sharing milestone with
  in-flight PRs`.
- **Thirty-seventh-comment-style design ingest.**
- **Second Aaron-authored design** ingested (after cycle 143's
  familiar-app-ui-hosting).
- Cycle 151 was nominally **papers-lane** (cycle 150 was
  comments — milestone tick at 9th pass-style file).
  Papers-lane has been blocked for **45+ consecutive cycles**
  due to lack of PDF-fetching infrastructure. Cycle 151
  pivoted to designs-lane.
- One cohesion-honest section.
