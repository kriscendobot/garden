**PR #236, gauntlet fix round 3: every panel-3 must-fix item is applied, the fix is pushed, and CI is green.**

There was no deterministic pre-pass block in the job, so I worked from the latest panel verdict (review 5765643966). Its only jurors were pruner and releaser, both asking for changes.

**Pushed** to `feat/remote-invitation-hints` with `safe-push-pr-head.sh`, which fast-forwarded the branch from `280bacc6` to `823bf9d1`. The commit is `docs(guest): trim repeated invitation-policy prose; changeset names the operator remedy (#236)`.

Pruner fixes:
1. Removed the header paragraph in `src/endo/guest-locator.ts` that repeated the `servedInvitationLocator` JSDoc.
2. Shortened the Federation bullet in `DEPLOYMENT.md` to "Its node check is weaker; see `servedInvitationLocator`."
3. Cut the design's section 1 sentence that repeated section 5.
4. Rewrote the changeset's last paragraph to describe what users see instead of how the filter works (the releaser asked for the same fix).
5. Deleted the comment in `src/web/guest-web-socket-service.ts` that only restated the code below it.
6. Renamed the test group to `describe("unchecked hint content")`.
7. Dropped the four-step WebSocket plan from `DEPLOYMENT.md` § Served dialect and kept the one-sentence 503 warning.
8. Edited the PR body: the "What changes" section is now one line plus the 503 and 409 rules. The out-of-scope note, trial, evidence ledger and open questions are untouched.

Releaser fixes:
- The changeset now tells operators how to avoid the 503: set `ENDO_FEDERATION_ROUTES` to routes the deployment actually serves (it links `DEPLOYMENT.md` § Guest-locator federation).
- It also says existing guest locators don't need to be re-issued, because each reveal is filtered again.
- The releaser's other items were marked no change needed or optional.

**Checks:** locally, the locator and web tests passed (185 passed, 5 skipped) and `tsc --noEmit` was clean. On the PR, `ci-wait-merge.sh --no-merge` returned rc 0 with all 7 checks green and none failed.

**Follow-ups:** none from this stage. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1104575 cached reads)
- Output: 7808 tokens
- Cost: $0.9047070000000001
- Wall-clock: 456s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
