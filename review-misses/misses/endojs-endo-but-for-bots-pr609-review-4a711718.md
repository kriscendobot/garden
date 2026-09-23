---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr609-review-4a711718
verdict: miss
category: naming
pr: 609
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/609#pullrequestreview-4675177693
identity: endojs/endo-but-for-bots#609:review:4675177693:retro
producing_role: gardener
producing_job: gauntlet-endo-but-for-bots-pr609-endoclaw-timer
missed_by: stylist
severity: minor
cluster: avoid-name-abbreviations
cluster_pattern: An abbreviated identifier in freshly-authored code (dir, Arg, subDir, Temp, Cmd) that a panelled PR let through — the maintainer repeatedly asks names be spelled out in full; no code-panel naming seat or gate mechanically flags abbreviation.
---

# Miss: abbreviated identifier `makeIntervalSchedulerCmd` in panelled new code on #609

kriskowal's CHANGES_REQUESTED review on #609 (review `4675177693`,
`feat(daemon): interval-scheduler formula`) carried a design-pivot body plus two
inline nits; all paraphrased here (verbatim untrusted text at `comment_url`):

1. **review body — a design pivot (NOT a miss):** rename/reframe the mechanism as
   a "message scheduler" (not a generalized scheduler), push durable persistence
   down to the platform (decouple from the file system; allow a DB or virtual file
   system), reconsider deep daemon integration in favor of an **unconfined plugin**
   using the VFS with a `@pins`-style live-reference narrative, and — the directive
   — **redraft the change as a new plugin `@endo/reminder`.**
2. **inline on `packages/daemon/src/host.js:1333` — a naming ask (the miss):**
   avoid the abbreviation; rename `makeIntervalSchedulerCmd` → `makeIntervalScheduler`.
   The maintainer's stated grounds: it is unclear what `Cmd` is meant to indicate,
   and the function is not making a command.
3. **inline on `packages/daemon/src/interval-scheduler.js:10` — a JSDoc nit:**
   omit the redundant `@module` tag. A trivial style-convention point (see grounds);
   below any cluster floor, not the cluster driver.

## Grounds (miss — the naming ask, comment 2)

This is the **second panelled abbreviation miss on a DIFFERENT PR** — the exact
trip-wire both prior `avoid-name-abbreviations` members (`…-pr650-review-35ff43ca`,
`…-pr650-review-d4abc76c`) named when they held the cluster at prs={650}: *"A second
panelled abbreviation miss on a DIFFERENT PR would give prs={650, …} and trip the
cluster."* #609 satisfies every clause the miss test requires:

- **Garden-authored, freshly written code.** `makeIntervalSchedulerCmd` is a host
  facet the endoclaw-timer build authored in this PR's diff (host.js:1333, one of
  15 changed files, 2051 additions), not inherited legacy.
- **The code panel demonstrably ran.** The gauntlet report
  (`gauntlet-endo-but-for-bots-pr609-endoclaw-timer`) records a full run of 10
  code-panel seats — including the always-on `stylist` naming seat — plus an
  adversarial verify of the fixer delta, yet let the `Cmd` abbreviation through to
  the maintainer.
- **A plain, unambiguous abbreviation.** `Cmd` for `Command` carries no
  domain-vocabulary ambiguity; the maintainer literally opens the inline with
  "Avoid abbreviations." The spell-it-out preference is now consistent across five
  asks and three PRs (`Arg` #592, `subDir` #127, `dir`/`Temp` #650, `Cmd` #609).

The `stylist` seat brief reads for identifiers being "crisp and unambiguous" but
encodes no mechanical *never-abbreviate* check, so an abbreviated-but-unambiguous
identifier slips its lens — the precise sense-gap the `avoid-name-abbreviations`
cluster was opened to close. Genuine review miss, not new direction.

## Why comment 1 (the design pivot) is NOT a miss

The review body rejects PR #609's daemon-formula-integration approach wholesale in
favor of a differently-architected unconfined `@endo/reminder` plugin (VFS-backed
persistence, out-of-band live-reference narrative). That is taste-and-scope
architecture first stated in the comment — nobody could have anticipated the
maintainer wants a full redraft, and the primary loop correctly routed it to a
fresh **designer** job rather than patching the superseded diff. New direction, not
a defect the panel let through. Recorded here so it is not separately re-litigated;
it mints no cluster.

## Why comment 3 (the `@module` tag) is NOT clustered

The "omit the redundant `@module` tag" ask is a trivial, single-occurrence JSDoc
style preference (arguably taste — a `@module` tag on a module file is defensible),
`severity: minor` at most, with no matching cluster and no cross-PR recurrence. It
does not clear any dispatch floor on its own and would only dilute the naming
signal if clustered. Noted and folded into the primary loop's redraft brief;
mints no cluster here.

## Threshold call recorded at this record's tail

Joining this miss bumps `avoid-name-abbreviations` to **count=3** with
**prs={650, 609}** — the floor (K≥3 misses across **≥2 distinct PRs**) is now
**met** for the first time. The two-PR guard that held #650's two members below the
floor is cleared: the abbreviation pattern is demonstrably cross-PR, not one messy
PR. The maintainer's preference is consistent, long-standing (five asks over three
PRs), and mechanically detectable, and — as the #592/#650 records established —
**no garden seat, skill, or gate encodes identifier-abbreviation avoidance today**
(the `stylist`/`ergonomist` lenses carry no never-abbreviate check; `no-latin-shorthand`
governs Latin prose abbreviations like i.e./e.g., not identifiers; `rename-discipline`
governs gratuitous renames). This is a standing prevention-and-sense gap the review
loop exists to close. Dispatching **one** `review-improve-avoid-name-abbreviations`
builder job.
