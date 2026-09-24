# Gauntlet fix round 2: endojs/endo-but-for-bots#1336

I pushed four follow-up commits that fix the panel-2 must-fix items and most of its should-fix items. CI is green: 33 checks ran and none failed (`ci-wait-merge` returned 0).

**What I did**

- **Panel findings:** I read both parts of the round-2 panel review. Four seats asked for changes: changeset-auditor, breaker, purist and integrator. fast-checker marked one finding must-fix-loop.
- **Checkout and push:** I worked in an isolated checkout of `endojs/endo-but-for-bots@build/endo-guest-stdio-mcp`. I pushed with `safe-push-pr-head.sh --mode advance`, moving the head from `73d4b644e5` to `4ff416dd32`.
- **Local checks:** everything passed before the push. The tests pass for `agent-mcp-stdio` (38) and for the agent-tools MCP adapter and exports (23). eslint shows no errors, prettier is clean, and the composite tsconfigs are up to date. The package type-checks show no errors in the changed files. The repo-root `tsc` check printed no errors in these packages, though I didn't confirm it ran to the end inside its timeout.
- **PR title:** I renamed the PR to "feat: MCP adapter in agent-tools and a stdio MCP server scoped to one guest", as the integrator asked.

**Commits**

1. `fix(agent-tools)`:
   - **Hardened errors:** construction errors are now made with `@endo/errors` `makeError` (with `sanitize: false`, so the fields can be added before hardening) and then hardened. `@endo/errors` is a new dependency of agent-tools.
   - **Brand check:** `isConstructionError` now checks a private `WeakSet` instead of looking for any string `reason`.
   - **Reason type:** the adapter's `ConstructionReason` lists only its own three reasons, and `ConstructionError<R>` is now generic. `agent-mcp-stdio` adds `invalid-formula-id` and `daemon-unreachable` in a new `src/types.ts`. `DaemonConnection` moved there too, which covers typist's point.
   - **Export rename:** the daemon export `./formula` is now `./formula-identifier.js`, and I added a brand test.
2. `fix(agent-mcp-stdio)` (breaker #1):
   - **Wait timing:** a `readFollower` wait now starts when the call arrives, not when earlier reads finish.
   - **No lost items:** a read that times out while waiting in line returns empty, and it takes nothing when its turn comes, so no item is lost.
   - **Integer check:** a fractional `maxItems` is refused.
   - **Tests:** new tests cover the timing and the no-loss case. A new test also lists exactly which inputs `toMessageNumber` accepts and rejects, which clears fast-checker's must-fix-loop.
3. `docs`:
   - **Changeset:** the changeset now lists `@endo/agent-mcp-stdio: minor` and puts one sentence on each line (changeset-auditor).
   - **Design, argument-scope:** the design now says `argument-scope` covers only arguments outside the declared schema. A petname the guest refuses gets the "facet threw" result instead (breaker #2).
   - **Design, package name:** the design records the final package name (integrator #4).
4. `chore: Update yarn.lock`.

**Left for the panel or the maintainer**

- **Commit history (integrator #1):** the integrator asked to reset and regroup the whole commit history. I didn't do that, because this stage pushes follow-up commits only. A retcon job could do it if the maintainer wants it.
- **Optional suggestions:** I skipped fast-checker's suggested property tests (they would need a new `fast-check` dependency). I also skipped the engine-realist, saboteur and warden should-fix notes, and the other comment-only notes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5038156 cached reads)
- Output: 30943 tokens
- Cost: $2.6023392000000003
- Wall-clock: 2782s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
