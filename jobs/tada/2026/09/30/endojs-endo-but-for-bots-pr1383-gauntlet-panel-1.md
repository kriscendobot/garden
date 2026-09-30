PR #1383's round-1 panel ran and returned **must-fix**, but I couldn't post the verdict. This host's bot token gets a 403 when writing a review to endojs, so I'm completing with `panel-error` so the driver re-runs this round on a host that can post.

**What ran**
- I made an isolated checkout of the PR head `design/daemon-lifecycle-idempotency` at `414af7744`. The first-time dependency install took about 10 minutes.
- `panel.sh` (single-round, base `llm-7ff30af`) exited 0 with **must-fix**. 33 seats ran. Four requested changes (wire-watcher, engine-realist, integrator, archivist), 11 approved, and the rest were comment-only.
- The phase/evidence pre-pass returned `blocked`, which forced must-fix. The integrator seat showed this block is a false positive: `llm-7ff30af` doesn't resolve in the review checkout, and re-running the check against `7ff30afbc` gives `clear reason=design-only-diff`. The must-fix still stands on the seats' own findings:
  - **Must-fix:** the design has `stop` and stale-worker cleanup signal recorded pids without checking they still belong to an Endo process. A reused pid would be an unrelated process.
  - **Should-fix:**
    - The proposed lock change covers only `manager-node.js`; three other daemon entry points need it too.
    - The lock sits in the temporary runtime directory, but the database lives in the persistent state directory.
    - The existing 500 ms lock reclaim would steal the lock from a daemon that is still booting.
    - The design doesn't say how its two locks relate.
    - The `start` wait has no stated outcome when it times out.
    - The Dependencies table cites a superseded design.
    - The planned tests cover only happy paths.
    - The README index row fills in an Updated date and appears in only one of the README's tables.

**Why it wasn't posted**
- `gh pr review --request-changes` failed: `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This is the host limitation already in memory (`bot-pat-no-pr-write-endojs`).
- Per the job spec, a round whose verdict wasn't delivered is a sensor failure. Emitting `panel=must-fix` would claim a verdict that isn't on the PR.
- The panel's backup copy of this run also failed to save to the journal, because the journal lock stayed busy for more than 3 minutes. The retry will re-run all the seats rather than resume.

**Files (local scratch only, not durable)**
- Ready-to-post review body (summary plus the request-changes seats, about 20 KB): `/Users/dom/garden/scratch/tmpexec/garden-panel-project-wt-endojs--c7cbf36042d3-a50b8dfc-1383/review-final.md`
- Follow-up comment with the comment-only and approve seats (about 59 KB): `seats-comment.md` in the same directory.
- The full combined output is 76 KB, over GitHub's 65,536-character limit, so a retry will need the same split.

**Follow-ups**
- The retried round should run on a host whose token can write endojs PRs (an endolin host). The permanent fix is giving the bot's fine-grained token pull-request read and write on endojs.
- The panel should pass a base that resolves in the checkout (a commit or a fetched ref). An unresolvable base triggers the false `blocked` pre-pass, and several seats hit the same problem.
- The panel should split or trim an aggregate over 65,536 characters before posting.

No garden repo changes were made.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1292605 cached reads)
- Output: 8003 tokens
- Cost: $0.958029
- Wall-clock: 1641s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
