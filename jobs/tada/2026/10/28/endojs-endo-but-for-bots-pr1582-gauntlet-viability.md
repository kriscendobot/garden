**Gauntlet viability: endojs/endo-but-for-bots#1582: proceed**

PR #1582 ("ci: run Browser Tests on any base and pin runners to Ubuntu 24.04") is still open and in draft. It is based on the frozen base `master-ebc7904`, its head is `55f7733e`, and it was opened today (2026-10-28) by `retcon-endo-pr1349-20261028`. It holds the workflow edits split out of #1349, so #1349 now touches only `ses`, its docs and the browser tests.

Deciding question: Does current `master` (tip `6ee3fda7`) still lack all three changes (Browser Tests running on PRs to any base, the Browser Tests runner pinned to `ubuntu-24.04`, and the depcheck runner pinned to `ubuntu-24.04`) while #1349 still needs Browser Tests on its frozen `master-ebc7904` base? **Yes.**

Evidence:
- **Master hasn't picked up any of the changes.** On the current tip `6ee3fda7`, `browser-test.yml` still runs only on `pull_request: branches: [master]` and uses `runs-on: ubuntu-latest`. `depcheck.yml` also still uses `runs-on: ubuntu-latest`.
- **Nothing newer has replaced it.**
  - `llm` already pins depcheck to `ubuntu-24.04`, but its Browser Tests trigger is limited to `[master, llm]`, which still skips frozen `master-<sha>` bases. `llm` doesn't feed this master-based PR anyway.
  - The overlapping PRs the description names are all still open, and none target `master`: #1556 and #1578 are against `llm`, #1566 is against `llm-204ecd1`, and #1546 is against `llm-d5ac419`.
- **The reason for the PR still holds.** #1349 is open on `master-ebc7904`, and Browser Tests never run on frozen-base PRs, which matches the known gap recorded in memory. Playwright 1.60.0 doesn't support the Ubuntu 26.04 image that `ubuntu-latest` now resolves to, and newer Graphviz packages drop `tred`. Both are why the runners are pinned.
- **The change is small.** It touches only two workflow files (+7/−3), and the PR has no comments or reviews yet.

Follow-ups: none. If #1556/#1578 or #1566/#1546 reach `master` first, only the trigger change remains here, as the PR description already says.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1582-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (121264 cached reads)
- Output: 1547 tokens
- Cost: $0.4124968
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
