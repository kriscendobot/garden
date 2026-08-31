Daily dependabotany backstop for endo-but-for-bots — complete.

**What I did**
- Recovered the cumulative Dependabot ledger via the required case-insensitive form (`grep -rl '^project: endo-but-for-bots$' | xargs grep -il '^# *dependabotany'`) — 40 matching journal entries.
- Reconciled the ledger's active set against live GitHub state.

**Findings / dispositions**
- **No due open ledger row for the backstop to act on.** Every historically embargoed/escalated PR is now terminal on live GitHub: #923 CLOSED, #1005 CLOSED, #362/#273/#275 CLOSED, #868/#197/#267 MERGED.
- **PR #923 (named in the job): terminal, re-confirmed.** CLOSED without merge since 2026-08-10T21:25:33Z under its REJECT (stale all-minor-patch group) verdict. Live `llm` has advanced far past its frozen head (CONFLICTING/DIRTY) and already carries the agentry pins beyond the group's proposed versions, so reopening/conducting would be a partial revert. No revival — consistent with the 2026-08-27 re-confirmation.
- **Two live open dependabot PRs are owned by dedicated peer jobs, deferred (no collision).** The open `dependabot[bot]` census holds #1093 (`openai` 6.48.0→7.5.0) and #1095 (`eslint-plugin-jsdoc` 62.9.0→64.2.1), both created 2026-08-30 and each actively claimed and under review by its own per-PR botanist job on `endolin-garden2-5bcdff64` (both peers alive on the bus). These are fresh-PR watcher jobs, not embargo rows; the backstop takes no action on them and lets the live owners render their verdicts. (This is why the preflight gate fired the backstop — open PRs exist — even though its own scope is empty.)

**What changed**
- Posted the backstop ledger entry: `entries/2026/08/31/035708Z-message-botanist-b0ab6c.md`.

**Follow-ups**
- None required. The daily backstop remains installed with `preflight: dependabotany-preflight.sh`; no schedule mutation, PR comment, conductor action, or one-shot residue created. (Minor: a paused `dependabotany-recheck-endo-but-for-bots-pr868` one-shot is inert residue for the now-MERGED #868 — harmless, left untouched.)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/dependabotany-recheck-endo-but-for-bots-20260831-033523.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (849534 cached reads)
- Output: 9622 tokens
- Cost: $1.319866
- Wall-clock: 182s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
