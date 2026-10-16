**Shepherd report: kriscendobot/minion.town PR #192** ("fix(deploy): install Node into a root-owned /opt/node tree")

**Result: CI is green on the current head. `next: none`.**

- **What failed:** The red run that triggered this job ([38899593882](https://github.com/kriscendobot/minion.town/actions/runs/38899593882)) was on the older head `bc97cca0`. One test failed: `test/install-node22.test.ts > install_node22 > clears staging left by an install that died midway`. It compared the `/opt/node` directory listing in whatever order it came back, so the result depended on filesystem order. The other 1149 tests passed.
- **Already fixed:** By the time I picked up the job, the head had moved to `0969cf9c` ("test(deploy): compare the /opt/node listing sorted and create it 0755"). That commit fixes this exact assertion. Its run ([38901166484](https://github.com/kriscendobot/minion.town/actions/runs/38901166484)) was waiting in line on the self-hosted `ci-minion-town` runner, which takes one job at a time.
- **What I did:** Waited in the foreground until the run finished. All three jobs passed: `test` (typecheck + vitest), `Claude harness (amd64)` and `Claude harness (arm64)`. I checked again afterwards: the head is still `0969cf9c` and that run is its only one, so nothing is still running or red.
- **Pushes and comments:** I pushed nothing. I posted no PR comment because the job didn't authorize one. No garden changes.
- **PR state:** Still a draft and `mergeable: true`. GitHub shows `mergeable_state: unstable`, but that came from a read I took while the run was still going.
- **Note:** This host's bot token is refused on the check-runs, commit-status and annotation endpoints, so I read CI state from the Actions runs and jobs API instead. This matches the known token limitation already in memory.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr192-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (574516 cached reads)
- Output: 3807 tokens
- Cost: $0.5331152
- Wall-clock: 726s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
