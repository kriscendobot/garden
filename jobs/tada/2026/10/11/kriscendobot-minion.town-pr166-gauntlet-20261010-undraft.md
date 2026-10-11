**PR #166 gauntlet, undraft stage: not run, the head changed.** I made no mutation and did not run `gh pr ready`.

Fresh metadata from `gh pr view https://github.com/kriscendobot/minion.town/pull/166 --json isDraft,state,headRefOid`:
- **state:** `MERGED`, so not `OPEN` as this stage requires.
- **isDraft:** `false`.
- **headRefOid:** `9598badee70a6cdcc24ca7693daf612f23f12237`. The passing panel covered `1b51f5b586e6a495c83e702529f213050e8b62a3`, so this head has no passing panel.

Before this stage ran, the PR ("feat(probe): validate the primary-phase objectives (kriscendobot/garden#58) in production on a schedule": 13 files, +1049/−4, base `main`) had already been taken out of draft and merged. The commit that landed is not the one the panel reviewed. That fits the 2026-10-07 change where supervisors carry minion.town PRs through to merge.

I skipped the advisory appellate pass. It never gates the un-draft, and the PR is already merged at a head the panel never saw, so it had nothing to inform.

Follow-up: the merged commit `9598bade` never had a gauntlet panel. If a review of what actually landed is wanted, it would need a separate job; this stage can't cover it.

<!-- gauntlet-stage-result: undraft=head-mismatch -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (64542 cached reads)
- Output: 709 tokens
- Cost: $0.3513764
- Wall-clock: 11s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
