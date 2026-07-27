Weekly plan recalibration complete. Report follows.

---

**Weekly plan recalibration & grooming — 2026-07-27 (Sunday)**

Worked in an isolated `origin/journal2` worktree; committed and pushed to `journal2` (CAS, first-attempt OK, now at `34677a2a1b`).

**1. Reconcile (auto-flip):** Ran `reconcile.sh` — **0 records advanced**. The only non-done record carrying a PR is `daemon-message-streaming` (#287), which is **CLOSED unmerged**, so reconcile correctly left it. No design PRs newly merged this week resolved to a plan record.

**2. Velocity:** Trailing 7-day window (07-20→07-27) merged **29 PRs** (27 onto `llm`, 2 onto stacked feature branches; 1/10/7/2/1/5/2/1 by day). Review-queue fast cohort = 23 PRs, **median 0.87 days**; tail of 6 (6.4–74.6 d). All-in median 1.29 d. Robust figure rounds to the standing **`review-queue-latency-days: 1`** — now four consecutive passes agreeing (1.15→0.90→0.76→0.87). Latency and the S/M/L/XL day mapping left unchanged; added a dated log entry to `velocity.md`.

**3. Reprojection:** No milestone carries a `target:`, and the standing policy holds — the effort→wall-clock parallelism factor is still uncalibrated, so dated targets stay unstamped (rationale reaffirmed in the log entry). No milestone edits.

**4. Grooming:**
- **Filed 5 previously-unfiled designs into M11 (Rust `endor`)** — all explicitly Rust-supervisor / xsnap / XS-worker-runtime designs matching M11's exit criterion ("attach to an XS worker's debugger"): `daemon-xs-worker-debugger`, `daemon-xs-worker-snapshot`, `daemon-xs-worker-metering`, `daemon-cas-management` (Endor CAS, `rust/endo/src/cas.rs`), `daemon-debug-worker-restart`. Each got `milestone: M11`, an `updated:` bump, and an audit note. M11 rollup moved 7→12 members (42%→33%).
- **Noted `daemon-message-streaming` drift**: PR #287 closed unmerged with no superseding PR; flagged for maintainer decision (re-open vs retire) rather than mutating status/pr unilaterally.
- **Held the genuinely ambiguous unfiled records** (`daemon-capability-bus`, `daemon-cross-peer-gc`, `daemon-web-gateway`, `daemon-make-archive`, the `cli-*`/`familiar-*`/`agent-tools`/`outliner`/`unhandled-rejection`/`endo-fs-backend-seam` set) — no clear single milestone; Reference-status docs (`endoclaw`, `endopi`, etc.) correctly stay unfiled.
- **No dangling `depends_on` edges.** `validate.sh`: **141 records, 0 errors, 0 warnings** (before and after).

**5. Re-render:** Regenerated `plan/README.md` (M11 rollup + member rows updated).

**6. Endo courtesy redirect:** Regenerated via `render-endo-redirect.sh`; differed from the existing redirect PR's head only by the 6 grooming `updated:` bumps (a real record change). Landed change-gated on the **reused open PR #536** (`chore/plan-in-journal-endo-redirect` → `llm`, bot identity), not a new PR. Pushed to `8ed032170`. Note: `designs/README.md` on `llm` itself is still the old v1 hand-index because PR #536 hasn't merged — the redirect cutover awaits that merge.

**Follow-ups for the maintainer:**
- Decide `daemon-message-streaming`: re-open Phase-1 work or retire the design (PR #287 dead).
- Merge redirect PR #536 to complete the plan-in-journal Phase-1 cutover on `llm`.
- ~18 records remain unfiled (milestone ambiguous); worth a maintainer pass or a future grooming round with per-design context.
