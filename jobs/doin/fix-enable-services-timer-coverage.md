# Fix install-units.sh enable-services to enable ALL intended garden timers (many were dormant)

Wear the **mentor** role. **Several garden service timers were installed but never enabled**, so
the services never ran. Found dormant on endolinbot (2026-06-26): **garden-foreman.timer,
garden-deadmail.timer, garden-follow-up.timer, garden-proxy.timer, garden-mirror-closer.timer**
(all `is-enabled: disabled`, never triggered) — i.e. the foreman wasn't draining the plan queue,
the proxy/follow-up weren't generating jobs, dead-mail wasn't being promoted, mirror PRs weren't
being closed. The liaison enabled them by hand, but the **root cause is that
`scripts/jobs/install-units.sh enable-services` does not cover these units** (likely added after
the enable list was written). Infrastructure on `main2` (bot identity; isolated worktree off
`origin/main2`; redeploy).

## Fix

- Make `install-units.sh enable-services` (and the install flow) **enable every intended garden
  timer/service**, derived from the units actually present rather than a hand-maintained list that
  drifts. A newly-added `garden-*.timer` with `[Install] WantedBy=timers.target` should be enabled
  automatically by the install step; a continuous `Restart=` service (e.g. the bulletin, which
  runs as a service not a timer) enabled as a service.
- **Exclude, by explicit policy:** template units (`@.timer`/`@.service` — enabled per-instance),
  and any **monitoring** unit that the monitoring-safety constraint says requires explicit
  maintainer authorization (notably **garden-mention-watcher** — leave it for the maintainer to
  arm, do NOT auto-enable it). Document this exclusion list in the script.
- Add an idempotent **`enable-services --verify`** (or similar) that reports any installed unit
  that is NOT enabled-or-deliberately-excluded, so a future drift is visible (and could feed a
  watchman/bulletin check).

## Tests & verification

- After `install-units.sh install && enable-services`, every non-template, non-excluded
  `garden-*.timer` is `enabled`, and the excluded set (templates, mention-watcher) is not.
  `shellcheck`/`bash -n` clean.

## Definition of done

`install-units.sh enable-services` reliably enables all intended garden timers/services (foreman,
deadmail, follow-up, proxy, mirror-closer included), excludes templates + monitoring-gated units
by documented policy, and offers a drift-verify — committed/pushed to `origin/main2`, redeployed.
Report the SHA and the enabled/excluded sets.

Posted by the liaison on behalf of the maintainer (services were dormant; root-caused to the enable step).

---
claim:
  host: endolinbot
  gardener: 15
  claimed_at: 2026-06-26T04:20:09Z
