## Gauntlet UNDRAFT: endojs/endo-but-for-bots#1349

**Outcome:** Nothing to do. The PR was already out of draft at the head the panel passed, so I did not run `gh pr ready`.

- **Fresh metadata before any change:** `state=OPEN`, `isDraft=false`, `headRefOid=4c315e84c021efcf6e0a20f3cb3bb5fac0deca5b`. This matches the head the panel passed.
- **Second check:** `isDraft=false`, and `headRefOid` is still `4c315e84c021efcf6e0a20f3cb3bb5fac0deca5b`.

**Advisory appellate pass (recorded only, does not block anything):** I read the core source changes myself: `encapsulate-host-constructor.js`, `tame-text-codecs.js` and `lockdown.js`. I did not do a separate `claude -p` run.
- The encapsulation looks sound. `construct(HostCodec, args, new.target)` keeps subclassing working. The `prototype` property is non-writable and non-configurable, as WebIDL requires. Calling the constructor without `new` throws. If the prototype's `constructor` can't be changed (for example because a second copy of SES froze it), it fails loudly with a `cause`.
- **Scope note:** the PR also adds an internal `onShimStartCompartment` callback parameter to `repairIntrinsics`. That is a separate change from taming the text codecs. Its docs say the public `lockdown` and `repairIntrinsics` on `globalThis` don't forward it. It should be checked that the changeset and PR description mention it.
- The PR also touches CI workflows (`ci.yml`, `browser-test.yml`, `depcheck.yml`), which presumably adds the browser spec for text codecs. That isn't a problem, just worth knowing about.

**Follow-ups:** none required.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (232928 cached reads)
- Output: 1323 tokens
- Cost: $0.44061359999999994
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
