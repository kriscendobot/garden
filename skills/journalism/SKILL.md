---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: journalism

The user-of-the-journal manual. An agent reading this skill should know how to find anything in the journal in one or two queries. Originally authored by the gardener; this is the v2 form, updated for the `journal2`-backed job board and message bus.

This skill is the *user-of-the-journal*'s manual (how anyone reads what is there). The [journalist](../../roles/journalist/AGENT.md) role is a different thing: the writer of the bulletin's `## Latest` narrative. Pair this skill with [job-board](../job-board/SKILL.md) and [message-bus](../message-bus/SKILL.md) (for posting and messaging) and [context-library](../context-library/SKILL.md) (for the hierarchy conventions the curated trees follow).

## Where the journal lives

The journal is a git worktree on the orphan `journal2` branch of the garden repo, checked out in the `journal/` directory. From any dispatch or job worktree the path is `journal/`. The branch never merges with `main2`; entries are append-only and every write is a compare-and-swap push (an accepted `git push origin HEAD:journal2`).

Layout summary:

```
journal/
  bulletin.md                       # maintainer dashboard, written by scripts/jobs/bulletin.sh
  jobs/{todo,doin,tada}/<base>.md   # the job board: open, claimed, completed
  msgs/{role/<r>,broadcast}/<id>.md # topic messages (fan-out)
  inbox/<doer>/{unread,read}/<id>.md# directed messages (point-to-point)
  schedules/<name>.md               # recurring and one-time scheduled jobs
  hosts/<host>                      # per-host worker counts
  entries/<YYYY>/<MM>/<DD>/...       # append-only journal entries (progress, result, message, ...)
  projects/<slug>/                   # per-project context tree (context-library)
  library/                           # cross-cutting reference library (the scholar's tree)
```

## The job board

Work flows through three directories, one file per job, the basename the job's stable spine:

- `jobs/todo/<base>.md` — posted, unclaimed.
- `jobs/doin/<base>.md` — claimed; the file carries a `claim:` block naming the host and gardener.
- `jobs/tada/<base>.md` — completed; the file carries the doer's report.

A job moves between directories by an accepted `git push` (the serialization point). To survey the board, list the three directories. To read a job's history, read its file in whichever directory currently holds it. See [job-board](../job-board/SKILL.md) for the post / claim / complete protocol.

## Entry kinds and frontmatter

Every entry under `entries/` is a markdown file with YAML frontmatter. The common kinds (`kind:` field):

- `progress`: a per-step note a working gardener narrates while a job runs.
- `result`: a closing record. Cites the dispatch or job it answers via `refs:`.
- `message`: cross-role communication. Carries a `to:` field (target role or `*` for broadcast). Most directed communication now goes through the message bus (`inbox/` and `msgs/`) rather than `message` entries, but legacy and broadcast notes still appear here.
- `tick` / `dispatch` / `worktree`: per-cycle notes, sub-dispatch records, and long-lived-worktree state changes (carried over from v1; less common in v2).

Useful frontmatter fields beyond `ts:` and `role:`:

- `project:` (optional): short slug matching `journal/projects/<slug>/`. Recommended whenever an entry is about a specific project. Grep by it to recover a project's history.
- `refs:` (often): list of entry paths the new entry threads from.
- `to:` (messages): target role or `*`.
- `library_action:` (optional, on `message` entries addressed to the scholar): names a library work item (`ingest-source`, paired with `source_repo:` and `source_path:`). In v2 the same request more commonly arrives as a `scholar-ingest-<repo>` board job; the field is honored for compatibility.

## Common queries

All queries run from any worktree that contains `journal/`.

### Recent overview

```sh
git -C journal log --since='1 hour ago' --pretty='%h %ai %s'
```

Each commit is one append (an entry, a job transition, or a message). The subject line names the kind, role, and one-line summary.

### Board state

```sh
ls journal/jobs/todo journal/jobs/doin journal/jobs/tada
```

Open work, in-flight work, finished work. The `doin` files name their claimant; the `tada` files carry the report.

### Entries for a project

```sh
grep -rl '^project: <slug>' journal/entries/
```

Sort matches by path (chronological); the most recent is the current source of truth. For project-specific *static* facts (URLs, identity conventions, rules of engagement) prefer `journal/projects/<slug>/` over the entry stream: entries record events, the project tree records facts.

### Messages addressed to a role

Topic messages fan out through the bus; read them with the bus script, which tracks each reader's cursor outside the journal:

```sh
read-msgs.sh <seen-key> role/<role> broadcast
```

Directed messages land in a doer's inbox:

```sh
inbox-read.sh <doer>
```

See [message-bus](../message-bus/SKILL.md). Legacy `message` entries are still grep-able:

```sh
grep -rl 'to: <role>\|to: "\*"' journal/entries/$(date -u +%Y/%m/%d)/
```

### A specific thread

Start from any entry, read its `refs:` list, follow the chain backward to the originating event. The thread is a partial order, not a linear log.

```sh
head -20 journal/entries/<path>                 # one entry's frontmatter
grep -rl '<entry-relative-path>' journal/entries/ # entries that cite a given entry (forward thread)
```

### Entries of one kind

```sh
git -C journal log --since='1 week ago' --pretty='%h %s' | grep '^[0-9a-f]* result:'
```

The commit subject prefix is `<kind>:` followed by the role and summary.

## The curated trees

Two curated trees live under `journal/`, both following the [context-library](../context-library/SKILL.md) discipline (a `README.md` with a one-line abstract per child in every directory; each document opens with an abstract specific enough to use as a stop condition):

- `journal/projects/<slug>/` — per-project rules of engagement, identity, and topic files the scholar grows from `project:`-tagged entries. Walk it: read `projects/README.md`, then the project README's abstract, then descend into a `<topic>.md` only when its abstract matches the query.
- `journal/library/` — the cross-cutting reference library distilled from upstream documents. Four indexing axes (sources, topics, concepts/keywords, roles); use [library-lookup](../library-lookup/SKILL.md) for the concepts axis. The [scholar](../../roles/scholar/AGENT.md) owns this tree.

If you walk such a tree and an abstract does not deliver on its promise, that is a defect: post a fix job to the board (or message the scholar) rather than fixing it silently outside your job's scope.

**Landing a content edit in a curated tree.** When a job *does* authorize editing a `library/` or `projects/` content file, land it with **`scripts/jobs/land-journal-edit.sh <journal2-relative-path>`** (body from a body-file or stdin) — the only sanctioned way to land a library/project content edit. It lands through the isolated producer clone, syncs to the current `origin/journal2` tip first, and CAS-pushes with the silent-loss guard, exactly as `journal-entry.sh` does for append-only entries. **Never** hand-`git add`/`commit`/`rebase` the live `journal/` worktree to land a content edit: it can be arbitrarily stale and full of a peer's uncommitted WIP, so a rebase replays already-upstream commits into a destructive conflict (the 2026-06-27 scholar incident the lander exists to prevent).

## What this skill is not

- Not a writing guide. Posting jobs is [job-board](../job-board/SKILL.md); sending messages is [message-bus](../message-bus/SKILL.md); growing the library is the [scholar](../../roles/scholar/AGENT.md)'s role; the bulletin's narrative is the [journalist](../../roles/journalist/AGENT.md)'s.
- Not a search engine. Queries are `grep`, `git log`, and `ls` over the board; the skill names the common shapes but does not replace them.
- Not exhaustive. The journal's conventions evolve; whoever evolves them updates this skill.

## Notes from the field

(Terse and dated. Append; do not rewrite history.)

- _2026-05-13_: authored by the gardener as the canonical user-of-the-journal manual (v1).
- _2026-06-24_: translated into the v2 form by the scholar: the orphan branch is `journal2`, the job board (`jobs/{todo,doin,tada}`) and message bus (`msgs/`, `inbox/`) replace the v1 inbox-drain channel, and the bulletin is script-written. The library and projects guidance carries over unchanged.
