I now have a complete, corroborated picture. This is a read-only analysis job — I made no modifications to any project files, branches, or GitHub. Writing the completion report.

---

# Feature-disposition analysis — subagent lifecycle & command plan (PR #149 TODO/53–61)

## Freshly observed SHAs (isolated read-only checkout)
- **`origin/llm`**: `a54c3adbebf18fd837770d467433e480de498e8d`
- **PR #149 head** (`jcorbin-exp-genie-bottle`, DRAFT/OPEN): `e0c8accb3235a340ce2b4e4307138429a7d1e5f3`
- **Merge base**: `33311ae9a41d0b12ba6f0367717352b67d9032bc`

These match all three discovery reports. I corroborated the reports by `git show`-ing them from `origin/journal2` (the `discover-genie-core`, `discover-sandbox-subagents`, and `discover-deployment-prompts` tada artifacts). All GitHub/kernel text was treated as untrusted data.

## Material feature
The subagent lifecycle-and-command plan: worker boot, directory tracking, ordered removal, listing, `/spawn`/`/agents`/`/remove-agent` specials, disposal cascade, acceptance tests, documentation, and guest-root mode — [TODO/53–61](https://github.com/endojs/endo-but-for-bots/tree/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO) on the PR head. This is the `F18` cluster in `discover-deployment-prompts` and the `subagent-slice-provisioning` / `subagent-explicit-introductions` scaffolding in `discover-sandbox-subagents`. On the PR, these are **open prompt kernels + non-building scaffolding**, not delivered behavior.

## Disposition: **(2) PARTIALLY HONORED** — the lifecycle core is already implemented on `origin/llm` by a superior route; a single command/verification slice remains.

The pivotal fresh observation: **`origin/llm` carries *more* of this plan than the PR head does** (58 lifecycle-symbol hits on `llm` vs 25 on the PR). The plan the PR frames as unbuilt scaffolding has largely landed on `llm` — via the config-form `spawnAgent` seam, not the PR's broken fork-slice path.

### Already honored on `origin/llm` (commit `a54c3adbe`, file evidence)
- **TODO/53 worker boot** — `spawnAgent` is defined *and wired*, invoked at [`packages/genie/main.js:1610`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js#L1610) off a received configuration-form message; boots the child via `E(hostAgent).provideGuest(agentName, …)` (`main.js:1073`). (On the PR, `spawnAgent` is unwired scaffolding — never called on boot.)
- **TODO/54 directory tracking** — `DEFAULT_AGENT_DIRECTORY = 'genie'` (`main.js:98`), `config.agentDirectory` threaded through spawn/remove/list, child locator recorded into the directory.
- **TODO/55 ordered removal** — `removeChildAgent` removes the directory edge *then* the child: `E(parentPowers).remove(agentDirName, childName)` → `E(hostAgent).remove(childName)` (`main.js:1410–1422`).
- **TODO/56 listing** — `listChildAgents` (`main.js:1431`).
- **TODO/60 documentation** — `spawnAgent`/factory/workspace-form-field surface is fully documented in `packages/genie/AGENTS.md`, `DESIGN.md`, and `README.md` on `llm`.
- **TODO/61 guest-root mode** — moot-and-safe on `llm`. TODO/61 wants to *restore* the guest-attenuated root that PR commit `84bfd2303` ("RIP provideGuest") removed. **`llm` never took that commit**: its root still boots through `provideGuest('setup-genie', …)` ([`setup.js:95`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/setup.js#L95)). The very security posture TODO/61 was written to recover is `llm`'s status quo; the PR's embody-`@self` regression it guards against does not exist on `llm`.

### The exact remaining gap (not honored on **either** branch)
- **TODO/57 operator command specials** `/spawn`, `/agents`, `/remove-agent` — absent from both. `llm` provisions/removes agents only along the *configuration-form* path; there are no `spawn`/`agents`/`remove-agent` handlers in `src/loop/builtin-specials.js` or the `main.js:733` specials dispatcher on `llm`, and none on the PR head either. The kernel ([TODO/57](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/57_endo_genie_subagent_specials.md)) itself gates this on a `spawnSubAgent` helper extracted from the "dormant `spawnAgent`" and on `fork()`'s structured errors.
- **TODO/58 + TODO/59 dispose-cascade acceptance matrix** — `llm`'s `removeChildAgent` removes pet names (GC-triggering), and spawn has a "probe/select/mint/dispose/spawner-wrap" sequence (`main.js:1254`), but the formal parent-`dispose()`→child cascade suite (`packages/sandbox/test/fork.test.js` "GC ordering", per [TODO/58](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO/58_endo_genie_subagent_dispose_cascade.md)) is not present. `llm` has `test/loop/agents.test.js`, `test/tools/spawner.test.js`, `test/tools/sandbox-spawner.test.js`, but not this cascade matrix.

Both remaining items are gated on the **sandbox Phase-3 `fork()`** primitive, which the `discover-deployment-prompts` report independently confirms does not build at the PR tip (its `F0` verified build-breaker: duplicate `const make` and three undefined helpers in `packages/sandbox/src/factory.js`; `fork()` still throws "not implemented before Phase 3").

### Destination for the gap
Stays in **genie** (the specials dispatcher is genie's operator surface), gated on **sandbox** Phase-3 `fork()`. Not `lal`/`fae`/`agentry`: the reusable primitives inside PR #149 (persistent sandbox slice, atomic config store, `walkDirectory`, provider catalog, `/model`) are separately dispositioned by the sibling discovery reports; *this* feature — operator lifecycle commands over child agents — is genie-experiment-specific.

### On the PR's scaffolding **code** (explicit omission)
The PR-side child-agent code (`subagent-slice-provisioning`, `subagent-explicit-introductions`; `F13`) should be **explicitly omitted**, not lifted: it is non-building (`F0`), calls `fork()` which throws, is parent-blind (persisted children re-mint as top-level slices), and is unwired — and it is *behind* `llm`'s already-landed config-form route. Cherry-picking it would regress `llm`.

## TODO/TADA/PLAN history worth migrating
The nine kernels [TODO/53–61](https://github.com/endojs/endo-but-for-bots/tree/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TODO) are the **only** surviving written record of the *residual* operator-command + dispose-cascade work: I confirmed `origin/llm`'s `TODO/` directory contains only `.keep` (none of 53–61, and none of the PR's 44 TODO/TADA kernels, are on `llm`). Recommended follow-up (not performed here — read-only mandate): **migrate the two genuinely-open items, TODO/57 and TODO/58, into the garden journal** as the tracked "genie subagent operator commands, gated on sandbox Phase-3 `fork()`" follow-up. TODO/53–56 and TODO/60 are satisfied by `llm` and need not be carried. TODO/61 can be recorded as a resolved/moot security note (guest-attenuated root is `llm`'s default). The `TADA/` kernels correspond to already-landed code and warrant nothing beyond an archival note.

## Read-only compliance
No project files, branches, commits, pushes, PR/issue edits, or GitHub posts were made. Work was done in an isolated per-job project checkout; the `yarn install --immutable` warm-cache miss is irrelevant to this inspection-only analysis (no build or test was required or run — conclusions rest on commit/source/branch comparison via `git show`/`git grep`). No `origin/main2` change was needed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-subagent-lifecycle-plan.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (858133 cached reads)
- Output: 14465 tokens
- Cost: $1.5123364999999995
- Wall-clock: 212s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
