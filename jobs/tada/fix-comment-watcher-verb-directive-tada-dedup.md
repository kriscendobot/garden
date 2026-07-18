Empty inbox. The work is complete and pushed. Writing the completion report.

---

## Completion report

**Job:** durable fix for the comment-watcher silently dropping a fresh maintainer verb-directive when its deterministic `(PR,verb)` base already sits completed in `jobs/tada/` (the #671 "Shepherd." drop).

### Root cause (confirmed)
The derived base for mechanical verbs is `<slug>-pr<N>-<verb>` — keyed on `(PR, verb)`, **not** the comment id. So a second directive on the same PR derives the *same* base as an earlier, already-completed job. **Two** dedup layers counted `tada`, and each fires before the comment-id identity guard could distinguish the two directives:
1. `comment-watcher.sh` idempotency **pre-check** (`verify_posted`, counted `todo/doin/tada`) — swallowed the directive *before* even the 👀 reactji, producing the observed zero-reaction silent drop.
2. `post-job.sh` **basename dedup** (counted `plan/todo/doin/tada`) — fires before its own directive-identity index, so even past the pre-check the fresh job would not land.

### Changes
- **`scripts/jobs/comment-watcher.sh`** — added a live-only `base_live()` (todo/doin) and switched the idempotency pre-check to it; `verify_posted()` (still incl. `tada`) is retained for the post-confirm, where a within-tick post→claim→complete legitimately lands in `tada`. Mirrors ci-watcher.sh's existing `shepherd_live` vs `posted_anywhere` split.
- **`scripts/jobs/post-job.sh`** — the basename dedup counts `tada` **only when no directive identity is given**. With an identity, the comment-id `jobs/index` map (which counts `tada` via `job_in_lifecycle`) is the authoritative re-see guard, so a genuinely new directive is no longer swallowed by a stale completed base. No-identity producers (e.g. the commit triager) keep full `tada` idempotency, unchanged.
- The maintainer's "visible instead of silent" ask is met: a fresh directive now flows to the 👀 reactji + job post; genuine re-sees still log a surfaced idempotent-skip.

### Tests (added, and verified to fail against pre-fix code)
- `comment-watcher-test.sh` **TADA/TADA2**: a fresh "Shepherd." on #671 posts a new live job + reactji + advances the cursor despite a completed same-base job in `tada/`; re-poll stays idempotent. (Reverting either fix half reproduces the drop: pre-check → 2 fails, post-job → 1 fail.)
- `directive-identity-dedup-test.sh` **case 8**: direct post-job.sh unit — a fresh identity re-mints over a `tada` base (8c), while a no-identity re-post of a `tada` base stays deduped (8d, unchanged behavior).

Full suites green: comment-watcher 226/0, directive-identity-dedup 19/0, ci-watcher 43/0, mention-watcher 25/0. Committed and pushed to `main2` (`1d6cdc5a14`).

### Follow-up (not done here — flagging)
`scripts/jobs/mention-watcher.sh` has the **same latent pattern** in its own `verify_posted` pre-check (counts `tada`). The post-job.sh fix now prevents it *double-posting*, but its pre-check could still swallow a fresh GitHub-wide @-mention that derives a completed base before reaching post-job. It has no evidenced failure and its own test harness, so I scoped it out to keep this fix focused; a small analogous `base_live` split there would close it.
