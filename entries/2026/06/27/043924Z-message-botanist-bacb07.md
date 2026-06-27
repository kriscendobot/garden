---
kind: message
role: botanist
host: endolinbot
at: 2026-06-27T04:39:36Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger row retirement: endojs/endo-but-for-bots#362

Daily `dependabotany-recheck-endo-but-for-bots` sweep, 2026-06-27. Retires the
EMBARGO row for #362 (originally recorded 2026-05-25, EMBARGO-2026-05-31). The
maturity date has passed, but the PR is no longer OPEN, so there is no terminal
verdict to execute — the row is retired as superseded, not merged or rejected.

## Per-PR posture

| PR | Headline upgrade | Prior verdict | Maturity date | State now | Disposition |
|---|---|---|---|---|---|
| [362](https://github.com/endojs/endo-but-for-bots/pull/362) | grouped `all-minor-patch` x 15 (ws 8.20.0→8.21.0 CVE-fix among 14 non-vuln bumps; base `llm`) | EMBARGO-2026-05-31 | 2026-05-31 | **CLOSED** (by `dependabot[bot]`, 2026-05-31T20:01:00Z) | **Row retired — superseded.** Dependabot closed the grouped PR itself: "Looks like these dependencies are updatable in another way, so this is no longer needed." (2026-05-31T20:00:58Z). The embargo is moot; no merge, no manual close, no re-botany was warranted because the PR is not OPEN. Dependabot will re-propose the still-current members in regrouped PRs that route through fresh botany on arrival. The ws 8.21.0 / GHSA-96hv-2xvq-fx4p CVE-fix is not lost — it returns in the next grouped run (and indeed the later #512 grouped PR included ws 8.20.0→8.21.0, rejected on an unrelated Babel regression). |

## Sweep result

- **#362**: row retired (closed/superseded by dependabot). See above.
- **#197** (electron 40→42, EMBARGO-2026-06-30): still OPEN, **maturity not yet
  reached** (3 days out as of 2026-06-27). Left embargoed, untouched. It carries
  its own dedicated one-time recheck `dependabotany-recheck-endo-but-for-bots-pr197`
  firing 2026-06-30T23:00:00Z (maintainer-directed, kriskowal on #197
  2026-06-25), with the standing daily sweep as the heartbeat backstop.

## Ledger / schedule state after this sweep

The endo-but-for-bots dependabotany ledger now holds exactly one embargoed OPEN
row: **#197 (EMBARGO-2026-06-30)**. The standing daily
`dependabotany-recheck-endo-but-for-bots` schedule is therefore **retained** (it
may be deleted only when the ledger holds no embargoed open rows). No schedule
change made this tick.
