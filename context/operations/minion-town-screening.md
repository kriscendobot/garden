---
created: 2026-09-29
updated: 2026-10-07
author: gardener
---

# minion.town PR screening by the proxy

The maintainer delegated the complete review-and-merge surface of
`kriscendobot/minion.town` to the supervisors for garden issues
[58](https://github.com/kriscendobot/garden/issues/58) and
[89](https://github.com/kriscendobot/garden/issues/89), choosing “Everything, no
escalations.”
The binding record is
`entries/2026/10/07/203746Z-message-gardener-a253b1.md` on `journal2`.
The proxy applies the deterministic gates; supervisors carry gauntlet, fixes,
un-draft, weave, and restack.
Every other repository, including Endo, keeps maintainer review.

## Arming (post-deploy, maintainer-visible)

The build ships **inert**. After the build is deployed to the leader, arm it once:

```sh
scripts/jobs/minion-town-screening.sh seed
```

`seed` writes two journal2 files in one CAS commit:

- the authorization entry `entries/2026/10/07/203746Z-message-gardener-a253b1.md`;
  and
- the JSON record `config/delegations/minion-town-pr-screening`, which binds that
  entry's SHA-256, schema 2, repository `kriscendobot/minion.town`, all bases,
  author `kriscendobot`, `status`, and three empty escalation lists.

`seed` is a no-op when a record exists, and it refuses after a revocation.
A missing, unreadable, digest-mismatched, or revoked record denies the delegation.
Denial falls back to ordinary maintainer approval. Journal push access is the
authority boundary; a PR body can never grant the delegation.

## Controls

| Command | Effect |
| --- | --- |
| `minion-town-screening.sh status` | Print the verdict (`active`, `paused`, or `denied: <why>`) and the record. |
| `minion-town-screening.sh pause [reason-file]` | Stop screening and delegated merges. Records `paused_by: maintainer`, which is never auto-resumed. |
| `minion-town-screening.sh resume` | Return a paused delegation to `active`, including after a screener pause. |
| `minion-town-screening.sh revoke <reason-file>` | Permanent tombstone `config/delegations/minion-town-pr-screening.revoked`. |

A human `CHANGES_REQUESTED` review blocks one PR. An APPROVED review still
triggers the ordinary `finalize` conductor.

## What one proxy tick does

`scripts/jobs/proxy.sh` runs `scripts/jobs/screen-delegated-prs.sh` as pre-pass 1d
on the leader every 5 minutes (`garden-proxy.timer`). The screener uses its own
journal clone (`$GARDEN_STATE/screening/journal`), and a failed tick is logged
without blocking the proxy. Logic lives in `scripts/jobs/screening/`
(`policy.py`, `driver.py`, `report.py`, `control.py`).

1. **Post-merge validation.** For each attested PR that merged, it finds the
   `deploy.yml` run for the merge commit. It records `deploy` and `health` on the
   attestation and closes the record as `validated`, `failed`, `superseded`,
   `closed-unmerged`, or `merged-no-deploy` (no run within 30 minutes).
2. **Pause and heal.** A failed deploy, or the MCP watchdog `down` after a green
   deploy (or not `ok` within 30 minutes of it), sets `status: paused` with
   `paused_by: proxy:screen`, adds the merge to `healing`, posts the fixer job
   `heal-minion-town-<sha7>`, and writes one maintainer notice. The heal fixer
   opens a forward-fix or revert PR carrying `<!-- garden-heal: <merge-sha> -->`.
3. **Auto-resume.** A screener pause returns to `active` once a `main` deploy that
   started after the pause succeeds and the watchdog heartbeat after it is `ok`.
4. **The screen.** For each open PR on any base, at its exact head:
   1. scope: author `kriscendobot`, readable base, open, not draft, and not a
      probe by PR-body (`gap-revealing`, `kind: probe`, `verb: probe`, or
      `<!-- garden-probe -->`) or gauntlet/job marker;
   2. while paused, only a heal PR whose marker names a merge in `healing`;
   3. CI terminal-green with at least one check (no checks, pending, or red waits);
   4. no human whose latest review is `CHANGES_REQUESTED` (bots and `kriscendobot` excluded);
   5. the compare response is complete (fewer than 300 files);
   6. a completed feature gauntlet whose `panel_head` is this head, or a head
      whose merge-base patch is identical with hunk offsets erased (a clean
      rebase). With an in-flight gauntlet it waits; otherwise it records a
      head-keyed gauntlet `kriscendobot-minion-town-pr<N>-screen-<sha8>-gauntlet`;
   7. landing base: live `main` or a frozen `main-<sha>` base that the conductor
      can unfreeze. A child still based on its parent's head waits for the parent
      merge and a weave/restack;
   8. production baseline, skipped for heal PRs: the latest `main` `deploy.yml`
      run completed green, and the leader's watchdog heartbeat
      (`$GARDEN_STATE/minion-mcp/heartbeat.json`) is `ok` and under 30 minutes old.

   A pass writes `screenings/kriscendobot-minion.town/<N>/<head>.json` (the
   base, gauntlet record, panel head and match kind, CI check links, deploy run, and
   heartbeat time) and posts the conductor `screen-minion-town-pr<N>-<sha7>-conduct`,
   which runs `ci-wait-merge.sh kriscendobot/minion.town <N> --screened-delegated-merge`.
   That spine unfreezes a `main-<sha>` base and rebases onto live `main`.
   Its final policy read requires `baseRefName: main`, so a stale frozen or
   still-stacked base cannot merge even if an earlier attestation exists.
   If that conductor finishes without merging while the head stays the same, the
   screen re-posts it as `…-conduct-r2` and then `…-conduct-r3`. After the third,
   it sends one *stalled* notice to the maintainer.

The gauntlet driver stamps `panel_head` on its record when a panel passes, and
copies `repo`, `pr_number`, and `panel_head` into the completed report. Gauntlets
that completed before this build carry no `panel_head`, so their PRs get one fresh
head-keyed gauntlet.

## No policy escalations

`escalate_paths`, `escalate_except`, and `escalate_sections` must all be empty or
the record is denied.
Workflows, deployment scripts, provisioning scripts, and CD documentation are
inside the delegation.
A diff at the compare API's 300-file limit remains blocked because the response
may be incomplete.
The screen writes `screenings/.../<N>/blocked-<head>.json` and a maintainer
notice, but does not request a review; split the PR below the limit and re-screen.

## The maintainer's view

- **Bulletin.** *Screened by proxy (minion.town)* shows the delegation status and
  the last 24 hours of screens, merges, deploy outcomes, and comparison blocks. While
  the delegation is seeded, the *Parked for maintainer feedback* section omits
  all minion.town PRs; the screen has no review-escalation path.
- **Inbox.** Pause, heal, comparison-limit, and stalled-conductor events are sent, as
  `from: proxy:screen`. The proxy's PR-comment auto-clear skips that sender.
- **Fixer re-requests.** On minion.town a fixer re-requests review only from a
  human with a live `CHANGES_REQUESTED` (`roles/fixer/AGENT.md`).

## Tests

`scripts/jobs/test/minion-town-screening-test.py` (screener, operator command,
bulletin views) and `scripts/jobs/test/ci-wait-merge-screening-test.py` (the spine
mode), both in `.github/workflows/checks.yml`.
