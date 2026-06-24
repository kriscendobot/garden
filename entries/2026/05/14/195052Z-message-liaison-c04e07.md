---
date: 2026-05-14T19:50:52Z
host: endolin
role: liaison
kind: message
to: scholar
from: liaison
re: queue unmerged-PR design for ingestion — endojs/endo#3121 daemon-persistence
library_action: ingest
source_repo: endojs/endo
source_branch: kriskowal-doc-formula-persistence
source_path: designs/daemon-persistence.md
source_commit: aefc1b87da0c
source_pr: endojs/endo#3121
source_pr_state: draft
source_authors: [Kris Kowal]
---

# Queue endojs/endo#3121 `designs/daemon-persistence.md` for ingestion

User direction this turn: *"There is an open pull request to add
documentation for formula persistence. We should find and add it to
our sources, although it is not yet merged."*

## Found

- **Pull request**: <https://github.com/endojs/endo/pull/3121>
  *"docs: Design for daemon formula persistence"*
- **Author**: kriskowal
- **State**: draft (opened 2026-03-08, last updated 2026-03-08)
- **Repo / branch**: `endojs/endo` / `kriskowal-doc-formula-persistence`
- **Head SHA**: `aefc1b87da0c` (516 lines added, single new file)
- **File**: `designs/daemon-persistence.md`
- **Base**: `master`

## Why it is *not* in the active corpus today

The library has standardized on:

1. Idempotency via `git --git-dir=worktrees/<owner>-<repo>.git log -1 --format=%H <default-branch> -- <path>` — i.e. comparing the file's commit on the *default* branch.
2. Source provenance via `(source_repo, source_branch, source_commit)` triples drawn from default-branch state.

This source is on a **draft PR branch**, not on `master`. The standard
idempotency check will silently return nothing because the file does
not exist on `master` yet. Two adjustments are needed:

- Fetch the PR branch into the bare clone *or* fetch the PR head as a
  ref, before the upstream-log idempotency check is meaningful.
- Tag the source-index entry with the PR number and draft state in
  `notes:` so future cycles know to re-check against the PR head, and
  re-ingest if the PR rebases / force-pushes / merges.

## Suggested approach for the next scholar cycle

1. Fetch the PR head into the bare clone:

   ```sh
   git --git-dir=worktrees/endojs-endo.git fetch origin \
     pull/3121/head:refs/pull/3121/head
   ```

   That makes `refs/pull/3121/head` a local ref pinned at the PR head;
   the file is reachable for read at that ref.

2. Use the PR head SHA (currently `aefc1b87da0c`) as `source_commit`,
   record `source_branch: kriskowal-doc-formula-persistence`, and add
   a notes line of the form:

   > **Draft PR** endojs/endo#3121, not yet merged to `master`.
   > Re-check this section's freshness against the PR head, not the
   > default branch. If the PR rebases or merges, re-ingest from the
   > new HEAD; if the PR is closed without merging, mark the source
   > and all its sections as **stale**.

3. Section budget likely ~5-7 for a 516-line design document; pick the
   section breakdown after reading, but candidate themes from a quick
   skim of the title and the daemon corpus already ingested are:
   problem & retention model, formula files on disk, durable graph
   integration, agent / pet-store interaction, recovery & migration,
   open questions.

4. Cross-references to lay down on ingest:
   - `endo-but-for-bots--llm-designs-dcpg--persistence-and-graph` and
     `--crash-reconnect-and-revocation` — these describe **cross-peer**
     retention persistence; the new `daemon-persistence.md` is the
     *local-formula-storage* counterpart, likely upstream of both.
   - `endo-but-for-bots--llm-designs-dcpg--retention-set-model` — the
     formula store is what the retention set is *about*; the new
     design likely formalizes the "formula" object class.
   - `endo-but-for-bots--llm-designs-dlt--*` — the locator-terminology
     design treats formula keys as opaque; this design likely defines
     where formula state actually lives.

5. The `persistence.md` topic page already has 21 rows after cycle 46;
   this design will add several more — consider whether the topic
   would benefit from a sub-section split (e.g. "formula state
   on disk" vs "exo durable zones" vs "agent persistence") on this
   pass or the next.

## Provenance considerations beyond this PR

This is the **first** unmerged-PR source the library will absorb. The
ingestion conventions (`journal/library/conventions.md`) do not yet
cover this case. Either this cycle or a near-future one should add a
brief section to `conventions.md` titled something like *"Sources from
unmerged PRs"* covering:

- When it is appropriate (e.g. the PR is the canonical source-of-truth
  for a design that has not landed because the implementation work is
  in flight, vs. a speculative PR that may be discarded).
- How to mark the source-index entry (status: `current` with a notes
  flag, vs. introducing a new `draft` status — recommend the former,
  to avoid taxonomy proliferation).
- How to keep the source fresh as the PR evolves (re-check PR head
  on each scholar cycle that touches the relevant topic; treat a
  force-push as a re-ingest trigger).
- How to handle merge / close: on merge, rewrite source_branch to
  default + new source_commit; on close-without-merge, mark all
  sections **stale** and leave them in place with a notes flag.

The liaison's recommendation is the first option: lean **current +
notes flag**, document the discipline in `conventions.md`, and revisit
when a second unmerged-PR source comes up.
