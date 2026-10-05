## Gauntlet FIX round 3: endojs/endo-but-for-bots PR #1389

The round-3 fixes are pushed and CI is green: `ci-wait-merge.sh --no-merge` returned rc=0, with 28 of 28 checks passing and none failed.

**Panel source:** review 5363890565 (2026-09-30). Commit `ff3705d574`, pushed on 2026-09-30, had already fixed some of its items: the handler-state sentence, the harden key spelling, the "Forward Sketch" link capitalization, and the cross-link to `sturdy-refs-endor-syscall`. This attempt applied what was left.

**PR body (the binding must-fix):** I added the three missing template headings: Scaling, Documentation and Upgrade Considerations. The body's headings now match the template's seven, in its order.

**`designs/sturdyref-shim-contract.md`** (commit `f14df30cff`, pushed with `safe-push-pr-head.sh` as a fast-forward from `ff3705d574`):
- **skeptic finding 1:** I corrected the claim about how `passStyleOf` rejects a ref. A ref has no own keys, so it passes the remotable duck-type check without anything to fail on. It is rejected only because `SturdyRef.prototype` has no `PASS_STYLE` tag. The doc now says layer 1 must not add that tag, and a test pins the rejection.
- **skeptic finding 2:** I added two rows to the #774 test table. One checks that the hook runs as `enliven.call(handler, ref)`, so `this === handler`. The other checks that `handler.enliven` is read once at construction (Open question 3).
- **critic finding 1:** I added a note to the Forward Sketch saying that interning refs at mint time (reusing the existing ref when the same target is exported twice) is a layer-5 decision.
- **critic finding 2 and copyeditor finding 3:** I reworded the Provenance sentence to "with that ref as its argument", and replaced "This is believed, to be confirmed…" with plainer wording.

**Not changed:**
- **pedant's anchor finding:** I left this alone because I believe it is wrong. GitHub drops the en dash from the heading "Layers 3–5" without adding a hyphen, so `#forward-sketch-layers-35-no-implementation` should already resolve.
- **decomplector and ergonomist (the `@endo/ocapn` name overlap, renaming the `enliven` parameter):** these are should-fix design choices for the maintainer or the layer-1 build, not text fixes.
- **novice's remaining items:** these are comment-only.

**Follow-up:** a terminal comment on the PR (2026-09-30) said the gauntlet was halted after an earlier claim of this fix-3 stage was set aside with failure cause "unknown". It has since been put back in the queue and has now finished. It is unclear whether the driver will post panel-4 on its own; if it doesn't, the gauntlet will need to be re-run by hand.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (989112 cached reads)
- Output: 5804 tokens
- Cost: $0.8107424000000001
- Wall-clock: 844s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
