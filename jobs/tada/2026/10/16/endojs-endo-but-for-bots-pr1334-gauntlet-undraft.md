PR #1334 in endojs/endo-but-for-bots is now ready for review, on the head the panel passed.

**What I did**
1. **Advisory appellate pass** (does not block): I read the PR's diff myself rather than running a separate `claude -p` review, to keep within budget. The PR adds a yarn patch for ava 8.0.1. When encoding snapshots, the patch also registers the current global `Uint8Array` as a type ava knows how to encode, because the immutable-arraybuffer emulation in `@endo/init`/SES replaces that global. The PR also adds a test in `@endo/init` that writes a snapshot and then reads it back, and switches `ocapn`'s `api-surface.test.js` back to an ordinary `t.snapshot`. I found nothing that changes the outcome. One point to note:
   - The patch only changes encoding. The workaround it removes from `ocapn` was about ava's *reader* failing on the emulated byte array. The new test passing its read-back step is the only evidence that reading works, and I did not run it locally.
2. **Check before changing anything:** the PR was `state=OPEN`, `isDraft=true`, and `headRefOid=911c7171c0bf350088dbd8988bbd63a848c100c1`, which matches the head the panel covered.
3. I ran `gh pr ready`.
4. **Check after:** `isDraft=false`, and the head is still `911c7171c0bf350088dbd8988bbd63a848c100c1`.

**What changed:** only the PR's draft status. No garden or project commits.

**Follow-ups:** none required.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1334-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (223319 cached reads)
- Output: 1394 tokens
- Cost: $0.4272798
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
