scripts/jobs/self-heal-run.sh

# Watchdog notices flood the maintainer inbox: 147 unread, 94 for one condition

Garden change on `main2` (direct push, no PR — CLAUDE.md § Conventions).

## Measured state (2026-07-28T07:00Z)

The maintainer inbox holds **291 unread**, of which **147 are `from: watchdog:*`**:

| Source | Count | What it is |
| --- | --- | --- |
| `watchdog:self-heal-claude` | **94** | `self-heal: <unit> exited rc=1 with no scoped fix. … Diagnosis: You've hit your weekly limit · resets 4:10pm (UTC)` |
| `watchdog:triager/<repo>` | ~40 | `triager: fetch for <repo> at <path>.git failed (rc=128). Retrying next tick` — spread across 13 repos |
| `watchdog:foreman-claude` | 3 | same family |
| `watchdog:ollama-serve` | 2 | same family |

These are **two different problems** wearing the same shirt. Do not treat them as
one.

## Problem 1 — the notice flood (the fix this job is named for)

**94 messages for a single condition is a reporting defect, not 94 events.** The
API weekly-quota limit is one fact; the maintainer needs it once, not 94 times.
It buried genuinely actionable mail — a blocked build, two halted orchestrations, a
triage circuit-breaker, and an access request all sat unread underneath it.

The garden **already solved this** elsewhere: the reaper's poison notices carry
`notice_count`, `first_seen`, and `last_seen`, and coalesce repeat occurrences of the
same signature into ONE inbox entry that updates in place. The watchdog path has no
such dedup. **Give it the same treatment:**

- Derive a **signature** per notice (unit + failure class — e.g.
  `self-heal-claude:garden-issue-inbox:quota-limit`), and coalesce repeats into one
  message with `notice_count` / `first_seen` / `last_seen` rather than appending a
  new one each tick.
- Treat **provider quota/rate-limit** as its own class. It is an *environmental*
  condition affecting every unit at once, not a per-unit fault: one fleet-level
  notice ("provider quota exhausted, resets <time>") is worth more than one notice
  per unit per tick. Detect it from the diagnosis text the self-healer already
  captures.
- Respect silent-until-error: a **recovery** should close the loop (one notice when
  the condition clears), so the maintainer learns it ended without reading 94 lines.

Cross-check the sibling watchdog paths (`triager`, `foreman-claude`, `ollama-serve`)
so the dedup lives in one shared helper rather than being fixed only for
`self-heal-claude`.

## Problem 2 — triager fetch rc=128 across 13 repos

Separate and functional: while it persists, **those repos cannot be triaged at all**,
and the only symptom is noise the flood was hiding. Affected (by notice count):
`kriscendobot-endo` (6), `kriscendobot-agoric-3-proposals` (6), `kriscendobot-cosgov`
(5), `kriscendobot-finbot` (4), `kriscendobot-proposal-compartments` (3),
`kriscendobot-minion.town` (3), `kriscendobot-garden` (3),
`kriscendobot-chrome-native-function-caller-arguments-repro` (3),
`kriscendobot-agoric-sdk` (3), `kriscendobot-vattr97` (2), `kriscendobot-test262` (2),
`kriscendobot-ocapn` (2), and others.

Diagnose the actual `rc=128` — run the fetch by hand against one of the bare clones
under `worktrees/<slug>.git` and read the real git error. Candidates worth
distinguishing: auth/credential failure, a genuinely deleted upstream (some of these
forks are known-dead — there is an existing self-heal job about an
`upstream-404-no-disarm` case), a corrupted bare clone, or collateral from the same
quota outage. **The remedy differs per cause**, so report the cause per repo rather
than applying one blanket fix. A repo whose upstream is genuinely gone should be
*disarmed* from the watch set, not retried forever.

## Explicitly out of scope

The **quota exhaustion itself is not a bug** — it is an account limit, and the
operational response is the [restore](../../skills/restore/SKILL.md) skill once
service returns. Do not try to "fix" it in code. This job is about the fleet
reporting it *once* instead of 94 times, and about the fetch failures the flood
concealed.

Do **not** bulk-archive the maintainer inbox as part of this job. Triage of the
existing backlog belongs to `consolidate-maintainer-inbox-20260727`; this job stops
the *source* so the backlog does not immediately refill.

## Definition of done

- A repeated watchdog condition produces ONE coalescing inbox entry with
  `notice_count`/`first_seen`/`last_seen`, not N entries — demonstrated by
  simulating a repeated failure.
- Provider quota/rate-limit is reported as a single fleet-level condition, with a
  recovery notice when it clears.
- The dedup lives in a shared helper used by every `watchdog:*` path.
- Each of the 13 fetch-failing repos has a stated cause and remedy in the report;
  genuinely-dead upstreams are disarmed rather than retried.
- Pushed to `main2`; `tada` report gives before/after notice counts for a simulated
  repeated failure.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  claimed_at: 2026-07-28T07:09:18Z
