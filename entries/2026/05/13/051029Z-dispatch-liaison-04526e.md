---
ts: 2026-05-13T05:10:29Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener designs the context-library, librarian, projects/, scholar, journalism skill, and the scripts/ reorg in one design pass

Dispatch root: `dispatches/gardener--context-library-and-friends--20260513-051029--04526e/`. The maintainer asked for a coherent shift in how the garden treats agent-facing documentation, plus several specific roles, skills, and structural changes. Items interlock (librarian reads journalist breadcrumbs; projects/ uses the context-library rules; scholar grows the projects index; journalism skill cites all of the above). One gardener engagement covers it.

## Tasks

### A. Gardener owns context-management for new subagents

Add to `roles/gardener/AGENT.md` a new operating norm: the gardener is responsible for context management for new subagents in general. Capture the maintainer's framing:

> The journal is agent-optimized documentation, not human-optimized. Hierarchies are deep, with separate files preferred over numbered sections. Each document's abstract is specific (so an agent can decide whether to descend without reading the body). Topics partition cleanly so the next layer is generally over-general and the layer below it disambiguates. An agent following a trail should be able to abandon the search at any level once the abstract makes clear it is the wrong branch.

Capture the discipline as a new skill: `skills/context-library/SKILL.md`. The skill is the canonical reference for: directory-as-hierarchy conventions, README-as-index per directory, abstract-at-the-top-of-each-document, partitioning rules, exit-criteria-when-descending. Other roles cite this skill rather than restating the rules.

### B. Journalist update

The maintainer's three sub-asks for the journalist:

1. **Procedural matter belongs in the role file, not in the bulletin board.** The current `journal/README.md` has long explanatory paragraphs above the bulletin sections (especially before *Pending kriskowal reviews*, *PR backlog*, *Scheduled engagements*) describing how each section is maintained. Move that procedural detail into `roles/journalist/AGENT.md`. The bulletin keeps only the section heading + the body items + (where present) the delimiter comments for idempotent rewrites.
2. **Bulletin order starts with the review queue.** Reorder `journal/README.md`'s bulletin sections so *Pending kriskowal reviews* is first, followed by *PR backlog*, then the other sections (*Awaits maintainer review*, *Awaits maintainer decision*, *Pre-staged authorizations*, *Surplus authority discovered*, *Scheduled engagements*).
3. **Topo-sort reminder.** Update the journalist's role to remind the role to apply the topological sort (per `skills/pr-dependency-topo-sort/SKILL.md`) consistently. The current role file already says it should; if the journalist has been rendering without topo-sort, the reminder strengthens the spec. Do not re-render the bulletin in this dispatch (the next steward-fired journalist dispatch picks up the new rule).

### C. Journalism skill

New: `skills/journalism/SKILL.md`. The skill that the journalist *maintains* in order to educate other roles on how to find information in the journal. Content:

- Where the journal lives (path).
- The kinds of entries (`dispatch`, `tick`, `result`, `message`, `worktree`) and how to filter by `kind:` / `role:` / `project:` / `to:` frontmatter.
- How to walk `refs:` chains to follow a thread.
- How to use the `journal/projects/` index (see task E) and the agent-optimized hierarchy (per `skills/context-library/SKILL.md`).
- How to use the `inbox-drain` script for addressed-to-you entries.
- The journalist's breadcrumb conventions: each `projects/<slug>/README.md` (and each subdirectory README) has an abstract specific enough to let a reader skip; descend only when the abstract matches the query.

The journalism skill is the *user-of-the-journal* manual; the journalist role file describes the *maintainer-of-the-journal*'s duties.

### D. Librarian role

New: `roles/librarian/AGENT.md`. Any agent (the steward, a fixer, a builder, the in-session liaison) can dispatch the librarian when it needs to find information in the journal but does not want to spend its own context budget on the search. The librarian:

- Reads the journalism skill to know the conventions.
- Walks the agent-optimized hierarchy (per `skills/context-library/SKILL.md`) from the closest entry point, deciding at each level whether to descend.
- Returns a concise answer with citations (entry paths or projects/ paths) the dispatching agent can read directly.

The librarian's authority bounds: read-only on the journal; cannot edit. Cannot dispatch sub-subagents. Returns within a budget — if the trail goes cold, return what was found with a "nothing found at <breadcrumbs>" report rather than fanning out.

### E. Projects section in the journal

New: `journal/projects/` directory. Schema (mirror the `journal/worktrees/README.md` model):

- `journal/projects/README.md` — index of all known projects with one-line abstracts; per the context-library rules, this is the entry point.
- `journal/projects/<slug>/README.md` — per-project entry with an abstract, a "rules of engagement" section (what the garden may and may not do with this project), upstream links, identity and credential conventions, and pointers down into per-project detail.
- `journal/projects/<slug>/<topic>.md` — per-topic detail when warranted; cited from the project README. Avoid bloating the project README; spin out topics into their own files per the context-library rules.

Seed projects (each gets a `journal/projects/<slug>/README.md`): `endo`, `endo-but-for-bots`, `agoric-sdk`, `cosgov`, `garden` (this repo, since it is itself a project). Use the existing journal entries tagged with each project slug (grep on `^project: <slug>`) as a hint for what each README should know. Per project, write only the README this dispatch; topic-level detail accumulates later (the scholar's job).

The maintainer will also add a sixth project, `ocapn`, in a follow-up dispatch immediately after this one; do not write its file in this engagement (it has special engagement rules the maintainer needs to record).

### F. Scholar role

New: `roles/scholar/AGENT.md`. Autonomous, like the steward and the liaison; the scholar runs in the bot sandbox on a tunable cadence and grows the index of project documentation in the journal. Specifically:

- Walks `journal/projects/<slug>/` directories and identifies gaps: missing abstracts, topics that the per-project README references but no `<topic>.md` file exists for, project-tagged journal entries that should be summarized into a topic file.
- Writes new topic files using the context-library rules (specific abstracts, partition cleanly, prefer separate files to long sections).
- Updates `journal/projects/<slug>/README.md` to cite new topics.
- Does NOT edit role or skill files. The scholar is the journal's documentation grower, not a meta-evolution role.
- Records each cycle's work as a `result` entry.

Cadence machinery: same shape as the steward's `autonomous-loop-pacing` skill. The scholar's default cadence is slower (idle mode default; the maintainer wants it tunable, so document how to change). Active-mode triggers: a new project added, a backlog of project-tagged entries since the last sweep, a maintainer ask.

Add a **bulletin item** in `journal/README.md` § *Awaits maintainer decision* (or a new section if shape demands) reminding the maintainer to kick off the scholar once it is ready. The bulletin item names the cadence-setting decision and the first-run scope.

### G. Reorganize `scripts/` into the relevant skill directories

The maintainer's separate ask, batched here. Move each `scripts/<name>.sh` into its skill directory:

- `scripts/monitor-poll.sh` → `skills/github-activity-poll/monitor-poll.sh` (the script implements the skill's procedure).
- `scripts/review-queue-poll.sh` → `skills/review-queue-poll/review-queue-poll.sh`.
- `scripts/inbox-drain.sh` → `skills/inbox-drain/inbox-drain.sh`.
- `scripts/dispatch-prepare.sh` and `scripts/dispatch-teardown.sh`: no existing skill owns these. Create `skills/dispatch-worktree/SKILL.md` (or similar name; `dispatch-lifecycle`, `dispatch-worktree-triple`; gardener picks) that documents the prepare/teardown procedure; move the two scripts there. `WORKTREES.md` § Per-dispatch worktree triple keeps the architecture explanation and cites the new skill for the procedural detail.

Update every reference in role files, skill files, top-level docs, and the journal's worktree index entries to use the new paths. Use `git mv` so the rename is tracked.

Do **not** restart the currently-running standing-monitor or review-queue daemons. Their in-memory bash processes hold the old script path; the file rename does not kill them. When the steward's liveness check next respawns a daemon, it will use the new path from the updated `roles/steward/AGENT.md` § Standing monitors. Active restart is unnecessary and disruptive.

Apply the same rule to any new scripts the gardener creates in this engagement (e.g. the scholar's cadence daemon, if any): they go directly into the right skill directory.

## Style and discipline

- Read `garden/roles/COMMON.md`, `garden/roles/gardener/AGENT.md`, `garden/CLAUDE.md`, and the existing `roles/journalist/AGENT.md` and `journal/README.md` before authoring anything.
- Em-dash sweep, frontmatter on every authored file, relative paths within trees.
- Do not invoke `Agent` to delegate further; the gardener works directly.
- Do not edit `roles/{liaison,steward,monitor,review-queue,boatman,fixer,weaver,shepherd,conductor,designer,scout,botanist,major-general}/AGENT.md` files except where the script-reorganization (task G) requires updating script-path references inside them.
- Do not run the journalist, the librarian, the scholar, or any other role for its first real engagement; those are separate dispatches.
- Do not add the `ocapn` project entry; the maintainer is doing that in a separate dispatch immediately after this one.

## Commits + push

Suggested commit split on `main`:

- A1: `gardener: context-library responsibility for new subagents` (gardener role norm).
- A2: `context-library skill: agent-optimized hierarchical doc conventions` (new skill).
- B: `journalist: procedural matter to role; bulletin starts with review queue; topo-sort emphasized` (role file).
- C: `journalism skill: how other roles find information in the journal` (new skill).
- D: `librarian role: dispatch-on-demand journal search` (new role).
- F: `scholar role: autonomous index-growing for project documentation` (new role + bulletin item).
- G1: `scripts: move into their relevant skill directories` (git mv plus reference updates).
- G2: `dispatch-worktree skill: documents prepare/teardown; WORKTREES.md cites it` (new skill plus WORKTREES.md edit).
- H: `inventory: enumerate the new roles and skills` (CLAUDE.md plus steward subordinates entry for scholar).

Push at end. Use retry-on-rejection (other gardener dispatches may push concurrently).

Suggested commits on `journal`:

- E: `projects: index + per-project READMEs for the five seed projects` (new directory).
- B-bulletin: `bulletin: reorder sections, drop procedural prose into the journalist role` (journal/README.md).
- F-bulletin: `bulletin: kick-off reminder for the scholar`.
- Result entry.

## Return

A brief report (≤ 600 words): files written (grouped by task), commit SHAs (main + journal), and any messages routed back to liaison. The orchestrator will tear down your dispatch root on return.
