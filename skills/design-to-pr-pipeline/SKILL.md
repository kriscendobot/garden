---
created: 2026-05-14
updated: 2026-06-24
author: gardener
---

# Skill: design-to-pr-pipeline

Inventory the project's roadmap branch for design documents that lack a tracking
PR, and post a `build` job to open the initial PR for the next uncovered design.
In v2 this is a **producer** procedure: a poller/triager runs the inventory on a
cadence and posts `build` jobs to the board; a gardener claims the job and opens
the tracking PR. (This replaces the v1 design-poller systemd daemon and the
general-contractor's slot-refill.) A liaison in-session may also run the inventory
directly to answer a user's "what's the next uncovered design".

This skill is the *queue maintenance* skill (designs ↔ PRs). The companion
*eligibility filter* (classify designs as eligible / blocked-on-revision /
blocked-on-dependency / blocked-on-maintainer-decision) is
[design-queue-drift-check]; the two compose: drift-check classifies, this skill
posts a `build` job for the eligible head.

## When to use

- The poller's cadence fires and the design-PR-drafting concurrency cap is free.
- The liaison wants the inventory to surface uncovered designs for a user
  question.
- A maintainer directive names a specific design and asks for the tracking PR to
  be opened.

## Inputs

- `project_slug`: short kebab-case name of the project (e.g. `endo-but-for-bots`).
- `repo`: `<owner>/<name>` of the project's bot fork (today
  `endojs/endo-but-for-bots`).
- `roadmap_branch`: the project's roadmap branch where designs live (today `llm`).
- `design_paths`: the project's design directories (today `designs/` at the repo
  root plus `packages/*/designs/`).

The per-project facts live in the journal under the project slug rather than
hardcoded here, so other projects adopting this discipline only supply the inputs.

## State

Stateless across invocations; the inventory is computed fresh each cadence against
the current state of the roadmap branch and the current set of open and merged
PRs. The "what counts as covered" rule below decides per-design without persistent
state. The producer's last-seen marker (which roadmap tip it last scanned) lives
under `GARDEN_STATE`, not in the journal.

A `progress` journal entry records the inventory result (uncovered count, the
design slug a job was posted for, if any) so future scans can read "what we knew
last cadence" without re-running the procedure.

## What counts as covered

A design at path `<design-file>` on the roadmap branch is **covered** when any of:

1. **Open PR cross-references the design path.**
   `gh pr list -R <repo> --state open --search '<design-slug>'` returns at least
   one PR whose title, body, or any commit message references the design file path
   (`designs/<slug>.md`, or the full package-scoped path). The cross-reference must
   be load-bearing (a "this PR implements `designs/<slug>.md`" line, or a commit
   message naming the design path); a passing mention in a checklist is not enough.
2. **Merged PR cross-references the design path.** Same search against
   `--state merged`. A merged PR that implemented the design is the natural
   terminus of the chain; do not post a new tracking-PR job for it.
3. **The design's own metadata names a PR.** Some designs carry a `Status: PR #N`
   line. If `gh pr view <N> -R <repo>` returns a PR still open or merged, count the
   design as covered.

Closed-without-merge PRs do **not** cover a design. A closed-not-merged PR is
evidence the prior attempt was abandoned; the design re-enters the uncovered set
and the next scan posts a job for a fresh tracking PR.

The "load-bearing reference" rule exists because design slug names recur as
English nouns ("the timer design"); a checklist listing "timer" among twenty items
is not a tracking PR for the timer design. The match has to be the canonical path.

## Procedure

Run from the producer's context (the poller/triager or an in-session liaison turn),
not from inside a claimed job's worktree (the procedure posts its own `build` job;
running it from inside a build job would nest).

### 1. Walk the design paths on the roadmap branch

```sh
gh api repos/<owner>/<name>/contents/designs?ref=<roadmap_branch> \
  --jq '.[] | select(.type=="file") | .path'
```

Repeat for each `packages/*/designs/` path the project uses. Concatenate into a
candidate list. Each candidate is the relative path to one design document.

### 2. For each candidate, check coverage

```sh
SLUG=$(basename <design-file> .md)
gh pr list -R <repo> --state all --search "$SLUG" \
  --json number,title,state,body,headRefName \
  --limit 20
```

A PR counts as covering the design if its title, body, or `headRefName` contains
the canonical design path. Use the *What counts as covered* rule above. For
closed-not-merged PRs, do not count them; record the closed PR number in the
`progress` entry so the maintainer can audit whether to revive rather than restart.

### 3. Compute the uncovered set

`candidates - covered`. Sort by the design's last-modified timestamp on the
roadmap branch (newest first), then by file path as a tiebreaker. The first entry
is the next-owed design.

### 4. Check the concurrency cap

The cap is **one in-flight design-PR-drafting build job across the estate at a
time**. Because the job board is the source of truth, check it directly rather
than grepping the journal: a posted-or-claimed job whose basename matches the
design-PR-drafting shape (e.g. `<slug>-draft-initial-pr`) in `jobs/todo/` or
`jobs/doin/` means the cap is taken; this scan posts no new job. The idempotent
basename means a duplicate post collides and is skipped even without the explicit
check.

### 5. Post the `build` job (cap free + uncovered set non-empty)

If the uncovered set is non-empty and the cap is free, post a `build` job:

```sh
scripts/jobs/post-job.sh <slug>-draft-initial-pr-<shorthash> <<'BODY'
kind: build
repo: <owner>/<name>
base: <roadmap_branch>
design_path: <design-path>
note: tracking PR for an uncovered design; open a DRAFT stub PR on the roadmap
      branch that cross-references the design path.
BODY
```

A gardener races to claim it and opens the tracking PR per the brief below. The
producer does not open the PR itself.

### 6. The build job's brief

The claiming gardener's task differs from a regular feature-implementation build in
two ways:

- **Base branch is the roadmap branch** (today `llm`), not `master`. The tracking
  PR lives on the roadmap branch alongside the design itself.
- **The initial PR is a stub.** The gardener opens a draft PR whose head commit is
  one of: (a) a re-statement of the design's acceptance criteria as a checklist in
  the PR body, (b) a placeholder slug-branch with a one-line README addition naming
  the design, or (c) an initial-pass skeleton (function signatures, types, no
  implementation) that compiles and runs the design's stated tests in failing
  state. Pick (a), (b), or (c) based on the design's shape; (a) is cheapest, (c)
  is most useful when the acceptance criteria are precise.

The job's `tada/<base>` report names the new PR number; the next scan marks the
design as covered because the open PR now cross-references the design path.

### 7. Empty uncovered set

If the uncovered set is empty, the `progress` entry records
`design-to-pr scan: 0 designs owed` and the scan continues. No job posted.

## Output

A posted `build` job (if the cap is free and the uncovered set is non-empty) and
the subsequent `tada` report when the gardener returns. The `progress` entry
records the inventory result either way:

```
design-to-pr scan: <N> designs uncovered; posted build job for <design-slug>
design-to-pr scan: <N> designs uncovered; cap taken by in-flight <prior-design-slug>
design-to-pr scan: 0 designs uncovered
```

## Notes from the field

- _2026-05-14_: skill landed. The maintainer's framing: "New designs have landed.
  Notice that new designs have landed and keep one builder busy drafting the initial
  PR at a time, until all designs are accounted for. That entails linking the
  design to a PR on the llm branch." The "what counts as covered" rule tightens the
  maintainer's provisional rule to require the canonical path rather than a
  slug-only mention.
- _2026-06-24_: migrated into v2. Translated the producer from the v1
  steward/design-poller/general-contractor slot-refill to a poller/triager that
  posts `build` jobs to the board; replaced the journal-grep concurrency check with
  a job-board check (the idempotent basename does most of the work); replaced the
  `dispatch-prepare.sh` + `dispatch` journal entry with `post-job.sh`. The gardener
  who claims the job opens the PR.
