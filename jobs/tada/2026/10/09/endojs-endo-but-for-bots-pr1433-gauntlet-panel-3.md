Panel round 3 on PR #1433 returned **must-fix**. I posted the aggregate as a PR review. I did not fix or un-draft anything.

- **Checkout:** I ran the panel against the PR head, `kriscendobot/endo-but-for-bots` on `design/formula-identifier-indirection`. I used the PR's base SHA `7d2eb307a2ee` as the base ref.
- **Run:** `panel.sh` exited 0 in single-round mode. Its terminal line was "design-panel single-round — must-fix".
- **Pre-passes:**
  - The ownership-map pre-pass flagged ATTENTION, so the decomplector lens was forced.
  - A repeated must-fix on one mechanism forced the decomplector's is-it-needed question.
  - The phase/evidence and PR-body-template pre-passes could not resolve the PR body or governing design. They are logged as non-fatal.
- **Review post:** GitHub refused `--request-changes` because the review author owns the PR ("Can not request changes on your own pull request"). I posted it as a plain `--comment` review instead, headed "Panel round 3 verdict: must-fix".
- **Main findings:**
  - The "strictly internal" claim is overstated, since formula identifiers still reach other egress channels (errors, logs, messages).
  - The shared default share conflicts with the independent-revocation goal.
  - The control-facet custody and issuer-surface API are unspecified.
  - There are gaps in the rotation, retry and revocation semantics.
  - The staging order is inconsistent and the migration claim is not lossless.
  - The cross-peer legacy-locator loss is unnamed.
- **Follow-up:** the fix stage should address these findings and then re-run the panel.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 50 tokens (1261278 cached reads)
- Output: 7739 tokens
- Cost: $1.0468776
- Wall-clock: 947s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
