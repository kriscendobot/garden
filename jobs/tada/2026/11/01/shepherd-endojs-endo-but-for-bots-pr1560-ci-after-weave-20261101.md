**Shepherd report: endojs/endo-but-for-bots#1560 (`build/exo-agent-factory-core`)**

CI on #1560 is already green, so I pushed nothing.

- **Head:** `21d142af2d`, committed 2026-10-31T17:11Z. The PR is open, not a draft, and mergeable. Its base is `design/endo-child-agent-factory-dcf4d60`.
- **Checks on that head:** every check run passed or was skipped. Nothing failed and nothing is still running. The skipped ones are the ironhorse jobs, which are filtered out by changed paths.
- From #1560's side, the parked claude-api phase jobs (`claude-api-p3-minion-ui` … `claude-api-p7-migration` in `jobs/plan/`) can be promoted. I did not promote them myself; the liaison or maintainer decides that.

**The weave didn't fully land on the stacked PRs:**

| PR | Base branch | CI |
|---|---|---|
| #1625 | `build/exo-agent-factory-core-21d142a` (current #1560 head) | green: 11 passed, 23 skipped |
| #1561 | `build/exo-agent-factory-core-8c4a87e` (older #1560 head) | red: build, test (22/24 ubuntu), sandbox-drivers, cover (22/24) |
| #1563 | `build/exo-agent-factory-core-8c4a87e` (older #1560 head) | red: build, test (22/24 ubuntu, 24 macos), sandbox-drivers, cover (22/24) |

#1561's head is 50 commits behind #1560's current head. #1563 sits on the same older base, so it is behind too.

**Follow-ups posted** (no prior job for either PR was on the board):
- `weave-endojs-endo-but-for-bots-pr1561-onto-pr1560-20261101`
- `weave-endojs-endo-but-for-bots-pr1563-onto-pr1560-20261101`

Each one asks for a rebase onto the current #1560 head (`build/exo-agent-factory-core-21d142a`, the snapshot #1625 already uses), conflict resolution, a force-push with lease, a move of the PR base, and then CI driven to green. If any of p3–p7 need #1561 or #1563 green, hold them until those weaves finish.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1560-ci-after-weave-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (491204 cached reads)
- Output: 3771 tokens
- Cost: $0.5788768
- Wall-clock: 65s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
