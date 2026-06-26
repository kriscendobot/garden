# Apply the self-healing claude -p wrapper to ALL garden services (best practice; bulletin first)

Wear the **mentor** role. The maintainer's directive: **every garden service should run under a
self-healing wrapper** that, on failure, captures the failure, hands it to a `claude -p`
debugging responder, and recovers — not a bare `ExecStart` that dies silently. Today the bulletin
crashed and went dark for ~2h with no diagnosis. The **pattern is documented**
(`skills/self-healing-wrapper/SKILL.md`, `designs/self-healing-audit.md`, common.sh capture
guidance) but **applied to ZERO live units** — every service is a bare
`ExecStart=.../<svc>.sh` with only `Restart=`. Build the reusable wrapper and roll it out.
Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`; redeploy units).

## 1. Extract a reusable self-heal runner (BEFORE the driver is deleted)

The skill names the **driver** as the full-shape exemplar — and the driver is being removed
(`plan-remove-driver-dead-code`). **Extract its self-healing wrapper shape into a reusable
runner now**, so the valuable pattern survives the driver's deletion. Create e.g.
`scripts/jobs/self-heal-run.sh <responder-context> -- <command...>` that:
- runs the wrapped command;
- on non-zero exit / crash, **captures combined stdout+stderr into the git content store**
  (`git hash-object -w`) and hands the **blob HASH** (never the inline log — per common.sh
  §self-healing guidance) to a `claude -p` **debugging/self-improvement responder** wearing a
  role/skill fit for the failure, which **diagnoses + posts a fix job or an inbox report**;
- then returns so systemd's `Restart=` brings the service back (the wrapper diagnoses; systemd
  restarts), with backoff.
- **Throttle the responder hard**: a crash-looping service must NOT spawn `claude -p` every few
  seconds. Rate-limit by failure-signature (e.g. once per signature per N minutes, with a daily
  cap) so self-healing can never become a token-burn or amplify the crash loop. Record throttle
  state outside the unit (e.g. under `$GARDEN_STATE`).

## 2. Apply it to the services

Change each qualifying unit's `ExecStart` to run through the wrapper. **Start with
`garden-bulletin.service`** (the proven failure), confirm it self-heals, then roll out to the
rest: watchman, follow-up, foreman, proxy, scheduler, mentor, deadmail, repo-watcher,
mirror-closer, mention-watcher, gardener-scaler, and the templated `comment-watcher@`,
`triager@`, `watcher@` (and `gardener@` with care — 100 instances; throttle especially there).
- **Honor the skill's exception:** a pure git/CAS primitive whose only failure mode is
  contention wants **retry, not a responder** — wrap those with capture-only or leave them
  (judge per service; note which you skip and why).
- Compose with the in-flight `harden-bulletin-loop-crash-resilience` (tick-level resilience +
  start-limit tuning): the wrapper is the OUTER diagnosis layer; tick-resilience + start-limit
  are the INNER survival layer. Both should hold for the bulletin.

## 3. Verify

- Inject a failure in a wrapped service (e.g. the bulletin) → confirm: a content-addressed blob
  is written, a `claude -p` responder fires ONCE (throttled on repeat), a fix job / inbox report
  is produced, and the service restarts. `shellcheck`/`bash -n` clean; `systemd-analyze verify`
  the changed units.

## Definition of done

A reusable self-heal runner (extracted from the driver before its removal), applied to the
garden service units starting with the bulletin, with a hard-throttled `claude -p` responder and
the CAS-primitive exception honored — committed/pushed to `origin/main2`, redeployed, self-heal
verified on at least the bulletin. If applying to all ~18 units is too large for one pass, do the
runner + bulletin + the top few unattended loops and **post follow-on jobs** for the rest (report
which). Report the SHA, the wrapper API, and the per-service application status.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 39
  claimed_at: 2026-06-26T00:35:15Z
