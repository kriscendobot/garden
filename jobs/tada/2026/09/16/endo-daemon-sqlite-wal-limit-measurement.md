The measurement is complete and the deliverable is durably recorded. Here is my completion report.

---

## Completion report: `endo-daemon-sqlite-wal-limit-measurement`

**What I did.** Measured representative daemon write bursts under the design's `wal_autocheckpoint = 1000` policy on both SQLite backends of `endojs/endo-but-for-bots` (branch `llm`, commit `65902a8f8c`), then compared candidate `journal_size_limit` values against the default. I built a shared, deterministic workload file that both backends replay byte-for-byte, so any difference is attributable to the binding, not the input:
- **Node:** the real `better-sqlite3` 12.11.1 (bundled SQLite 3.53.2) that `manager-database-node.js` imports.
- **Rust:** a `rusqlite` 0.31 (`features=["bundled"]`, SQLite 3.45.0) harness pinned identically to `rust/endo/xsnap/Cargo.toml`, mirroring the daemon's host functions (`journal_mode=WAL`, `foreign_keys=ON`, 5000 ms busy timeout, re-prepare-per-call). Schema is a verbatim copy of `SCHEMA_SQL` (v3).

Workloads: mixed (formula + pet-store + daemon_state + audit, matching the daemon's autocommit-per-write pattern) at 1k/10k/50k units, plus a 100k formula-only burst (drives the DB to 70.68 MB). Candidate limits: {-1 default, 0, 512 KB, 1 MB, 4 MB, 8 MB, 32 MB}. Recorded raw samples, environment, commit, workload, WAL high-water mark, checkpoint/reset frequency, per-write latency distribution, and close latency — identical reporting shape across both backends.

**Findings (verified by execution, all 8 runs).**
1. **WAL high-water mark is bounded by `wal_autocheckpoint`, not `journal_size_limit`** — it plateaued at **1011–1018 pages (~4.14–4.17 MB) in every run, every limit, both backends**, invariant to DB size (0.98 MB → 70.68 MB).
2. `journal_size_limit` changes only the *transient* resident `-wal` size (sawtooth) between checkpoints; the peak never drops.
3. Checkpoint frequency is independent of the limit: identical reset counts per workload on both backends (5 / 57 / 290 / 427).
4. **A clean `close()` leaves the `-wal` at 0 bytes** in every case — the ~4 MB WAL is a running-time cost, reclaimed on shutdown.
5. Cross-backend + cross-SQLite-version parity (3.53.2 vs 3.45.0) is exact on all structural metrics.
6. No consistent write-latency case for a small limit (tails are shared-host scheduling noise).

**Recommendation: keep SQLite's default `journal_size_limit = -1` on both backends.** It does not materially bound disk use (autocheckpoint already caps the WAL at ~4 MB and close reclaims it); a limit below the high-water mark only adds truncate-and-regrow churn per checkpoint for a transient few-MB benefit. This confirms the design's provisional stance, so **no code change is required**. The two cases where a WAL genuinely grows (a long-held reader; an abrupt kill) are both unhelped by `journal_size_limit` — the right levers there are avoiding long readers / an explicit `wal_checkpoint(TRUNCATE)`, and recovery-on-open (already in the design).

**What changed.** No project code changed (recommendation is "keep default"). Deliverable is a durable journal `result` entry (scout default): `entries/2026/09/16/120639Z-result-scout-64b465.md`, containing the full report, all result tables, the complete harness sources, and the raw JSON — reproducible from the journal alone.

**Follow-ups / notes.**
- This report was **not** posted to PR #934: the job carries no per-action authorization for a scout to comment upstream. If the maintainer wants the loop closed on the PR, the summary can be posted as a reply on the originating thread (`https://github.com/endojs/endo-but-for-bots/pull/934#discussion_r3729870370`) once authorized.
- Flagged a library gap to the liaison (journal `message` entry `120735Z-message-scout-d493bc.md`): the job declared `role: scout` and COMMON.md references a scout clause, but there is no `roles/scout/AGENT.md` and `scout` is absent from the CLAUDE.md inventory. Ran fine under the gardener fallback; below my threshold to land unasked.

Self-improvement: nothing this time (routed the scout-role gap to the liaison rather than encoding it myself).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-daemon-sqlite-wal-limit-measurement.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 176 tokens (10025800 cached reads)
- Output: 70433 tokens
- Cost: $8.445405
- Wall-clock: 2283s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
