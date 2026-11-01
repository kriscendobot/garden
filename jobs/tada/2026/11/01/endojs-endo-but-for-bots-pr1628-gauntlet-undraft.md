PR endojs/endo-but-for-bots#1628 is now out of draft. The gate held: the PR was OPEN and its head was exactly `4a17faa2c73b0d104e5b1796fad865334830eac2`, the commit the panel passed.

**Steps:**
1. **Advisory appellate pass** (advisory only, did not gate): a light `claude -p` review of the 1-file, +123/−2 test diff. The reviewer only had the diff, so none of these points are verified:
   - **Possible early-pass race:** the `eventually` waits use an empty `list()` or `listDerived()` as the sign of convergence. The `piecesOf(...)` checks after them run only once, so the wait could pass before teardown finishes and those checks could flake.
   - **Not a real crash:** `crashAfterAppending` writes the journal record and then calls `restart`, which is a graceful restart. The test shows that replaying a hand-written record converges, not that a real mid-operation crash recovers.
   - **Checks that may not be able to fail:** `isActive() === false` might pass even if reconciliation never ran. `t.throwsAsync(...lookup('helper'))` has no message matcher, so any error, including a transport error, would pass.
   - **Fragile journal parsing:** if no `j<ns>.<seq>` names match the pattern, the record is silently written at `.0` instead of failing. Adding an assertion that the sequence list is non-empty would catch that.
   - **Smaller points:** the revocation test assumes the default quota is 4, it doesn't check `faults()`, and one line may be over 80 columns (prettier may reformat it).
2. **Pre-mutation check:** state OPEN, head matched, isDraft was true.
3. **Un-draft:** ran `gh pr ready`.
4. **Re-check:** isDraft is false and the head is unchanged at `4a17faa2…`.

No garden repo changes. The advisory points are left for the maintainer's review; I posted no follow-up job.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1628-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178399 cached reads)
- Output: 1618 tokens
- Cost: $0.4249278
- Wall-clock: 50s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
