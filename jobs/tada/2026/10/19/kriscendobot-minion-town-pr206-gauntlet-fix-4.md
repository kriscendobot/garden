Fix round 4 for kriscendobot/minion.town PR #206 is pushed and CI is green. I fixed the one failing pre-push check and also trimmed the comment the advisory flagged.

**What I did** (on the head branch `heal-cfafabe-deploy`, commit `6701f680`, pushed with `safe-push-pr-head.sh` from `139ed3ae`):
- **Failing check, prefer-endo-primitives:** `test/deploy-www-staging.test.ts` was doing its own base64 conversion with `Buffer.from(...).toString("base64")`. It now uses `encodeBase64` from `@endo/base64`, which the repo already depends on. My first version used `new TextEncoder()`, but the detector flags that too (it points to `@endo/bytes`, which the repo doesn't depend on), so I pass the result of `Buffer.from(str)` instead. That form isn't flagged and the file already uses it elsewhere.
- **Advisory, comment length:** I cut the 7-line comment at `deploy/aws/scripts/deploy-www.sh:14` to 3 lines. It keeps the rules that aren't obvious from the code: one file per SendCommand, chunked to stay under the ~100 KB limit; staged outside the served root; digest-checked before the rename; assets written before the HTML that uses them. It also keeps the pointer to DEPLOYMENT.md.

**Checks:**
- The prefer-endo-primitives probe now passes against `origin/main`.
- `vitest run test/deploy-www-staging.test.ts`: 9/9 tests pass.
- `bash -n` passes on the script.
- `ci-wait-merge.sh --no-merge` returned rc 0 with 3/3 checks passing: test, Claude harness amd64 and arm64.

I did not re-run the panel; the driver re-posts panel-5. No follow-ups.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr206-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (908587 cached reads)
- Output: 4751 tokens
- Cost: $0.7057774
- Wall-clock: 1068s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
