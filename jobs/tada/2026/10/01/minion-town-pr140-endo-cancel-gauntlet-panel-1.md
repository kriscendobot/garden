The panel ran round 1 on kriscendobot/minion.town#146 and found **must-fix** issues; I posted its review on the PR.

**Panel run**
- I set up a separate checkout of the PR branch `build/claude-infer-endo-cancel` at head `7c6a302`. The base branch is `main-af7af61`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against it. It exited 0 with disposition `must-fix`. The panel record is in the journal at `panel-runs/kriscendobot-minion.town-146/677588ce0f46.md`.
- Of the 33 seats, 2 voted request-changes (warden, corner-prober), 14 comment-only and 17 approve.

**Must-fix items**
1. **The cancel kit isn't hardened (warden).** `src/endo/cancel-kit.ts:74` uses `Object.freeze`, which leaves the `cancelled` promise unfrozen. That promise goes to `exo.infer` at `src/endo/claude/agents.ts:611`, and a guarded or CapTP boundary will reject it. `@endo/harden` is already a dependency and works without `lockdown()`, so the PR's stated reason for not using it doesn't hold. The fix is to wrap the kit with `harden`, pass `context.harden({ cancelled })`, and correct the "WHAT IS TRIMMED" note.
2. **The `cancelled` token now rejects where it used to resolve.** Nothing tests a provider that lets that rejection escape `infer`, which has a `finally` but no `catch`. The never-fulfills contract should also be documented on the option at `src/endo/claude/types.ts:237`.
3. **Missing boundary tests (corner-prober):**
   - teardown before `infer` reads the token, after it settles, and twice;
   - a falsy reason being silently replaced with `"Cancelled"`;
   - a parent cancellation only being seen after a microtask;
   - a child's reason still winning after a later parent cancel.

**Posting the review**
- The full aggregate is 78KB, over GitHub's 65,536-character limit for a review body. I posted a condensed version (about 60KB): a header with seat tallies and the must-fix list, the two request-changes seats in full, and the other seats' text until the limit. It lists the 13 seats left out and points to the journal panel record.
- It went up as a comment review, not request-changes, because GitHub refuses request-changes from the PR's own author (this bot). The body states the must-fix disposition plainly and ends with `<!-- garden-panel-verdict: must-fix round=1 -->`.
- The gh wrapper refused the first attempt for bare `#1015` and `#146` references. I rewrote them as `endojs/endo-but-for-bots#1015` and `kriscendobot/minion.town#146`.

**Follow-ups**
- Panel dispatch passes a base ref (`main-af7af61`) that doesn't exist in the project checkout, so warden had to diff against the raw SHA. Dispatch should create that ref or pass the SHA.
- The next-stage heuristic may expect a request-changes review. That can't exist on a bot-authored PR, so a comment review with the must-fix marker is the only option.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr140-endo-cancel-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1212946 cached reads)
- Output: 7294 tokens
- Cost: $0.8393652000000001
- Wall-clock: 823s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
