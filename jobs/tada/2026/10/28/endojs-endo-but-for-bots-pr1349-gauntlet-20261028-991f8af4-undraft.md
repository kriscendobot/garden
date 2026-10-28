Undraft stage report for endojs/endo-but-for-bots PR #1349 (gauntlet `endojs-endo-but-for-bots-pr1349-gauntlet-20261028-991f8af4`)

**Result: nothing to do.** The PR was already marked ready for review on the head the panel passed, so I did not run `gh pr ready`.

**Metadata check, before and after:**
- `gh pr view` returned `state=OPEN`, `isDraft=false`, `headRefOid=991f8af47e27cee09c6e3db5babf9714dbd60214`.
- That head is the exact commit the panel passed.
- The second fetch returned the same values.

**Appellate pass (advisory only, did not block anything):** I read the core source changes myself (`encapsulate-host-constructor.js`, `tame-text-codecs.js`, `lockdown.js`) and the browser spec instead of launching a separate `claude -p` reviewer. The panel doesn't seem to have missed any bugs. Points to note:
- **Scope:** the PR bundles changes that don't depend on the text-codec fix:
  - a second changeset for XS compartments built after `lockdown()`, plus changes to `src-xs/compartment.js` and `src-xs/lockdown-shim.js`;
  - CI workflow changes: `browser-test.yml` drops its `branches: [master]` filter, and the `browser-test.yml` and `depcheck.yml` jobs are pinned to `ubuntu-24.04`.

  Reviewers may want these split out or called out in the PR description.
- **New hook:** `repairIntrinsics` gains an internal `onShimStartCompartment` callback. Its doc comment says the public `lockdown` and `repairIntrinsics` don't forward it. That claim is worth confirming in review.
- **Repointing failure:** `encapsulateHostConstructor` throws a clear `TypeError` when it can't repoint `prototype.constructor` (for example, a second copy of SES already froze the prototype). This is reasonable, but on affected Chromium it is a new way for `lockdown()` to fail.
- **Behavior change:** the changeset documents a visible change on affected hosts: a codec reference cached before `lockdown()` is no longer identical to the global after it.

No follow-ups needed.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261028-991f8af4-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (242649 cached reads)
- Output: 1656 tokens
- Cost: $0.4877138
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
