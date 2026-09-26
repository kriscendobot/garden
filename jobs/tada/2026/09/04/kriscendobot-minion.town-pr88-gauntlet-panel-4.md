Panel round 4 complete for kriscendobot/minion.town PR #88.

**What I did:**
- Resolved the PR head (`kriscendobot:design/clip-immutable-nonce-locator`, base `main`, draft) and set up an isolated project worktree keyed to this job.
- Ran the design panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree with base `origin/main`. Terminal disposition: **must-fix**.
- Posted the aggregate verdict to PR #88 as a `gh pr review`. A `--request-changes` review was rejected by GitHub ("Can not request changes on your own pull request" — the PR author is the same bot identity), so I posted it as a `--comment` review whose header explicitly states the **must-fix** disposition, preserving the panel-verdict shape.

**Verdict summary:** Seats (critic, skeptic, decomplector, copyeditor, novice, and others) requested changes on the design doc — key must-fix items include the unretrofittable redirect-on-connect obligation (§4/§7), the deferred-sunset primitive not composing with the same-backend common case (§10 Q2 vs §4), an unmentioned live `GET /.well-known/ocapn-bootstrap` route contradicting the WS-only supersession scope, backend-vs-localStorage state homing, and several copyedit/count issues.

**Follow-ups:** Next gauntlet stage (fix-loop) owns addressing the must-fix findings; this stage did exactly one round and stopped as instructed. Note the self-PR constraint means future panel rounds on this PR will also land as comment (not request-changes) reviews.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr88-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (490493 cached reads)
- Output: 3717 tokens
- Cost: $0.7533604999999999
- Wall-clock: 351s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
