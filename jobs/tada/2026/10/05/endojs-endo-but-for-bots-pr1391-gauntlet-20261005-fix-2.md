Fix round 2 for endojs/endo-but-for-bots#1391 is pushed and CI is green.

**Must-fix (integrator): reconcile the rest of #695's review.** I edited the PR description. It now covers the two other threads of the open review on #695 (https://github.com/endojs/endo-but-for-bots/pull/695#pullrequestreview-4700861513), not just the remotable-versus-passable one:
- **Confinement:** the PR shares only the constructor. A confined compartment gets no way to locate or enliven a ref it was not given (see the sturdyref README § Child compartments). Whether a guest may enliven a ref it *was* given belongs to the enlivenment layer (#1392 and the network layers).
- **Retention:** out of scope. This PR adds no retention edge and no registry.

The Security Considerations section now says the "no authority" property holds only because of how the shim is written; SES does not enforce it.

**Should-fix and comment items, also applied in commit `740f94e9b2`, pushed with safe-push:**
- **Breaker:** lockdown checked `SturdyRef.prototype` one way and later read it another, so a Proxy could show a different prototype at each step. Lockdown now also requires that `prototype` be non-writable and non-configurable, as on every class. JavaScript's Proxy rules then force both reads to return the same object. This means a plain function with the right statics is now refused. New tests `_sturdyref-plain-function.js` and `sturdyref-plain-function.test.js` cover that case.
- **Breaker's comment:** the comment in `global-object.js` now matches the hedge in `intrinsics.js`: the shape check guards against misconfiguration, not authority.

Locally, eslint showed no errors, the ses package passed 416 tests and the sturdyref package passed 22.

**CI:** the first run had one failure, `test (24.x, macos-15)`. `@endo/daemon`'s `endo.test.js` timed out opening a relay channel, which matches the known daemon relay flake and is unrelated to this SES change. I re-ran only the failed job. `ci-wait-merge.sh --no-merge` then returned rc 0, with all 33 checks green.

**Not done:** the integrator also suggested rebasing four net-zero daemon orphan-teardown commits (`e703fad05d`, `d6d07ab446`, `14381fc8f5`, `0ebeab85eb`) out of the branch. That rewrites history, so I left it out of this push-only round. A later retcon can do it if wanted.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1766839 cached reads)
- Output: 10022 tokens
- Cost: $1.1092158
- Wall-clock: 4538s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
