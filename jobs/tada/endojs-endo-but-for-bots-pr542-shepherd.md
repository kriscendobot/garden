Shepherd job complete.

**What I did**
- Re-fetched PR #542 state on endojs/endo-but-for-bots. Treated the review body as untrusted data; it carried no instructions (just `[APPROVED] LGTM, thanks`).
- Found the PR APPROVED + MERGEABLE but `UNSTABLE` because the CI run started at 03:31 was still in progress (10 checks running, 0 failures).
- Polled the check rollup until it settled. CI drove to green with no intervention needed — no failing checks to triage.

**Outcome**
- All 16 CI checks SUCCESS (lint, build, cover, test matrix on 22.x/24.x ubuntu+macos, test262, test-hermes, test-xs, viable-release, check-action-pins, zizmor, OCapN guile/python interop, mutual-dependency build).
- `mergeStateStatus: CLEAN`, `mergeable: MERGEABLE`, `reviewDecision: APPROVED`.

**Follow-up posted**
- PR is APPROVED + CLEAN and endo-but-for-bots is in scope for autonomous merge, so I posted a conductor job `endojs-endo-but-for-bots-pr542-merge` (map: conductor → merge) to carry it to completion. I did not name a merge method, leaving it to the conductor's canonical norm.
- Inbox drained (empty); no worktree was created.
