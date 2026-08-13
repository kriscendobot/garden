Design landed on `main2`.

## Completion report

**Job:** designer — date-shard `jobs/tada/` so recently-completed work is easy to find.

**Delivered:** `designs/date-sharded-tada.md`, committed and CAS-pushed to `main2` (`b2096e007e`).

**What the design settles (the five hazards the spec named):**

1. **Basename lookup (highest risk).** Recommends an **exhaustive recursive scan, no separate index and no date window** — both alternatives reintroduce the #671 *drop* failure mode. The lookup is built so its only possible error is "not found → re-mint" (noisy, self-healing), never a silent drop. Confirmed the with-identity dedup (`jobs/index` / `job_in_lifecycle`) is unaffected, so the #671 fix stays intact.
2. **Which date.** Completion time, **chosen once at write** (`date -u +%Y/%m/%d`) and frozen into the path — never recomputed at read. For existing entries, recovered deterministically from the **add commit** (`git log --diff-filter=A`, verified working). Unrecoverable → `jobs/tada/undated/`.
3. **The refactor.** Six new `common.sh` helpers (`tada_write_path`, `tada_path_for`, `tada_find`, `tada_find_tree`, `tada_exists`, `tada_recent`) so the layout lives in one place. Full consumer disposition table across all ~27 scripts, splitting **dangerous** (drops/double-runs work) from **noisy** (wrong count).
4. **Rolling-deploy safety.** Confirmed the ordering *readers-tolerate-both → writers-switch → migrate → drop-fallback*, and gave the concrete reason A-before-B is mandatory: orchestrate/gauntlet are leader-only, so the leader must be tolerant before any follower writes sharded, else a completed child reads `gone` and halts a serial campaign. Old-code host behavior stated per stage.
5. **Migration atomicity.** One commit / one CAS push / all 4,521 renames; idempotent retrying loop like `complete-job.sh`; **no fleet drain required**. Documented the interaction with concurrent claims/completions.

**Notable finding surfaced beyond the ask:** `orchestrate.sh`'s atomic four-path snapshot read and — importantly — `follow-up.sh`'s **host-local seen-marker keyed by rel-path**, which the migration would otherwise turn into a 4,521-report follow-up storm. Design specifies re-keying it on `basename` (durable fix) plus a per-host `sed` sweep (belt-and-suspenders). Also flagged `follow-up.sh:156`'s `base` extraction bug under sharding, and the `bulletin`/`cost` counters that use `-maxdepth 1`.

**Follow-ups (for the implementing builder):** the design is staged into 4 land-on-`main2` checkpoints with a test list per stage (absent→re-mint, sharded-child-reads-tada-not-gone, `tada_find` across flat/sharded/undated). No code was changed — this is design-only per the job role.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-tada-shard-01-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (814068 cached reads)
- Output: 18547 tokens
- Cost: $1.550492
- Wall-clock: 297s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
