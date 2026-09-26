Pushed to main2 on the first try. The work is complete.

## Completion report

**Job:** `openrouter-reputation-unmask-migration` (Child 3 of 3 of the `openrouter-zdr-and-stealth-orchestration` — Decision 2b). Built a maintainer-triggered reputation-arm migration for carrying an unmasked stealth OpenRouter id's accumulated history forward onto the now-named model's arm(s).

**What I did**
- Read `reputation.sh` + `reputation-reduce.sh` first, confirming the load-bearing invariant: arm projections (`reputation/arms/…`) are a **pure function of the event log**, recomputed every tick and keyed on `(kind, provider, model, thoughtfulness) × work_class × target`. So the migration goes **through the source of truth** (relabels events) rather than hand-editing a projection, exactly as the spec required.
- Added `scripts/jobs/rerecord-reputation-arm.sh <old-arm-key> <new-arm-key> --authorized-by <login> [--dry-run]`. An arm key is `<kind>/<provider>/<model>` in raw event-frontmatter values (kind/provider are slash-free, so the first two slashes split the key; the promo model is namespaced `openrouter-promo/<wire-id>`, the named model `openrouter/<wire-id>`).

**What it does**
- Relabels the `kind`/`provider`/`model` fields of every matching event **and** not-yet-finalized pending event, preserving thoughtfulness/work_class/target/acceptance/dollars; the next reducer tick re-projects the full history onto the named arm(s).
- **Merge came free:** because the reducer recomputes each arm from *all* its events (Welford over the set), relabeling onto a target arm that already has history folds the two together exactly — clean rename and merge-on-collision are the *same* operation. So the spec's fallback ("build rename now, leave merge as an open question") was unnecessary; both are covered and tested.
- **Orphan GC:** the reducer never deletes a zero-event arm, so the migration removes the old model's orphaned `arms/` subtree in the same commit — no stale projection lingers.
- **Idempotent + auditable:** a re-run matches no old-arm events → clean no-op; every real application writes an append-only `reputation/migrations/<ts>-<hash>.md` record and stamps `rerecorded_from/_to/_by/_at` on each moved event.
- **Attestation** follows the sysop destructive-op precedent — `--authorized-by <login>` gated against the journal `maintainers/allowlist`.

**Verification:** `scripts/jobs/test/rerecord-reputation-arm-test.sh` — 24 hermetic assertions, reducer-in-the-loop (attest gate, rename+reproject+GC, merge-on-collision, pending migration, audit record, idempotence): **24 passed, 0 failed**. `bash -n` clean; the one real shellcheck concern (SC2115 on the `rm -rf` fallback) hardened with `${var:?}` guards.

**Docs:** `designs/openrouter-provider.md` (§ stealth lane — unmask carry-forward, decision 2b) and `context/operations/openrouter.md` (§ When a stealth id is unmasked).

**Out of scope (untouched, as instructed):** no `OPENROUTER_API_KEY`, no worker enabled — both pools stay at zero. Retiring the cloak itself (drop the promo ledger row, add a stable-lane inventory row) is separate and reuses existing tools, noted in both docs.

Committed as `9845c3e973` and pushed to `main2` (rebase-CAS, first attempt).

**Follow-ups:** none required. This completes Child 3, so the parent orchestration `openrouter-zdr-and-stealth-orchestration` should now have all three children landed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/openrouter-reputation-unmask-migration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (6041596 cached reads)
- Output: 45835 tokens
- Cost: $5.587732
- Wall-clock: 651s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
