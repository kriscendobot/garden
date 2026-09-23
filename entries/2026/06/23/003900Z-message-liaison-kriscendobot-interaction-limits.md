---
kind: message
role: liaison
host: endolinbot
at: 2026-06-23T00:39:00Z
---

# Locked down kriscendobot forks to contributors-only; gardener job posted for the standing policy

Maintainer: "Please ensure that kriscendobot forks do not accept comments
from non-contributors."

Applied this turn (via `gh api PUT repos/kriscendobot/<name>/interaction-limits`,
body `{"limit": "contributors_only", "expiry": "six_months"}`):

  * kriscendobot/agoric-sdk   (expires 2026-12-23T03:38:04Z)
  * kriscendobot/garden       (expires 2026-12-23T03:37:41Z)
  * kriscendobot/endo         (expires 2026-12-23T03:37:42Z)
  * kriscendobot/cosgov       (expires 2026-12-23T03:37:43Z)
  * kriscendobot/xsnap-pub    (expires 2026-12-23T03:37:43Z)
  * kriscendobot/ocapn        (expires 2026-12-23T03:37:44Z)
  * kriscendobot/lavamoat     (expires 2026-12-23T03:37:45Z)

GitHub caps interaction-limit expiry at six months — so without a renewal
mechanism the protection lapses silently in December. Posted gardener
job `jobs/open/20260623T033844Z--e3aff6--kriscendobot-interaction-limits.md`
to encode the standing policy: idempotent enforcement script, ~5-month
renewal cadence (first renewal target 2026-11-23), and an on-fork-creation
trigger so future kriscendobot forks inherit the setting at birth.

`contributors_only` covers PRs, issues, and comments — that is the
closest GitHub setting to the maintainer's "no comments from
non-contributors". There is no comments-only variant.

Out of scope of the maintainer's directive (and surfaced for decision):
kriscendobot also owns `finbot` (public, not a fork — "Finance OODA
garden: planner + executor + Monte Carlo ensemble forecasting"). The
maintainer said "forks", so I did not gate finbot. The gardener job
flags it as a follow-up decision.

Also notable for this surface: `endojs/endo-but-for-bots` is the active
monitored fork and is presumably gated at the org level — but that is
an endojs org-side setting, outside kriscendobot's authority.
