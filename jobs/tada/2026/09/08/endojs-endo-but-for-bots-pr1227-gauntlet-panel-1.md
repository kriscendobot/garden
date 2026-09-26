Panel round 1 complete for PR #1227.

## Report

**Job:** PANEL stage, round 1, of the endojs/endo-but-for-bots PR #1227 gauntlet.

**PR under review:** `docs: design guest bot incarnation on mailbox delivery` (draft) — a single new design doc, `designs/daemon-guest-bot-incarnation.md` (+396 lines), head `d10ebb239` on `kriscendobot:design/endo-daemon-guest-bot-incarnation`, base `llm`.

**What I did:**
- Fetched an isolated project checkout of the PR head via `ensure-project-worktree.sh`.
- Fetched the upstream base SHA and computed the merge-base (`67dfc18b1c`) so the panel reviewed only the PR's own diff (avoiding the stale fork-copy-base pitfall).
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode (design-panel seats: critic, skeptic, decomplector, ergonomist, novice, orthographer, pedant, copyeditor). It aggregated and printed disposition **must-fix**.
- Posted the full aggregate on the PR as a review.

**Disposition:** `must-fix`. Notable request-changes findings: the skeptic flagged that a daemon restart silently grants a crash-loop-broken bot a fresh attempt (defeating the operator-only-retry guarantee), and a two-concurrent-consumers race when cancellation isn't awaited before clearing the supervisor entry; the decomplector flagged `getBotStatus` abandoning the discriminated-union discipline the rest of the doc uses.

**Posting note:** `--request-changes` is rejected by GitHub because the PR is authored by the same bot identity (`kriscendobot`) — "cannot request changes on your own pull request." I posted the aggregate as a `--comment` review instead (state `COMMENTED`, submitted 2026-09-08T19:26:14Z). This does not affect the gauntlet transition: the driver (`gauntlet.sh`) reads the `gauntlet-stage-result` marker from this completion report, not the PR review state, so the must-fix signal propagates to the next (fix) stage correctly.

**Scope discipline:** exactly one panel round; no fix, no un-draft, no loop.

**Follow-up:** the gauntlet driver will advance to `fix-1` on the must-fix marker below.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (832644 cached reads)
- Output: 6168 tokens
- Cost: $1.0563310000000001
- Wall-clock: 292s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
