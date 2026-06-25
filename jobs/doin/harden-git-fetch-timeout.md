# Harden: timeout journal git fetches so one stalled fetch cannot wedge the fleet

Wear the **mentor** role. SECOND outage (2026-06-25 ~14:40, ~15 min): dozens of
`git fetch -q origin journal2` processes hung **5–15 minutes** across the fleet's
clones, blocking journal operations fleet-wide (the comment-watcher was stuck in
`do_wait` on a `cursor-set` blocked on a stuck fetch). **origin was healthy** — a
fresh fetch succeeded; GitHub ssh+https were fine. The hung fetches were stale
half-open connections that **never time out** (git has no default fetch IO timeout),
so a transient network blip stalls a fetch FOREVER. Cleared by killing the stuck
processes. Infrastructure on `main2` (bot identity; isolated worktree off `origin/main2`).

## Why it wedged the WHOLE fleet (the amplifier)

The `flock` clone-serialization added by `harden-producer-push-path` means a stuck
fetch **holds its clone lock**, so every producer serialized behind that lock blocks
too. Before flock a stuck fetch only hurt its own clone; now it wedges everyone on
that lock. So the fix must bound BOTH the fetch and the lock wait.

## Fixes

1. **Timeout every journal git fetch.** In `scripts/jobs/common.sh` `sync_clone()`
   (and any other place the fleet runs `git fetch ... origin "$JOURNAL_BRANCH"`),
   wrap it: `timeout "${GARDEN_FETCH_TIMEOUT:-45}" git fetch ...`. On a timeout,
   treat it as a **transient failure → backoff + retry**, never a hang. Belt: set
   git stall detection where it applies (`GIT_HTTP_LOW_SPEED_LIMIT`/`_TIME` for
   https) and ssh `ConnectTimeout`/`ServerAliveInterval` for the `git@github.com`
   remote.
2. **Bound the lock wait.** Make `clone_lock` use `flock -w "${GARDEN_LOCK_WAIT:-60}"`
   so a waiter never blocks forever behind a stuck holder; on lock-timeout, backoff
   and retry. This caps the blast radius of any single stuck holder.
3. **Stuck-fetch janitor.** Add a periodic check (in the mentor sweep, the reaper,
   or a small janitor) that **kills `git fetch` processes older than N minutes** (a
   journal fetch should never run more than ~1 min) and surfaces a one-line anomaly —
   so a stuck fetch self-heals in minutes instead of wedging the fleet for hours.

## Tests & verification

- Simulate a stalled fetch (e.g. point at an unresponsive remote / inject a sleep)
  and assert `sync_clone` **times out and retries** rather than hanging; assert a
  `clone_lock` waiter times out rather than blocking forever. `shellcheck`/`bash -n`
  clean.

## Definition of done

Journal fetches and clone-lock waits are bounded by timeouts with retry, a stuck-fetch
janitor reaps long-running fetches, tests added — committed and pushed to
`origin/main2`. Report the SHA, the timeout values chosen, and the janitor mechanism.
If blocked, report the diagnosis and ready-to-apply change rather than claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 62
  claimed_at: 2026-06-25T14:58:25Z
