Inbox empty. Work complete.

## Completion report

**Job:** Teach the gardener handler to honor a per-job `model:` selection so a job can request a specific model (e.g. the README tutorial on Fable).

**What I did:**

1. **`scripts/jobs/handlers/gardener-claude.sh`** — Added an optional per-job model-selection block just before the `claude -p` invocation. It reads a `model:` scalar from the claimed job's leading YAML frontmatter (via the existing `plan_field` helper in `common.sh`), maps short tier names to concrete model ids, and threads the result through as `claude -p --model <id>`:
   - `fable` → `claude-fable-5`
   - `opus` → `claude-opus-4-8`
   - `sonnet` → `claude-sonnet-4-6`
   - `haiku` → `claude-haiku-4-5-20251001`
   - a concrete `claude-*` id → passed through verbatim
   - The invocation now expands `"${model_args[@]}"` (empty when no field).

2. **Robustness:** absent field → no `--model`, behavior **unchanged** (fleet default). A blank/unknown value → falls back to the default (no `--model`) and logs; a typo can never crash the tick.

3. **Relation to `skills/model-selection`:** the block uses the same canonical short-name vocabulary as that skill (which governs the `model` param on `Agent` dispatches); documented in the code comment. Note: the skill lives on the v1 `main` branch, not `main2`, but the vocabulary is the shared source of truth.

4. **`scripts/jobs/test/gardener-worktree-test.sh`** — Extended the fake `claude` to record `--model`, and added three assertions: `model: fable` → `--model claude-fable-5`; no field → no `--model`; unknown value → fallback with no `--model`.

**Verification:** full test run is **22 passed, 0 failed** (16 pre-existing + 6 new). `bash -n` clean; shellcheck shows only the pre-existing SC1091 source-follow info.

**Landed:** committed and pushed to `origin/main2` as `a1f357ea4` (clean CAS push, first attempt).

**Follow-ups:** none required. If/when the `model-selection` skill migrates to `main2`, its table could note the per-job override path, but that's out of scope here.
