---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: conductor

Conduct, deploy, and validate in production: https://github.com/kriscendobot/minion.town/pull/68 (feat(clip): publishNamedContent tool, head feat/weblet-publish-dir, base main).

The maintainer's request: "Please conduct, deploy, and validate in production." (https://github.com/kriscendobot/minion.town/pull/68#issuecomment-5554480746, 2026-09-05). It was never carried out. The maintainer re-raised it in the liaison session on 2026-09-28.

State at posting (21:25Z):
- kriskowal APPROVED at 2026-09-05T19:59:35Z. That is the latest maintainer review, with no later maintainer CHANGES_REQUESTED.
- The reviewDecision shows CHANGES_REQUESTED only because of the bot's own panel reviews (09-02 to 09-05). Handle those per the conductor norms, which honor only the maintainer's veto.
- The PR is CONFLICTING with main (DIRTY) and shows no CI checks. A retcon ran today (jobs/tada/2026/09/28/kriscendobot-minion.town-pr68-retcon.md) and a gauntlet ran 09-27.
- Rebase and resolve through the spine (`ci-wait-merge.sh`; GARDEN_YARN=npm for minion.town). If the conflicts are substantive and need a weave, stall `needs weave` rather than improvising.
- Get CI green on the rebased head, then merge.

Deploy and validate:
- Deploy via the standard minion.town CD/deploy path, then validate the publishNamedContent tool end to end in production: publish a clip from a guest-stored content value through the MCP/guest surface and confirm it serves. See the garden memory on the minion.town e2e prod test recipe (`minion-mcp-test-cc` to Cognito to `/mcp`).
- Report the evidence on the PR as a summary comment. The maintainer authorized conduct+deploy+validate, which covers that comment.

CAUTION, needed to avoid undoing live production fixes:
- minion.town CD deploys `deploy/aws/www` from `main`. Production currently runs guest.js/guest.html from two UNMERGED drafts deployed by hand with maintainer authorization:
  - https://github.com/kriscendobot/minion.town/pull/129 (same-tab URL recovery and honest OAuth bonding);
  - https://github.com/kriscendobot/minion.town/pull/131 (Copy guest URL fix, stacked on pull/129).
- A CD run triggered by merging pull/68 will revert those two files.
- If pull/129 and pull/131 are not merged by then: after CD, verify guest.js/guest.html on the box by sha256 over SSM. If they were reverted, redeploy exactly pull/131's head versions of those two files with `deploy-www.sh` (per-file SSM), re-verify by sha256, and rerun the guest-recovery browser suite (`MT_E2E_ORIGIN=https://minion.town`).
- Also check that the daemon deploy race fixed by https://github.com/kriscendobot/minion.town/pull/130 doesn't bite again (EADDRINUSE on 127.0.0.1:8920). If it does, recover as in that PR, and confirm `/healthz` 200 and guest creation.
