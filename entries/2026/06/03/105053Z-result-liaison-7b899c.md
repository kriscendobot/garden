---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--7b899c
ts: 2026-06-03T10:50:53Z
ref_id: 7b899c
---

# Cycle 151 result — app-sharing-milestone.md (thirty-seventh-comment-style design ingest; second Aaron-authored design)

Cycle 151 of the librarian arc. Nominally papers-lane (cycle 150 was
comments — milestone tick at 9th pass-style file); papers-lane has
been blocked for **45+ consecutive cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/app-sharing-milestone.md` — 256-line
*Proposed* status milestone *coordination document* by Aaron
*(prompted)*, created 2026-06-01. Last touch commit `26467aa2a`
2026-06-01 by Claude: `docs(designs): reconcile app-sharing
milestone with in-flight PRs`. **Second Aaron-authored design**
ingested (after cycle 143's familiar-app-ui-hosting).

## Structural moves captured

- **Single most structurally interesting move**: §milestone-not-
  bucket discipline — *it is a cut, not a new bucket of unrelated
  work*. The §end-to-end-make-a-thing-send-it-run-it product
  narrative makes the cut coherent.

- **§Three-pillars** (downloadable installer / deep-link peer
  connect / runnable+shareable apps with sandboxed UI) with
  §user-experience-as-pillar-anchor discipline.

- **§Verified-current-state methodology** — §audit-before-spec with
  §3-paragraph-form per pillar. §File-path-and-PR-citation density
  throughout (live map of codebase + tracker).

- **§Pillar-1-adopts-familiar-release.md governance move**: *defer
  to existing plan, do not restate*. §two-designs-must-not-define-
  the-same-thing-twice invariant; §named-deferral; §macOS-arm64-
  first MVR scope; §swarm-of-G-item-PRs catalog (ten named PRs for
  G1/G4/G5/G7/G8/G13/G14/G15/G16).

- **§Pillar-2 + §Pillar-3 decomposition** with §template-for-the-
  missing-piece (Pillar 2: `localhttp://` already works → `endo://`
  is the same pattern). §similar-shape-as-precedent reduces design
  risk. §Reconcile-don't-duplicate for parallel-angle work
  (familiar-run-apps-vfs / exo-zip / exo-stream / daemon git-tree
  archive).

- **§Four-phase plan** with §exit-criterion-per-phase + §user-flow-
  as-completion-gate. §P3-honors-cloneable-policy with §transport-
  handles-integrity (no per-blob hashing; OCapN-Noise provides
  integrity at wire layer).

- **§Genuinely-net-new-vs-substrate distinction** in the 20+ PR
  catalog: only two pieces genuinely new (`endo://` deep-link
  invites + streaming clone helper/zip-backed receiver); everything
  else is substrate-in-flight. §minimize-new-work-maximize-leverage.

- **§Raw-doc-URLs-not-durable caveat** with §two-anchor-policy (PR
  link durable; raw-doc convenience).

- **§Aaron-authored-pair observation**: both Aaron designs (cycle
  143 + this) touch Pillar 3 — UI sandboxing + the milestone
  coordinating Pillar 3 with others. Library now records three
  distinct attribution shapes: Kris Kowal *(prompted)*, Joshua T
  Corbin *(evoked)*, Aaron *(prompted)*.

- **§Coordination-doc-as-graph-edge role**: this single document
  touches dozens of prior cycles' work; more outbound references
  than original content. §Milestone-as-clustering-event.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-app-sharing-milestone`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-app-sharing-milestone--three-pillar-cut-with-verified-current-state-methodology-and-adopt-existing-plan-discipline.md`
- **Topics**: daemon, agent-conventions, chat-ui
- **Library totals**: 655 sections from 196 source documents
- **Lane rotation**: nominally papers-lane (45+ consecutive blocks);
  pivoted to designs-lane

Cycle 151 closes. Schedule next wake 1500s for cycle 152.
