I applied three of the four round-5 must-fix items on PR endojs/endo-but-for-bots#1124. The fourth, the decomplector's main finding, needs your decision, so I left it for you. CI is green on the new head `1f0f47314` (33 checks, 0 failed), and the 11 locator tests pass locally.

**What was fixed:**
- **PR title (integrator):** now `feat(daemon): add OCapN formula nonce locator`. The old title named `@endo/ocapn`, which the PR no longer changes.
- **Commit history (integrator):** rewritten into two commits on base `llm-f1e3065`:
  - `bd7008173 feat(daemon): add formula nonce locator`
  - `1f0f47314 docs(daemon): relate external-connectivity §2 to the formula nonce locator`

  I dropped the commit that added the `@endo/ocapn` session hook and the later commit that reverted it. The overall change is unchanged apart from the two items below. I pushed with `safe-push-pr-head.sh --mode rewrite`, guarded against a newer push from anyone else.
- **Re-export (reexport-auditor):** I deleted the one-line re-export file `packages/daemon/formula-nonce-locator.js`. The `./formula-nonce-locator.js` entry in `package.json` now points straight at `./src/networks/formula-nonce-locator.js`, the same way `./iroh.js` does, so no plain re-export remains.
- **Design note (a decomplector should-fix):** §2 now says the locator is not yet wired in, and that the live endpoint still serves peers through `localGateway.provide`.
- **PR description:** removed the paragraph narrating earlier review rounds and the "around line 387" pointer.

**Not fixed — your decision needed (decomplector must-fix):** the panel wants the public `makeFormulaNonceLocator` export removed, because nothing uses it and it duplicates `localGateway.provide(id)`. In its place would go a small private adapter in `networks/ocapn.js`, landed together with the change that retires the gateway path. The panel says this needs your confirmation first, so I sent you a message asking you to choose:
- **(a)** keep the PR as it is;
- **(b)** rescope it to the private adapter plus that Phase 1 wiring;
- **(c)** close it as superseded.

The deciding question is whether you confirm that the daemon's OCapN locator should replace the gateway `provide` path now. Until you answer, the round-6 panel will most likely raise the same must-fix again.

I also posted a summary comment on the PR (https://github.com/endojs/endo-but-for-bots/pull/1124#issuecomment-6045668364). The other should-fix items (the breaker's disagreement over which identifiers count as local, the wire-watcher's points, tightening the endpoint test assertions, and making the new types reachable from the package's type entry) are not done. They are worth doing only if the answer is (a).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1676534 cached reads)
- Output: 8637 tokens
- Cost: $1.0935108
- Wall-clock: 1986s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
