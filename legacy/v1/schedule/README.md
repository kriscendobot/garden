---
created: 2026-05-13
updated: 2026-05-13
author: gardener
---

# Schedule

The garden's pending and fired scheduled events. The [timekeeper](../../<garden-root>/roles/timekeeper/AGENT.md) consumes pending events whose `trigger:` timestamp has elapsed; any role may register a new event per `<garden-root>/skills/scheduling/SKILL.md` § Register an event. This README is the index for an agent surveying what is scheduled and what has fired.

Layout and event-file shape live in the [scheduling skill](../../<garden-root>/skills/scheduling/SKILL.md). The short version:

- Pending events live under `<owner-or-garden>/<UTC-trigger-timestamp>--<short-id>.md`.
- Fired events live under `_fired/<owner-or-garden>/<UTC-trigger-timestamp>--<short-id>.md` (archive; append-only).
- Trigger timestamps are UTC ISO-8601 in the frontmatter and compact `YYYYMMDDTHHMMSSZ` in the filename, computed via `<garden-root>/skills/scheduling/next-trigger.sh`.

## Pending events

### garden

- [`garden/20260513T070000Z--5a93f9.md`](garden/20260513T070000Z--5a93f9.md): daily midnight Pacific progress summary. Trigger `2026-05-13T07:00:00Z` (00:00 PDT). Recurrence `daily-at-00:00-America/Los_Angeles`. Dispatch `journalist` / `daily-progress-summary`. Output `journal/periodicals/<YYYY>/<MM>/<DD>.md`.
- [`garden/20260514T010000Z--72f1f4.md`](garden/20260514T010000Z--72f1f4.md): hourly scholar library cycle. Trigger `2026-05-14T01:00:00Z`. Recurrence `hourly-at-00-UTC`. Dispatch `scholar` / `library-cycle`. Drains the `to: scholar` inbox; ingests up to the cycle's section budget (3 to 5 source documents or ~25 section writes); writes under `journal/library/`. Indefinite.

## Fired events

(none yet; archive populates as the timekeeper fires events)

## Adding an event

Follow `<garden-root>/skills/scheduling/SKILL.md` § Register an event. The procedure is: pick a recurrence rule, run the helper script to compute the first trigger, generate a short id, write the event file under the right `<owner-or-garden>/` directory, then add a one-line bullet here under *Pending events* matching the event file's abstract.

The timekeeper picks up the new event on its next cycle. Cross-cycle latency is bounded by its cadence; an event whose trigger is sooner than the timekeeper's next wakeup may fire late by up to one wakeup interval. This is by design.
