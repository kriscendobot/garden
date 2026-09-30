Fix round 2 for PR endojs/endo-but-for-bots#1391 is done. The round-2 must-fix items are applied and CI is green on the current head `49112da9e1`. I did not push any commits myself: an earlier claimant of this same job (host `endolin-garden2-5bcdff64`) had already pushed them, so I checked that work and ran the CI wait.

**What the panel required.** The panel's must-fix verdict (round 2, reviewing head `c78271e1f1`) was forced by the PR-body template check. It also had a few request-changes items from individual seats:
- **integrator:** the PR body was missing four template sections, and the title said "layer 2".
- **changeset-auditor:** the changeset needed one sentence per line.
- **saboteur:** any unrelated function named `SturdyRef` would be shared with every compartment, and the stand-in test shim wasn't frozen like the real one.
- **pruner:** the Security and Testing sections were too long.

**What the earlier claimant pushed**, with a summary comment on the PR:
- `819203dd53`: lockdown now accepts `SturdyRef` only if it has the `@endo/sturdyref` shape (`enliven` and `isSturdyRef` statics) and throws otherwise. A new test, `sturdyref-impostor.test.js`, covers this.
- `a05d0fcd77`: the stand-in test shim is now frozen the same way the real shim is.
- `5d43b703ad`: the changeset is rewrapped to one sentence per line and documents the new ways lockdown can throw and the need to release the shim and SES together.
- `49112da9e1`: prettier formatting.
- The PR body now has all seven template sections, and Security and Testing are shorter. The title no longer says "layer 2". It is now "feat(ses): permit and share a pre-lockdown SturdyRef shim".
- The summary comment includes a verification line: `ses` tests pass (409, with 1 known failure) and lint passes; `sturdyref` tests pass (22).
- It openly declined integrator's request to fold the fix-up commits, because rewriting the branch mid-gauntlet would break review anchors. That can be done before merge.

**CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1391 --no-merge` returned rc 0, with all 33 checks finished and none failing. `test-xs`, `lint` and the full `test` and `cover` matrices all passed.

**Follow-ups:**
- The driver should post panel round 3.
- Folding the fix-up commits is still open for before merge.
- The comment on the PR says the round-2 review the panel posted had another PR's body pasted in (from kriscendobot/minion.town#135). The copy I read does match #1391, so it looks like it was corrected, but it's worth checking the panel's posting.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 138 tokens (5901682 cached reads)
- Output: 25463 tokens
- Cost: $3.0119244000000003
- Wall-clock: 7016s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
