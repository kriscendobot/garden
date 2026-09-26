PR #1024 is a draft against `llm` with 23 changed files (my 20 design docs + README + ARCHIVE, plus AGENTS.md carried from the #1023 stack). All three tasks are complete.

## Completion report

**Job:** `groom-endo-stale-design-docs` — sweep stale individual design-doc metadata + milestone-table cells in `endojs/endo-but-for-bots` `designs/`.

Clean re-run (no prior branch/PR/tada existed). Work is stacked on the unmerged predecessor #1023 (its README reconciliation and the `ARCHIVE.md`/`AGENTS.md` archive convention are prerequisites), delivered as **draft PR endojs/endo-but-for-bots#1024** (base `llm`).

**1. Per-doc metadata tables (20 docs, Updated → 2026-08-17):**
- Landed-but-behind → correct status: `registry-capability` (In Progress), `http-confine`/`exo-zip-package`/`endoclaw-browser`/`endopi-edit-tool`/`endopi-jsonl-transcript-format` (Implemented), `inventory-drag-and-drop`/`inventory-grouping-by-type` (**Complete**), `inventory-cancel-and-liveness`/`inter-package-plain-re-exports`/`intra-package-plain-re-exports`/`notifier-pubsub-migration`/`endo-reminder`/`endo-fetch` (In Progress).
- `break-dev-dependency-cycles` → **Complete** (metadata + prose `## Status`).
- Non-vocabulary strings normalized: `endoclaw-browser`, `captp-error-identification` & `unredacted-stack-sanctioned-ses-api` (→ Proposed), `daemon-locator-reference` (→ Reference).
- `outliner-design-doc` gained a metadata table.
- `namehub-interface-unification`: **confirmed landed** (daemon `ReadableNameHubInterface` implements the design's Decision 3; #339 "complete EndoMount…" merged 2026-05-27) → flipped to **Complete** in the doc, the summary table, and M9; totals adjusted (57 Complete / 25 Proposed).
- Note: `endo-fs-seam-review-followups` was listed in the spec but its doc already read **Complete**, so it was left untouched (no fabricated revision).

**2. Milestone-table inline Status cells (M3–M11):** reconciled `registry-capability` + siblings `mvs-resolver`/`snapshot-mapper`/`daemon-worker-import-from-mount`, `endo-reminder`, `endo-fetch`, `exo-zip-package` (both the M7 3-col and M8 4-col pillar rows), `inventory-*` (M9), `endoclaw-browser` (M10), `namehub-interface-unification` (M9).

**3. Archived Milestone 2 (Project Hygiene)** to `designs/ARCHIVE.md` (full section, appended after M1 in milestone order) with the one-line README pointer per the `AGENTS.md` convention; summary rows retained, mirroring #1023's M1 handling.

**Follow-ups / caveats:**
- Base is `llm` (not #1023's head) because #1023 is a cross-fork PR whose head branch lives on the `kriscendobot` fork and can't serve as a base on `endojs`. #1024's diff therefore temporarily overlays #1023's 3 files; that collapses once #1023 merges. **#1024 should merge after #1023.**
- `ensure-pr.sh` initially returned INCONCLUSIVE (200-PR enumeration cap); confirmed via marker search that no prior PR for this job existed, then created with `GARDEN_ENSURE_PR_LIST_LIMIT=600`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/groom-endo-stale-design-docs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 61 tokens (3053858 cached reads)
- Output: 47446 tokens
- Cost: $4.119820000000001 (1 engagement(s) unpriced)
- Wall-clock: 656s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
