---
handed-off: minion-town-api-key-agent-panel3-fixes-20261105
deliverable-complete: false
---
orchestration-failed: true

**I applied no fixes and pushed nothing to kriscendobot/minion.town#244; a successor job owns the fixes.** I also left out the stage-result marker on purpose. The PR was closed unmerged at 00:15:46Z, about four minutes before I claimed this job, because its head `e66e75a257` had already reached `main` through `7e98920208`. CI can't verify a push to that closed head, so `fix=done` and the other two markers would all be false. The missing marker should make the driver halt this gauntlet, which is what a closed PR needs.

**Findings still on `main`:** I checked `7a0bcc9030` by reading the code, and ran no tests. `7a0bcc9030` only changed the UI default for subagent endowments, not the server-side issue. The surfaces are behind default-off flags, so production isn't exposed yet.
- **Provider replace route:** it doesn't validate `grantIds` or `agentIds` against the provider's attachments, and one agent can be moved twice.
- **Agent create:** it forwards arbitrary `endowments` names from the browser.
- **`delete()` type:** its return type doesn't match the sparse record the factory reports for a deleted agent.
- **Browser JSON:** `publicAgent` and `publicOption` pass nested remote values through unprojected.
- **`sendWake`:** it mints a new idempotency key on every attempt.
- **Create and reattach retries:** create rebuilds the retried payload from editable controls. The reattach dialog keeps its key the same way, but I didn't read its request code, so the builder should re-verify that half.
- **Identity-based authorization:** agent actions are still authorized from `iss`/`sub` through the factory's broad facet.

**What I did**
- **Successor job:** I posted `minion-town-api-key-agent-panel3-fixes-20261105`, confirmed in `jobs/todo` on origin. It's a builder job for a new PR off `main`, and it lists the findings and the should-fix items.
- **Maintainer message:** I asked whether the flags should stay off until the successor lands (I recommended yes). I also asked whether identity-based authorization is accepted or should move to per-agent capabilities; the successor must not build that unasked.

**Follow-ups**
- **Stray dead letter:** I sent a warning to `kriscendobot-minion.town-pr245-gauntlet-panel-4`, but that stage had already finished, so the message was dead-lettered (`20261105T002501Z-fb1ffd`). `garden-deadmail` may turn it into a small stray job, which can be closed once the point below is handled.
- **kriscendobot/minion.town#245 is in the same state:** it was closed unmerged, but its gauntlet is still running and is now at `fix-4`. Its fix stage can't verify anything either, so that gauntlet should be stopped, and its open findings need checking against `main`.
- **Driver gap:** `gauntlet.sh` checks whether a PR is closed only at the viability stage, so fix and panel stages keep running after a close. A state check before each stage would stop this. The fix stage also has no marker for a closed PR.
- **Unknown integrator:** the journal has no record of who integrated these commits or whether they knew about the open panel-3 verdict, so I asked the maintainer to weigh in.

<<<GARDEN-ORCHESTRATION-FAILED>>>
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr244-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (792372 cached reads)
- Output: 14277 tokens
- Cost: $1.1452223999999998
- Wall-clock: 368s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
