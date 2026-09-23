---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 618
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-07-10T02:25:01Z
last_appended_at: 2026-07-10T02:25:01Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#618

Created from the code-panel verdict (daemon-agent-tools Phase 4 — dynamic capability tool discovery + form provisioning).
The panel's one must-fix (Fae's `registerCapabilityTools` clobbering the built-in `exec`) and the summary-fixes (void-result coercion, load-bearing static-wins/void tests, README exports, changeset, stale comment/PR-body, banner strip) were addressed in the fixer commit `cc084dc61` and the PR was un-drafted.
The items below are deferred deliberately and warrant revisit when the PR merges.

## Items

- [ ] **Discriminate and log non-absence lookup failures in `tryLookup`.**
  **Source seat(s)**: warden, saboteur, assessor, breaker.
  **Round**: 1.
  **Recommended action**: open a follow-up PR on `packages/agent-tools/src/discover.js` narrowing `tryLookup`'s bare `catch {}` so a genuine "not found" is swallowed (the discovery signal) while a transient/broken-capability error is logged (and ideally surfaced) rather than silently degrading authority. Needs the daemon's not-found error discriminator; a blanket log would be noise on the common absent path.

- [ ] **Tighten the default Shell allowlist and soften the docstring.**
  **Source seat(s)**: locksmith, spec-keeper.
  **Round**: 1.
  **Recommended action**: `packages/lal/agent.js` `defaultShellPolicy.allowedCommands` includes arbitrary-code multitools (`node`, `python`, `python3`, `find`, `sed`, `awk`); the docstring overstates the argv allowlist as "the enforceable boundary." Operator-gated and design-Decision-4-sanctioned, so not blocking, but reconsider the default set and reword the docstring to say the allowlist is advice, not a boundary (the host-engine `Shell` exo is the boundary).

- [ ] **Load-bearing tests for the form-provisioning error/guard branches.**
  **Source seat(s)**: saboteur, prover, corner-prober.
  **Round**: 1.
  **Recommended action**: open a follow-up PR adding integration/unit coverage for the unknown-capability rejection, the `projectPath`-required guard, a partial grant (`fs`-only) through the form, and the `has()`-guarded idempotency/re-use path — each currently unexercised (only the all-three happy path is tested).

- [ ] **Narrow the `any` casts in `discover.js` to the declared `ERef<…>` param types.**
  **Source seat(s)**: typist.
  **Round**: 1.
  **Recommended action**: cast the `shell`/`git` lookups to `ERef<ShellToolCapability>` / `ERef<GitToolCapability>` (per `src/types.ts`) rather than `any`, restoring the boundary signature check. The `mount → any` cast is justified and stays.

- [ ] **Update the design's provisioning pet-names to the canonical `fs`/`shell`/`git`.**
  **Source seat(s)**: spec-keeper.
  **Round**: 1.
  **Recommended action**: amend `designs/daemon-agent-tools.md` (a separate design PR on the `llm` branch) so its § Granting and Provisioning example uses `fs`/`shell`/`git` instead of `workspace`/`repoGit`/`repoShell`, matching the implemented well-known discovery names.

- [ ] **Give the shell `exec` tool a distinct name if Fae guests must reach shell-exec.**
  **Source seat(s)**: round-2 adversarial verifier.
  **Round**: 2.
  **Recommended action**: with the static-wins fix, a Fae guest granted a `shell` cap surfaces `inspect` but not the shell `exec` (the name is held by the built-in JavaScript `exec`). Correct per the invariant; if such guests are ever expected to run allowlisted shell commands, expose the shell exec under a distinct name (e.g. `shellExec`).

- [ ] **Document or support re-scope of a monotonic provisioning grant.**
  **Source seat(s)**: locksmith, saboteur.
  **Round**: 1.
  **Recommended action**: re-submitting the same `agentName` with a changed `projectPath` reuses the original `<name>-project-mount` (the `has()` guard), silently ignoring the new path. Never widens authority, but surprising; document the monotonicity or add a re-scope path.

- [ ] **(Optional) Split the yarn.lock churn into its own `chore: Update yarn.lock` commit.**
  **Source seat(s)**: packager.
  **Round**: 1.
  **Recommended action**: acknowledged and not done pre-merge (2-line delta, trivially reviewable, and rewriting a green weaved PR's base history is disproportionate). If the PR is rebased rather than squash-merged, relocate the 2-line lock delta then.
