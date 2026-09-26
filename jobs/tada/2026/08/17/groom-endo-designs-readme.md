All deliverables are in place and verified. The draft PR is open, the changelog is relocated with my dated entry on top, the archive convention and ARCHIVE.md exist, and the follow-on job is posted.

## Completion report

**Job:** `groom-endo-designs-readme` — groom `designs/README.md` in endojs/endo-but-for-bots (`llm`): verify, reorganize, archive, illuminate. Landed as **draft PR endojs/endo-but-for-bots#1023** (base `llm`, designer convention — its review thread is the interactive surface for further milestone resequencing).

**What I did (all six sections addressed):**

1. **Status verification (§1, fan-out).** Read `designs/AGENTS.md` in full, then fanned 6 parallel subagents across all 185 summary-table rows, each cross-checking claimed status against real merged/open-PR state (402 merged + 309 open PRs) and the `llm` git log, plus each design's own metadata. Corrected **~34 drifted rows** — almost all *understating* landed/in-flight work (e.g. `http-confine`, `exo-zip-package`, `inventory-drag-and-drop`/`-grouping`, `endoclaw-browser`, `endopi-edit-tool`/`-jsonl`, the `daemon-git-*` trio, `endo-reminder`, `endo-fetch`, re-exports, `notifier-pubsub-migration`). Added a **Verification drift (2026-08-17)** table with claimed→verified + PR evidence.
2. **Totals recount.** Prose claimed 151 designs; the table had grown to **185 distinct rows**. Replaced three contradictory historical totals paragraphs with one authoritative recounted block.
3. **Milestone reorg (§2).** Chose *not* to physically renumber M1–M11 (that numbering encodes the dependency invariant; renumbering churns the whole cross-reference web). Instead added an **Expected landing order** view (confidence tiers A/B/C, not invented dates) and explicitly surfaced where realistic landing order **conflicts** with the dependency numbering (M11 Rust/`ironhorse` and M10 `endoclaw-browser` landing ~1 year ahead of slot while critical-path M3 gateway work slips). Documented the choice for review.
4. **Velocity grounding (§3).** Aggregated real fleet velocity from the garden journal `jobs/tada/*.md` cost stamps (design/build jobs median ≈ $1–3 / ≈ 6–20 min) and added a 2026-08-17 calibration note: development is fleet-driven not single-developer; the binding constraints are human-review latency (~50–190× machine cost) and token-budget admission at dispatch. Extended the existing calibration discipline rather than replacing it.
5. **Discrepancy illumination (§4).** Added **Planned milestone vs. actual landing** and **Delivery-date estimates vs. real dates** tables.
6. **Changelog relocation (§5).** Moved the ~273-line `*Layered on…*` chain from the head to a `## Changelog` at the foot (entries verbatim; new dated entry prepended).
7. **Archive M1 + convention (§6).** Moved fully-complete Milestone 1 into new **`designs/ARCHIVE.md`** (stands alone), left a one-line pointer, and added a standing **archive convention** to `designs/AGENTS.md`.

**Changed files:** `designs/README.md`, `designs/AGENTS.md`, new `designs/ARCHIVE.md`.

**Flagged, not done (scope guard):** Milestone 2 flagged as the next archive candidate; ~16 individual design docs whose own metadata is stale + milestone-table inline Status cells left for a scoped follow-up — **posted follow-on job `groom-endo-stale-design-docs`** naming exactly what's left.

**Notes / caveats:** The 2 Mermaid blocks were not edited (they render as before; their per-node status labels didn't drift for the corrected designs). `namehub-interface-unification` left at Proposed pending confirmation (mixed evidence). Milestone-table inline Status cells intentionally not mass-edited (varied column shapes; summary + drift table are authoritative, noted inline). PR creation initially hit `ensure-pr.sh`'s 200-PR page-limit guard; resolved by raising `GARDEN_ENSURE_PR_LIST_LIMIT`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/groom-endo-designs-readme.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (7725458 cached reads)
- Output: 66684 tokens
- Cost: $12.228175499999995
- Wall-clock: 974s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
