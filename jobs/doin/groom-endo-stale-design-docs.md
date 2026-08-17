---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
tier: mentor

# Sweep stale individual design-doc metadata + milestone-table inline cells (endo-but-for-bots)

Repository: endojs/endo-but-for-bots, directory `designs/`, branch `llm`.
Follow-on from the 2026-08-17 `groom-endo-designs-readme` pass (draft PR
endojs/endo-but-for-bots#1023), which reconciled the README summary table
but, per its scope guard, did NOT rewrite individual design docs or the
per-milestone inline Status cells.

Three tasks, land as a draft PR against `llm`:

1. **Fix stale per-doc metadata tables.** These docs' own Status/Updated
   fields disagree with reality (verified 2026-08-17). Bring each into line
   with the README summary table / the PR #1023 "Verification drift" table,
   updating the **Updated** date:
   - Landed but marked behind: `registry-capability`, `http-confine`,
     `exo-zip-package`, `endoclaw-browser` (also has a non-vocabulary Status
     string), `endopi-edit-tool`, `endopi-jsonl-transcript-format`,
     `inventory-drag-and-drop`, `inventory-grouping-by-type`,
     `inventory-cancel-and-liveness`, `inter-package-plain-re-exports`,
     `intra-package-plain-re-exports`, `notifier-pubsub-migration`,
     `endo-reminder`, `endo-fetch`, `endo-fs-seam-review-followups`.
   - Terminal but marked In Progress: `break-dev-dependency-cycles` (Complete).
   - Non-standard Status vocabulary: `captp-error-identification` (doc "Draft"),
     `unredacted-stack-sanctioned-ses-api` (doc "Draft"),
     `daemon-locator-reference` (doc "Current" → Reference).
   - `outliner-design-doc` has NO metadata table at all — add one.
   - `namehub-interface-unification`: mixed evidence (doc says "Accepted, not
     yet implemented"; #339 EndoMount unification may have landed it).
     Confirm against real state before flipping; left at Proposed in the README.

2. **Reconcile milestone-table inline Status cells** in `designs/README.md`
   (M3–M11 tables) so they match the summary table for the rows PR #1023
   corrected. Watch the varied column shapes (3-col vs the M6 slice / M8
   pillar 4-col tables).

3. **Archive Milestone 2 (Project Hygiene)** to `designs/ARCHIVE.md` per the
   convention PR #1023 added to `designs/AGENTS.md` — all six designs are
   Complete and its exit criterion is met. Leave the one-line pointer.

Scope guard: `designs/` only. If it runs long, complete a coherent subset and
post a follow-on naming the remainder.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T21:43:12Z
