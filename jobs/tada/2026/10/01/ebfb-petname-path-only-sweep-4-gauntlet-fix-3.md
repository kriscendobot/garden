# Fix round 3 report: endojs/endo-but-for-bots#1390

I pushed nothing in this round. Five fix commits (`45efa290a7` through `4427342873`) were already on the PR head and cover every must-fix item from the round-3 review (5374655419) and from the later review 5375072125, which lists the same items. Those commits landed after the panel's head `784decdc7a`. After two flaky reruns of one macOS test leg, CI on head `4427342873` is green: `ci-wait-merge` returned rc=0, with 33 checks and 0 failures.

**How each must-fix item stands at head `4427342873`:**
1. **typist:** `container-mounts.js` now passes `[journalName(sequence)]`. The floot test fakes, along with the agent and dev-review call sites, accept only string arrays.
2. **locksmith:** The `.split('/')` calls that this PR added to `spaces-util/src/command-executor.js` (resolve, post/reply, endow, evaluate, invite, accept, provideHost/provideGuest) and the three in `chat.js` now wrap the name as one segment. The 25 `.split('/')` calls still in the file are the same 25 that are on base `llm-8e53cc0`, so this PR did not add them.
3. **surfacer:** `types.d.ts` now names these parameters `workerNamePath`, `resultNamePath`, `archiveNamePath` and `correspondentNamePath`. One old name remains, `MakeCapletOptions.resultName`, which is an options-record key rather than a method parameter.
4. **stylist:** In lal's `mail.js` and `tool-dispatch.js`, `petNames` is now `petNamePaths`. The `help.md` and `help-text-data.js` headers now read `recipientNamePath` and `responseNamePath`.
5. **integrator:** The PR body names the overlap with #1343, gives the landing order and rebase plan, and says the PR is not a phase of `designs/fs-interface-consolidation.md`.
- **Should-fix:** The `lookup`/`maybeLookup` exemption in `interfaces.js` now has a comment. I left `@endo/agent-tools` `evaluate-tool.js`'s `resultName` as it is, because renaming it would change that tool's public argument schema and the panel rated it should-fix only.

**CI:** The `test (22.x, macos-15)` leg failed twice, on a different test each time:
- **First run:** `daemon-teardown › an orphaned daemon shuts itself down`.
- **Second run:** `chat › inventory-component › two-step cancel … cancel button rendered`.

Neither test file is in the PR's diff (nor is the inventory component it exercises), and both tests passed on the other three legs. The second attempt also got past the daemon-teardown failure, so I treated both as timing flakes and reran only the failed job. The third attempt passed.

**Follow-ups:**
- The PR body states the #1343 overlap twice, in two slightly different paragraphs. It reads fine but could be trimmed.
- The 22.x macOS leg is flaky on two tests: the daemon-teardown orphan test and the chat inventory cancel-button render.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 50 tokens (1721111 cached reads)
- Output: 8728 tokens
- Cost: $1.1287742 (1 engagement(s) unpriced)
- Wall-clock: 11014s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
