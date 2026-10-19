I opened the PR as a draft: **endojs/endo-but-for-bots#1500** — https://github.com/endojs/endo-but-for-bots/pull/1500

- **Before opening:** `git ls-remote origin build/endo-gateway-mcp-termination` still showed `e7e63160d9eac20bec1cb68b0688c8400f478400`, and `llm-ca5aaef` was at `ca5aaefb2`. A `--find-only` run of `ensure-pr.sh` found no existing PR for job `build-endo-gateway-mcp-termination`, so there was no duplicate to adopt.
- **How it was opened:** I wrote the body exactly as given to a file and ran `ensure-pr.sh` from an `ensure-project-worktree.sh` checkout of the head, using the original job base `build-endo-gateway-mcp-termination` and the given title. The spec gave the script as `/Users/dom/garden/...`, but that path is not on this host, so I used `/home/kris/garden/scripts/jobs/gardening/ensure-pr.sh`.
- **Checked on GitHub:** the PR is a draft, head `e7e63160d`, base `llm-ca5aaef`, and the body carries the `<!-- garden-job: build-endo-gateway-mcp-termination -->` marker.
- **No code changed.**

**Follow-up:** `ensure-pr.sh` logged "no work/build-endo-gateway-mcp-termination record on the board", so it did not write #1500 onto the original job's board record. That's because this handoff job, not the original, holds the claim. Whatever stages the gauntlet should get the PR number from this report: **#1500**.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-gateway-mcp-termination-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (299723 cached reads)
- Output: 4229 tokens
- Cost: $0.5274126
- Wall-clock: 71s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
