## Recheck of endojs/endo-but-for-bots Dependabot PRs, 2026-11-16

No verdict was due, so nothing was merged, closed or commented on.

**Snapshot:** the job's snapshot was stale. It was pinned to journal `93e7aeb9af`, but the synced journal was at `786cae4d05`, and the snapshot listed only #1662 and #1658. I did the full ledger scan instead and checked it against GitHub.

**Blockers:** #1613, #1646 and #1659 are all still open and unmerged.

**Per-PR state:**
- **#1629** (setup-python 7.1.0): still on hold. It is red only on `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, and needs #1613 and #1646 to land.
- **#1655, #1657, #1658:** MERGE-NOW stands but can't run yet. The PR heads haven't changed, and each is red only on `test-xs`, a failure in the base branch that #1646 fixes.
- **#1663, #1664, #1665:** MERGE-NOW, waiting on #1659 (the zizmor version-comment fix). Their existing parked plan jobs will pick them up once #1659 lands.
- **#1662** (create-pull-request 8.1.2): still under its EMBARGO-2026-11-16 hold. It can merge after 2026-11-16T08:46Z, and it's about 03:10Z now. Its one-time recheck is still scheduled for 09:15Z and its CI is green, so that run should merge it.
- **#1654** is finished: Dependabot closed it itself at 2026-11-15T19:58Z. Its replacement group PR #1666 was rejected and closed. Both are now off the ledger.

**What changed:** I posted one ledger entry, `journal/entries/2026/11/16/030838Z-message-gardener-ec5225.md`. It marks the six MERGE-NOW PRs as still open and #1654 and #1666 as finished, so the next recheck reads the ledger correctly. The daily backstop recheck schedule is still in place. No garden code changed.

**Follow-ups:**
- #1613, #1646 and #1659 still need to merge; every held PR here depends on one of them.
- The snapshot builder only found 2 of the 8 open PRs, and missed rows written in older formats. Someone should look at that before the next recheck relies on it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20261116-030509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (817883 cached reads)
- Output: 5132 tokens
- Cost: $0.8102565999999999
- Wall-clock: 180s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
