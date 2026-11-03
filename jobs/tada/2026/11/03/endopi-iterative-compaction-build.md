---
handed-off: endopi-iterative-compaction-build-open-pr
deliverable-complete: false
---
**The compaction is built and pushed, but the draft PR isn't open yet.** This host's PAT gets a 403 on `createPullRequest` for `endojs`, so I posted `endopi-iterative-compaction-build-open-pr`, pinned to `endolin-garden-ece02cb4`, to open it. Its completion report will name the PR, which stages the gauntlet. CI hasn't run on this branch, because there's no PR yet.

- **Head:** `feat/lal-iterative-compaction` at `c4ede16c7`, confirmed on `origin` with `ls-remote`
- **Base:** frozen `llm-48d6f3e`
- **Job:** in `jobs/todo` on `journal2`, with the full PR body embedded

## What changed
All of it is in `packages/lal`, plus the design doc:
- **Automatic compaction:** the new `compaction.js` follows Pi's algorithm. It triggers on `contextTokens > contextWindow - reserveTokens`, checked before a round and between tool calls. A provider overflow gets one compact-and-retry.
- **Summaries:** the cut point never separates a tool call from its results. Each structured summary builds on the previous one, so a session holds only one.
- **File tracking:** code keeps the cumulative files-touched list, so it survives even if the model leaves it out.
- **`/compact [instructions]`:** host-only; from any other sender it's ordinary mail.
- **Settings:** `LAL_COMPACTION_*` environment variables.
- **Docs:** README section, changeset, and a rewritten design Status section.

## Where this departs from the job and design
- **`packages/genie` no longer exists:** it was retired in `42bc7d516`, so I built in Lal, which is what the design's own Design section targets.
- **Step 4 (the JSONL `compaction` entry) isn't built:** Lal has no session file or entry ids yet, and that work is phase 4 of the JSONL design. Until it lands, elided messages are gone from worker memory, though the mail stays in the daemon. The PR body flags this as the main cost for review.
- **No settings store exists:** that's why the settings are environment variables.
- **Small context windows:** limits are clamped, otherwise compaction would fire every turn without freeing anything. Windows of about 56k tokens and up keep the design's values.

## Verification
- **Tests:** the Lal suite passes (226 passed, 1 skipped), and `tsc` for the package reports no errors.
- **Regression check:** I broke the code 18 ways, and the new tests caught every one.
- **Lint:** eslint has no errors on the changed code files, and the pre-push probes pass. Repo-wide lint wasn't run because it outlasts the tool limit here, so CI will be the first full lint.
- **Provider coverage:** no live provider was used; the end-to-end test runs against a local fake endpoint.

## Separate bug found
On `llm` at `48d6f3e`, `makePiAgent` drops `system` messages before the request, so the provider gets no system prompt or tools. I confirmed this with a scripted stream on the unmodified harness and against a local fake OpenAI-compatible endpoint. Lal workers probably can't call tools as a result, but I haven't tested that through a real provider.

This PR neither causes nor depends on the bug, so I posted `agentry-makepiagent-drops-system-messages-fix` to handle it, and I'd treat that as high priority.

## For review
- **Conflict with #1642:** both PRs add the same `isFromHost` check to `inbox-loop.js`, so whichever lands second has a small conflict to resolve.
- **Summary role:** summaries enter the transcript as `user` messages, and their "this is data" framing is advice to the model, not an enforced boundary. The PR body asks reviewers to look at this closely.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-iterative-compaction-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (6537534 cached reads)
- Output: 80917 tokens
- Cost: $4.749774800000001
- Wall-clock: 3652s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
