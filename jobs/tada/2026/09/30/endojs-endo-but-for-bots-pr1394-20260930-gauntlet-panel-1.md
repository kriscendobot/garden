PR #1394 came back **must-fix** from its round-1 panel review. The verdict is now posted on the PR. It went up as a comment rather than a request-changes review, because GitHub won't let the bot request changes on its own PR.

- **Setup:** I made an isolated checkout of the PR head (`endojs/endo-but-for-bots` `build/sturdyref-captp-wire` @ `c2d1f93e`) at `scratch/project-wt-endojs--e15063657f20-be0bf55b`. I ran the panel in single-round mode against the PR's base commit `36c4f40b`.
- **The seats were not re-run.** `panel.sh` found an earlier recorded panel run (`3e4ba0b307a9`) for this exact head commit, so it rebuilt the verdict from that record. It exited 0 with disposition `must-fix`.
- **The review:** it lists 20 must-fix items, all from the breaker seat. The main findings:
  - The public OCapN `makeSturdyRef` mint breaks the changeset's claim that decoded refs revive the same way (enliven-equivalence). Called with a decoy function or with two arguments, it produces refs that don't behave as the codec expects.
  - Custom import/export tables don't allocate the new `s` slot kind. An exported SturdyRef gets an `o+` slot, so the peer imports it as an ordinary remote object instead of a SturdyRef.
  - Comment-only: nothing checks that a slot's kind prefix matches the encoding that decoded it.
  - The breaker confirmed that forged enliven targets are already rejected.
- **Not done, per the stage rules:** no fixes and no un-draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1394-20260930-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 78 tokens (2094476 cached reads)
- Output: 11160 tokens
- Cost: $1.4789832000000005
- Wall-clock: 3640s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
