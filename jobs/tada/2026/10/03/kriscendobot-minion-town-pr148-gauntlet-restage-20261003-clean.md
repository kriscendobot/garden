The clean stage is done for kriscendobot/minion.town PR #148 (still a draft): I added two tests and CI is green on the new head `8ea1b79`.

- **Where it started:** CI was already green at head `6f604ae`, but no clean stage had ever run. The earlier gauntlet halted at its viability stage after running out of retries.
- **Coverage pass:** I ran coverage on the code the PR touches. Most of `src/endo/claude` is around 90% or higher. The weakest new file was `src/endo/claude/cli-deployment.ts` at 58%: two of its startup refusal paths had no tests.
- **What I pushed:** commit `8ea1b79`, "test(claude): cover the CLI seams' shape-file and agent-MCP refusals". It adds tests in `test/claude-cli-deployment.test.ts` for two cases: a response-shapes file that doesn't parse, and an Endo checkout without the agent MCP package. Coverage of `cli-deployment.ts` went from 58% to 67%. The remaining untested lines (171–229) are the success path, which needs lockdown and a live daemon; the existing test file deliberately avoids both, so I left it alone. Type-check and Prettier pass, and I pushed with `safe-push-pr-head.sh` (fast-forward from `6f604ae`).
- **Dead code:** none found. The PR deletes `captp-client.ts` together with its test, and nothing else refers to it. Every export with no outside users is still used inside its own file.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0 with all 3 checks passing at `8ea1b79`.

**Follow-ups:**
- `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent") fails on this host. This PR doesn't touch that code, and I'm treating it as the git-remote failure already noted as a quirk of this host's environment.
- `cli-provider.ts` has only 62% branch coverage. A later fix round could add tests there.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1092427 cached reads)
- Output: 7911 tokens
- Cost: $0.8713053999999999
- Wall-clock: 482s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
