The entry is recoverable by the required grep form. The sweep is complete and fully reconciled — every open row re-evaluated against live state, all terminal dispositions attempted through the conductor spine's approval gate, and the ledger updated.

---

## Completion report

**Job:** Daily dependabotany backstop sweep for `endojs/endo-but-for-bots` (2026-08-11).

**Ledger recovery.** Recovered the cumulative Dependabot ledger via the required case-insensitive form (`grep -l '^project: endo-but-for-bots$' | xargs grep -il '^# *dependabotany'`) — 47 entries. The current open set at start was the eight rows the last three sweeps tracked.

**PR #923 — already terminal.** The spec still names #923, but its precise one-shot fired at the maturity floor and reached a **terminal REJECT (stale group)** on 2026-08-10T21:25:33Z; the PR is **closed**. Not a defect finding — the head fell 127 commits behind `llm` (CONFLICTING/DIRTY) and base `llm` had advanced `@earendil-works/pi-agent-core`/`pi-ai` to `^0.84.0` vs the PR's `^0.82.1`, so a merge would have partially reverted both manifests. The one-shot self-deleted on fire; no replacement npm-group PR has been opened yet (the watcher will auto-post when Dependabot regenerates the group). Nothing to unwire.

**Open set — exactly seven approval-held MERGE-NOW rows** (#867, #868, #912–#916). All re-verified this tick against live state:
- **CI terminal-green** at every (unchanged) head via `/check-runs` — 25/24/26/23/24/23/23 runs, 0 pending / 0 failed, matching the 08-10 sweep.
- **No supersession by the base.** Heads are 118–287 commits behind `llm`, so I re-censused the live base; every target (setup-node v7, paths-filter v4.0.2, cache v6.1.0, setup-python v7, action-gh-release v3.0.2, @noble/curves 2.2.0, eslint-plugin-unicorn 72) is still **ahead** of the base — none reached/passed, so none flips to REJECT-superseded. #868 remains CONFLICTING/DIRTY (needs a weave after approval).
- **Approval gate fails closed on all seven.** Ran the conductor spine's deterministic gate (`pr-maintainer-approval-gh.sh`) against each current head; all exit 1 ("no current APPROVED review on head"), `reviewDecision` empty, `autoMergeRequest=null`. **No merge or auto-merge was issued** — no terminal disposition was available.

**Wiring.** Daily backstop schedule `dependabotany-recheck-endo-but-for-bots` remains active (this job was its dispatch). No outstanding precise one-shot (a stale *paused* #868 one-shot from 08-02 stays parked and correctly does not fire). No schedule change needed.

**Recorded.** Posted the sweep to the ledger: `entries/2026/08/11/162510Z-message-gardener-98b82c.md`, confirmed recoverable by the canonical grep.

**Follow-ups (none actionable by this role):** the seven MERGE-NOW rows are blocked solely on a current maintainer approval — a human/liaison action, not a schedulable recheck. When Dependabot regenerates the npm `all-minor-patch` group that #923 held, the watcher will auto-post a fresh botanist job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260811-162001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 37 tokens (1365991 cached reads)
- Output: 15489 tokens
- Cost: $1.8037334999999999
- Wall-clock: 320s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
