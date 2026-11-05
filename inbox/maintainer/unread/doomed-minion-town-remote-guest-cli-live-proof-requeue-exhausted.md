from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-05T17:37:11Z
doom_base: minion-town-remote-guest-cli-live-proof
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-05T17:37:11Z
last_seen: 2026-11-05T17:37:11Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/minion-town-remote-guest-cli-live-proof; it stays HELD until a human promotes it
(promote-plan.sh minion-town-remote-guest-cli-live-proof) or removes it, so nothing is lost.
Original job base: minion-town-remote-guest-cli-live-proof

--- original job body ---
---
tier: mentor
posted_at: 2026-11-04T07:06:39Z
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-05T17:04:23Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Own the remaining delivery of designs/remote-guest-endo-cli.md after https://github.com/kriscendobot/minion.town/pull/236 (a slice covering the hint filter of step 3).

Remaining: step 2 (Endo CLI `endo net ensure ocapn` and hint-fallback diagnostics), the rest of step 3, and step 5 / the section 8 acceptance proof from a clean workstation, using a real OAuth member's canonical guest. The proof needs the release gate in DEPLOYMENT.md § Preconditions before `enable`, and the maintainer's answers to the open questions on #236, so this waits on a maintainer go-ahead; do not deploy without one.

On completion, update #236's phase and evidence ledger to `Disposition: deliverable` with the durable receipts so its gauntlet can re-stage.
