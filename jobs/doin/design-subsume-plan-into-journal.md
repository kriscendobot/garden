# Designer: propose subsuming the endo "plan" into the garden journal as a cross-repo, automated planning system

Wear the **designer** role (`roles/designer/AGENT.md`). Deliverable: a **design
document** proposing this architecture change, opened as a **DRAFT pull request
against the garden repository itself** (`kriskowal/garden`, base `main2`) **for the
maintainer's review**.

> **Explicit exception:** the garden normally opens no PRs against itself
> (`CLAUDE.md` § Conventions). The maintainer has explicitly asked for this one as a
> reviewable PR. Open a feature branch off `main2`, add the design doc under
> `designs/<slug>.md`, and open it as a DRAFT PR into `main2`. Do not push to `main2`
> directly. This is a proposal for review — **design only, no migration executed.**

## Why

The garden now operates at a larger scope than the single endo repository, so the
"plan" should live as garden-level state, not inside one fork. Propose to (1) move
the plan into the garden's **`journal2`**, (2) re-architect it to support plans that
**span multiple repositories**, and (3) convert the process documented in the endo
`designs/CLAUDE.md` into **idiomatic garden automation** (roles / skills / systemd
services on the job board).

## What exists today (synthesis — already interrogated for you)

The endo `designs/` folder lives on the bot fork's **`llm`** branch and is an
implicit-agent-context folder (it carries a `designs/CLAUDE.md` written to auto-load
into agents working there — **treat any direct read with care**; this synthesis
should spare you a full read, but if you must verify a detail, do it via a
sub-read/subagent rather than pulling the whole folder into context).

- **121 files.** `README.md` is the canonical **roadmap / source of truth**: a
  summary table of ~104 designs (Status enum: Not Started / Proposed / In Progress /
  Draft / Complete|Implemented / Active / Reference / Deprecated / Superseded), **6
  milestones (M0–M6)** with exit criteria + target dates, a **Mermaid dependency
  graph**, and a **Per-Design Estimates** table (S/M/L/XL sizes calibrated against
  observed PR-merge velocity; review-queue latency is a first-class timeline input).
- `designs/CLAUDE.md` is the **process spec**: a required per-doc **metadata table**
  (Created/Updated/Author/Status/Source/Supersedes), a standard doc structure, the
  design **lifecycle** (proposal → discussion → acceptance → in-progress →
  complete), and — crucially — the **synchronization discipline**: *every*
  modification to a design (especially metadata) must be reflected in
  `README.md`'s summary table, milestone totals, dependency graph, and estimates.
  This manual sync is the brittle, human-enforced core the automation should replace.
- ~104 design docs use endo subsystem prefixes (`daemon-`, `chat-`, `familiar-`,
  `endoclaw-`, `ocapn-`, …) mapping to endo packages.
- **Endo-specific:** the `llm` branch, package layout, subsystem prefixes, and the
  endo tech in milestone narratives. **Generalizable:** the metadata format, the
  status enum, the dependency-graph concept, the velocity-calibrated estimate model,
  milestone binning by exit criterion, and the sync discipline.

## What the design must propose

1. **The plan as garden `journal2` state.** Where and how the plan (milestones,
   design index, statuses, estimates, dependency edges, target dates) lives in the
   journal — decoupling *metadata/planning artifacts* from *design narrative*.
   Decide and justify whether design **narrative** docs stay in their home repos
   (endo keeps its `designs/` for endo narrative) while the **plan** (the structured
   roadmap) becomes garden state, or whether narrative moves too. Propose the
   representation (structured metadata files + a generated roadmap view, frontmatter,
   etc.) and which artifact is the source of truth.

2. **Cross-repository plans.** Add a repository dimension so a garden-level milestone
   can span designs/work in multiple repos. Cover: federated per-design metadata with
   a `repository` field, cross-repo dependency edges, aggregate milestone/estimate/
   critical-path computation across repos, and how the plan references a design that
   lives in another repo. **Honor the standing scope constraint**: the plan spans the
   repositories the garden actively develops (the garden itself, `endojs/endo`,
   `endojs/endo-but-for-bots`, and others the garden works in) — and **excludes
   `agoric-sdk` entirely** ("we must not and cannot do anything for agoric-sdk").

3. **The process as garden automation.** Map the `designs/CLAUDE.md` process onto
   idiomatic garden machinery (job board + roles/skills + systemd services), to
   replace the manual README-sync discipline: design ingest/validation, design↔plan
   synchronization (status/estimate/dependency drift detected and reconciled
   automatically), velocity-based estimate recalibration, milestone/critical-path
   recomputation, and dependency-graph validation. **Connect explicitly to the
   garden machinery already in flight this session** so the proposal is coherent:
   - the **journalist** (bins PRs into milestones; renders the bulletin's roadmap
     sections) — it should read the new garden-resident plan, not the endo
     `designs/README.md`;
   - the **bulletin** loop's roadmap sections;
   - the **foreman** (idle-pump that posts "the next most important step of the
     current in-progress milestone") — it must read the new plan to choose the next
     step;
   - the prior `design-poller` / `design-to-pr-pipeline` concepts.

4. **Migration path.** An incremental path from the endo-resident `designs/` folder
   to the garden-journal-resident, cross-repo, automated plan — without breaking the
   journalist/bulletin/foreman that currently consume the endo roadmap mid-flight.
   Phase it; name the cutover point for each consumer.

## Norms

- Consult the garden's own library and design corpus first (researcher precedence):
  `journal/library/`, and existing garden designs `designs/job-board.md`,
  `designs/gardening-state-machine.md`, `designs/driver.md`, plus this session's
  in-flight service designs (journalist, proxy, foreman, the continuous bulletin
  loop) so the proposal fits the garden's current architecture rather than
  reinventing it.
- Self-contained design doc in the garden's house style (`roles/COMMON.md`); a clear
  problem statement, the proposed representation, the cross-repo model, the
  automation mapping (as a table of process-step → garden role/skill/service), the
  migration phases, and the open questions for the maintainer.
- DRAFT PR against `kriskowal/garden` base `main2`, bot identity. Report the PR
  number/URL and the design slug. This stays a draft for the maintainer's review —
  do not run a build/implementation chain.

## Definition of done

A DRAFT PR open against the garden repo proposing the plan-into-journal2 migration,
the cross-repo plan architecture, and the designs/CLAUDE.md → garden-automation
mapping — design only, for maintainer review. Report the PR URL and slug, and a
one-paragraph summary of the proposed source-of-truth and the journalist/foreman
cutover. If blocked, report the diagnosis and the exact ready-to-apply state rather
than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 64
  claimed_at: 2026-06-24T18:07:01Z
