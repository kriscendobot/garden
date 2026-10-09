Panel round 4 on kriscendobot/minion.town PR #166 came back **must-fix**. The verdict is posted on the PR.

**What I did**
- Made an isolated checkout of the PR head `525596d` (`feat/prod-objectives-probe`) at `scratch/project-wt-kriscen-ce557790dfc8-e051010f`. The base is `main-50aa690` (`50aa690`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 166 origin/main-50aa690`. It exited 0 with `panel #166: code-panel single-round — must-fix`.
  - All 33 seats returned ok: 1 request-changes (pruner), 18 comment-only, 14 approve.
  - My first launch was stopped early and rerun detached. Some seat files are timestamped before the rerun, but the round's recorded head is `525596d`, so the verdict applies to the current head.
- Posted the verdict as review 5467229206 on commit `525596d`, in the same layout as earlier rounds: header, must-fix list, should-fix highlights, then per-seat reports.
  - It went up as a comment, not request-changes, because GitHub refuses request-changes on the bot's own PR. Rounds 1–6 and the earlier rounds of this gauntlet were posted the same way.
  - The full aggregate is 85 KB, over GitHub's 65,536-character limit, so I shortened each seat's report to fit (61.5 KB posted). Each shortened report ends with a note that the full text is in the panel-run record.

**Must-fix (pruner, concision):** delete comments that restate the code or repeat facts stated elsewhere:
- `prod-probe.yml:32` and `:48`
- in `prod-objectives.mjs`: the SDK note at `:366`, the two "summary is public" reminders at `:363` and `:420`, and the header paragraph that repeats what the workflow already says
- the first sentence of `cache-policy.ts:3`
- in `DEPLOYMENT.md`: list the headers and directives in each check-table row instead of repeating them, and trim the detail at `:1460`

**Notable should-fix (not blocking):**
- The probe needs Node 22.18 or later, but `package.json` `engines` still allows `>=22.15.0`.
- `HARD_CACHE_MAX_AGE` is parsed back out of a string. If the parse fails, the one-year cache check passes any `max-age`.
- An operator note names the secrets `MINION_PROBE_CC_*`, but the workflow and docs use `MINION_PROBE_CLIENT_CREDENTIALS_*`. Unless that's reconciled, the strict scheduled runs will go red.
- No completion-summary comment has been posted for head `525596d`.

No garden-repo changes. My inbox couldn't be read because the journal clone timed out after 300s, so any message sent to this job during the run went unread.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1411290 cached reads)
- Output: 8459 tokens
- Cost: $0.974166
- Wall-clock: 800s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
