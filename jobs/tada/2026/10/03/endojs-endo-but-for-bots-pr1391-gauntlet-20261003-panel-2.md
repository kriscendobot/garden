Panel round 2 on endojs/endo-but-for-bots#1391 is done, and the verdict is **must-fix**.

**What ran:** the panel ran in single-round mode against the PR head `61a08fd144`, using the base `ef4662f04b` that the PR records. The base is an in-repo branch, so I passed its exact SHA rather than the branch name. `panel.sh` exited 0 with disposition `must-fix`. All 33 seats ran: 4 asked for changes, 7 left comments only, and 22 approved.

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5400463462

It went up as a COMMENT review, not request-changes, because GitHub won't let the account that opened a PR request changes on it. The body says to treat it as request-changes, the same way round 1 did. It covers only the seats that asked for changes or commented; approving seats are listed by name, which keeps it under GitHub's size limit.

The first post was refused because some seat reports used bare PR numbers (#695, #697, #774, #1392) next to a link to another repo. All of those numbers refer to endojs/endo-but-for-bots, so I wrote them out in full as `endojs/endo-but-for-bots#N` and posted again.

**Changes the panel asks for (for the fix stage):**
1. **saboteur (must-fix):** `assertSturdyRefShape` in `packages/ses/src/intrinsics.js` can be fooled by a Proxy. While the check runs, the Proxy can swap `globalThis.SturdyRef` for another value. `sampleGlobals` then reads the global again, so the value every compartment ends up sharing may never have been checked. Fix: have the check return the value it validated, and use exactly that value.
2. **breaker (should-fix):** the check only looks for the `enliven` and `isSturdyRef` statics. It doesn't check that the value is a constructor or has its own `prototype`, so an arrow function carrying those two statics passes. The purist seat noted the same gap.
3. **spec-keeper (should-fix):** the changeset says any other shape of `SturdyRef` binding makes `lockdown` throw. In fact a mismatched binding marked `configurable: true` is quietly normalized instead. The changeset wording should match what the code does.
4. **coverage-auditor:** `test:xs` in `packages/sturdyref` is just `exit 0`, yet the PR description claims an XS smoke test. Either point that script at the `packages/ses` XS run, or say in the description where the XS coverage actually lives.

Nothing was fixed, the PR was not taken out of draft, and no further round was run.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1143471 cached reads)
- Output: 5696 tokens
- Cost: $0.8608542000000001
- Wall-clock: 1268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
