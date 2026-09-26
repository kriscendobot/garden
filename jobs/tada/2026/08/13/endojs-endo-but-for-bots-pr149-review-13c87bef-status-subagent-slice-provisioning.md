I have everything needed. All three discovery reports corroborated, both SHAs freshly confirmed, and the feature's actual code inspected on both branches. Writing the report.

---

# Feature-disposition analysis — `subagent-slice-provisioning`

**Job:** read-only disposition of the subagent slice-provisioning scaffolding from https://github.com/endojs/endo-but-for-bots/pull/149.

## Freshly observed state
- **origin/llm SHA:** `a54c3adbebf18fd837770d467433e480de498e8d` (freshly fetched)
- **PR-head SHA:** `e0c8accb3235a340ce2b4e4307138429a7d1e5f3` (`refs/pull/149/head`, branch `jcorbin-exp-genie-bottle`, DRAFT)
- Histories have no merge base; compared feature-by-feature, not by diff.

## Corroboration of the three board reports
Read portably via `git show origin/journal2:jobs/tada/…` (all GitHub-quoted text treated as untrusted). All three agree and I independently reproduced their load-bearing facts:
- `discover-sandbox-subagents` lists `subagent-slice-provisioning` as unfinished scaffolding (fork stub, no live caller, lost parent linkage) → **confirmed**.
- `discover-deployment-prompts` F13 says the same and marks `spawnAgent`/`removeChildAgent`/`listChildAgents` defined-but-not-invoked → **confirmed**.
- `discover-genie-core` notes "child-agent spawning remains scaffolding" → **confirmed**.
- **One discrepancy, reported for honesty:** the deployment-prompts report's *build-breaker* diagnosis for `packages/sandbox/src/factory.js` — "SyntaxError: Identifier 'make' has already been declared" — **does not reproduce**. `node --check` on the PR-head file returns rc=0 (node v22.23.1); the two `const make` (L442, L757) live in separate closures. The file *is* nonetheless non-functional at runtime: three helpers it calls — `assembleSliceFromMakeOpts` (L758,902), `buildSliceHandle` (L750), `nestingProbe` (L728,746) — are **referenced but never defined** (dangling → ReferenceError). So the report's *conclusion* (the new persistent-slice path does not work) holds; only its *SyntaxError* mechanism is inaccurate. This factory cluster is adjacent to — not part of — the feature under review.

## The feature, as freshly inspected
`spawnAgent` (PR-head `packages/genie/main.js` L1198-1335) computes the stable child name `subAgentSliceName(agentName) = "<agentName>-sandbox"` (`packages/genie/src/pet-names.js`), then `await E(parentSliceHandle).fork(childSpec)`, then in parallel records the spec via `E(sandboxFactory).makePersistent(sliceName, childSpec)`, and on persistence failure disposes the forked sub-slice before re-throwing. Evidence corroborated: commit https://github.com/endojs/endo-but-for-bots/commit/aa1eda6d048ef24db367fce88cf92c7bc9e8273d and https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/main.js#L1198-L1335.

Three decisive facts, each freshly verified:
1. **`fork()` is an unconditional throw on BOTH branches.** `forkSlice` = `throw makeError(X\`fork not implemented before Phase 3\`)` at PR head (https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/sandbox/src/factory.js#L633-L635) and identically on origin/llm (factory.js L593-594). The whole mechanism rests on a stub that exists nowhere yet.
2. **No live caller.** PR-head main.js states `spawnAgent` "is no longer invoked on boot" (L1466) and is merely `harden()`-ed; `grep 'spawnAgent('` over PR-head main.js finds **zero** call sites. It is hardened-but-dead scaffolding.
3. **Lost parent linkage by design.** `makePersistent` is parent-blind; `spawnAgent`'s own comment concedes that on restart the recorded spec "will be re-minted as a top-level slice, and the parent linkage … will need to be re-established," pending a filed follow-up (TADA/23 § Follow-ups). The dispose-on-failure branch only ever runs if `fork()` succeeds, which it never does.

**Not already/partially honored on llm.** origin/llm carries a *different, working sibling*: its `spawnAgent` mints a **flat per-agent** slice via `E(sandboxFactory).make({...})` (single-level, non-nested) and **is** boot-invoked (llm main.js L1610). `subAgentSliceName`, `pet-names.js`, and the fork/`makePersistent` nesting path do **not** exist on llm. So the PR feature is a distinct, nested fork-based mechanism, not an increment of what llm already ships.

## Disposition — **(4) Explicitly omit** (in its current form)

The fork-based nested sub-slice provisioning is inert scaffolding for an unbuilt substrate: `fork()` is an unconditional throw on both PR head and origin/llm, the helper has no live caller, and the persisted spec loses parent linkage across restart. It cannot be lifted as delivered behavior, and origin/llm already honors the confinement genie actually needs via its `.make()`-based per-agent `spawnAgent`. This is genie-experiment scaffolding gated on sandbox "Phase 3" nesting that does not exist. **Contingent forward note (not a present integration recommendation):** once a real attenuating `fork()` lands in `@endo/sandbox`, the nested-provisioning *pattern* — stable `<name>-sandbox` keyspace, fork-then-persist, dispose-on-failure, pet-store bridge for `provideGuest` introductions — would be worth reconsidering for **agentry** (reusable authority/provisioning primitive) and **fae** (named-agent lifecycle/teardown). It is explicitly omitted *now* because its dependency is absent in both branches.

## Associated history worth leaving behind (report-only; folds in option 5 as a secondary recommendation for the coordinator, not performed here)
All PR-head-only (confirmed absent on origin/llm), capturing the durable design intent behind this feature — candidates to **migrate into the garden journal** as design knowledge rather than code:
- `TADA/23_endo_posix_sandbox_phase3_5b_genie_subagent.md` — the load-bearing decisions: flat `<agentName>-sandbox` keyspace (Decision 2), main-side mint because `MakeCapletOptionsShape` has no `introducedNames` channel (Decision 3), and the parent-blind-`makePersistent` follow-up.
- `TADA/33_endo_genie_sandbox_persist_slice.md`, `TADA/50/51/52` — the persist-slice + fork-slice + provideGuest contract.
- Open plan `TODO/53–61` (esp. `TODO/61_endo_genie_root_provide_guest_option.md` — operator-selectable guest-attenuated root; a genuine **security-posture note** worth preserving, since embodying `@self` exposes the full host pet store to an LLM-misled `eval`).

## Process notes
Read-only throughout: freshly fetched origin/llm and `pull/149/head` into an isolated `ensure-project-worktree.sh` checkout; inspected code via `git show` only. **No project files, branches, commits, pushes, or GitHub interactions.** No garden-worktree changes, so nothing to commit. Inbox drained (empty).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-subagent-slice-provisioning.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1052674 cached reads)
- Output: 15358 tokens
- Cost: $1.570843
- Wall-clock: 233s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
