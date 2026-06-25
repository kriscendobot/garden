# Plan tooling

The garden **plan** (the roadmap) is state on the `journal2` branch under
`journal/plan/`. These scripts are the *code* that validates, renders, reconciles,
and imported it. The *data* (per-design records, milestones, the generated view)
lives in journal2; the schema/contract is documented at `journal/plan/SCHEMA.md`.
The architecture is the approved design `designs/plan-in-journal.md` (garden#4).

The per-design records are the **single source of truth**; `journal/plan/README.md`
is a **generated aggregation** of them — never hand-edited.

| Script | What it does |
|---|---|
| `lib.sh` | Shared frontmatter/record helpers, the status enum, the size→days map. Sourced by the others. |
| `validate.sh` | Schema + slug-uniqueness + repository-resolution gate; rejects any record targeting agoric-sdk. Run as a pre-push gate and as a job on plan change. |
| `render.sh` | Aggregate the records into the roadmap view (`journal/plan/README.md`): per-design table, per-milestone rollup, Mermaid dependency graph. Deterministic (no clock, no network) so it is multi-host idempotent and change-gated. |
| `reconcile.sh` | Advance each record's `status`/`pr` against actual PR + board state; auto-flip to Complete on a detected merge, with an audit note. Mutates records; the caller commits. |
| `import-endo.sh` | The one-time import of the endo v1 plan (`endojs/endo-but-for-bots:llm` `designs/README.md` + per-design narratives) into the record set. |

## Where each runs

- **Rendering** rides on the bulletin loop (`scripts/jobs/bulletin.sh`,
  `render_plan`): every tick it re-renders `journal/plan/README.md` from the
  records and commits it change-gated. Deterministic output means a plan-only
  change is reconciled even on a tick where the maintainer dashboard is unchanged.
- **Status/PR reconciliation** (the gh merge-detection auto-flip) runs on the
  weekly **Sunday-evening** recalibration job (`journal/schedules/plan-recalibrate.md`),
  alongside velocity recalibration, roadmap reprojection, and grooming. Folding the
  reconcile continuously into the bulletin/journalist loops is a tracked follow-on,
  pending a weekly pass proving the auto-flip safe on the freshly imported data.
- **Validation** is a pre-push gate and a job posted on plan change.
- **The bulletin's parked-PR ranking** (`roadmap_index` in `bulletin.sh`) reads the
  records' `pr:` + `milestone:` frontmatter to rank the maintainer's review queue by
  roadmap position; it degrades to recency-only when no record maps a parked PR.

## Cutover state (per designs/plan-in-journal.md Migration phases)

- **Phase 0 (schema, reconciler-render, import):** done — records + milestones +
  repositories.md + velocity.md imported; render folded into the bulletin loop.
- **Phase 2 bulletin / foreman:** done — `roadmap_index` already reads the journal
  plan tree; `foreman-claude.sh` reads `journal/plan/` instead of the endo `llm`
  `designs/README.md`.
- **Phase 1 endo redirect, Phase 3 cross-repo records (garden/endo), Phase 4 retire
  the endo CLAUDE.md discipline, continuous gh reconcile:** tracked as follow-on
  `implement-plan-*` jobs.
