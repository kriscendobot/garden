Hourly scholar library cycle (job `scholar-library-cycle-20260628-132011`, gardener 32 on endolinbot). Idle cycle for ingestion; one garden-infra follow-on posted.

Drain:
- Job inbox (`scholar-library-cycle-20260628-132011`) empty; `scholar` role inbox empty.
- `role/scholar` topic + broadcast: only the `fetch-source.sh` mirror-first + `source_fetched_via` procedure notices already absorbed into the role file (step 4) and main2-advance / deliberate-deploy broadcasts. No `library_action: ingest-source` asks and no writeback-review requests.
- Board: no claimable `scholar-*` ingest job in `todo/` (only this cycle job). One job parked in `plan/` (`scholar-ingest-ocap-kernel-comment-fragments.md`), never claimed by contract.

No source ingested, re-ingested, or skipped: there was no ingest ask and no claimable ingest job. Source freshness is covered deterministically by the standing `garden-library-source-drift-scan` timer (verified healthy: last fire 13:07Z, `audited=49 current=45 drifted=0 posted=0`, exit 0), so no manual drift sweep was run.

Section-link integrity check, run live this cycle: `bash scripts/jobs/library-link-scan.sh` synced to tip `b6e4ef83` and reported exit 0, "every checked link resolves to a committed file." No live dangling-link debt; nav surfaces are clean.

Garden-infra finding (proactively-fix-the-garden directive). `scripts/jobs/library-link-scan.sh` calls itself "the standing, tip-synced section-link-integrity scan" and the scholar role § step 8 cites it as a standing downstream checker, but it is wired to **no systemd unit** (the only library timer is `garden-library-source-drift-scan`). So it only ever runs when a scholar invokes it by hand. This is the explicitly-named, still-undone follow-up from its build job (`jobs/tada/improve-deterministic-section-link-integrity-scan.md`: "Wiring `library-link-scan.sh` into a cadence ... is a small next step"). Posted a fully-specified follow-on infra job, `improve-wire-library-link-scan-to-cadence`, to `todo/`. It names the mirror target (the drift-scan service/timer pair + install-units auto-derive), and flags the one non-mechanical design decision: the scan is diagnostic-only (exits nonzero on findings, posts no remediation job), so wiring it under `self-heal-run.sh` unchanged would mark the unit Failed on every finding rather than actuate. The job recommends the actuating shape (post a follow-on per dangling cluster, exit 0) for parity with the drift-scan.

Integrity gate (step 8): not applicable; this cycle wrote no section/source/README files, so nothing is in scope for `library-link-check.sh --changed`.

No library/sources/topics/concepts/README files written. No project-tree files written. Follow-on jobs posted: 1 (`improve-wire-library-link-scan-to-cadence`). No deferred ingest backlog.

Self-improvement: nothing this time for roles/skills. The hourly idle path worked as intended (drain, find no ingest work, verify the deterministic scans, exit). The one substantive find was an infra gap surfaced and routed as a job per the standing directive, not a role/skill friction.
