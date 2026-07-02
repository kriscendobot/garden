Both files are verified on `origin/journal2`. The job is complete. My cwd (garden main2) worktree has no changes — all work landed journal-side via the sanctioned lander, which is correct for a project-context edit.

---

## Completion report

**Job:** `groom-refine-endo-roadmap` — refine the endo project roadmap (groom role).

**What I did.** Reconciled the endo roadmap (the authoritative ledger is `designs/README.md` on `endojs/endo-but-for-bots@llm`, tip `e50be0b0c`, whose header still read *Last updated 2026-06-15*) against the 2026-06-16 → 2026-07-01 progress window. Because this is a v2 gardener job constrained to the sanctioned journal lander (`land-journal-edit.sh`, `projects/` tree) rather than a fork-side ledger PR, I produced a grounded **groom reconciliation snapshot** that surfaces the deltas and open questions for the next fork-side groom PR and the maintainer, without editing the ledger or the drafts (append, not rewrite).

**What changed (both landed and verified on `origin/journal2`):**
- **New:** `projects/endo/roadmap-reconciliation-2026-07-02.md` (commit `e8097b5eb`).
- **Pointer:** added a `## Roadmap` section to `projects/endo/README.md` (commit `76b6efca8`) so the ledger and the reconciliation are discoverable.

**Roadmap changes reported in the snapshot:**
- *Status drift found:* `fs-interface-reconciliation` + `fs-interface-consolidation` still read "In Progress" though PR #467 (merged) + the ledger's own 2026-06-19 prose say all five phases landed → recommend flip to Complete.
- *Four merged workstreams with no ledger home surfaced:* arrow/method house style (#474 on `llm`; #589 open on `master`), plain re-exports rule (#543/#544/#548 + passes #570/#571), error-tracing substrate (#50/#58 merged, aggregator #301 open), `@endo/pubsub` (#513 + #507).
- *In-flight milestone state spot-checked:* M3 gateway substrate P0 (PR #356 packaging/AWS designs still **not on `llm`**), M4 iroh-first networking (#446/#452/#465/#479/#470/#462), UX confined-Preact migration (#460/#471/#516).

**Open questions sharpened & pruned:**
- *Pruned 3 (overtaken):* gateway-package/endo-gateway consolidation (done), the three M5 gap M-bin assignments (settled at M5 by renumbering), raise-endopi-provider (settled: leave).
- *Standing (need maintainer):* the 2026-06-11 resequencing proposal was **never applied** (ledger still M1–M11, no M7 Community Hub) — its 7 decisions remain live, chiefly P4-in-O1-exit and the dedicated-O2-milestone call; plus the M6 MCP exit-criterion tool-surface question, now sharper since `ToolRecord` (#523) landed.
- *New 2:* whether the roadmap wants a house-style/hygiene track, and the `llm`↔`master` house-style divergence (#589).

**Re-prioritization / near-term sequence projected:** P0 land PR #356 onto `llm` → P1 M6 MCP termination (gated on gateway phases 2/7/8) → P2–P4 author the three M5 hosting/billing gap designs, with the hygiene track running in parallel.

**Follow-ups:** (1) a fork-side groom PR should apply the §D ledger edits (the status flips, header refresh, hygiene note, M4 Gantt re-projection); (2) the §B.2 standing questions (esp. the un-applied resequencing) have been pending since 2026-06-11 and want a maintainer decision via the liaison — I did not send an unsolicited maintainer message, since the snapshot is the surface and maintainer-nudging is the liaison's call.

Self-improvement: this job exposed a lane mismatch worth encoding — the endo *roadmap* is a fork file (`endo-but-for-bots@llm:designs/README.md`), but a v2 gardener groom job is constrained to the journal lander (`projects/` tree), so it cannot edit the authoritative ledger directly. The durable resolution is a two-surface groom discipline (journal reconciliation snapshot ⇒ fork-side ledger PR), and the migration of `roles/groom` + `skills/{groom-open-questions,roadmap-projection}` from the v1 `main` branch into `main2` should carry that split explicitly so future groom jobs know a journal snapshot is the deliverable and a fork PR is the apply step, rather than silently landing a parallel roadmap.
