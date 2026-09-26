Inbox empty. Job complete.

## Completion report — `tune-fable-k3-model-assignments-20260725`

**Audit finding (key correction to the premise).** The job's premise that "designers currently default to Fable" is **stale** — the walk-back already shipped on 2026-07-13 (`downgrade-fable-roles-to-opus`). I audited **every live assignment surface** and confirmed the code policy is already correct:

- `role_default_model` (`common.sh`): gardener designer→`claude-opus-4-8`, builder→`claude-opus-4-8`, every other role empty; cleric designer/builder→`gpt-5.6-terra`; hermit designer/builder→local default; **mystic all-empty**. **No role default on any of the four worker kinds resolves to Fable.**
- `resolve_model_tier`: `fable` still binds `claude-fable-5` (explicit-only); `moonshot` binds only exact `kimi-k3` (short `k3` rejected).
- `claim-job.sh` § 1.3 eligibility: mystic claims **only** explicit `model: kimi-k3` and **refuses designer/builder** — this already *is* a safe, zero-default, explicit-only K3 lane.
- Roles' `AGENT.md`, `CLAUDE.md`, foreman/scaler, model-routing seed: no implicit Fable anywhere.
- Journal schedules: 8 endo press campaigns carry **explicit** `model: fable` frontmatter — honored under policy (explicit ≠ implicit); left untouched.

**Before → after assignment map:** unchanged (already compliant). designer=Opus, builder=Opus, every other gardener role=fleet default, Fable=explicit-only pin, K3=zero-default mystic-only explicit lane. What changed is that these are now **invariants with drift guards**, not passing prose.

**Changes made (main2, commit `5650c6b36b`):**
1. `worker-spine-kinds-test.sh` — new **POLICY INVARIANTS** block: asserts no role default on any kind resolves to the Fable id (loops kinds×roles), designer/builder→Opus, mystic zero-default across roles, and kimi-k3 binds under no non-moonshot provider. Fails loudly if any future edit re-pins a role to Fable.
2. `skills/model-selection/SKILL.md` — stated the **no-implicit-Fable invariant** (Fable explicit-only); documented the previously-undocumented **moonshot/mystic Kimi K3 explicit-only, zero-default trial lane** grounded in `research-harness-kimi-k3`, `scholar-fireworks-kimik3-fable`, and the accepted live canary `kimi-k3-canary-20260725-f` (work_class `gardener:s`); defined trial classes (low-risk/reversible/tool-verifiable gardener/research work — never design/build/merge); marked the fable tier explicit-only; added a 2026-07-25 field note.
3. `gardener-worktree-test.sh` — fixed a **pre-existing** staging gap (didn't copy `quota-panel.sh`, which `common.sh` now sources), so the designer→Opus / fable-override assertions actually run.

**K3 trial classes selected:** `gardener:s` and researcher/scholar-style read-and-report and file-scoped chore classes — explicit-opt-in only, structurally barred from design/build by the existing eligibility gate.

**Tests:** worker-spine-kinds 109/109, gardener-worktree 33/33, model-routing 29/29, mystic-kimi-harness 29/29 (200 total, all pass). Doc links verified; no new shellcheck warnings.

**No routing/eligibility code changed** — the machinery already expressed the policy; the risk-appropriate action was to lock it with tests + docs rather than re-engineer a correct engine.

**Deployment readiness:** pure policy/docs/tests, no code path altered. No hosted worker pool enabled or scaled; no live credentials consumed. Ships on the next deliberate deploy.

**Follow-ups (optional, maintainer's call):** the 8 endo press schedules still explicitly pin `model: fable`; if the intent is to move those campaigns off Fable too, that's a separate per-instance `set-schedule.sh` edit (journal state, not this policy change).
