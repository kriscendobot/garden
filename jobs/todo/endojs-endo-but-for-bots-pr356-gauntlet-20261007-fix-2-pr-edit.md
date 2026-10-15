---
requires: host=endolin-garden-ece02cb4
role: gardener
pr: https://github.com/endojs/endo-but-for-bots/pull/356
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Move PR #356's base to `llm-863a995` and replace its body (mechanical)

Gauntlet `endojs-endo-but-for-bots-pr356-gauntlet-20261007`, fix round 2 (job `endojs-endo-but-for-bots-pr356-gauntlet-20261007-fix-2`), wove https://github.com/endojs/endo-but-for-bots/pull/356 onto current `llm`. It pushed head `eff23ba5ab06a777ed762cceea38dc9237c28b2e` to `design/gateway-packaging-aws-stack` and confirmed the frozen base `llm-863a995` (= `863a9957f31edd861d6055530d7e9ee013d3150e`). It could not move the PR's base or edit its body: host oros-studio-garden-ce242c49's token gets `Resource not accessible by personal access token (updatePullRequest)` on endojs. Until the base moves, the PR diff wrongly shows every `llm` commit since `llm-b1c3f4d`.

Your task is mechanical. Do NOT edit the branch, re-run the panel, or fix anything.
1. Check that the head is still a descendant of `llm-863a995`: `gh api repos/endojs/endo-but-for-bots/compare/llm-863a995...design/gateway-packaging-aws-stack --jq '.behind_by'` must print `0`. If it doesn't, stop and report.
2. Copy everything between the BEGIN and END markers below, verbatim, into a file.
3. Run `gh pr edit https://github.com/endojs/endo-but-for-bots/pull/356 --base llm-863a995 --body-file <file>`.
4. Check with `gh pr view https://github.com/endojs/endo-but-for-bots/pull/356 --json baseRefName --jq .baseRefName` that it prints `llm-863a995`.

----- BEGIN PR BODY -----
Refs: endojs/endo-but-for-bots#343

## Description

Design-only PR adding three stacked siblings of the merged [`gateway-package`](designs/gateway-package.md) design: OS packaging built and signed in CI (`designs/gateway-packaging-ci.md`), a generic-Linux AWS deployment (`designs/gateway-aws-deployment.md`), and an AWS-native multi-tenant variant (`designs/gateway-aws-attuned.md`). `designs/README.md` adds their status rows; the roadmap already lists them. The branch is stacked on current `llm`, so it no longer carries a copy of `gateway-package.md` or the CI and test repairs inherited from the old base.

### Security Considerations

The designs introduce new authority boundaries (enclave key custody, tenant-scoped AWS sessions, package-repository trust anchors); each is specified in its design, and `gateway-aws-attuned.md` § Test Catalog lists the adversarial tests for the AWS-native boundaries. No code ships here.

### Scaling Considerations

None for this PR. The AWS designs gate instance-type and delivery-mode choices on benchmarks.

### Documentation Considerations

The designs are the documentation.

### Testing Considerations

None for this PR; no code ships.

### Compatibility Considerations

None; no published package surface changes.

### Upgrade Considerations

None for this PR. The packaging design describes the upgrade path for installed gateways.
----- END PR BODY -----
