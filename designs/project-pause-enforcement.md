---
created: 2026-09-17
author: gardener
---

# Project pause enforcement: a pause is journal state, not just deployed prose

A project **pause** — "the garden does no work on project X until further notice" —
used to live only as prose in `roles/COMMON.md`. That prose reaches a running host
only through a **deploy**. A host running a stale garden therefore silently violates
every directive newer than its deployed sha, and nothing watches for it.

## The grounding incident (2026-09-16/17)

`roles/COMMON.md` § Project scope carries an unambiguous directive (kumavis,
2026-09-09, kriscendobot/garden#91): IronHorse work is **paused at zero priority** —
the garden does not claim, post, promote, orchestrate, or run any IronHorse work, and
every existing IronHorse plan item stays parked.

Despite that, between 2026-09-16T23:53Z and 2026-09-17T02:23Z the fleet posted and ran
a storm of IronHorse fuzz repair jobs — roughly **sixty**, each quarantined with
`doom_signature=policy-refusal` and each delivering its own maintainer-inbox message.
The diagnosis (`ironhorse-fuzz-repromote-quarantined`): the **leader** host was running
an **old deployed garden** (~08-31..09-04) whose fuzz lane kept posting per-finding
repair jobs. Its deployed code **predated the 09-09 pause**, so as far as that host's
running code was concerned, the pause did not exist. The storm stopped only when the
leader finally deployed. Nothing detected that a paused project was being actively
worked for over a week.

Two harms, one upstream of the other. The policy refusals and the reaper's quarantine
were **correct** and deterministic. The failure was upstream: the work should never
have been posted, claimed, or promoted. And the reporting itself was a defect — sixty
messages for one systemic cause.

## The design gap

- A pause is prose in a file that reaches a host only via deploy, so a stale host
  cannot honor it.
- The violation is invisible: no alert fires, because nothing watches for "work is
  happening on a paused project."
- The blast radius scales with how far behind a host is — and the **leader**, which
  runs every singleton producer (foreman, scheduler, watchers), is the worst host to
  be stale.

## The fix, in five parts

### 1. A pause is journal state

An active pause is a record `pauses/<slug>.md` on the **`journal2`** branch, which
every host reads **live** (it does not wait on a deploy). Its frontmatter names the
project, the authorizing maintainer, the directive citation, the date, the scope, and
optional `match:` patterns; its **existence** means paused. Written/lifted by
`scripts/jobs/pause-project.sh` (`<slug> on … | <slug> off | status <slug> | list`),
CAS-raced onto `journal2` exactly as `brake-foreman.sh` writes the foreman brake.

`roles/COMMON.md` keeps the **human-readable** statement; the journal record is what
**machinery** consults. **Keeping the two from drifting:** the record body embeds the
directive citation and points back to COMMON.md; `pause-project.sh` prints an explicit
"now update roles/COMMON.md § Project scope to match" on every arm and lift; and
`pause-project.sh list` / `status` is the surface a human (or a future guard) uses to
confirm the journal matches the prose. The two-place update is deliberate: the prose is
the human's contract and the journal is the machine's, and each audience needs its own.

### 2. Enforcement at the chokepoints

`common.sh project_pause_hit <clone> <base> [body-file]` echoes the slug of an active
pause that covers a job (base name + body matched, case-insensitively, against the slug
and the `match:` patterns) and returns 0, else 1. It is wired at the three seams a
paused job could enter or advance through:

- **post** (`post-job.sh`) and **park** (`post-plan.sh`) — a stale producer cannot put
  paused work onto the board. Refuses with `GARDEN_PAUSED_RC` (78).
- **claim** (`claim-job.sh`) — defense in depth: even a paused job already on the board
  is never claimed; the candidate is skipped like the backend-fit filter.
- **promote** (`promote-plan.sh`) — refuses to move a paused plan item into `todo/`,
  **even under `--maintainer`**. Promoting a parked paused item is exactly what
  re-armed the storm. The authorized way to run paused work is to **lift** the pause
  (delete the record) — the auditable act — not to slip one promotion past the gate.

### 3. Fail safe toward paused

`project_pause_hit` is generous toward paused, mirroring `foreman_braked` (existence is
the signal; a garbage flag still brakes) and the drain-source default (an unreadable
marker is treated as `operator`). The mechanism: the slug is the record's **filename**,
which is always readable even when the record's **content** is corrupt. So a
present-but-unreadable pause record still blocks any job that names the project. The
richer `match:` patterns are an addition read only when the body is readable. The blast
radius stays bounded: with no record at all every job passes (no record ⇒ no
restriction), and an unreadable record blocks only jobs that name **its** slug, never
the whole board. The chokepoints call `project_pause_hit` only after `sync_clone`, which
itself exits the tick on an offline/unreadable journal, so the pause is never evaluated
against a journal that could not be read.

### 4. Coalesced alerting

When a paused project shows activity, the chokepoint calls
`common.sh note_project_pause_block`, which routes through `alert_maintainer` keyed
`project-pause-active-<slug>` — so `watchdog-notice.sh` folds every occurrence into
**one** maintainer entry per project whose count climbs, never one message per job.
Sixty messages for one cause is precisely the reporting defect that helper exists to
kill. On one host the first block delivers and the rest fold in under the throttle;
across hosts the notice amends the same journal entry.

### 5. Leader staleness

The `root-repo-guard`'s stalled-deploy watch already alerts when the deployed sha lags
`origin/main2`, with a **shorter leader fuse is not** the point — a leader that is far
behind is disproportionately dangerous because it runs every singleton producer, and a
day-based fuse can still let a leader drift many commits before firing. So the watch
gains a leader-specific **commits-behind** trigger (`GARDEN_DEPLOY_STALL_COMMITS_LEADER`)
that fires the same coalesced alert as soon as a leader is far enough behind, whichever
comes first, and the message names the specific danger: a leader on stale code is not
honoring directives newer than its deployed sha — a project pause among them. This stays
one signal inside the guard rather than a new unit; the guard already owns "the deployed
tree is wrong."

## Out of scope (and honored here)

This design does **not** lift the IronHorse pause, un-park any IronHorse plan item, or
run any IronHorse work. The 67 parked IronHorse items stay parked — that is what the
directive requires — and this enforcement mechanism itself honors the pause it enforces.
The live IronHorse pause record is **armed operationally** by the liaison/maintainer
running `pause-project.sh ironhorse on …` once this change is deployed (arming journal
state before the reading code exists on hosts is a no-op, and is an operator act, not a
build-job act); the mechanism ships here, the arming is a documented follow-up.

## Tests

`scripts/jobs/test/project-pause-enforcement-test.sh` pins: a paused project's job
cannot be **posted**, **parked**, **claimed**, or **promoted**; an **unreadable** pause
record still blocks (fail safe toward paused); a job for an **unpaused** project passes
every chokepoint unchanged; and lifting the pause re-opens all four.
