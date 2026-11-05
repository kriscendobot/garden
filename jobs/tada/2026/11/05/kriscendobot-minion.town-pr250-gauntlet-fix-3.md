I applied the only must-fix from the latest panel verdict on PR #250 (the decomplector finding from 05:41Z), pushed it, and CI is green. No deterministic pre-pass block was attached to this job.

**The problem:** the design's ownership section gave the factory retry, replay and control commits that the baseline designs assign to other layers. It also contradicted itself on whether the guest and broker commit.

**Changes to `designs/api-key-agent-directory-authorization.md`** (commit `ab0b29d9`, a follow-up on `design/api-key-agent-directory-authorization`):
- **Ownership table, agent factory to guest row:** the factory now coordinates and commits the `AgentRecord`. The guest commits its own state and the provider registry commits the grant record, both as participants. The factory reconciler recovers the operation.
- **Prose under the table:** I replaced the summary that made the factory the owner with the skill's four ownership questions, answered per level:
  - **Durable state:** the factory's registry, the provider registry, the usage ledger and the guest each own their own data.
  - **Commit and discard:** the factory commits its own records, and the guest, registry grant and responder commit their effects as participants. The registry is the one committer for control methods and grant records, and the broker owns per-turn admit and discard.
  - **Restart and replay:** Endo owns formula revival, and the factory's reconciler recovers only the factory's own operation records.
  - **Execution classification:** the harness classifies how a turn ended, and the broker owns retry and spend policy. The factory does neither.
- **Precedence:** the section now says the decision adds no state, operation or lifecycle, assigns no new owner, and that the baselines govern if the text ever differs. The wording matches the provider design's ownership map at `069b429c16` and the workbench design's "One commit owner" text.
- **Unchanged:** the admission-checks distinction and the inner/outer naming sentence stay as they were.

**Reversal of an earlier ask:** an earlier decomplector finding (first review on this PR) asked for guest and broker classification with factory translation. This round reverses that, and I followed the latest verdict.

**Push and CI:**
- **Push:** `safe-push-pr-head.sh` in advance mode moved the head from `2b86e725` to `ab0b29d9`, confirmed with `ls-remote`.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0 (total=1, failed=0). The bot token can't read `statusCheckRollup`, so it used the Actions runs API, and commit statuses and non-Actions check runs were not visible.

**Follow-ups:** none from this stage; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (435716 cached reads)
- Output: 6395 tokens
- Cost: $0.6978112
- Wall-clock: 542s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
