Done. Inbox is empty. Here is the completion report.

---

## Completion report: `design-endo-legacy-host-registry-migration-20260916`

**Deliverable:** design `designs/endo-legacy-host-registry-migration.md`, landed on `main2` (commit `98303c33e5`) and opened as draft review PR **kriscendobot/garden#98** (frozen base `endo-legacy-host-registry-migration-base-a197ac8b`, diff = the design file only, 258 lines).

**What I did.** Examined the actual daemon code at the target pin `0eb88836` (via an isolated `endojs/endo-but-for-bots` checkout) rather than reasoning from the job spec alone. That surfaced two decisive facts the design rests on:

1. **The crash is two Endo-side bugs, not one.** The reported `Invalid formula identifier "[undefined]"` is `seedFormulaGraphFromPersistence` → `onFormulaAdded` (`graph.js`) → `extractLabeledDeps` emitting `['registry', undefined]` → `isLocalId(undefined)` → `parseId(undefined)`. The sibling reader `getFormulaGraphSnapshot` already guards this exact case with `if (dep && …)`; the seed path does not. Separately, the incarnator's clean fail-fast (`Host formula missing registry`) is *unreachable* because the seed crashes first.
2. **The migration Endo asks me to design already exists on paper and was never built.** `registry-capability.md` § *Migration for already-formulated hosts* specifies precisely a one-shot idempotent per-host backfill. No such pass exists at `0eb88836` **or at today's `llm` tip** (`387ea6614`, verified). What shipped is a changeset stating the store "must be re-initialized" — i.e. discard the 61 names / 14 guests. The `@node` precedent it claims to mirror shipped with "no migration path."

**Decisions settled** (all four job questions): (Q1) a one-shot idempotent transactional **migration**, not a read-time default, because Endo made `@registry` deliberately required; (Q2) **yes, Endo-side bug** — fix both defects upstream in `endojs/endo-but-for-bots` (the seed guard + the promised migration pass) with a **local patched-daemon stopgap** (one diff, used twice), rejecting an offline SQLite-rewrite tool as riskier; (Q3) proof gates before production — seed completes, socket exists, the 61-name/14-guest root list reproduced exactly, formula-count invariant 3635+2=3637, idempotency; (Q4) rollback is snapshot-restore + repin to `f6650503`, never a reverse migration, with a fresh pre-migration snapshot and a stopped daemon as hard preconditions.

Mermaid diagram validated (parse-only, `flowchart-v2 OK`). Did not implement anything and did not touch the live daemon or its state; it remains active at `f6650503`.

**Follow-ups (left as maintainer-facing open questions in the design / PR #98):** the registry URL for migrated hosts (public npm vs minion.town's endor proxy); whether to open the upstream endojs PR now or after revival; whether `0eb88836` is still the right target given the 1317-commit gap. Per the manual-gauntlet regime the PR is left draft; promote with **run the gauntlet #98** when ready.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-legacy-host-registry-migration-20260916.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (2849711 cached reads)
- Output: 29634 tokens
- Cost: $3.0612145
- Wall-clock: 503s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
