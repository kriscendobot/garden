Inbox empty. Here is my analysis.

---

# Feature-disposition analysis — workspace capability & sandbox bootstrap (PR #149)

**Job:** read-only feature-disposition analysis, `endojs/endo-but-for-bots` [PR #149](https://github.com/endojs/endo-but-for-bots/pull/149) "[EXPERIMENT] genie in a bottle".

## Freshly observed state (this checkout, just fetched)
- **`origin/llm` HEAD:** `a54c3adbebf18fd837770d467433e480de498e8d`
- **PR #149 head:** `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (branch `jcorbin-exp-genie-bottle`, DRAFT/OPEN, author `jcorbin`)
- **Merge base with `llm`:** none (the two histories have diverged; the PR was cut from an obsolete `llm` base, so commits are not cherry-pickable wholesale).

## Feature under analysis
Idempotent workspace `Mount` provisioning + `@endo/sandbox` plugin registration + main-side sandbox-slice minting. Primary PR evidence corroborated:
- [`2e0d0ec6d`](https://github.com/endojs/endo-but-for-bots/commit/2e0d0ec6d3e6414a609ec6cfecf5f2a7cc73cac9) — *feat(genie): provide workspace mount for sandbox* (jcorbin; touches `packages/genie/setup.js`, adds `TADA/31`).
- [`aefcd01bc`](https://github.com/endojs/endo-but-for-bots/commit/aefcd01bc049406c81ea7a56fdc7274964bc701a) — *feat(genie): add @endo/sandbox plugin power* (jcorbin; touches `packages/genie/setup.js`, adds `TADA/32`).

Both commits corroborated by content: `TADA/31`/`TADA/32` are the completion records for TADA/22 Decision 1 (main-side slice minting), all checkboxes `[x]`.

## Disposition — **(1) ALREADY HONORED**, in a corrected/superseded form

All three sub-capabilities exist in current `origin/llm`, in an implementation that deliberately fixes the PR's provisioning shape. Detail:

**a) Idempotent workspace Mount provisioning — already honored.**
`origin/llm:packages/genie/setup.js` mints `workspace-mount` via `has('workspace-mount')`-guarded `E(hostAgent).provideMount(workspace, 'workspace-mount')` (idempotent, restart-reincarnated). Same guard/idempotency intent as PR-head [setup.js](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/setup.js). Difference: `llm` gates on `GENIE_WORKSPACE` being present (keeps a legacy "workspace = host cwd, no slice" path); the PR fails loud when it is absent.

**b) `@endo/sandbox` plugin registration — already honored.**
`origin/llm:packages/genie/setup.js` registers the factory via `has('sandbox-factory')`-guarded `E(hostAgent).makeUnconfined('@main', sandboxSpecifier, { powersName: '@agent', resultName: 'sandbox-factory' })`, with an inline note that `powersName:'@agent'` is what grants the factory the privileged `provideHostPath`/`provideScratchMount` surface. The PR-head registers the same factory but in worker `@agent` (`makeUnconfined('@agent', …, { powersName:'@agent', resultName: SANDBOX_FACTORY_NAME })`) as part of its embody-`@self` root model.

**c) Main-side slice minting — already honored, in a *corrected, fail-closed, per-agent* form.**
- `origin/llm:packages/genie/main.js` mints **per agent** through `mintGenieSlice({ sandboxFactory, workspaceMount, workspaceDir, … })`, bridging the Mount cap to a host path with `E(hostAgent).provideHostPath(workspaceMount)` (main.js ~L1145), and is **fail-closed**: when a `sandbox-factory` is present but no workspace Mount cap is available it *throws* (`main.js` ~L1268, `"sandbox-factory configured but no workspace Mount cap available…"`) — "explicit confinement, no implicit relaxation," no fall-back to direct spawn.
- The PR-head instead mints a **single best-effort ROOT slice** via `E(factory).makePersistent(SANDBOX_SLICE_NAME, {…})` ([main.js L1595-1660](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/main.js#L1595)) inside a `try/catch` that logs and **"proceed[s] without slice"** on any failure.

### The reported provisioning mistakes — verified, with one correction to the board record
The sandbox-subagents discovery report's disposition ("current `llm` has a corrected, fail-closed implementation; the PR could not mint a slice") is corroborated. The concrete, reproducible root cause:
- **The PR's `makePersistent` path cannot run.** `packages/sandbox/src/factory.js` at the PR head references three helpers — `assembleSliceFromMakeOpts`, `buildSliceHandle`, `nestingProbe` — that are **defined nowhere** in the PR-head `@endo/sandbox` package (grep-confirmed across `packages/sandbox`). `makePersistent` (and the second `make`, factory.js L757-758) reach `assembleSliceFromMakeOpts`, so the main-side mint at PR head throws a **runtime `ReferenceError`**, is swallowed by the best-effort `catch`, and yields "proceeding without slice." That is exactly "its integration tests could not mint a slice."
- **Correction to the deployment-prompts discovery report (F0):** that report claimed `factory.js` fails with a **parse-time** `SyntaxError: Identifier 'make' has already been declared` (duplicate `const make` at L442/L757). I could **not** reproduce that: `node --check` on the PR-head `factory.js` blob **parses cleanly** (the two `const make` sit at different lexical/brace depths, so there is no redeclaration). The failure is a **runtime `ReferenceError` from the undefined helpers**, not a parse `SyntaxError`. `origin/llm`'s `factory.js` also parses cleanly and has **no `makePersistent`/`listPersistent`/`forgetPersistent`** at all — slice creation there goes through the fully-defined `factory.make(...)`.
- **`provideHostPath`:** the PR's genie `main.js` passes the raw Mount cap straight into `makePersistent` (`{ cap: workspaceMount, innerPath:'/workspace', … }`) and never calls `provideHostPath`; `origin/llm` bridges via `provideHostPath` before minting. Corroborated by code reading; I could **not** run the daemon integration tests to observe the failure live (isolated dependency provisioning is not runnable here — the discovery agents hit the same wall).
- **Security posture:** the PR embodies the root as `@self`/`@agent` (no guest attenuation — the F3↔TODO-61 tension); `origin/llm` keeps the guest-attenuated `setup-genie` provisioning path. `llm` chose the safer shape.

## Associated TODO/TADA/PLAN history — recommendation: **leave behind, no migration**
- `PLAN/endo_posix_sandbox.md` — **already present on `origin/llm`**; the durable plan for this arc is carried.
- `TADA/31_endo_genie_sandbox_workspace_mount.md`, `TADA/32_endo_genie_sandbox_factory_register.md` — **absent from `llm`**; they are the experiment branch's completion records for a genie-embodiment provisioning shape that `llm` superseded. Their substance (idempotent `provideMount` + `has`-guarded factory registration) is already honored by `llm`'s `setup.js`, so nothing durable is lost by leaving them on the experiment branch. `PLAN/genie_in_bottle.md` is likewise experiment-only and not needed by `llm`.
- The one lesson worth preserving — **best-effort root-slice mint (silent "proceed without slice") vs. fail-closed per-agent mint** — is already captured in the three discovery reports now sitting in `jobs/tada/` on `journal2`; no additional garden-journal migration is required for this feature.

## Net
The material feature is **already honored** at `origin/llm@a54c3ad` in a corrected implementation; the PR-head variant (embodied-`@self` root, single best-effort `makePersistent` root slice atop three undefined factory helpers) is **not** to be ported. No project files, branches, or GitHub state were modified; this was pure read-only inspection.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-workspace-bootstrap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 31 tokens (1198080 cached reads)
- Output: 20425 tokens
- Cost: $1.9574710000000002
- Wall-clock: 302s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
