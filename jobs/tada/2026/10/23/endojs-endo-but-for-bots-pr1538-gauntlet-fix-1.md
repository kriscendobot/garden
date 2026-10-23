# Fix round 1 report: endojs/endo-but-for-bots PR #1538 (gauntlet `endojs-endo-but-for-bots-pr1538-gauntlet`)

I fixed all three failing style-prepass stages and pushed the fixes to the PR head. CI came back **GREEN**: `ci-wait-merge` returned rc 0 with 35 checks and 0 failures.

**What changed.** Three follow-up commits on `build/daemon-git-clone` (`cdddbb0de..b1c190daa`), pushed with `safe-push-pr-head.sh`, which advanced the branch without rewriting anything:
1. `5ca4339d3` style(sandbox): `packages/sandbox/src/drivers/bwrap.js` now has a top-of-file `/** @import { Readable } from 'stream' */`. The two inline `import('stream').Readable` types (the `@param` at line 126 and the `@type` cast at line 938) now use the bare `Readable`.
2. `ef424d67f` test(daemon): in `packages/daemon/test/git-remote.test.js`, the non-mount cap that the PR added with bare `Far('NotMount', {})` is now `makeExo('NotMount', M.interface('NotMount', {}), {})`. I added imports from `@endo/exo` and `@endo/patterns`, both already daemon dependencies.
3. `b1c190daa` style: two spell-out fixes.
   - In `packages/daemon/src/host.js`, the `makeHostMaker` JSDoc parameter is renamed from `args` to `powers` across the whole block (55 doc-only lines). The function's real parameter is destructured, so no code changes. The probe checks each line separately and does not treat ` * @param` lines as comments, so the two `args.` lines the PR added tripped it. I renamed the whole block so the JSDoc stays consistent.
   - In `packages/sandbox/test/bwrap.test.js`, the cleanup loop the PR added now uses `directory` instead of `dir`. Older loops that predate the PR still use `dir`; I left them alone.

**Not changed.** The pruner advisory on `host.js:1600` was non-blocking. That comment says `provideGitRemote` and `provideGitClone` store their remote policy records in the same shape, which is a real invariant and not narration, so I kept it.

**Checks.** Before committing, I re-ran the three gate probes (`no-inline-import-jsdoc`, `prefer-endo-primitives`, `spell-out-identifiers`) on the change and all three passed. ESLint on the four touched files gave 0 errors; the warnings are pre-existing. `tsc --noEmit` was clean for sandbox, and the daemon type check showed no errors in the touched files. On CI, lint, sandbox-drivers, cover, the tests and viable-release all passed.

**Follow-ups:** none from this round. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2161998 cached reads)
- Output: 9558 tokens
- Cost: $1.1297675999999996
- Wall-clock: 3097s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
