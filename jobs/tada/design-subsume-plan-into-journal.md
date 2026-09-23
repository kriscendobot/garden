Done. The work is committed on the PR branch; `main2`'s working tree is back as it was (the index row is part of the PR diff, not `main2`).

---

## Completion report

**Job:** `design-subsume-plan-into-journal` — propose subsuming the endo "plan" into the garden journal as a cross-repo, automated planning system.

**Deliverable:** DRAFT PR **#4** against `kriskowal/garden` base `main2` — https://github.com/kriskowal/garden/pull/4
**Design slug:** `plan-in-journal` (`designs/plan-in-journal.md`, plus an index row in `designs/README.md`).

**What I did:** Grounded the proposal in the garden's actual in-flight architecture (read `designs/job-board.md`, `gardening-state-machine.md`, `driver.md`, the foreman/journalist role files, `scripts/jobs/foreman.sh` and `bulletin.sh`, and the endo/endo-but-for-bots project READMEs that name the `llm` roadmap branch and the `journal/plan/` consumers), then wrote a self-contained design in house style (no em-dashes, no Latin shorthand, relative links, mermaid diagrams). Branched `design/plan-in-journal` off `main2`, committed only the two design files (the pre-existing uncommitted foreman changes in the working tree were left out of the PR), pushed, and opened the PR as a draft. Verified: `isDraft: true`, base `main2`, state OPEN.

**Proposed source-of-truth and cutover (one paragraph):** Per-design **metadata records** under `journal/plan/designs/<repo>/<slug>.md` on `journal2` become the single source of truth; the roadmap view (`journal/plan/README.md` — table, mermaid dep graph, estimates) is **generated**, never hand-edited, which retires the manual `designs/CLAUDE.md` sync discipline. Design *narrative* stays in its home repo (referenced by a `narrative:` pointer); only the *plan* metadata becomes garden state. A `repository` field adds the cross-repo dimension (garden, `endojs/endo`, `endojs/endo-but-for-bots`; **agoric-sdk rejected by the validator**), with dependency edges and critical path crossing repo boundaries. A **roadmap renderer** modeled on the bulletin loop (durable cursor, change-gated CAS push, multi-host idempotence) regenerates the view; velocity recalibration, roadmap projection, dependency-graph validation, and a reconciliation gardener job cover the rest of the process. Migration is phased so nothing breaks mid-flight: shadow-import → flip source of truth (endo README becomes a generated mirror) → cut consumers over in risk order — **bulletin** (already journal-local), then **journalist** (bins against records instead of the `llm` `designs/README.md`), then **foreman** (reads `journal/plan/milestones/` + records to pick the next unblocked step, gaining cross-repo sequencing), then **design-poller** (readiness becomes a plan query) — then cross-repo activation, then retire the manual discipline.

**Changes:** New `designs/plan-in-journal.md`; one index row added to `designs/README.md` (both on the PR branch only).

**Follow-ups / open questions for the maintainer** (in the design's final section): narrative-stays-vs-moves; record granularity (per-design files vs. one plan file); who owns the Complete transition; renderer as a standalone service vs. folded into `garden-bulletin.service`; Phase-1 mirror lifetime; per-repo review-queue latency; metadata field naming. This stays a draft for review — no build/implementation chain was run.

**Self-improvement:** nothing this time.
