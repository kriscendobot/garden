# Establish a periodic bulletin-update practice that aggregates maintainer messages

The maintainer asks: **establish a practice of periodically updating the
bulletin. It should largely resemble prior iterations, and must contain a list of
messages to the maintainer aggregated from their inbox.**

## What exists today

- `scripts/jobs/bulletin.sh` regenerates `journal/bulletin.md` **deterministically**
  (board counts, watch set, per-host worker counts, the last ~15 progress
  entries), idempotently (no commit when unchanged).
- It runs **periodically** already via `garden-bulletin.service` +
  `garden-bulletin.timer` (a `systemd --user` unit; confirm it is enabled and
  firing — `systemctl --user list-timers garden-bulletin.timer`).

So the *cadence* mostly exists; the gap is **content**.

## Task

1. **Aggregate the maintainer inbox into the bulletin (required).** Add a section
   listing the messages addressed to the maintainer — read the unread maintainer
   inbox at `inbox/maintainer/unread/` (the same source
   `scripts/jobs/maintainer-watch.sh` reads). For each message show enough to act
   on it: its id, the originating job/doer (`reply_to`), and a one-line summary.
   This must be a real list of pending maintainer messages, aggregated each tick.
2. **Make it resemble prior iterations.** The v1 bulletin was the maintainer
   dashboard — a "what needs a human" board (e.g. a *Pending kriskowal reviews*
   section) plus an ongoing-work summary. The prior generation's journal (and its
   bulletin/README) is archived on the **`journal-v1`** branch (also
   `origin/journal`); consult it and `v1/README.md` for the prior shape, and bring
   the current bulletin closer to it where it makes sense, without dropping the
   useful deterministic sections (board/hosts/watch/progress) already present.
3. **Keep it deterministic and reliable.** Preserve `bulletin.sh`'s design
   contract: computed without an LLM dependency so it runs on every tick,
   idempotent (no commit when unchanged ignoring the timestamp), committed and
   pushed to `journal2` with backoff. An optional `GARDEN_BULLETIN_HANDLER` may
   enrich, but the inbox aggregation must work without it.
4. **Confirm the periodic practice.** Ensure the timer is enabled so the bulletin
   is genuinely updated on a cadence; if the cadence needs to be a journal-shared
   schedule rather than a host-local timer, note that and use
   `scripts/jobs/set-schedule.sh` (see `skills/schedule/SKILL.md`).

## Deliverable

The updated `scripts/jobs/bulletin.sh` (committed to `main2` under the bot
identity; `shellcheck` clean), a regenerated `journal/bulletin.md` that shows the
aggregated maintainer-message list, and a note on the cadence. Report the SHA(s).
If a write is blocked, report the diagnosis and exact ready-to-apply change
rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
