I applied all five must-fix items from the round-3 panel on kriscendobot/minion.town#183 and pushed them as four follow-up commits. The PR head moved from `eee6880` to `8faa77a`, and CI is green on all 3 checks (test, Claude harness amd64 and arm64).

**What changed:**
1. **Inbox responder (migrator):** a mailed prompt to a root-created agent gets a `needs-containment` refusal. The responder used to record that as the answer and dismiss the message. Now it logs a warning, writes nothing, and leaves the message in the mailbox. It does not send a reply to the sender: the responder has no way to reply, so the request staying visible in the mailbox is the only signal. New test in `test/claude-inbox-responder-caplet.test.ts`. `/_internal/claude/infer` still answers `needs-containment` as DEPLOYMENT.md describes; I did not change it.
2. **Gate docs (archivist):** the header comment in `prompt-origin-gate.ts` now matches DEPLOYMENT.md: guest-influenced paths to a root-created agent are refused by design until phase 6.
3. **`PromptOrigin` (curator/typist):** it is now declared once, in `types.ts`, and the other files import it from there.
4. **Root authorship (curator/decomplector/locksmith):** the registry and `inferRootAuthored` moved into `agents.ts`, and the function that registers an agent's root-authored `infer` is no longer exported. Only `makeClaudeAgent` can grant root authorship now. `guest-tools.ts` loads `agents.ts` with a dynamic import, because a static import broke three test suites that run without `@endo/init` (the same pattern `http.ts` uses). I dropped the unit test that called the registrar directly. The root-authored path is still covered end to end in `test/claude-agents-tools.test.ts`.
5. **Rename (integrator):** the comment in `credentials.ts` now names `secrets-credential-vault.ts` as the injected store.

I also made one should-fix: renamed `conn` to `connection` in the new secrets integration test (stylist).

**Local checks:** typecheck is clean. The full test suite gives 1067 passed and 1 failed. The failure is `test/git-remote/capability.test.ts > projectPartition > propagates a git failure`, in a file this PR doesn't touch, and it passes in CI.

**Not done:** the rest of the should-fix list (decomplector's simplifications, rollback/deploy ordering, the assessor's `closed.then`, the vendor-header and re-export items, pruning duplicate comments, commit-type and rewrap nits). I also didn't edit the PR body.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2940116 cached reads)
- Output: 16314 tokens
- Cost: $1.6226472000000005
- Wall-clock: 975s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
