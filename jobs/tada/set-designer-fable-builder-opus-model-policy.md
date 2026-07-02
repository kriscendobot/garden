Inbox empty, everything pushed. The work is complete.

## Completion report

**Directive** (kriskowal, 2026-07-02): switch the `designer` role to Fable; keep `builder` on the latest Opus — enforced *by default* wherever a designer/builder is dispatched, on both paths, with an explicit `model:` still overriding.

### What I found
- Models were resolved *per-job only* — `gardener-claude.sh` mapped a job's leading `model:` frontmatter to a concrete id, with no role-aware default and no central map.
- `skills/model-selection/SKILL.md` was referenced by `CLAUDE.md` but **did not exist on `main2`** (it lived on the retired v1 `main` branch and was never migrated) — a dangling pointer.
- Jobs carry no machine-readable performing-role field; the foreman only free-texts the role in the body.

### What I changed (all on `main2`, pushed as `85306b453`)
1. **Canonical map — executable source of truth** (`scripts/jobs/common.sh`): `resolve_model_tier` (`:1729`, tier/id→concrete id, factored out of the handler's inline case) and `role_default_model` (`:1748`, `designer`→`claude-fable-5`, `builder`→`claude-opus-4-8`, every other role empty→fleet default). Added `plan_role` (`:1713`) to read a job's `role:` field.
2. **Scripted-fleet path** (`gardener-claude.sh:227-243`): explicit `model:` wins (via `resolve_model_tier`); absent that, `role:` selects the per-role default (via `role_default_model`); absent both, no `--model` (unchanged). An explicit `model:` present but invalid still falls back to fleet default, never the role default.
3. **Producers stamp the role**: `post-plan.sh --role` (`:106`, emits `role:` frontmatter), `post-job.sh --role` (`:72`/`:117-127`, injects `role:` into the body's leading frontmatter, never clobbering an explicit one), and the foreman — an optional `ROLE <role>` block line (`foreman.sh:179`) parsed and threaded to `post-job.sh --role` (`:196`), with the prompt emitting it (`foreman-claude.sh`).
4. **Agent-dispatch path**: restored `skills/model-selection/SKILL.md`, rewritten for the v2 two-path reality — the standing pin plus a procedure for each path, pointing at the `common.sh` functions so prose and code can't drift. Updated `CLAUDE.md` dispatch contract (`:43`) to describe the real mechanism (no dangling pointer).

### Worked examples (verified by test + unit run)
- **Designer job**, `role: designer`, no `model:` → handler logs `role 'designer' -> default model claude --model claude-fable-5`.
- **Builder job**, `role: builder`, no `model:` → `--model claude-opus-4-8`.
- **Override**, `role: designer` + `model: opus` → `--model claude-opus-4-8` (explicit wins).
- **Unpinned** `role: fixer` → no `--model` (fleet default).
- **Agent path**: dispatch a `designer` with `model: fable`, a `builder` with `model: opus`.

### Verification
- `gardener-worktree-test.sh`: **30/30 pass** (added 4 role cases). `producer-arg-guard-test.sh`: 13/13. `bash -n` clean on all six edited scripts; `common.sh` functions and `post-job` injection logic exercised directly. Note: I did **not** run the heavier `run-test.sh` (it targets `/home/kris/.garden-test` and can splice under the live fleet).

### Follow-ups (not in scope)
- Other scripted producers (triager, mentor, proxy, any future design-queue poller) don't yet pass `--role`; their designer/builder jobs will ride the fleet default until they stamp `role:` or `model:`. Wiring them is a natural next step.
- `CLAUDE.md`'s inventory still lists `skills/design-poller/SKILL.md`, which is also absent on `main2` — a separate dangling pointer left untouched.
- `resolve_model_tier` keeps the pre-existing `sonnet`→`claude-sonnet-4-6` / `haiku`→`claude-haiku-4-5-20251001` bindings unchanged (out of scope; only designer/builder were pinned).

The completion report (this) is the job's `tada` record; the substantive change is the single pushed commit on `main2`.
