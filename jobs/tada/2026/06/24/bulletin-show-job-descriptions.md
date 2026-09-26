The deploy is live and confirmed. The job is complete.

## Completion report — `bulletin-show-job-descriptions`

**What I did (mentor role):** Adjusted `scripts/jobs/bulletin.sh` so the bulletin's `## Board` section lists each active job with a short description instead of bare counts. Built in an isolated worktree off `origin/main2` (bot identity `endolinbot`), since the shared `/home/kris` tree is concurrently mutated.

**What changed (`scripts/jobs/bulletin.sh`):**
- New `job_desc()` helper extracts a one-line description from a job file: first Markdown heading (`# …`) if present, else first non-empty line; strips leading `#`/whitespace, drops backticks/CR/control chars, collapses whitespace, truncates to ~80 chars (with `…`), and falls back to `(no description)`. `grep -m1` guarantees no embedded newline (Markdown-safe) and makes it cheap.
- New `render_board()` groups jobs under counted sub-headings — `### todo (N)` / `### doin (N)` listing every job as `` - `slug` — desc ``, and a **bounded** `### tada (N)` showing only the 5 most-recently-modified completions plus a `… and N more` line, so the hundreds of completions never bloat the bulletin.
- `compute_dashboard()` now interpolates `${board}` in place of the three count lines. Freshness line, maintainer messages, watch set, hosts, recent progress, the journalist `## Latest`, and the idempotent change-compare / quiet-on-success behavior are all untouched.

**Verification:**
- `bash -n` clean; `shellcheck` clean (only the pre-existing `GARDEN_TAG`/`SC1091` items remain — no new warnings).
- Fixture-board test (throwaway journal + stubbed journalist, real `bulletin.sh` in `ONCE` mode): all assertions pass — todo/doin jobs render `` `slug` — Title ``; counts in sub-headings; a non-heading first line is used as the description; a stray backtick is stripped; tada is bounded to 5 + remainder. A second edge-case run confirmed empty todo → `(none)` and tada ≤ 5 → no "more" line.

**Deploy:** Pushed to `origin/main2` as **`07c548e4`**. Updated only `scripts/jobs/bulletin.sh` in the garden root via `git checkout origin/main2 -- …` (no destructive reset — left other gardeners' in-flight edits to `common.sh`/`post-job.sh`/`run-test.sh` intact). Restarted `garden-bulletin.service` (`systemctl --user restart`, succeeded). Confirmed the next tick rendered per-job descriptions on `origin/journal2`.

**Sample of the rendered board (live):**
```
### doin (11)
- `bulletin-show-job-descriptions` — Bulletin: show a short description per job, not just the slug/count
- `harden-producer-push-path` — Harden the producer push path: confirm the push landed; fix the shared-clone ...
...
### tada (74)
- `scholar-ingest-cask-2` — scholar-ingest-cask-2 — done (gardener 52, endolinbot, 2026-06-24)
- … and 69 more
```

**Follow-ups / notes:** None blocking. The `tada` descriptions reflect each completed job file's first line (often a report header rather than the original title) — acceptable for a bounded recency list, but if a cleaner "original title" is wanted there later, the job files would need a stable title field. No action needed now.
