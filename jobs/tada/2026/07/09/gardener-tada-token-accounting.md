The design landed on `main2` (commit `0508e1425`) and my inbox is empty. The job's definition of done — a builder-ready design resolving questions a–f — is met.

## Completion report

**What I did.** Designed deterministic per-engagement token-spend accounting for the tada report and landed it directly on `main2` as `designs/tada-token-accounting.md` (commit `0508e1425`, pushed clean on the first CAS attempt), with an index row added to `designs/README.md`. Status: Accepted (maintainer-commissioned 2026-07-09, builder follow-up expected).

**The design, by the job's questions:**

- **(a) Attribution** — session-scoped, not time-windowed. `gardener-claude.sh` already runs `claude -p` with cwd in the per-base worktree and a deterministic session id, so each job's transcripts land in per-job `~/.claude/projects/<encoded-worktree>/` dirs no other job can write. Engagement spend = clamp(after − before) of the billable sum (usage-meter's exact formula and message-id dedup) over those dirs. Two-layer contract mirroring `GARDEN_COMPLETION_SENTINEL`: the handler writes the delta to a new `GARDEN_USAGE_FILE` env-passed temp path right after `claude` exits (before it spools/deletes the transcript — the ordering that forces this layer); `gardener.sh` computes its own fallback delta when the handler was killed before writing; `unknown` as last resort. Time-window summing is rejected outright (concurrent gardeners share `~/.claude`; it double-books by construction).
- **(b) Engagement** — one `$GARDEN_JOB_HANDLER` invocation, any outcome (tada / requeue / fail); every invocation appends a row, accumulating across requeues, gardeners, hosts, and re-posts.
- **(c) Store** — journal-backed append-only `usage/<base>.tsv` (top level, deliberately outside `jobs/` and its lane-cleanup semantics), rows `epoch, host, gardener-id, elapsed, tokens|unknown, source, outcome`; running total derived by sum-on-read (a stored cumulative column is rejected as divergence-prone under CAS-rebase retries). Non-completion rows go through a new best-effort `usage-append.sh`; the completing row rides `complete-job.sh`'s existing push — zero extra pushes on the happy path.
- **(d) Report surfacing** — option (i): `complete-job.sh` strips-then-re-stamps a delimited machine footer (totals + engagement/host/unmetered counts) on every doin→tada transition, so an agentic rewrite — even a fabricated footer — is deleted and re-derived from the ledger, which stays the sole source of truth.
- **(e) Multi-host** — host-additive by construction: each host appends rows from its own `~/.claude` to the shared journal; the total is the column sum. Sidesteps usage-meter's single-host assumption (and incidentally gives its `TODO(multi-host)` a future data source).
- **(f) Fail-open** — every step guarded: meter failure records `unknown`, lost appends are logged undercounts, footer stamping failures never block the doin→tada commit; idempotence guard prevents duplicate rows on a completion re-run.

The doc closes with a six-item builder edit list (`usage-meter.sh`, `gardener-claude.sh`, `gardener.sh`, new `usage-append.sh`, `complete-job.sh`, tests) requiring no further design decisions.

**Follow-ups.** Post the builder job to implement the design (expected per the spec, deliberately not posted by this job). The `designs/README.md` index predates several existing designs; a small librarian sweep could backfill it, unrelated to this work.
