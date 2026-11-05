Fix round 4 for kriscendobot/minion.town PR #240 is pushed and CI is green (7 checks, 0 failed).

**Blocking finding (spell-out-identifiers on `numRuns`):** I didn't rename it. `numRuns` is fast-check's own option name, so renaming it would break the property tests. Instead I put the repo's usual exemption header on the first line of `test/web/capability-url.test.ts`: `// spell-out-exempt -- \`numRuns\` is the fast-check parameter name.` Other test files that pass `numRuns` to fast-check already carry the same header, for example `test/deploy-accounts-store-backfill.test.ts` and `test/web/guest-web-socket-faults.test.ts`.
- Commit `34949faa`, pushed with `safe-push-pr-head.sh`, moving the head from `9e5669e0` to `34949faa`.
- The 68 tests in that file pass locally.

**Non-blocking warning (comment length, `deploy/aws/www/home.js:11`):** I kept the comment. The added lines are entries in the file's header list of what the landing page shows for each case. They say which fragment forms and paths (`#v=1&invitation=`, `#v=1&locator=` at /accept or /adopt) open the accept card. They also cover the new "malformed link" case, which shows an error without echoing the fragment. That isn't obvious from the code right next to it.

Prettier reports formatting issues in this test file, but it already did before my one-line change. The repo has no prettier or format script, so I left it alone.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr240-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (544857 cached reads)
- Output: 3196 tokens
- Cost: $0.5736433999999999
- Wall-clock: 370s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
