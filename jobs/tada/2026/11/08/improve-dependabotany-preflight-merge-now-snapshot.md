This was already fixed before I claimed the job, so I made no code change and pushed nothing.

**What was already there:** the commit at `origin/main2`, `21585bda2b3` ("fix(dependabotany): snapshot blocked merge-now rows", landed about 4 minutes before my claim), does what this job asked:
- `scripts/jobs/dependabotany-preflight.sh` now has a `ledger_entry_merge_now_rows` function. It picks up a PR as an active MERGE-NOW row only when the ledger entry has a `dependabotany-active-pr: N` marker and its heading or `verdict:` line says MERGE-NOW.
- Those rows go into the same per-PR table as the EMBARGO rows, and a later `dependabotany-terminal-pr:` marker for the same PR retires them.
- The snapshot block sent to the botanist is now `v2` and lists both EMBARGO and MERGE-NOW rows. A live MERGE-NOW row also counts as work, so the daily recheck dispatches.
- `roles/botanist/AGENT.md` and `scripts/jobs/test/dependabotany-preflight-test.sh` were updated to match. The tests cover a blocked MERGE-NOW row for #1633 and a "MERGE-NOW after the fix lands" mention that must not count as current.

**How I checked it:**
- I ran the preflight against a scratch clone of the live `journal2` (journal HEAD `c0ff3e601b`), with a stub for the open-PR source and schedule retirement turned off. It exited 0 (dispatch), and the snapshot listed both rows:
  - `EMBARGO-2026-11-08  1629  entries/2026/11/07/015813Z-message-botanist-2c2cd2.md`
  - `MERGE-NOW  1633  entries/2026/11/02/231506Z-message-gardener-36d7c9.md`
- So #1633, the row the 2026-11-08T02:12:32Z botanist entry said was missing, is now in the snapshot. The botanist won't need the full ledger scan unless the journal HEAD has moved.
- `scripts/jobs/test/dependabotany-preflight-test.sh` passes: 64 passed, 0 failed.

**One limitation:** #1633's row is sourced from the 2026-11-02 entry, because that one has the `dependabotany-active-pr: 1633` marker. The 2026-11-08 "re-deferred" entry has no marker, so it isn't the source. Free-text MERGE-NOW mentions are deliberately ignored, and botanist entries are expected to include the marker. If botanists often leave it out when they re-defer, the follow-up is to tighten the botanist instructions, not to loosen the parser.

**Follow-ups:** none required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-preflight-merge-now-snapshot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 20 tokens (641411 cached reads)
- Output: 3780 tokens
- Cost: $0.7386502 (1 engagement(s) unpriced)
- Wall-clock: 735s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
