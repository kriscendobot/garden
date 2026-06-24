# Bulletin: show a short description per job, not just the slug/count

Wear the **mentor** role. The bulletin's `## Board` section currently shows only
counts (`- todo: N` / `- doin: N` / `- tada: N`). The maintainer wants each job shown
with **a short description**, not just its slug. Adjust the bulletin generator on
`main2` (bot identity; **isolated worktree off `origin/main2`** — the shared tree is
concurrently mutated).

## Change

In `scripts/jobs/bulletin.sh` (`compute_dashboard`, the `## Board` section), list the
active jobs with a one-line description each:

- For every job in **`jobs/todo/`** and **`jobs/doin/`**, render `` - `<slug>` — <desc> ``
  where `<desc>` is a **short description extracted from the job file**: its first
  Markdown heading (`# …`) if present, else its first non-empty line, with leading
  `#`/whitespace stripped, collapsed to a single line, and **truncated** (~80 chars).
  Sanitize so it cannot break the bulletin's Markdown (no embedded newlines; escape or
  drop stray backticks).
- Group under sub-headings with counts, e.g. `### todo (N)` / `### doin (N)`.
- **`tada`** can be large (hundreds of completed jobs) — do **not** list them all; keep
  a count and optionally the most recent few with descriptions. Don't bloat the
  bulletin.
- Keep everything else (freshness line, Messages to the maintainer, Watch set, Hosts,
  Recent progress, the journalist `## Latest`) intact, and preserve the idempotent
  change-compare and quiet-on-success behavior. Reading the first line of each job
  file is cheap; keep the loop deterministic.

## Redeploy

The bulletin runs as the continuous `garden-bulletin.service`; after the change lands
on `main2`, redeploy so the running loop picks it up: ensure the garden root has the
new script and **restart** `garden-bulletin.service` (non-blocking), then confirm the
next tick renders the per-job descriptions in `journal/README.md` (the bulletin's
current output path). If you cannot restart the host service from a dispatch worktree,
say so and flag the restart as a pending deploy step.

## Tests & verification

- With a fixture board (a todo and a doin job each with a `# Title` first line), assert
  the rendered `## Board` contains `` `slug` — Title `` for each, the tada list is
  bounded, and a job whose first line has no heading still gets a sensible one-line
  description. `shellcheck`/`bash -n` clean.

## Definition of done

`bulletin.sh` renders each todo/doin job with a short description (tada bounded),
committed and pushed to `origin/main2` (bot identity), service redeployed (or restart
flagged), and a tick confirmed to show descriptions. Report the SHA and a sample of the
rendered board. If blocked, report the diagnosis and ready-to-apply content rather than
claiming completion.

Posted by the liaison on behalf of the maintainer.
