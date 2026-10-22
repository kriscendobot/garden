Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1531 for the `endor run` form-override and `--cas-dir` slice. No code changed.

- **Branch check:** `origin/feat/endor-run-form-flags-cas-dir` is at `14af3028ae`, one commit on top of #1521's head `0300b55f9f`. Its merge-base with `origin/llm-f02cd81` is `f02cd81b22`. The branch had not moved.
- **PR:** opened through `ensure-pr.sh`, with the predecessor job's base as the first argument. The job's body text went in as written. I checked afterwards: it is a draft, head is `feat/endor-run-form-flags-cas-dir` @ `14af3028ae`, base is `llm-f02cd81`, and the body carries the `<!-- garden-job: build-endor-run-expanded-archives-directories-entry-points -->` marker.
- **Rate limit:** the first `ensure-pr.sh` run stopped with INCONCLUSIVE and did not create anything, because the bot's GitHub REST core quota was at 0/5000. I waited for the hourly reset (about 20 seconds away) and ran it again, and it went through.
- **Board record:** `ensure-pr.sh` noted there is no `work/build-endor-run-expanded-archives-directories-entry-points` record on the board, so the PR number was not written against the predecessor job. The gauntlet should stage from the PR URL in this report. If it doesn't, post it explicitly: "run the gauntlet #1531".

Follow-up: #1531 is stacked on #1521 and has to merge after it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-run-expanded-archives-directories-entry-points-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (462098 cached reads)
- Output: 3070 tokens
- Cost: $0.5215796
- Wall-clock: 81s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
