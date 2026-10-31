## PR #1589 fix round 1: fixes pushed, CI still pending

I applied the panel's must-fix items to endojs/endo-but-for-bots#1589 and pushed them. CI did not finish within the 3600s window: `ci-wait-merge.sh` returned rc 4 with 4 of 36 checks still running. Those four are the `test` legs (Node 22/24 on ubuntu and macos-15), which had been running for about 50 minutes. Nothing has failed on the current head.

**Commits pushed** to `build-daemon-git-capability` with `safe-push-pr-head.sh`, head `df3b6cc75a` → `fb40b59e0a`:
1. `feat(agent-tools): select the workspace git catalog by facet`
   - `provisionWorkspaceTools` and `makeWorkspaceTools` take a new `gitFacet` option (`'reader'` or `'writer'`, default `'writer'`). It has a test and a changeset.
2. `fix(fae): refuse a remote beside a read-only workspace Git`
   - **Read-only Git plus remote** (assessor, saboteur, breaker, engine-realist, corner-prober, archivist): setting up the workspace now throws when a remote is granted alongside a read-only Git. Tested with a recording remote, which receives no calls.
   - **Rewrite verbs out of reach** (breaker): a writable Git is narrowed to its writer scope before any tool uses it. Tested.
   - **Duplicate tool assembly** (decomplector, purist, integrator): Fae now builds its workspace tools through the shared `provisionWorkspaceTools` and keeps only the small adapter to its own tool shape.
   - **Unknown pet names** (purist): `createAgent` now fails if a workspace pet name doesn't resolve. Tested for both the Git and the remote.
   - **Return-type cast** (typist): removed the cast to `Promise<string>`; workspace tools now declare `FaeTool<unknown>`.
   - **Missing test coverage** (prover): remote tools are now invoked against a recording `GitRemote`. A new end-to-end test goes from `createAgent({ workspace })` through the driver to the inbox loop and ends with a real commit.
   - **Test fixture** (warden, transplanter): exports and return value are hardened, and it uses `os.devNull` instead of `/dev/null`.
   - **Docs** (archivist, changeset-auditor, pruner): README, factory `help()` and the design doc are corrected, and the changeset is rewritten one sentence per line.
3. `fix(fae): keep executeTool's string result contract`
   - The first push failed CI's TypeScript checks: a non-generic alias, and floot code that expects a string from `executeTool`. I reverted `executeTool` to its original contract. The repo-root `tsc`, Fae and agent-tools lint, and the touched Fae and agent-tools tests pass locally.

I also trimmed the PR description per the pruner, keeping scope, security behavior and limitations.

**Not fixed in code:**
- **Remote/Git pairing** (locksmith, breaker): `GitRemote` has no method that names its bound Git, so the factory can't check that the two grants point at the same repository. I documented this as an operator responsibility in the README, design doc and PR body. Closing it properly would need a single workspace capability minted by the host, which is a follow-up.
- **Breaker's `exec` claim:** it doesn't hold. `exec` runs with the agent's own guest powers, and `workspace-git` is stored only in the driver's namespace. The writer-scope narrowing is in place anyway.
- **Typist should-fix:** I did not move `FaeWorkspaceGrant` into a `types.ts`, because Fae doesn't have one.
- **Maintainer decision (decomplector #2):** whether new Fae exposure through JSON tool records conflicts with the parked code-mode direction (reviews 4803387786 and 4802833193). This needs the maintainer to decide; flag it before the PR is un-drafted.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 142 tokens (9048972 cached reads)
- Output: 37655 tokens
- Cost: $3.816534400000001
- Wall-clock: 6036s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
