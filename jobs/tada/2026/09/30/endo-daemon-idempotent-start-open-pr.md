The draft PR is open: https://github.com/endojs/endo-but-for-bots/pull/1387

- **Refs:** Before opening, I checked the refs with `git ls-remote`. `feat/daemon-idempotent-start` was at `b36b90d4b7c51cebc519fc964a58e42e4de8be09` and `llm-7ff30af` was at `7ff30afbce95f60d21ff3ae385bd9a17ed0850db`, as the job expected, so the head had not moved.
- **How it was opened:** I ran `ensure-pr.sh` from an isolated project checkout, using the original job base `endo-daemon-idempotent-start-build`. The title is "feat(daemon): idempotent start and an early single-instance state lock", and the body is the specified text, word for word.
- **Checked after opening:** The PR is a draft, its head is at `b36b90d4b7`, its base is `llm-7ff30af`, and its body carries the `<!-- garden-job: endo-daemon-idempotent-start-build -->` marker.
- **No code changes:** I changed no code, did not rebuild, and made no commits to main2.

**One thing to watch:** `ensure-pr.sh` warned that there is no `work/endo-daemon-idempotent-start-build` record on this host's board, so it did not write the PR number to that job's record. If the gauntlet staging looks that record up to find the PR, nothing may start automatically. In that case, post *run the gauntlet #1387*.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-daemon-idempotent-start-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168352 cached reads)
- Output: 2369 tokens
- Cost: $0.4244664
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
