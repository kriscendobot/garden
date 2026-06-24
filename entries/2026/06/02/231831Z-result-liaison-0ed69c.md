---
ts: 2026-06-02T23:18:31Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/230207Z-dispatch-liaison-0ed69c.md
  - entries/2026/06/02/231614Z-result-builder-0ed69c.md
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
---

# result: garden #3 scripts/ layout pivot landed; new kriskowal CHANGES_REQUESTED arrived during build

User asked for a subagent to implement the top-level scripts/ pivot
on garden #3. Builder `0ed69c` closed cleanly.

## Outcome

- **New head**: `1c7e27a2` on `design/driver` (atop prior
  `b6a1318a`, five commits).
- **Commits**:
  - `564372ae` `feat(scripts): top-level scripts/ layout, driver,
    daemons, systemd units (#3)` — 15 files.
  - `52389684` `feat(skills): driver state machine, prompt-on-
    failure capture, activity-feed watcher (#3)` — 5 files.
  - `e320bc6a` `chore(driver): retire roles/driver/ in favor of
    scripts/driver/ (#3)` — 1 file.
  - `da83dac2` `test(driver): update path references for scripts/
    driver/ (#3)` — 6 files.
  - `1c7e27a2` `docs(claude): mention top-level scripts/ in
    Layout (#3)` — 2 files.
- **Test suite**: `tests/driver/run.sh` exit 0; 4 suites pass (59
  assertions).
- **Shellcheck**: `-S warning` clean on all 7 new shell artifacts
  (two `SC2034` directives on `config.sh.example` for sourced
  vars).
- **Top-level PR comment**: `4607743752`.

### Judgment calls

- `skills/driver-state-machine/` renamed to
  `skills/driver-pr-creation-state-machine/` via `git mv` (body
  preserved); two cross-references updated.
- `skills/cleaner/cleaner.sh` left in place (Phase-1 optional;
  flagged as known follow-up).
- Stub-only watcher for `endo-but-for-bots` feed; other three
  feed slugs not stubbed.
- `scripts/daemons/config.sh` gitignored; `.example` checked in.

## Companion event: new kriskowal CHANGES_REQUESTED on #3

While the builder was working, kriskowal landed review
`4406036404` on garden #3 at 2026-06-02T23:07:15Z. Body
(verbatim):

> We should be able to anticipate feedback like this automatically,
> without using agent tokens unless there is a possibility of a
> violation:
> https://github.com/endojs/endo/pull/3294#discussion_r3342643104
>
> That is, if we do a recursive grep for the offending pattern and
> dispatch an agent only if we detect it, we will never make the
> same error again.
>
> Our subagents should be primed to not only respond to feedback,
> but perform self-improvement like this, extending the automation
> to include guards for common hints and dispatch an agent to
> specifically address them. This would likely be a sequence of
> `git` commands that exit non-zero if matches are found, followed
> by a `claude` prompt command with very focused instructions.
>
> This, presumably could also be used to detect common symptoms of
> forgetting the line wrapping rules, like the introduction of ". "
> or ".  " in a comment or markdown file, except for initialisms
> and salutations. Maybe we dispatch an agent only if these
> patterns are found in the diff, so that we do not relitigate
> salutations.

This is **garden-meta process feedback**, not a direct ask on the
scripts/ layout PR. It proposes a pattern: pre-dispatch grep
gates that exit non-zero on match, then claude with focused
instructions on the matched hunks. The two named patterns:
1. The `.engines` → `.bench-engines` rename mistake (endo#3294
   discussion r3342643104 — the original 02:39Z asking ambiguity)
2. Line-wrap rule violations (introduction of double-space
   sentence separators except for initialisms / salutations)

**Not autonomously implementable today**: this is a feature
request for the garden's process layer; it overlaps with the new
`scripts/` layout pivot (driver-pre-ci-validation skill is
Phase 1-2, but pre-feedback-dispatch grep gates is a different
shape). Deferred for maintainer-engaged scoping.

## Teardown

`dispatches/builder--0ed69c` torn down.

## Steward queue post-engagement

- **garden #3** scripts/ pivot landed at `1c7e27a2`; new
  kriskowal CHANGES_REQUESTED proposes garden-meta pre-dispatch
  grep gates; awaits scoping.
- **#387** all CI green at `e22369065`; gibson042 APPROVED
  upstream on endo#3294; one inline suggestion to carry
  (relative-path traversal at install-engines.sh:82) — fixer
  dispatch next.
- **#388** at `f3de0d0fa`; awaits reassessment.
- **#394** at `b22e0db66`; CI failures inherited from #393 base.
- **#401** at `46ba16528`; awaits reassessment.
- **#403** CHANGES_REQUESTED architectural pivot; awaits scoping.
- **#393** stack-wide directive; awaits scoping.
- **#244** retconned; awaits kmkmbp2021 boatman.
