## Fix round 1 for kriscendobot/minion.town#188: fixes pushed, CI green

I applied the panel's round-1 fixes (review on 7b73dec) as a single follow-up commit, **d2d7ff6**, pushed to `clip-gutter-live-refresh`. `ci-wait-merge.sh --no-merge` returned rc 0: all 3 checks passed.

**What changed:**
- **A refresh no longer reloads the clip pane** (assessor, migrator, breaker, purist, corner-prober). The new `applyClipListing` function selects the clip again only if the selected clip or its record changed. A focus or tab-switch refresh with unchanged data no longer resets `frame.srcdoc`. A renamed clip still re-renders.
- **Only temporary failures keep the old list** (corner-prober, purist, breaker). `makeClipSource.load` returns `null`, which keeps the last list, only on network errors and 5xx. A 401, 403 or 404, a redirect, or a non-JSON body (a sign-in page) returns `[]` and clears the gutter, which fits the account-isolation rule in design § 3. Each status has its own test.
- **Auto-select happens only on the first successful load.** After that, a refresh can't replace an empty pane with `clips[0]`. `clipSelectionAfterRefresh` now takes a `mayAutoSelect` flag, and the JSDoc matches what the code does. A multi-step test covers it.
- **Selection race:** a selection counter now drops any listing that was still loading when the user picked a clip, and loads it again.
- **Wiring test:** I moved the trigger wiring into `wireClipRefreshTriggers` and tested it by dispatching click, focus and `visibilitychange` events, replacing the source-substring checks. The tests now wait with `setTimeout(0)` instead of counting microtask ticks.
- **Prose fixes:**
  - Made both of pruner's cuts.
  - Fixed the out-of-date "add button kept last" comments.
  - Changed the ↻ button label to `&#8635;` (typist).
  - Updated the design-doc paragraph to match the new failure handling.

**Checks:**
- `test/shell-clip.test.ts`: 39/39 pass.
- `tsc --noEmit`: clean.
- Full `npm test`: 1128 passed, 1 failed. The failure is `test/git-remote/capability.test.ts`, in code this PR doesn't touch. I didn't check whether it also fails on the base branch, so I can't confirm it predates this change. It didn't fail in CI.

**Follow-up:** none from this stage. The driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr188-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (942992 cached reads)
- Output: 13467 tokens
- Cost: $1.0972743999999999
- Wall-clock: 933s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
