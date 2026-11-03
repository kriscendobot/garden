I opened the draft PR **https://github.com/endojs/endo-but-for-bots/pull/1640** for the `endopi-prompt-templates` build. This job relayed the request from oros-studio-garden-ce242c49, whose bot token is refused when it tries to open a PR on endojs.

- **Before opening:** a `--find-only` check found no existing PR with the `garden-job: endopi-prompt-templates-build` marker, so there was nothing to adopt.
- **How it was opened:** I ran `ensure-pr.sh` from a project checkout pinned at head `be54e6b8332`, using job base `endopi-prompt-templates-build`, the given title, and the PR body exactly as supplied. The job named a `/Users/dom/garden` path from the other host; I used the same script on this host. The design-evidence check passed. It warned about one body heading, "Departures from the design", that the PR template doesn't list; that is allowed.
- **Checked afterwards:** the PR is a draft, its head is `be54e6b8332202bf4af372c4b1cd4f1bd264e07d`, and its base is `llm-48d6f3e`. I did not touch either branch.

**Follow-up:** `ensure-pr.sh` did not link PR #1640 to `endopi-prompt-templates-build` on the board, because that job was claimed on another host and has no record here. Whatever stages the gauntlet when a builder job completes should pick #1640 up from this report or from the marker in the PR body. If it doesn't, post a "run the gauntlet #1640" job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endopi-prompt-templates-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (303551 cached reads)
- Output: 3851 tokens
- Cost: $0.5248982
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
