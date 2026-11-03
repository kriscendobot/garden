Panel round 2 on [PR #233](https://github.com/kriscendobot/minion.town/pull/233) finished with a **must-fix** result, and its review is posted. I did not fix anything or un-draft the PR.

**Pinned pair**
- Base: `c5c350442cc8fede797239418f8f08fb62530b6c`
- Head: `485bf557e1449cd77035e063d47cf6ae96a672fa` (`kriscendobot:garden/build-minion-town-mcp-guest-invite`). `git rev-parse HEAD` matched it, and the PR head was unchanged after the panel.

**Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. It gave one non-blocking warning: a 3-line prose comment at `src/endo/guest-control.ts:146`, flagged for the pruner to check.

**Panel:** `panel.sh` in single-round mode exited 0. The new-mechanism probe seated the decomplector, and the PR-body concision probe forced the pruner over the description.

**Review:** posted by `kriscendobot` at 2026-11-03T11:26:34Z on the pinned head, as a `COMMENTED` review because the PR is self-authored. It keeps the `Must-fix before merge` heading.

I only read the first 2,500 characters of the review, so these findings from the locksmith seat are not the full list. The review on the PR is the complete record for fix-2.
- **Must-fix:** `cancelInvite` authorizes by comparing owner identity (`src/web/local-invitations.ts:107-110`). The juror found no bypass today, but wants a held revoker capability instead and the `owner` field deleted.
- **Should-fix:** `InviteToolDeps` gives every session more authority than the tools need (`src/http.ts:436-444`).
- **Should-fix:** an outstanding MCP link outlives its inviter's admission. `acceptLocal` checks only the invitee, so a suspended guest's link still works and that guest can no longer cancel it.

**Follow-ups:** the driver routes this to the fix stage; this job posted nothing further.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr233-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (389338 cached reads)
- Output: 3499 tokens
- Cost: $0.5240076
- Wall-clock: 1387s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
