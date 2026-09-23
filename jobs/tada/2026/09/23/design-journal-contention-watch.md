Empty inbox. The work is done.

## Completion report

**Job:** `design-journal-contention-watch` (designer role)

**Deliverable:** `designs/journal-contention-watch.md`, landed **bare on `main2`** (commit `1f810f19af`, pushed cleanly).

**Bare-vs-PR decision:** I settled every threshold and policy the brief raised, so there is **no `## Open questions` section** → the garden's own-repo carve-out for open-questions designs does not apply, and it lands direct-to-`main2` as most garden designs do. Where a choice was genuinely a risk-appetite call (auto-remedy on from day one; page-immediately vs confirm-count) I settled it with a stated principle rather than deferring: hard-guard incident classes page on the first tick, baseline/drift anomalies page after 2 confirming ticks.

**What the design specifies (grounded in the real code):**
1. **Instrumentation** — one cheap recorder `contention_record` (a single `$EPOCHREALTIME` builtin read + one atomic append, gated by `GARDEN_CONTENTION_INSTRUMENT`), wired into the exact existing functions: `clone_lock` (wait/steal/give-up), `_journal_git_fetch`+`bounded_fetch` (duration vs the 45s `GARDEN_FETCH_TIMEOUT` cap), the CAS push loops via `commit_and_push` (attempts + `journal_push_is_*` class, reusing the predicates so logic can't drift), and `start_journal_outage_cooldown`/`journal_outage_active` (latch + silent-skip count).
2. **Storage** — host-local bounded rings under `$GARDEN_STATE`, writers append-only, checker trims; **no per-event/per-tick journal writes**; the fleet-wide hourly summary is explicitly declined (probe + bulletin give the view without churn).
3. **Anomaly detection** — rolling median+MAD and p95 with absolute floors, named hard guards (fetch ≥31.5s = 70% of cap, any lock give-up, stuck latch >10min, 50-attempt push wedge, clone ≥2 GiB / gc.log / ≥50 packs), plus **drift** (oldest-third vs newest-third median with a 24h cap-projection for fetch).
4. **Silent-skip visibility** — every outage-latch skip counted; a >10min episode pages (the 4.5h class, caught an order of magnitude sooner).
5. **Remediation** — automatic **lossless** clone rebuild (lock → rename-aside → `ensure_clone` rebuild → background delete → alert, 6h backoff, kill-switch), matching the root-repo-guard posture; scoped to `$GARDEN_STATE` clones only, root repo left to root-repo-guard.
6. **Runs on every host, not leader-only, and through drain**, like `garden-root-repo-guard`; own liveness via the three-turtles heartbeat.
7. **Alerting** via `watchdog-notice.sh`, coalesced per host+clone+class, closed `--recovered`.
8. **Observability** — read-only `journal-contention-probe.sh` + a bulletin one-liner.

Includes an ownership map (multi-boundary design) and a test plan (unit stats/flapping, the 4.5h-latch replay, the oversized-clone remedy replay, behavior-preserving instrumentation).

**Follow-ups:** the builder job `build-journal-contention-watch` follows in orchestration `journal-contention-watch` (per the brief); nothing owed from this job. Inbox drained (empty).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-journal-contention-watch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1607360 cached reads)
- Output: 21305 tokens
- Cost: $2.4210949999999998
- Wall-clock: 340s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
