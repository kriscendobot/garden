Clean tree, pushed to `origin/main2`. Job complete.

## Completion report

**Job:** `model-routing-journal-state-hermit-qwen` — make worker model-routing data-driven from journal state; route hermits (`local` provider) to **qwen**, not gpt-oss.

**Landed on main2:** commit `374deede654d033a528b5e5460f40a0a49a3cb5b` (direct push, no PR, per garden convention).

### What changed
- **New tracked seed / fail-safe table** `scripts/jobs/model-routing-defaults.tsv` — `<provider>\t<patterns>\t<fleet-default>`, one row per provider. Seeded to current reality: `local → qwen*` default `qwen3.6`; `openai → gpt-* o[0-9]* codex-* !gpt-oss*` default `gpt-5.6-terra`; `anthropic → claude-*`. The `gpt-oss:*` → local mapping is **retired** (a gpt-oss job now matches no provider → unpinned, no longer auto-local).
- **`scripts/jobs/common.sh`** — added `_model_routing_table` (reads a per-instance journal `config/model-routing` override from an already-synced clone, else the tracked seed, else an inline built-in + throttled warn — **no new clone/fetch**), `_model_classify <provider> <id>` (deterministic backend-fit predicate with `!`-exclude globs), `model_routing_default <provider>`. `resolve_model_tier` still **binds** short tier aliases in code (a version bump stays one edit); only concrete-id **classification** and **fleet defaults** are now data. `role_default_model hermit` rides the local table default.
- **`reputation.sh` (`rep_resolve_arm`)** and **`handlers/cleric-codex.sh`** — fleet-default fallbacks read `model_routing_default` with a sane built-in on an unreadable table.
- **`claim-job.sh`** — `job_eligible_for_kind` comments updated; classification now flows through the table.
- **New edit helper `scripts/jobs/set-model-routing.sh`** — `<provider> <patterns> [default]` upsert / `--remove` / `--show` / `--validate`; seeds a fresh journal file from the tracked default so the table is never partial; validates before every CAS push (invalid table can't be committed). Journal DATA edits need **no deploy**.

### Fail-safe
A missing/unreadable table falls back to the seeded qwen reality and warns — it never opens the claim path to mis-routing (verified by test).

### Tests run (green)
- `model-routing-test.sh` — **24/24** (qwen→local-only, claude→anthropic, gpt-*→openai, gpt-oss unpinned; defaults; journal-override precedence; built-in fail-safe; set-model-routing upsert/remove/validate CAS).
- `worker-spine-kinds-test.sh` — routing + eligibility sections green (updated to qwen). **Note:** 2 pre-existing FAILs in that file (`worker_kind not stamped in claim history`, cleric/hermit) reproduce on `origin/main2` **without** my change — not introduced here.
- `auction-reputation-test.sh` — **33/33**.

### Journal routing state written
**None to the live journal, deliberately.** The tracked main2 seed already encodes `local→qwen3.6`, so post-deploy `model: qwen3.6` routes hermit-only with no journal write. A pre-deploy write would be inert (old deployed code ignores it) and risky (it seeds from the not-yet-deployed tracked tsv → a partial table). The override mechanism is tested and ready for future changes.

### Handed to the liaison/maintainer (via message-user)
Full acceptance package including: deploy main2 → `set-model-routing.sh --show` sanity → supersede the obsolete `jobs/doin/test-hermit-local-inference-garden2.md` (pinned `gpt-oss:20b`, which now becomes unpinned/404) → **exact qwen replacement job** `test-hermit-local-inference-qwen-garden2` (body pins `model: qwen3.6`, expects provider=local, model=qwen3.6, host, 7×6=42, `HERMIT LOCAL INFERENCE OK`) → require the completed hermit tada as acceptance proof. Also flagged: confirm the exact served Ollama tag via `ollama list`; if it differs from `qwen3.6`, `qwen*` still routes it hermit-only and the default is a one-line journal edit.

### Follow-ups (owner: liaison/operator, not this job)
1. Deploy main2 to the garden root (deliberate drained deploy) — the reading code + seed aren't live until then.
2. Supersede the obsolete gpt-oss liveness job and post the named qwen replacement; require the hermit report.
3. The hermit actually **serving** qwen3.6 (garden2 op) is separate from this routing fix.
