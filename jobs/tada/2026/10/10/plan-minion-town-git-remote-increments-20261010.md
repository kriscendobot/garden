## Completion report: plan-minion-town-git-remote-increments-20261010

I wrote a plan for the rest of the `minion-town-git-remote` arc and parked five increments, all stamped `--arc minion-town-git-remote`. Three can be drawn by the foreman now, and the other two are blocked on one of them. I built nothing.

**The brief is out of date on deployment.** It says increment 1 (kriscendobot/minion.town#86) is not deployed. It was deployed on 2026-09-29: `DEPLOYMENT.md` row 13 says so, and job `verify-git-minion-town-deploy` confirmed the service, the Caddy route, TLS and DNS. What that job skipped is the live push/clone test with a capability URL.

**Gaps found on `main` (c9a073c):**
- **Pushed content is never served.** A push records its content root in a file that nothing reads, so a push doesn't change what visitors see.
- **No Endo-directory binding.** Only the operator can create a partition or mint a URL. There is no guest power for it and no MCP tool.
- **No limits on pushes.** There are no caps on pack size, repo size or push rate.

**Plan:** `designs/minion-town-git-remote-plan.md`, pushed to main2 as 6021144b5fb.

**Parked plans:**

| # | Job | Role | Gate |
|---|-----|------|------|
| 1 | `minion-town-git-remote-live-validation`: run the skipped live push/clone/revoke test in production, then clean up | builder | deferred, drawable now |
| 2 | `minion-town-git-remote-push-caps`: configurable caps on pushes | builder | deferred, drawable now |
| 3 | `minion-town-git-remote-endo-binding`: a guest-held git power, modeled on `@sites`, that creates partitions and mints URLs, plus MCP tool names | builder | blocked on #2 |
| 4 | `minion-town-git-remote-served-clip-design`: a design PR on how a partition's pushed content gets served. It is reconciled with open PRs #88, #142 and #170. | designer | deferred, drawable now |
| 5 | `minion-town-git-remote-served-clip`: build what the approved design names | builder | blocked on #4 |

Increment 3 waits for the caps because guests shouldn't be able to create partitions before pushes are bounded. The arc goal is met once increments 3 and 5 have landed and been deployed.

**Other changes:** I updated the memory note `minion-town-git-remote-pr86.md` and its MEMORY.md line, which still said #86 wasn't deployed.

**Follow-ups:**
- Increment 1 changes production data, though only a test partition that it removes afterwards. Since supervisors now carry minion.town work, I parked it as an ordinary deferred job rather than holding it for the maintainer.
- Increment 4's design PR needs a maintainer decision before increment 5 can run.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/plan-minion-town-git-remote-increments-20261010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1154705 cached reads)
- Output: 10827 tokens
- Cost: $1.0402169999999997
- Wall-clock: 182s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
