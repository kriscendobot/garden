All six steps complete and verified on `origin`. Cleaned up my auxiliary worktrees; inbox empty.

---

## Completion report — `plan-recalibrate-20260628-210527` (weekly plan recalibration + grooming)

**1. Reconcile (status/PR drift).** Ran `reconcile.sh` over all 141 records: **0 flips**. The three records carrying PRs are all unmerged — #133 and #284 OPEN, #287 CLOSED-without-merge — so the automatic Complete flip correctly fired for none. Verified each PR's merge state by hand to confirm the no-op was real, not a `gh` failure.

**2. Velocity recalibration.** Measured the trailing-7-day window (2026-06-22→06-29) on `endo-but-for-bots`: **35 merges (~5/day)**, open→merge latency **median 1.15 d / mean 9.98 d** (mean skewed by a few design-record PRs that sat 35–47 days). Recalibrated `review-queue-latency-days` **2 → 1** on the robust median; added a dated recalibration log to `velocity.md`. Left the S/M/L/XL→day effort map unchanged (it is a per-design effort model; the high merge rate is a parallel-fleet throughput signal, not evidence the effort estimates are wrong).

**3. Roadmap reprojection.** Added a "Projection basis" note to `velocity.md` and **deliberately did not stamp per-milestone calendar `target:` dates** this week: the single-developer effort-day totals can't be mapped to wall-clock against a parallel fleet without a calibrated parallelism factor the plan doesn't yet carry, and serial single-dev targets (≈8 months to the back milestones) would be misleading. Recorded that calibration as the tracked follow-up.

**4. Grooming.** Filed 7 unfiled designs into milestones (high-confidence only): `daemon-git-capability`, `daemon-git-next-steps`, `daemon-git-remotes`, `endo-fs-from-git`, `fs-interface-consolidation`, `fs-interface-reconciliation` → **M3**; `ocapn-noise-session-reconnect` → **M4** (siblings already there). Noted PR #287 closed-unmerged on `daemon-message-streaming` (status left In Progress pending re-attempt). `validate.sh`: **141 records, 0 errors, 0 warnings.** No dangling `depends_on` edges (none recorded). ~17 lower-confidence unfiled incomplete designs left for a future pass.

**5. Re-render.** Regenerated `plan/README.md`.

**6. Endo courtesy redirect.** Regenerated and pushed to the existing redirect PR **#536** (`chore/plan-in-journal-endo-redirect`) — reused per the contract. Change was exactly the 7 groomed records' `updated`-date bumps (change-gated).

**Bug fixed along the way (in scope — it corrupts this job's own deliverable).** `render.sh` joined the per-design TSV with tabs and read it back with `IFS=$'\t' read`. Tab is IFS-whitespace, so bash **collapsed empty fields** — every record with a `milestone` but no `size` rendered with its milestone shoved into the Size column (e.g. `daemon-256-bit-identifiers` showed Milestone=— / Size=M1). Switched both renderers to a US (`\037`) delimiter so empty fields survive `read`; output otherwise byte-identical (verified idempotent). Fixed the same latent footgun in `render-endo-redirect.sh`. Landed on **main2**.

**Pushes:** `journal2` (records + velocity + README), `main2` (render fix), and PR #536 branch (redirect) — all CAS-pushed (one rebase each), verified intact on `origin`.

**Follow-ups:**
- **PR #536 is `mergeable: CONFLICTING`** (pre-existing — the branch and `llm` report "no merge base"). The weekly regeneration keeps the redirect current but does not resolve the branch conflict; whoever lands #536 needs a conflict-resolution pass.
- **Projection parallelism factor** (effort-days → wall-clock) needs calibrating from design-record completions before per-milestone dated targets are meaningful (recorded in `velocity.md`).
- **Library divergence:** the `velocity-recalibration`, `roadmap-projection`, and `groom-open-questions` skills the job cites are listed in `CLAUDE.md`'s inventory but are **absent under `skills/` on main2** (not yet migrated from the v1 set). I applied the methodology directly from `designs/plan-in-journal.md` + the plan scripts. Worth either porting those skills or trimming the inventory list.
