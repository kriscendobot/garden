# Watchdog notice dedup — one entry per condition, one notice per environment

| Created | 2026-07-28 |
| Author  | gardener (job `dedupe-watchdog-notices-and-fix-triager-fetch`) |
| Status  | Implemented |

## The observation

On 2026-07-28T07:00Z the maintainer inbox held **291 unread**, of which **147
were `from: watchdog:*`**:

| Source | Count | What it was |
| --- | --- | --- |
| `watchdog:self-heal-claude` | 94 | `self-heal: <unit> exited rc=1 with no scoped fix. … Diagnosis: You've hit your weekly limit · resets 4:10pm (UTC)` |
| `watchdog:triager/<repo>` | 43 | `triager: fetch for <repo> at <path>.git failed (rc=1\|128). Retrying next tick` — across 13 repos |
| `watchdog:foreman-claude`, `watchdog:ollama-serve`, … | 10 | same family |

94 messages for a single condition is a **reporting defect, not 94 events**. The
account's weekly API limit is one fact; it buried a blocked build, two halted
orchestrations, a triage circuit-breaker, and an access request.

## Why it happened

Every `watchdog:*` message is written by `alert_maintainer` (`common.sh`), which
throttled per dedup key (1h) and then posted a **fresh** message through
`inbox-send.sh`. Two consequences:

1. A condition that outlives its window posts again — one message per key per
   hour, indefinitely. Nothing collapses them.
2. The key is per unit. The provider quota is not a per-unit fault; it is one
   **environmental** condition that every unit trips at once, so ~40 distinct keys
   reported the same sentence.

The garden had already solved shape (1) once, for the reaper: `doom-notice.sh`
keeps ONE keyed message per open condition and amends it (`notice_count`,
`first_seen`, `last_seen`). That treatment simply never reached the watchdog path.

## The design

**One shared helper, because there is one shared writer.** `alert_maintainer` is
the sole producer of `watchdog:*` mail, so fixing it fixes every watchdog path
(self-heal, the per-repo triagers, the foreman, `ollama-serve`, the
journal-worktree keeper, the root-repo guard, `require_tools`) at once.

1. **Coalesce.** Delivery routes through the new `scripts/jobs/watchdog-notice.sh`
   — `doom-notice.sh` generalized from job+signature keys to condition keys. It
   amends `inbox/maintainer/unread/watchdog-<key>.md` in place: `notice_count`
   rises, `first_seen` is preserved, `last_seen` refreshes, the body carries the
   latest detail. Archive interaction follows the doom sibling: dedup applies
   only while the entry is UNREAD, so a re-occurrence after the maintainer (or the
   proxy's watchdog auto-clear) handled the prior one is seen again.
2. **Count what the throttle suppresses.** Occurrences inside the throttle window
   are counted in host-local state (`$GARDEN_STATE/alerts/<key>.count`) and folded
   into the next delivery, so `notice_count` is the true occurrence count rather
   than the delivery count. The throttle now bounds journal pushes, not visibility.
3. **Classify the environment.** `is_provider_quota_text` re-keys any provider
   quota / usage-cap refusal to the single fleet-level key `provider-quota`, with
   the reset clause lifted into the notice and an explicit statement that this is
   an account limit, not a garden defect (the operational response is
   [restore](../skills/restore/SKILL.md); there is no code fix). The self-heal
   responder additionally short-circuits: when its own `claude -p` is refused it
   never had a diagnosis to report, so it files the fleet condition instead of a
   per-unit "no scoped fix" message.
4. **Close the loop.** `alert_maintainer_clear` (and `note_provider_ok`) post ONE
   recovery notice that amends the open entry with `recovered: true`, so
   silent-until-error does not leave the maintainer inferring the end of a
   condition from silence. It is a single builtin file test when nothing was
   raised, so callers can put it on their happy path — the triager clears its
   fetch condition on every successful fetch.

Cross-host: the state that feeds the fold is host-local, the entry is
journal-shared, so two hosts observing one fleet condition amend one entry and
their counts add up — which is the intent for `provider-quota`. A host-specific
condition keys its host into the key, as `require_tools` and the root-repo guard
already do.

## Measured effect

`scripts/jobs/test/watchdog-notice-dedup-test.sh` runs both arms on a throwaway
journal: 11 occurrences of one condition through the pre-fix path produce **11
unread messages**; the same 11 through `alert_maintainer` produce **1 entry with
`notice_count: 11`**. Three different units tripping the quota produce **1**
`provider-quota` entry (count 3), not three, and `note_provider_ok` closes it.

## The other half: what the flood was hiding

The 43 triager fetch notices were a second, functional problem — while a fetch
fails, that repo is not triaged at all. `triager.sh` captured git's stderr for
"the same offline classification sync_clone uses" and then **never performed the
classification**, escalating every cause identically with no diagnosis attached.
Now it classifies, in this order:

- **Upstream gone** (`GARDEN_UPSTREAM_GONE_SIGNATURES`) — tested FIRST, because
  GitHub's dead-repo answer over SSH ends in `fatal: Could not read from remote
  repository.`, which is also an OFFLINE signature; classifying offline first is
  how a deleted fork retries silently forever. Reported immediately with the
  durable disarm remedy (`watch-optout/<slug>` + removing `repos/<slug>`).
- **Transient** (DNS/TLS/reset/5xx/timeout, or rc 124/137) — counted, not paged,
  until it has persisted `GARDEN_TRIAGE_OFFLINE_ALERT_STREAK` ticks (default 5).
  A blip is weather; a blip that keeps happening means the repo is not being
  triaged, which is the maintainer's business.
- **Anything else** — reported at once, carrying git's own words so the notice is
  diagnosable without a shell on the host.

The steady-state fetch also narrowed from `--all` to `origin`: the triager reads
only `refs/remotes/origin/<ref>`, and `fetch --all` fails the whole tick when any
unrelated remote a clone happens to carry fails.
