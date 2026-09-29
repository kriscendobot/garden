**Gauntlet viability for endojs/endo-but-for-bots#1383: proceed**

PR #1383 is a draft design PR, "docs(designs): daemon lifecycle idempotency". It is open and unmerged. Head is `414af7744b`, base is `llm-7ff30af`. It adds `designs/daemon-lifecycle-idempotency.md` and a line in the `designs/README.md` index.

Deciding question: Does `llm` still lack idempotent daemon lifecycle controls, with no newer design or implementation already covering them?

Answer: yes. The PR is not superseded, and the problem it describes still exists.

Evidence:
- **No newer base history.** The PR was opened today at 22:47Z, about 50 minutes before this check. Its frozen base `7ff30afbce` is exactly the current tip of `origin/llm`, so nothing has landed on `llm` since the PR was made.
- **The defects are still in the code.** `packages/daemon/index.js:792` still calls `await clean(config)` inside `start` without first checking whether a daemon is running. Nothing under `packages/` mentions `ENDO_NO_AUTOSTART`, so there is still no way to turn off CLI auto-start.
- **No competing design.** The only related design on `llm` is `designs/daemon-engo-supervisor.md`, a Go supervisor rewrite marked "Not Started" that does not deal with idempotent start/stop. A GitHub search for other daemon lifecycle, idempotency or autostart PRs found none that overlap. The closest is #1107, which makes iroh netlayer setup idempotent, a different part of the daemon.
- **The motivation still holds.** The PR responds to kriskowal's request on kriscendobot/minion.town#117 for idempotent daemon start/stop. It also covers the workarounds in minion.town#130 and #137. #137 is the fix for the minion.town daemon crash-loop caused by a stray process holding its port, and it recurred three times on 09-28/29.
- **Nothing has been posted on the PR yet.** It has no comments and no reviews.

GitHub's REST API was over its rate limit during this check, so I could not list recent commits through the API. I checked `llm` with `git fetch` in a job-isolated project checkout instead.

Nothing was changed. No clean, panel, fix or CI budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (210007 cached reads)
- Output: 2132 tokens
- Cost: $0.40859339999999994
- Wall-clock: 41s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
