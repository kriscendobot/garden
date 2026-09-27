**Botanist report: endojs/endo-but-for-bots PR #1352 (`@lavamoat/allow-scripts` 3.4.3 → 5.1.0)**

**Verdict: REJECT (incompatible Node engine range). I closed the PR.**

**Checks on the live PR head** (`b143be1b0f2d`):
- The root `package.json` still declares `engines.node: "^20.17.0 || >=22.9.0"`, so the project's lowest supported Node version is 20.17.0.
- `npm view @lavamoat/allow-scripts@5.1.0 engines` returns `^20.19.0 || ^22.5.1 || ^24.0.0`. That drops Node 20.17.x–20.18.x, which the project supports. It also drops 23.x and 25+, which `>=22.9.0` allows.
- The current version, 3.4.3, declares `^16.20.0 || ^18.0.0 || ^20.0.0 || ^22.0.0 || ^24.0.0`, which covers the project's floor.
- The PR changes only `package.json`, `packages/familiar/package.json` and `yarn.lock`. Nothing unexpected there.

Both ranges matched what the job said, so I skipped the full review (lockfile, source, advisories, tests), as the job instructed.

**What I did:** `endojs/endo-but-for-bots` is bot-owned, so I ran `gh pr close 1352` and attached a verdict comment. The comment gives the evidence, says this is not a finding against 5.1.0's code or supply chain, and says how to reopen: raise the root `engines.node` floor to `^20.19.0` or higher, or wait for an allow-scripts release whose range covers the project's. I confirmed the PR state is `CLOSED`.

**Follow-ups:** None required. If the maintainer wants allow-scripts 5.x, the fix is to raise the root engine floor first, and after that Dependabot will propose the bump again.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1352-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172439 cached reads)
- Output: 1901 tokens
- Cost: $0.4330838
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
