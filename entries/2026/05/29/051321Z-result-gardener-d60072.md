---
ts: 2026-05-29T05:13:21Z
kind: result
role: gardener
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/29/015400Z-message-steward-b8c2d3.md
  - projects/endo-but-for-bots/README.md
---

# Result: widen endo-but-for-bots authority to every commenter

## Maintainer directive (2026-05-29)

> Please dispatch a gardener to adjust standing instructions regarding
> the authority of maintainers commenting on pull requests or issues in
> endo-but-for-bots. This repository is guarded so only maintainers can
> comment or propose changes and all maintainers are effectively of the
> same authority. Please respond to all instructions in that repository,
> from all users. Particularly, do not ignore kriskowal, kumavis,
> erights, danfinlay, or 0xpatrick.

## Files touched

- `journal/projects/endo-but-for-bots/README.md` § Authority structure:
  rewrote the section to state the general rule (the repo's GitHub
  permission gate restricts commenting to maintainers, so every
  commenter is maintainer-equivalent on every subsystem and every
  topic), list the non-exhaustive named set (kriskowal, kumavis,
  erights, danfinlay, 0xpatrick, plus jcorbin from the 2026-05-13
  recognition), state the routing consequence (`@kriscendobot`
  instructions from any commenter route through the normal dispatch
  chain rather than journal-only), and note that the elevation is
  **repo-scoped to `endojs/endo-but-for-bots` only**, leaving the
  topic-scoped erights treatment on `endojs/endo` unchanged.

- `garden/skills/at-mention-surveillance/SKILL.md`: added a *Per-repo
  overrides* sub-section to the reaction matrix that names
  `endojs/endo-but-for-bots` as the override (every commenter is
  treated as maintainer-equivalent; the "unrecognized author" gap row
  does not apply), cited the project README § Authority structure for
  the canonical statement, kept the default authorization model
  (maintainer-or-topic-scoped-senior) for other safe-to-monitor repos.
  Added a 2026-05-29 Notes-from-the-field entry citing the steward's
  matrix-gap observation at `b8c2d3` as the precipitating signal.

- `garden/skills/monitor-endo-but-for-bots/SKILL.md`: replaced the
  Recognized-maintainers section so it widens to every commenter on
  this repo (the prior `kriskowal`/`jcorbin`-only matching was a
  redundant inner gate behind the permission gate). Rewrote the
  `PullRequestReviewEvent` and `IssueCommentEvent` rule rows to read
  "any reviewer" / "every commenter" rather than "recognized
  maintainer." Replaced the *Senior contributors (erights et al.)*
  subsection (with its topic-match keyword/file-path heuristic) with a
  short *Cross-repo erights note* that retains the topic-match
  heuristic explicitly on `endojs/endo` only, deferring to
  `skills/monitor-endo/SKILL.md` and the endo project README. Added a
  2026-05-29 Notes-from-the-field row recording the widening.

## Steward's kumavis-#328 routing: now overridden

The steward's `b8c2d3` message (2026-05-29T01:54Z) decided "no reactji,
no fixer / judge / panel dispatch, surfaced to liaison" on kumavis's
`@kriscendobot review this pr` comment on
[endojs/endo-but-for-bots#328](https://github.com/endojs/endo-but-for-bots/pull/328),
on the grounds that kumavis was not in the named maintainer or
topic-scoped-senior set. Under the new authority structure landed in
this dispatch, that routing is overridden: kumavis is in the
non-exhaustive named list, and even an unnamed commenter would route
the same way (every commenter is maintainer-equivalent on this repo).
The gardener does not act on #328 directly; the next steward cycle (or
the next at-mention-surveillance Monitor tick that observes the
comment is still un-acked) will pick it up under the new rule and
react+dispatch normally.

## Notes

- No PR opened; meta-edits land on `main` directly per
  `garden/CLAUDE.md` § Conventions.
- Garden commit `002debba` ("monitor-endo-but-for-bots: widen authority
  to every commenter (2026-05-29 directive)") pushed to `origin/main`.
- Frontmatter `updated:` bumped to 2026-05-29 on both edited skill
  files; the project README has no frontmatter (journal documents
  carry their own dating via `ts:` per `roles/COMMON.md`).
- Em-dash and relative-paths style applied per
  `garden/skills/em-dash-style/SKILL.md` and
  `garden/skills/relative-paths/SKILL.md`.

Self-improvement: `garden/skills/at-mention-surveillance/SKILL.md`, `garden/skills/monitor-endo-but-for-bots/SKILL.md`, `journal/projects/endo-but-for-bots/README.md`; added a per-repo authorization override for `endojs/endo-but-for-bots` whose GitHub permission gate already restricts commenting to maintainers, closing the matrix gap the steward's `b8c2d3` message flagged.
