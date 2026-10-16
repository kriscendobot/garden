The panel round finished with a **must-fix** verdict, but I couldn't post it: this host's bot token is refused write access to endojs PRs. I'm completing with `panel-error` so the driver re-runs this round on a host that can post.

**What ran**
- I made an isolated checkout of the PR head `endojs/endo-but-for-bots@build/ocapn-noise-session-reconnect-rekey` at `da167ac38`. The base is `build/ocapn-noise-session-queue-2a16357`.
- I ran `panel.sh` with `GARDEN_PANEL_SINGLE_ROUND=1`. All 33 seats returned ok, and the last line was `code-panel single-round — must-fix`. The run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1481/4fe3dfdbf4d1.md`.
- Seat verdicts:
  - **Request changes (11):** assessor, packager, curator, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, pruner, corner-prober.
  - **Comment only (12).**
  - **Approve (9).**
  - **No verdict line (1):** warden.
- The main must-fix finding, from the assessor: when the responder resumes while its old instance is still attached, frames can be delivered twice. In `network.js`, the received-frame count is read before `await writeSessionHello`, and the old instance is only detached after that await, so frames arriving in between get replayed.

**Why nothing was posted**
- The full aggregate is 97 KB, over GitHub's 65,536-character limit for a review. I split it into a 57 KB review body (all request-changes seats first) and a 40 KB continuation comment.
- Both posts failed with `Resource not accessible by personal access token`, on `addComment` and on `addPullRequestReview --request-changes`. This is the known problem in memory `bot-pat-no-pr-write-endojs`: the token on `oros-studio-garden-ce242c49` lacks write access to pull requests on endojs.
- That memory says to use `panel-error` in this case so the retry lands on a capable host. A `must-fix` marker would claim a review exists that doesn't.

**Follow-ups**
- I added this PR #1481 occurrence to the memory file.
- The retry may re-run all the seats rather than reuse these verdicts, because the panel record is keyed by this host's checkout name.
- The split review bodies are in `/Users/dom/garden/scratch/tmpexec/p1481/` on this host (temporary).
- The lasting fix is to give the bot's fine-grained token read and write access to pull requests on endojs.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1137409 cached reads)
- Output: 6832 tokens
- Cost: $0.8366338
- Wall-clock: 903s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
