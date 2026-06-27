# Audit: inbox / message-bus discipline across the claude-agent fleet

Mentor audit (2026-06-24, job `audit-inbox-discipline-and-deadmail`). Scope: every
script that runs a `claude -p` inner agent — does the agent **monitor a
corresponding inbox** while it runs, and does it **know how to message related
living agents** (including how it learns peers' live `<base>`)?

## The two agent shapes

The fleet has exactly two shapes, and the inbox model follows from which one an
agent is:

- **Job doers** (gardeners) have a **lifecycle inbox**: `inbox/<base>/` is created
  at claim and destroyed at completion (`skills/message-bus/SKILL.md`). A doer is
  addressable for exactly its working lifetime, so directed mail makes sense.
- **Service agents** (triager, watchman, mentor, proxy, foreman, follow-up,
  bulletin) are **stateless per-tick** producers/transformers driven by a
  timer/loop. A oneshot that exits in seconds has no stable lifetime to receive
  directed mail into, so — correctly — it has **no inbox of its own**. Its
  communication is outbound and appropriate to its function (post jobs, broadcast,
  or write into the maintainer / a doer inbox).

So "every agent monitors an inbox" is the wrong invariant; the right one is: *job
doers monitor their lifecycle inbox; service agents have a working outbound
channel; and a message to an agent that has torn down is never lost.* The last
clause was the real gap (Part B).

## Coverage table

| Agent (driver → handler) | Inbox shape | Monitors inbox? | Can message peers? | Learns peer `<base>`? | Class |
|---|---|---|---|---|---|
| **gardener** (`gardener.sh` → `handlers/gardener-claude.sh`) | lifecycle | drains `inbox-read.sh <base>` at claim; polls `read-msgs.sh role/gardener broadcast` every loop | `message-user.sh` (maintainer); `inbox-send.sh` (peer doer) | now via `inbox-list.sh` + `reply_to` | **covered** (was partial) |
| **triager** (`triager.sh` → `handlers/triager-claude.sh`) | none (producer) | n/a | posts jobs (`post-job.sh`) | n/a | covered |
| **watchman** (`watchman.sh` → `handlers/watchman-claude.sh`) | none (broadcaster) | n/a | `send-msg.sh broadcast` + targeted notes | n/a | covered |
| **mentor** (`mentor.sh` → `handlers/mentor-claude.sh`) | none (producer) | n/a | posts improvement jobs | n/a | covered |
| **proxy** (`proxy.sh` → `handlers/proxy-claude.sh`) | none (reads maintainer inbox) | scans `inbox/maintainer/unread` | routes replies to doers + notes to maintainer (`inbox-send.sh`) | from each message's `reply_to` | covered (exemplary) |
| **foreman** (`foreman.sh` → `handlers/foreman-claude.sh`) | none (idle-pump) | n/a (watches the board) | posts jobs + maintainer notes | n/a | covered |
| **follow-up** (`follow-up.sh` → `handlers/follow-up-claude.sh`) | none (producer) | n/a (watches `jobs/tada`) | posts jobs/schedules + maintainer notes | n/a | covered |
| **bulletin** (`bulletin.sh` → `handlers/bulletin-claude.sh`) | none (narrator) | n/a | n/a (output is `README.md`) | n/a | covered |

## Gaps found, and disposition

- **G1 — gardener mid-job discipline lived only in the role brief (PARTIAL → fixed).**
  `gardener.sh` drains the inbox once at claim and polls the topic bus each loop,
  but the inner `claude -p` is a single blocking call: a message arriving mid-job
  is picked up only if the agent itself shells out to `inbox-read.sh <base>`. The
  role brief says to, but the handler prompt (`gardener-claude.sh`) never named the
  agent's `<base>` as its inbox key, nor how to reach the maintainer/peers.
  **Fix (landed):** `gardener-claude.sh` now injects a *Messaging discipline* block
  naming `<base>`, `inbox-read.sh`, `message-user.sh`, `inbox-send.sh`, and
  `inbox-list.sh` into the prompt, so the discipline is reinforced at the point of
  work rather than depending on the brief alone.

- **G2 — no live-peer discovery (MISSING → fixed).** An agent that wanted to
  message a peer had no way to learn the peer's live `<base>` except `reply_to`
  (replies only). **Fix (landed):** `inbox-list.sh` enumerates the live
  `inbox/<doer>/` set (excluding the standing `maintainer` inbox and the `dead`
  queue) — the canonical "who is alive right now" lookup before `inbox-send.sh`.

- **G3 — a message to a tearing-down recipient was dropped with a hard error
  (the race the maintainer named) (→ fixed in Part B).** `inbox-send.sh` now
  dead-letters undeliverable mail into `inbox/dead/` and `garden-deadmail` promotes
  each dead-letter into a fresh job. See below.

## Part B — the dead-mail mechanism (race fix)

1. **Capture, don't drop.** `inbox-send.sh` (and everything layered on it —
   `message-user.sh`, `maintainer-reply.sh`, the proxy/foreman/follow-up senders)
   now deposit a message whose recipient inbox is gone into `inbox/dead/<id>.md`
   (carrying `to:` the intended recipient, `from`, optional `reply_to`, and the
   body) instead of erroring. Delivery to a live inbox stays the fast path;
   dead-lettering is the fallback. `GARDEN_NO_DEADLETTER=1` restores the legacy
   hard failure for callers that genuinely want it.
2. **Promote to a job.** `garden-deadmail` (`scripts/jobs/deadmail.sh`, timer-driven
   like the reaper) scans `inbox/dead/`, posts one job per message
   (`deadmail-<id>`, a deterministic basename so re-scans are idempotent) carrying
   the original message, the intended recipient `<base>`, and "the addressee had
   already completed; pick up its intent," then retires the dead-letter. Honors
   `fleet_draining` (the draining marker; was `killswitch_engaged`); quiet on success.
3. **Registered** in `scripts/systemd/garden-deadmail.{service,timer}` and
   `install-units.sh` (`enable_services` + summary line).

## Tests

`scripts/jobs/test/run-test.sh` SUBTEST 5 now asserts a send to a torn-down doer is
dead-lettered (not dropped, not a hard error) and that `GARDEN_NO_DEADLETTER=1`
still hard-fails. SUBTEST 16 (new) asserts dead-letter capture, recipient
recording, promotion to exactly one job with the right body, retirement of the
entry, and idempotency on re-scan. A live-inbox send still delivers (SUBTEST 5/6).
Full suite: 80 passed, 0 failed (run with the host's `GARDEN_GARDENER_*` env unset
so the harness uses its throwaway journal — see note below).

> Harness note: `claim-job.sh`/`gardener.sh` honor `GARDEN_GARDENER_CLONE` from the
> environment. On a host running the live fleet, that variable is exported into the
> shell, so `run-test.sh` must be run with it unset (`env -u GARDEN_GARDENER_CLONE
> -u GARDEN_GARDENER_ID`) or the test gardeners share the real clone and SUBTEST 1
> spuriously fails. Pre-existing; not introduced by this change.
