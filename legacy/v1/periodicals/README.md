---
created: 2026-05-13
updated: 2026-05-13
author: gardener
---

# Periodicals

The garden's periodical reports. Each periodical is a curated summary of journal activity over a defined window, written by a role on a scheduled cadence. The [timekeeper](../../<garden-root>/roles/timekeeper/AGENT.md) fires the schedule that triggers each periodical's authoring role; the schedule itself lives under [`../schedule/`](../schedule/).

The default periodical is the **daily progress summary**: every day at 00:00 America/Los_Angeles (DST-aware), the timekeeper dispatches a [journalist](../../<garden-root>/roles/journalist/AGENT.md) with purpose `daily-progress-summary`. The journalist reads the prior 24 hours of journal entries (every project, every activity kind), summarizes progress, and writes the result here at `<YYYY>/<MM>/<DD>.md`. The seed scheduled event for this periodical is [`../schedule/garden/20260513T070000Z--5a93f9.md`](../schedule/garden/20260513T070000Z--5a93f9.md).

## Layout

```
journal/periodicals/
  README.md                        # this index
  <YYYY>/
    <MM>/
      <DD>.md                      # one daily progress summary per day, by the journalist
```

Each daily file's filename is the **local Pacific date** of the window the summary covers, not the UTC date of the trigger. A summary that fires at `2026-05-13T07:00:00Z` (00:00 PDT on 2026-05-13) covers `2026-05-12` Pacific-local and lands at `2026/05/12.md`. The journalist's dispatch arguments name the window unambiguously.

Other periodical kinds may grow alongside (weekly project rollups, monthly ledgers, per-repo CI rollups). When a new kind arrives, add a sibling subtree (`journal/periodicals/<kind>/`) and document it under *Kinds* below. Avoid a single long file with mixed kinds; per `<garden-root>/skills/context-library/SKILL.md`, prefer many small files.

## Kinds

- **Daily progress summary** (`<YYYY>/<MM>/<DD>.md`): the seed kind. Author role: journalist. Cadence: daily, 00:00 America/Los_Angeles. Window: the prior 24 hours, ending at the trigger instant. Source: every entry under `journal/entries/<YYYY>/<MM>/<DD>/` whose `ts:` falls inside the window.

## Entry shape (daily progress summary)

```markdown
---
date: 2026-05-12                            # local Pacific date of the window (the day being summarized)
window_start: 2026-05-12T07:00:00Z          # UTC start of the window (the prior trigger)
window_end: 2026-05-13T07:00:00Z            # UTC end of the window (the firing trigger)
created: 2026-05-13
author: journalist
---

# Daily progress summary: 2026-05-12

<one-paragraph abstract: what happened today in one sentence per project, then a one-line meta-state>

## By project

### <project-slug>

- <bullets of progress, each citing one or more entries by relative path>

### <next-project>
...

## Garden meta

- <bullets for entries with no project tag, or whose subject is the garden itself>
```

The journalist writes the abstract first (per `<garden-root>/skills/context-library/SKILL.md` § Abstract-at-the-top); the body lives up to it. Cite source entries by relative path (`../../../entries/<YYYY>/<MM>/<DD>/<HHMMSS>Z-<kind>-<role>-<short-id>.md`); paraphrase rather than copy.

## Browse

- **By date**: walk `<YYYY>/<MM>/<DD>.md`.
- **By topic**: grep across periodicals (`grep -rl '<topic>' journal/periodicals/`). The journalist's per-project sub-sections make grep-by-slug effective.
- **By kind**: future kinds will land in sibling subtrees; this index lists them.
