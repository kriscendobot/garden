---
ts: 2026-05-29T05:06:56Z
kind: dispatch
role: gardener
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/gardener--6e19e2
short_id: 6e19e2
refs:
  - journal/projects/endo-but-for-bots/README.md
  - skills/at-mention-surveillance/SKILL.md
  - skills/monitor-endo-but-for-bots/SKILL.md
  - entries/2026/05/29/015400Z-message-steward-b8c2d3.md
---

# dispatch: gardener — endo-but-for-bots commenter parity (all guarded-repo commenters are maintainer-equivalent)

## Maintainer directive

> Please dispatch a gardener to adjust standing instructions
> regarding the authority of maintainers commenting on pull
> requests or issues in endo-but-for-bots. This repository is
> guarded so only maintainers can comment or propose changes and
> all maintainers are effectively of the same authority. Please
> respond to all instructions in that repository, from all users.
> Particularly, do not ignore kriskowal, kumavis, erights,
> danfinlay, or 0xpatrick.

## What needs to change

The current authority structure in
`journal/projects/endo-but-for-bots/README.md` § Authority structure
names kriskowal + jcorbin as maintainers, erights as a topic-scoped
senior contributor, and routes "anyone else" to journal-only. That
last clause is incorrect for this repo: the repo is guarded so
non-maintainers cannot comment at all; the people who *do* comment
are by construction maintainer-equivalent.

Encode:

1. **The general rule** — on `endojs/endo-but-for-bots`, every user
   who can comment / review / open PRs is effectively a maintainer
   (the repo's permissions enforce this). All maintainers are of
   the same authority on this repo; there is no topic-scoping that
   excludes any of them from any subsystem.
2. **The non-exhaustive named list** — the maintainer explicitly
   names kriskowal, kumavis, erights, danfinlay, 0xpatrick as
   examples we must not ignore. The list is illustrative, not
   complete: the general rule applies to *anyone* who comments.
3. **Routing consequence** — `@kriscendobot` (or otherwise-directed)
   instructions from any of these users on a PR or issue in
   `endojs/endo-but-for-bots` route through the normal dispatch
   chain (fixer / judge / etc.), not journal-only. The
   "Reviews from anyone else are journal-only by default" clause
   is removed for this repo.

## Files to edit

- `journal/projects/endo-but-for-bots/README.md` § Authority structure:
  - Drop the kriskowal-and-jcorbin-only maintainer enumeration in
    favor of the guarded-repo-permission rule plus the named-list
    examples.
  - Drop the erights-as-topic-scoped-senior-contributor distinction
    *for this repo* (he is a maintainer-equivalent commenter on this
    repo by virtue of being able to comment at all; the topic-scoped
    erights rule still applies on `endojs/endo` per the parallel
    project README, unchanged).
  - Rewrite the "Practical rule" section so it reads: all commenters
    on this repo route as maintainer signals; no journal-only
    default.
- `skills/at-mention-surveillance/SKILL.md`:
  - The matrix's "unrecognized author" row (the gap the steward
    flagged in entry `b8c2d3` on 2026-05-29) does not apply on
    `endojs/endo-but-for-bots`. State this in the matrix or in a
    "Per-repo overrides" subsection.
- `skills/monitor-endo-but-for-bots/SKILL.md`:
  - If the per-project monitor skill carries authority-routing logic,
    align it with the new rule. If it just delegates to the project
    README, no edit needed.

## Acceptance

- Per `roles/COMMON.md`'s file-mtime discipline, the gardener uses
  the `--ignore-existing-mtime` trick (or whatever the gardener's
  procedure is for landing meta-edits) and commits each file in a
  conventional-commit shape.
- The result entry names every file touched and includes the
  reasoning behind the erights-on-this-repo elevation (he goes
  from topic-scoped on `endo` to repo-wide on `endo-but-for-bots`).
- No PR (per the garden's CLAUDE.md § Conventions, meta-work lands
  on `main` directly and is pushed to `origin`).
- The cycle-cycle messaging implication: the steward's earlier
  decision on kumavis #328 review-request (entry `b8c2d3`) is now
  reversed prospectively. The gardener does not need to act on
  #328 directly; the steward picks up the new rule on its next
  cycle and dispatches accordingly. The result entry can note the
  reversal for the liaison's awareness.

## Notes for the gardener

- The `endojs/endo` project's authority structure is unchanged;
  erights remains topic-scoped there. Only the
  `endojs/endo-but-for-bots` project README and the at-mention
  skill change.
- The list (kriskowal, kumavis, erights, danfinlay, 0xpatrick) is
  the maintainer's non-exhaustive examples. The general rule
  (guarded-repo permissions → maintainer-equivalent) is the
  load-bearing primitive; the named list is examples-of.

## Report

Return:
- Files touched and a one-sentence summary of each edit.
- Confirmation that the steward's previous kumavis-#328
  routing is now overridden by the new rule.
- Final `Self-improvement: ...` per
  `skills/self-improvement/SKILL.md`.

The liaison writes the matching `result` entry on your return and
tears down this dispatch root.
