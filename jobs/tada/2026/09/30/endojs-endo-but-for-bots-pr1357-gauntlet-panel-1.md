Panel round 1 on endojs/endo-but-for-bots#1357 (design PR "design(claude): back-fill inference backends from the minion.town experiments") returned **must-fix**, and the verdict is posted on the PR.

- **Run:** I ran `panel.sh` in single-round mode on an isolated checkout of `design/endo-claude-inference-backends`, compared against the PR's pinned base `llm-47f6965`. It exited 0 with disposition `must-fix`. All 9 seats completed without errors. A pre-check flagged that the design crosses ownership boundaries, so the decomplector seat (which looks for tangled responsibilities) was added.
- **Seat verdicts:**
  - Request changes: critic, decomplector, copyeditor, pedant.
  - Comment only: skeptic, ergonomist, novice.
  - Approve: orthographer, thesaurus.
- **Blocking finding (critic #1):** in § Subscription credentials under `--bare`, the `ANTHROPIC_API_KEY` row was tested with an OAuth `sk-ant-oat01-` access token, not a real API key. The table presents it as evidence about API-key behavior, which it isn't. The fix is to strike or relabel that row and list "real API key under `--bare`" as untested.
- **Other notable should-fix points:**
  - The `--bare` confinement claim was only tested with some of the flags.
  - Decision 5 calls a path "observed" that was never run with a real `setup-token`.
  - No verification gate covers `cancelled`.
  - `formulaIdentifier` sits inside the interface that carries authority.
  - The ownership-map summary leaves out the factory's retained-child ledger.
  - `limit-exceeded: budget` is classified as a runtime kill when it is really an admission refusal.
  - Smaller items: forward references to numbered Decisions, heading case, and a few prose fixes.
- **Review type:** GitHub refused a request-changes review because the bot account authored the PR ("Can not request changes on your own pull request"). I posted the full aggregate as a **COMMENTED** review instead (2026-09-30T00:07:06Z), headed "must-fix" and carrying the job marker. The marker line below is what tells the gauntlet driver the result.

No fixes were made and the PR is still a draft; the fix-loop stage owns the fixes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (717938 cached reads)
- Output: 3334 tokens
- Cost: $0.6595316
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
