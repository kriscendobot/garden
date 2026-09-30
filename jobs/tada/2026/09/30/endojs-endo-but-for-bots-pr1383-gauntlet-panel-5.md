Panel round 5 on endojs/endo-but-for-bots PR #1383 ("docs(designs): daemon lifecycle idempotency") came back **must-fix**, and the verdict is posted on the PR.

**How it ran:**
- Reviewed head `984880f7ad` in its own project checkout, against the pinned base `llm-7ff30af` (`7ff30afbce`).
- I ran `panel.sh` in single-round mode and it exited 0. All 10 seats finished without error.
- The ownership-map check flagged the change, so the decomplector seat was added. A check on the PR description's length added the pruner seat.

**Seat verdicts:**
- **Request changes (6):** critic, skeptic, decomplector, copyeditor, novice, pruner
- **Comment only (2):** ergonomist, pedant
- **Approve (2):** orthographer, thesaurus

**Main must-fix findings:**
- **Critic:** the design treats the `endo.lock` owner record (pid, start time, socket path) as the only safeguard against two daemons running at once. It never says whether that file is written atomically, or what happens when it's malformed or half-written. That can undo the design's main promise.
- **Novice:** §1 relies on the five owner-state values (`live`, `booting`, `elsewhere`, `stale`, `absent`) before §2 defines them. The pointer to §2 lands about 90 lines before the actual definition.
- **Pruner:** the PR description repeats "Documentation only; no …" six times. It should be merged into one statement.
- **Critic (should-fix):** `stop` can shut down a daemon serving a different socket than the one asked for, and it prints no message in that case.

**Posting:** GitHub rejected a request-changes review because the bot can't request changes on its own PR. So I posted a COMMENT review marked `<!-- garden-panel-verdict: must-fix -->`, the same way rounds 1–4 were posted. As instructed, I didn't fix anything or take the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (510348 cached reads)
- Output: 2633 tokens
- Cost: $0.5421376
- Wall-clock: 253s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
