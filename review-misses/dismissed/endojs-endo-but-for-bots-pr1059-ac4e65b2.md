---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1059-ac4e65b2
verdict: not-a-miss
category: new-direction
review_at: 2026-08-31T05:17:46Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1059#issuecomment-5474067434
identity: endojs/endo-but-for-bots#1059:comment:5474067434:retro
---

Another iterative round of the maintainer's continuous domain-expert review of the
ironhorse snapshot-store seam — this one a **test-coverage-gap** review (delivered
via an AI review persona) of the Rust SQLite persistence layer
(`rust/endo/ironhorse-store-sqlite`, `rust/engine/ironhorse-snapshot`). The
maintainer judged the SQLite coverage substantial but named several narrower gaps:
persistence fixtures assert admission/refusal rather than resumed behavior (no
post-resume behavioral oracle); the on-disk metamorphic suite never closes and
reopens a connection mid-scenario (so WAL folding, `SqliteHeapStore::init` reopen,
`root_cache`/`edge_pairs` reconstruction, and post-reopen lazy reads go unexercised
for the newly graduated carry rows `FUNC`/`GENR`/`IBFN`/`PRIV`/`DISP`); no test
forces an SQL error *after* transaction mutation begins (a `RAISE(ABORT)` trigger to
prove mid-commit rollback + advanced-root-cache drop); valid-database corruption
coverage is narrow (whole-file truncation and a leaf-hash edit, but no
structurally-valid row mutation of `slot_pages`/`chunk_exts`/`small_state`/`free_segs`
bytes against validation, eager resume, and lazy fault); and a few exact updated
edge cases (three repaired `@@iterator` identities, Intl rebound-function ordering)
run through blob/memory/file stores but not the SQLite backend.

**Grounds for not-a-miss.** This is the same maintainer-driven ironhorse Rust-engine
arc the two prior rounds were already dismissed against (comment 5452184664 →
`…-a5d1fff6`; comment 5486686006 → `…-1e30a92e`); the grounds hold and strengthen:

1. *No garden review surface has jurisdiction.* No gauntlet/panel job for #1059
   exists anywhere on the board — `journal/jobs/tada/` holds only fix/rebase/shepherd
   and review-fix jobs for this PR and zero panel/gauntlet jobs. Under the
   manual-gauntlet-trigger regime the garden stages no automatic gauntlet, and none
   was requested; the garden's role on this PR is *fixer*, and the maintainer is the
   continuous, engaged evaluator. This is therefore not a `process` miss (no gauntlet
   was owed).

2. *No juror seat's lens reaches the domain.* Although the taxonomy would route a
   coverage gap to `coverage-auditor`/`corner-prober`/`fast-checker`/`prover`, those
   seats reason about JS/TS coverage (via coverage-driven-testing and coverage
   reports) and design docs — not an ironhorse Rust persistence engine's binary
   snapshot format. The specific gaps named here (mid-commit `RAISE(ABORT)` rollback
   proof, WAL last-connection close/reopen and `root_cache` reconstruction,
   structurally-valid row-byte corruption across eager/lazy fault paths) require deep
   Rust snapshot/SQLite-persistence domain expertise no garden seat is scoped to hold.

3. *No standing garden rule failed to bind.* There is no seat brief, skill, or
   COMMON.md norm requiring the ironhorse SQLite suite to carry post-resume oracles,
   close/reopen lifecycles for every graduated carry row, mid-transaction failure
   injection, or valid-structure row corruption. That coverage discipline is being
   *established* by this review round, not violated against a written rule, so the
   single-major-miss severity bypass is not met.

4. *Iterative expert review, not evaluator-gaming.* Nothing was routed around a gate
   and no measurement was moved while the target stood still. Each round the garden
   extends the suite and the domain-expert maintainer reviews again and names the next
   completeness layer of a hand-written persistence engine's test matrix. That is the
   review process working as intended for a maintainer-driven Rust-engine arc.

Recording as a dismissal keeps the discriminator's calibration auditable and stops
this comment being re-litigated; it mints no cluster and dispatches nothing.

**World-check (deliverable confirmed, no discrepancy).** The primary
(`endojs-endo-but-for-bots-pr1059-ac4e65b2`) did *not* close as a no-op — it reported
adding the mid-transaction abort/rollback + cold-cache retry coverage, valid-database
row-corruption matrices across validation/eager-resume/lazy-fault, and concurrent
resume-oracle + close/reopen carry-matrix coverage for `FUNC`/`GENR`/`IBFN`/`PRIV`/
`DISP` plus iterator identities and Intl rebound ordering, with the full
`ironhorse-snapshot` and `ironhorse-store-sqlite` suites passing (head `c0c30fcde8`).
Those items map directly onto this comment's P1–P3 gaps. PR #1059 is now **merged**
(head `48c92dadf`, base `llm`), so the coverage follow-up landed. Deliverable
confirmed; no discrepancy to report.
