I applied all three must-fix items from the round 5 panel review on kriscendobot/minion.town#166 and pushed them as commit `4353d0b`. CI is green: `ci-wait-merge.sh --no-merge` returned 0, and all 3 checks passed (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`).

**What changed, by must-fix item:**
1. **Case-sensitive header comparison.** `isolationViolations` now compares COOP, COEP, `Origin-Agent-Cluster` and CORP exactly. Only `X-Frame-Options` and `X-Content-Type-Options` still ignore case. New tests check that `Require-Corp` and `Same-Origin` count as violations, and that `deny` / `NOSNIFF` still pass.
2. **`default-src` assumption.** The probe now throws when it loads if the floor's `default-src` is not `'self'`. The exemption for extra directives that allow only `'self'` or `'none'` relies on that value.
3. **Node floor.** The root `package.json` and `package-lock.json` now require Node `>=22.18.0`, because the probe imports `.ts` files directly and Node only strips types without a flag from 22.18. I updated the Node floor note in `DEPLOYMENT.md` to say why the root package and `tools/claude-harness/` (still `>=22.15.0`) differ.

**Tests:** the probe's offline suite passes 21/21 locally on Node 22.23.3.

**Push:** I used `safe-push-pr-head.sh` in its default history-preserving mode, which fast-forwarded 9572abf → 4353d0b.

I did not change the round 5 comment-only suggestion to replace the semantic CSP/Cache-Control checks with exact equality. That design choice is left to a later round or to the maintainer. As the job instructs, I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1092910 cached reads)
- Output: 5620 tokens
- Cost: $0.8227820000000001
- Wall-clock: 1938s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
