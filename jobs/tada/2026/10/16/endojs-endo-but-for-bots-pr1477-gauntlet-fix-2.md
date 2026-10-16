## Fix round 2 for endojs/endo-but-for-bots#1477

I fixed both blocking items from the round-2 panel (review 5553698267) and pushed the result. CI is green: 35 checks ran and none failed (`ci-wait-merge` rc 0).

**Must-fix items:**
- **integrator, PR body:** I rewrote the PR body to follow the template, with every heading in order: Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade. Scaling and Upgrade each get one sentence saying they don't apply. Documentation now says that `designs/ocapn-network-transport-separation.md` § Target Model exists on the base and that the PR agrees with it, which also covers integrator's should-fix #2. The body still has the `garden-job` marker.
- **pruner, changeset:** I deleted the third line, which repeated the first, and moved the `locationNetworkId` export into the first line.

**Optional items also done:**
- `util.js` now has a comment saying that a new identity-keyed network gets added to `identityKeyedNetworks` (integrator's should-fix #3).
- `location-id.test.js` now checks that a `.np` location with `hints: {}` gets the plain `ocapn://<designator>.np` ID (from corner-prober).

**Optional items not done:**
- **`harden` on `identityKeyedNetworks`:** I tried it and the test failed with `ReferenceError: harden is not defined`, because `harden` doesn't exist yet when the module loads. No other ocapn source file hardens at module top level, so I reverted it.
- **`hints: undefined`:** the type is `false | Record`, so I didn't add a test for it.
- **Empty-string `network`:** today it produces `ocapn://x.` with nothing after the dot. That looks wrong rather than worth locking into a test, so I didn't add one.
- **Top-level completion summary (scribe):** not posted.

**Commit:** bb7efe0603, `fix(ocapn): address panel round 2 on np location IDs`, pushed with `safe-push-pr-head.sh` (295c136e65 → bb7efe0603). Locally, the 5 tests in `location-id.test.js` pass and prettier is clean. I couldn't run tsc locally because npx didn't find TypeScript, but CI's lint passed.

My first CI wait was cut off by the 10-minute background limit. I restarted it with a longer timeout and it finished green.

**Follow-up:** the driver re-posts panel round 3. The empty-string `network` behavior may deserve its own check later.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1477-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1004150 cached reads)
- Output: 6848 tokens
- Cost: $0.8101019999999998
- Wall-clock: 1997s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
