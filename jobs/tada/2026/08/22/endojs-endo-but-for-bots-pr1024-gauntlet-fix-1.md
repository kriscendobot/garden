All 5 checks pass and `mergeState` is now `CLEAN`. The fix stage is complete.

## Completion report

**Gauntlet FIX round 1 — endojs/endo-but-for-bots PR #1024** ("docs(designs): sweep stale per-doc metadata + milestone cells; archive M2")

**Panel verdict applied.** The round-1 panel (7 seats, all request-changes) converged on a set of self-contradiction and convention blockers in the docs-only reorganization. I applied them in commit `6dcfc67`:

- **M2 archive contradiction** — deleted the "Milestone 2 is the next archive candidate / left in place this pass" blockquote that the second commit had falsified by actually archiving M2; moved that pass-narrative into the `## Changelog`.
- **One-job-two-tenses** — reconciled `:193`/`:249`/`:672` so the stale design docs read as swept *in this PR's second commit*, not deferred to a future job.
- **Recount that didn't reproduce** — corrected the totals to **55 Complete/Implemented, 48 In Progress** (verified reproducible by `sort | uniq -c` after bucketing on the leading vocabulary word) and stated that method inline.
- **Roadmap preamble miscount** — "four subsections" → five, all named.
- **namehub hedge** — dropped "needs confirmation / likely-landed" (it is landed via #339).
- **Status-precedence inversion** — the per-doc metadata table is the source of truth; the summary table its derived index (per AGENTS.md), no longer granting authority to the drift table.
- **Archive convention vs. its own first application** — added a Summary lede + archive note, marked the 13 M1/M2 rows "(archived)", synced 19 swept docs' Updated dates into the summary table, amended AGENTS.md to permit the pointer's provenance note, and added `Draft`/`Superseded` to the Status Values table with a normative bolding/qualifier rule.
- Attenuated the velocity note to qualitative claims (its numbers live outside this repo); reclassified inter/intra re-exports as post-M2 hygiene (not part of the archived milestone); fixed the exo-zip M8 cell (shipped, not in-flight); normalized typist-hostile code points in newly authored prose.

**Base-conflict unblock (required for CI).** The PR head was 207 commits behind its base `llm` and conflicted in `designs/README.md` — GitHub therefore ran **no** CI at all (`mergeState: DIRTY`). I merged current `llm` (commit `2cfd64c`), keeping this PR's reorganized structure and folding in `llm`'s meanwhile-landed row updates (endor-git-bindings libgit2/Zig rebind + `L 2-3 weeks`, ironhorse-snapshot-store-seam phases 5-10, agentry-agent-builder #965 grants, daemon-git-next-steps, their summary Updated dates, and the 2026-08-14 changelog entry). The PR diff is now clean docs-only.

**Pushed** both commits to the PR head via `safe-push-pr-head.sh` (advance mode).

**CI: GREEN.** `browser-tests`, `build`, `lint`, `test`, `zizmor` all pass; `mergeState: CLEAN`.

Per the stage protocol, I applied fixes once and stopped without re-running the panel (the driver re-posts panel-2).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1024-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (6 unmetered)
- Input: 210 tokens (14741310 cached reads)
- Output: 76889 tokens
- Cost: $11.207930000000003 (6 engagement(s) unpriced)
- Wall-clock: 3346s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
