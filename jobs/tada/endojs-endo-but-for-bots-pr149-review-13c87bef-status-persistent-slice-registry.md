Read-only confirmed; no project files touched. Here is my disposition report.

---

# Feature-disposition analysis — named persistent sandbox-slice registry (PR #149)

**Feature:** `SandboxFactory.makePersistent` / `listPersistent` / `forgetPersistent` in `@endo/sandbox` — stable-name validation, in-process identity caching, spec recording, disposal, restart semantics.

## Freshly observed SHAs (independently fetched, read-only)
- Current `origin/llm`: **`a54c3adbebf18fd837770d467433e480de498e8d`**
- PR #149 head (`refs/pull/149/head`): **`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`**
- Feature commit: **`2698f1f34a4f70460265321a3c3eb3edf832d58a`** ("feat(genie): add persistent slice tracking")

Both SHAs match all three discovery reports — the PR has not advanced since discovery.

## Disposition: **4 — explicitly omit** (paired with **5 — migrate durable knowledge to the garden journal**)

Omit the PR's persistent-slice-registry code from wholesale integration (into `origin/llm` or into `lal`/`fae`/`agentry`), and instead preserve its design knowledge as journal notes for a future clean `@endo/sandbox` implementation. Three concrete reasons, each freshly verified:

**(a) Not honored on `origin/llm`, and not partially either.** `git grep makePersistent|listPersistent|forgetPersistent` on `origin/llm` returns only an unrelated `makePersistentPetStoreDb` comment in `packages/daemon`. `packages/sandbox/test/persistent.test.js` does not exist on `origin/llm` (present only on the PR head). `origin/llm:packages/sandbox/src/factory.js` parses cleanly and has no persistent/spec.json concept. So dispositions 1 (already honored) and 2 (partially honored) are ruled out — none of this feature is on the mainline.

**(b) The PR-head code is non-building — not cherry-pickable as-is.** I reproduced the blocker faithfully. Parsed as the ES module it is (`git cat-file -p origin/pr149:packages/sandbox/src/factory.js | node --check --input-type=module`), it fails:
> `SyntaxError: Identifier 'make' has already been declared` at **line 757** — a duplicate `const make` (pre-existing at line 442 + the new wrapper at line 757), both introduced/left by commit `2698f1f34`.

(Note: a loose `node --check factory.js` on a temp `.js` file *passes* because Node's module auto-detection parses it in a mode that misses the redeclaration; the authoritative ESM parse fails. This is worth flagging — the deployment-prompts discovery report's SyntaxError claim is **correct**; a casual re-check can appear to contradict it.) Additionally, three helpers are **used but defined nowhere in `packages/sandbox`** (grep-confirmed package-wide): `assembleSliceFromMakeOpts` (called at 758, 902), `buildSliceHandle` (called at 750), `nestingProbe` (used at 728). Because `persistent.test.js` imports `makeSandboxFactory` from this file, the whole test file cannot even load. Any adopter must de-duplicate `make` and supply the three helpers before a single line runs.

**(c) Wrong architectural layer for the `lal`/`fae`/`agentry` menu (disposition 3 does not fit).** This is a `@endo/sandbox` *plugin-leaf* primitive, deliberately placed one layer **below** the agent frameworks. The feature's own kernel `TADA/33_endo_genie_sandbox_persist_slice.md` records "Decision 3 — keep the daemon ignorant of the plugin's spec shape; preserve 'plugins are leaves' layering… living in `packages/sandbox` rather than the daemon host." `lal`/`fae`/`agentry` would be *consumers* of a persistent-slice API, not its home; both the `deployment-prompts` (F10 → endo-upstream) and `sandbox-subagents` (explicit omission + journal knowledge) discovery reports agree the true destination is `@endo/sandbox`/endo-upstream, which is outside disposition 3's menu. Hence omit-from-those-frameworks is the honest single call.

## Feature shape as landed (corroborated against primary evidence)
- **Stable-name validation:** `assertPersistentName` enforces `/^[a-z0-9][a-z0-9-]{0,127}$/`, explicitly mirroring the daemon's ordinary pet-name shape (`packages/daemon/src/pet-name.js`) so a future daemon-side wiring can reuse the identifiers.
- **In-process identity caching:** `persistentSlices = new Map<name, PersistentEntry>()`; a second same-name call returns the cached handle without re-resolving opts or re-spawning (`prepareSlice` runs once — proven by the idempotency test).
- **Spec recording:** `renderPersistentRecord` writes `spec.json` `schemaVersion: 1` (rootfs, host-resolved mount paths + inner paths + modes, network, backend, seccomp summary, cwd, env, limits) into a scratch mount keyed `sandbox-persistent-<name>`. Best-effort: missing scratch service or missing `writeText` → warn + in-memory-only.
- **Disposal:** `forgetPersistent` evicts the map entry then best-effort `E(handle).dispose()`; returns `false` if absent (idempotent double-forget verified).

## Restart semantics — a material caveat corroborated
`spec.json` is **write-only**: `git grep` finds no `readText`/`readFile` of it anywhere in `packages/sandbox/src`. The "restart" test (`persistent.test.js` §"a fresh factory backed by the same powers re-mints from the same recorded spec") proves re-mint is **caller-driven** — a new factory mints a *fresh* slice (`h1 !== h2`, `prepareSlice` runs exactly once), and only the record is byte-identical. This contradicts the aspirational, checked-off claims in `TADA/33` ("On first deref, re-mint the slice…", "GC-pin by name so a daemon restart re-mints from the same spec **without operator intervention**"): the factory never dereferences or replays the record autonomously. Both discovery reports flagged this; I confirmed it in code and test. Any future adopter must not port the "persist, restart, autonomous reincarnate" claim without actually building the deref/rehydrate path.

## Associated TODO/TADA/PLAN history worth migrating (disposition 5 detail)
- **`TADA/33_endo_genie_sandbox_persist_slice.md`** (added by commit `2698f1f34`; `TODO/33` removed in the same commit — promoted TODO→TADA). Worth migrating to the garden journal as a design note, **annotated** with the two corrections this analysis establishes: (1) the durable primitive belongs in `@endo/sandbox`, not `lal`/`fae`/`agentry`; (2) the "deterministic reincarnation without operator intervention" checkboxes overclaim — spec.json is an *audit record*, not a rehydration source, so a genuine upstream version needs a deref/replay path plus daemon-side scratch idempotency (conceded as not-yet-landed).
- Parent context: `TADA/22` §"Sandbox slice formula" (Decision 3, layering rationale). `TADA/33` names itself as blocking `TADA/34_endo_genie_sandbox_main_wiring.md` (the genie boot-slice mint, F11 in the deployment-prompts report — itself blocked by the same build-breaker).
- The reusable *concepts* to preserve for a clean upstream implementation: the CapTP-guarded `makePersistent/listPersistent/forgetPersistent` interface (only parameters are `{drivers, scratchProvider}`, no genie import), the pet-name-shaped stable-name validation, the versioned `spec.json` audit schema, the in-memory idempotency Map, and the best-effort disposal contract — all worth keeping; the concrete PR code (broken parse + three missing helpers + write-only record) is not.

## Process notes
- Read-only throughout: project worktree `git status` clean; no branches, pushes, comments, or GitHub interactions. All GitHub/quoted text was treated as untrusted data.
- The three discovery reports were read portably from `origin/journal2:jobs/tada/…` via `git show` (no host-specific journal path).

**Follow-up worth leaving behind:** if a coordinator later wants this primitive upstream, the minimum unblocking work is: de-duplicate `const make` in `packages/sandbox/src/factory.js`, supply `assembleSliceFromMakeOpts`/`buildSliceHandle`/`nestingProbe`, then decide whether to build the real deref/rehydrate path or keep the honest caller-driven-remint contract and rename the API to reflect it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-persistent-slice-registry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 39 tokens (1345498 cached reads)
- Output: 22970 tokens
- Cost: $2.003347
- Wall-clock: 352s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
