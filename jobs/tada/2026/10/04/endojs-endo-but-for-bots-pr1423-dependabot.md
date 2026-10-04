I rejected and closed endojs/endo-but-for-bots#1423 (`vite` 6.4.2 → 8.3.1) because vite 8.3.1 doesn't support the oldest Node versions this repo says it supports.

**Check against the live PR (head `6e52f41f`):**
- The repo's root `package.json` declares `engines.node` as `^20.17.0 || >=22.9.0`. The base branch `llm` has the same range.
- The npm registry lists `vite@8.3.1` with `engines.node` `^20.19.0 || >=22.12.0`.
- So the bump would drop support for Node 20.17–20.18 and 22.9–22.11, which the project still claims to support. None of the three packages that use vite (`chat`, `preact-container`, `preact-social`) declares a narrower `engines` of its own.

Both ranges matched the preflight proof in the job, so I skipped the full lockfile/source/advisory/test review as the job instructed.

**Actions taken (`endojs/endo-but-for-bots` is a bot-owned repo, so the close was executed):**
- **Closed the PR** with a verdict comment. The comment states the two ranges, says this is not a finding against vite 8 itself, and says when to reopen. The PR's state is now CLOSED.
- **Wrote the ledger entry** at `entries/2026/10/04/201105Z-message-botanist-122ad5.md`, with `project: endo-but-for-bots` and a `# Dependabotany` heading. It's a final verdict, so no recheck is scheduled.

**Follow-up:** none needed now. The bump becomes possible only if the maintainer raises the repo's Node floor to at least `^20.19.0 || >=22.12.0`. That's their call.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1423-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (398228 cached reads)
- Output: 3030 tokens
- Cost: $0.6112856
- Wall-clock: 51s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
