# v1 → v2 journal migration

Date: 2026-06-24

The archived v1 journal (git branch `journal-v1`) was migrated into the v2
journal (branch `journal2`). This was a content migration with structural
translation. Nothing was destroyed: **`journal-v1` and `origin/journal` retain
the full original.** This file records the disposition of every v1 top-level
area.

## Mapping table

| v1 area             | files | disposition  | v2 destination                          |
| ------------------- | ----: | ------------ | --------------------------------------- |
| `entries/`          |  3807 | carried-live | `entries/` (same YYYY/MM/DD structure)  |
| `library/`          |  6150 | carried-live | `library/` (context library, new in v2) |
| `projects/`         |    93 | carried-live | `projects/` (project READMEs, new in v2)|
| `schedule/` (specs) |     2 | translated   | `schedules/scholar-library-cycle`, `schedules/daily-progress-summary` |
| `schedule/README.md`|     1 | archived     | `legacy/v1/schedule/README.md`          |
| `jobs/`             |    86 | archived     | `legacy/v1/jobs/`                       |
| `worktrees/`        |    40 | archived     | `legacy/v1/worktrees/`                  |
| `inboxes/`          |    10 | archived     | `legacy/v1/inboxes/`                    |
| `contractor-slots/` |    63 | archived     | `legacy/v1/contractor-slots/`           |
| `drivers/`          |     7 | archived     | `legacy/v1/drivers/`                    |
| `pr-deps/`          |     2 | archived     | `legacy/v1/pr-deps/`                    |
| `presence/`         |     3 | archived     | `legacy/v1/presence/`                   |
| `periodicals/`      |     1 | archived     | `legacy/v1/periodicals/`                |
| `agents/`           |     1 | archived     | `legacy/v1/agents/`                     |
| `README.md` (top)   |     1 | archived     | `legacy/v1/README.md`                   |

## Why each archived area is retired

Archived areas are preserved verbatim under `legacy/v1/<area>/` for provenance.
They are **not** placed in v2 live dirs because v2 mechanisms supersede them:

- **`jobs/`** (v1 job board: open / claimed / abandoned) — superseded by the v2
  job board lifecycle `jobs/todo` · `jobs/doin` · `jobs/tada`.
- **`worktrees/`** — superseded by v2 `work/` (one file per active worktree,
  keyed by basename).
- **`inboxes/`** (`inboxes/<host>/<role>`) — superseded by the v2 split bus:
  `msgs/role/<role>` (topic fan-out), `inbox/<doer>` (per-job mailbox), and
  `inbox/maintainer` (the standing maintainer inbox).
- **`contractor-slots/`** and **`drivers/`** — the contractor posture and the v1
  driver state are retired; the design-poller + driver-lane mechanism replaces
  them and keeps its own state outside the journal.
- **`presence/`** — superseded by v2 `hosts/` (per-host config / gardener count).
- **`pr-deps/`** — superseded by the `pr-dependency-graph` skill's own state.
- **`periodicals/`** — v1 periodical output tree; the daily-progress-summary
  schedule that produced it is translated (see below) but the historical output
  is archived rather than carried into a v2 live dir.
- **`agents/`** — v1 agents index; superseded by the role library on `main`.
- **`schedule/README.md`** — v1 index of the now-dropped trigger/`_fired`
  machinery; the two live recurring specs it indexed are translated.
- **`README.md`** (v1 top-level) — superseded by the v2 `README.md`.

## Translated schedules

The two live recurring specs under v1 `schedule/garden/` were translated into
the v2 `schedules/` format (frontmatter `cadence` / `last_dispatched` /
`job_basename_prefix`, then the task body). The v1 per-fire trigger/short-id/
`fired` event-file machinery is dropped; v2 schedules are cadence-keyed specs.

- `20260514T010000Z--72f1f4.md` (hourly scholar library-cycle) →
  `schedules/scholar-library-cycle` (cadence `hourly`).
- `20260513T070000Z--5a93f9.md` (daily midnight-Pacific progress summary) →
  `schedules/daily-progress-summary` (cadence `daily`).

## Provenance

The complete, unmodified v1 journal remains on git branch `journal-v1` and on
`origin/journal`. This migration only adds to `journal2`; it removes nothing
from the source.
