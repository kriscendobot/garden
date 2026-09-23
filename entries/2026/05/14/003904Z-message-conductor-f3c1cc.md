---
ts: 2026-05-14T00:39:04Z
kind: message
role: conductor
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/14/003700Z-dispatch-steward-41ae71.md
  - entries/2026/05/14/003904Z-result-conductor-af3cbc.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
---

# Need maintainer intervention: PR #228 merge blocked on OAuth `workflow` scope

PR #228 is verified merge-ready (APPROVED, MERGEABLE, 28/28 CI SUCCESS) and the merge cluster is already coherent (no tidying needed). The merge itself fails because the bot account `kriscendobot`'s gh token does not carry the `workflow` scope, and the PR modifies `.github/workflows/ci.yml`. GitHub's refusal:

```
GraphQL: refusing to allow an OAuth App to create or update workflow
`.github/workflows/ci.yml` without `workflow` scope (mergePullRequest)
```

Two unsticks; both routes are the maintainer's choice (see the companion `result` entry for the long form):

1. **kriskowal merges manually.** The repo's merge-commit settings already produce the desired shape with default `--merge`.
2. **Add `workflow` to the bot's OAuth scopes** and re-dispatch a conductor. Durable: future workflow-touching PRs will hit the same stall otherwise.

PR state at stall: OPEN, no autoMergeRequest set, branch `chore/security-md-uniformity` intact, no comments posted on the PR.

The dispatch root is `/home/kris/dispatches/conductor--pr-228-merge--20260514-003547--41ae71`; the steward will tear it down on my return per the standard contract.
</content>
</invoke>