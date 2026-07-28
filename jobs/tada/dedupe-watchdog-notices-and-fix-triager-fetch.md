Work is complete and pushed. Here is the report.

---

## What I did

**Problem 1 — the notice flood (fixed at the one place that writes it).** Every `watchdog:*` maintainer message in the fleet is written by `alert_maintainer` in `scripts/jobs/common.sh`, so that is the shared helper the dedup now lives in; no path was fixed in isolation.

- **New `scripts/jobs/watchdog-notice.sh`** — `poison-notice.sh`'s amend-or-post treatment generalized from job+signature keys to *condition* keys. It keeps ONE keyed entry (`inbox/maintainer/unread/watchdog-<key>.md`) per open condition and amends it in place: `notice_count` rises, `first_seen` is preserved, `last_seen` refreshes, the body carries the latest detail. Archive interaction follows the poison sibling deliberately (dedup holds only while unread, so a re-occurrence after the maintainer handled it is seen again).
- **Occurrences suppressed by the throttle are now counted** in host-local state (`$GARDEN_STATE/alerts/<key>.count`) and folded into the next delivery, so `notice_count` is the true occurrence count, not the delivery count. The throttle now bounds journal pushes, not visibility.
- **Provider quota is its own class.** `is_provider_quota_text` re-keys any usage/weekly-cap refusal to a single fleet-level `provider-quota` notice carrying the reset clause and an explicit "this is an account limit, not a garden defect — see `skills/restore`". `self-heal-claude.sh` short-circuits before its per-unit escalation: when its own `claude -p` was *refused* it never had a diagnosis, so it files the fleet condition and stays silent per unit (the capture blob is still named in that notice).
- **Recovery closes the loop.** `alert_maintainer_clear` / `note_provider_ok` amend the open entry with `recovered: true`, reporting how many occurrences it covered. It is one builtin file test when nothing was raised, so callers put it on the happy path (the self-heal responder calls it whenever the provider answers; the triager on every successful fetch).

**Problem 2 — triager fetch failures.** `triager.sh` captured git's stderr "for the same offline classification `sync_clone` uses" and then never performed the classification, escalating every cause identically with no diagnosis attached. It now classifies, in this order: **upstream-gone first** (GitHub's dead-repo answer ends in `fatal: Could not read from remote repository.`, which is *also* an offline signature — classifying offline first is how a deleted fork retries silently forever) with the durable disarm remedy attached; **transient** (DNS/TLS/reset/5xx/timeout, rc 124/137) counted but quiet until it has persisted `GARDEN_TRIAGE_OFFLINE_ALERT_STREAK` ticks (default 5); **anything else** immediately, carrying git's own words. The steady-state fetch also narrows from `--all` to `origin` — the only remote the triager reads, and `--all` fails the whole tick when any unrelated remote a clone happens to carry fails.

## Before/after, on a simulated repeated failure

`scripts/jobs/test/watchdog-notice-dedup-test.sh` (new, 22 assertions) runs both arms on a throwaway journal:

| Simulation | Before (pre-fix path) | After |
| --- | --- | --- |
| 11 occurrences of one condition | **11 unread messages** | **1 entry, `notice_count: 11`** |
| 3 different units tripping the quota | 3 per-unit reports | **1 `provider-quota` entry, count 3**, with reset time |
| condition clears | nothing (silence) | same entry amended `recovered: true`, "observed 3 times" |

Tests: `watchdog-notice-dedup-test.sh` 22/22; `triager-test.sh` 109/109 (I rewrote the M-section assertions that encoded the old page-for-everything behavior, and added M1b/M1c/M5 for the streak, the recovery, and the gone-upstream key); `run-test.sh` exit 0, 0 failures; `journal-worktree-keeper-test` 94/94, `comment-watcher-test` 236/236, `foreman-maintainer-notice-dedup-test` 6/6. `clone-keeper-test` has 4 failures — **pre-existing**, verified by running it against a pristine `origin/main2` extract. shellcheck clean on all new/changed scripts.

## Cause and remedy per fetch-failing repo

I re-ran the fetch by hand against every bare clone on the shelf. Two distinct causes, not thirteen:

- **Transient transport, 11 repos** — `endo`, `agoric-3-proposals`, `cosgov`, `finbot`, `proposal-compartments`, `minion.town`, `agoric-sdk`, `vattr97`, `test262`, `ocapn`, `moddable`, `ymax-stdio-mcp`. Evidence: **9 of the 43 notices landed inside a single 20-minute window** (2026-07-24T16:00–16:20) across 9 unrelated repos, and every one of these clones fetches cleanly today. The per-repo notice cadence (~1/hour/repo) is exactly `alert_maintainer`'s throttle window, not an event rate. `rc=1` versus `rc=128` is `fetch --all`'s aggregate "an error occurred" versus a single-remote fatal; three of these clones carry extra remotes (`endo` → `cjs-module-lexer`, `agoric-sdk` → `upstream`, `minion.town` → `minion-town`) that `--all` let fail the tick. **Remedy applied:** fetch `origin` only, classify, and don't page until it persists.
- **Genuinely dead upstream, 1 repo** — `kriscendobot-chrome-native-function-caller-arguments-repro`: `gh api` returns 404 (the maintainer deleted the experiment). **Already disarmed** — journal `watch-optout/` tombstone (today 01:15), no `repos/` record, and its stale bare clone has since left the shelf. New code files this class under its own `triager-upstream-gone-<slug>` key with the disarm remedy, instead of misreading it as weather.
- **`kriscendobot-garden`** — was never a fork: the garden's own repo was `kriskowal/garden` until the transfer today, and the local slug pointed at a then-nonexistent `kriscendobot/garden` (which now returns 200). Tombstoned today 06:45 *deliberately* (its comment surface is watched by hand; a commit triager on the garden's own repo is not wanted). No further action.

The systemic disarm already exists and works: `fork-watch-provisioner.sh` re-probes armed own forks every 4h and auto-tombstones a 404 — the gap noted in the hand-written tombstone has since been closed in `main2`.

## Landed

`4ebcb98f89` on `main2` (rebased over three peer commits; one conflict in `common.sh` against the newly landed agent-CLI resolver, resolved keeping both, tests re-run green after the rebase). Files: `scripts/jobs/{common.sh,watchdog-notice.sh,triager.sh,handlers/self-heal-claude.sh}`, tests, `designs/watchdog-notice-dedup.md` (+ index row), and pointers in `roles/proxy/AGENT.md` § Watchdog auto-clear and `skills/self-healing-wrapper/SKILL.md`. It reaches hosts on the next deliberate deploy.

## Follow-ups

1. **I did not touch the maintainer inbox** — still 301 unread, 147 `watchdog:*`, per the job's instruction; the backlog is `consolidate-maintainer-inbox-20260727`'s. This change stops the source so it does not refill.
2. **Automatic gc is broken in the shared garden repo**: `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`, recorded in the worktree's `gc.log`. The object is genuinely missing. I deliberately did not touch the root repo's object store; this wants the root-repo-guard's attention or a maintainer.
3. **Dedup versus the proxy's watchdog auto-clear**: archiving an entry re-opens its key by design. In the flood scenario (fleet drained during an outage, proxy not clearing) that yields one entry; when the proxy runs it archives them anyway. If a strictly-one-entry-across-archives policy is ever wanted, `GARDEN_WATCHDOG_RECOVERY_IF_OPEN_ONLY` is the existing lever to build on.
4. Narrowing the triager to `fetch origin` means it no longer incidentally refreshes a clone's extra remotes (`endojs-endo-but-for-bots` keeps an `endo`); `clone-keeper.sh` remains the maintainer of standing clones, so this should be a no-op, but it is the one behavior change worth watching.
