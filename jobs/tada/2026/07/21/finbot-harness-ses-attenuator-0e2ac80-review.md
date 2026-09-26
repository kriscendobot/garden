Review complete. No source changes pushed (review job; defect flagged to maintainer per the job's directive, as opening an unrequested fix on a merged security path was the higher-risk option).

## Completion report — security review of finbot harness SES compartment attenuator (kriscendobot/finbot @ 0e2ac80)

**Scope reviewed:** `packages/harness/sandbox/permissive.js`, `spawn.js`, `index.js`, `schemas/spawn.js`, `test/spawn.test.js`; plus how the change is consumed (`packages/pipeline/role-dispatch.js`). Deps installed, all 9 harness spawn tests pass, and I wrote two runnable PoCs to confirm findings.

### Verdict: the security posture advertised by the commits is NOT actually in force (misrepresentation defect). No exploitable live-funds escape today.

**Finding 1 (headline) — per-role globals policy is constructed then discarded; no Compartment exists.** `compartmentAttenuator` builds a role globals policy via `buildRolePolicy`, but `spawn.js`/`runLoop` consumes only `attenuated.tools` — `attenuated.globals` is never used, and the subagent `llm` and tool `run` functions execute in the **host realm**. There is no `new Compartment(...)` anywhere. PoC: role `monitor` (ambient = `console` only, `fetch` explicitly excluded; built globals keys `['console']`) still reached `process.pid`, `process.cwd()`, `fs.readdirSync`, `process.env.HOME`, and `fetch`. The commits' claim of "real SES compartment attenuator" / "actual SES enforcement" replacing "prompt-level isolation" overstates reality: the only enforcement delivered is (1) process-wide `lockdown()` and (2) tool-name filtering. The code's own docstrings are honest that the compartment *runner* is future work, so the defect is chiefly in the commit/change framing.

**Finding 2 — tool filtering is fail-open.** With `capabilities` null/empty, `compartmentAttenuator` (and `permissiveAttenuator`) vends **all** parent tools. The pipeline always passes explicit `capabilities` (EXECUTOR_TOOL_NAMES etc.), so it's covered in practice, but the harness default is unsafe.

**Finding 3 — declared `vended` slice never enforced.** `CAPABILITY_MAP[role].vended` is dead: `compartmentAttenuator` filters by the caller's `capabilities` argument, never intersecting with `entry.vended`. The docstring's "tools are the vended capability slice" is false; nothing prevents a caller from requesting a capability outside the role's declared vended set. Within a granted subset, tool-name denial does work correctly (test 9 confirms an unauthorized tool is blocked).

**Finding 4 — default flip adds a synchronous hard-throw.** `compartmentAttenuator` throws `unknown role for attenuation` for any role not in `CAPABILITY_MAP`, thrown synchronously out of `spawn()` (not captured into the handle), whereas `permissiveAttenuator` accepted any role. No in-repo breakage — analyzer/planner/auditor/executor and the tests are all mapped, 9/9 pass — but any off-map role now hard-throws where it previously returned a handle. PoC confirmed.

**Finding 5 (hardening note) — `lockdown({ errorTaming: 'unsafe' })`** weakens error taming process-wide; worth revisiting once a real compartment boundary exists.

**Confirmed sound:** SES dependency version is correct and current — declared `ses@^2.2.0`, npm `latest` is `2.2.0`, installs and locks down cleanly. No live-funds exposure today (executor is dry-run, `walletTouched` always false; subagents are stubs).

**Actions taken:** Flagged all findings to the maintainer via the message bus (delivered `20260721T153121Z-575b4d`) with reproduction details and a recommendation: (a) correct the commit/docstring claims to "policy shape, not enforcement"; (b) wire an actual Compartment runner that consumes `globals` before any live executor; (c) make tool vending fail-closed and intersect with the role's `vended`. Offered to open a fix PR for (a)+(c) on request. Did not merge over or modify project source.

**Follow-ups:** await maintainer decision on the fix PR; the live-executor milestone must not ship until Finding 1 is closed with a real compartment boundary.
