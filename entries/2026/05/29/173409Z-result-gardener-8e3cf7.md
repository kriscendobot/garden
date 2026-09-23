---
ts: 2026-05-29T17:34:09Z
kind: result
role: gardener
host: endolinbot
to: liaison
refs:
  - entries/2026/05/29/024700Z-result-steward-d5e6f7.md
---

# Result: retire upstream-side mirror cross-link comments

## Maintainer directive

> My fellow maintainers would like the garden to no longer produce
> mirror messages on upstream pull requests. Please remove this process
> from the relevant roles.

## Scope

Going-forward removal of the *upstream-side* mirror cross-link comments.
Garden-side cross-link comments (on the bot's fork, e.g.
`kriscendobot/endo-but-for-bots` PRs) are unchanged because the
directive specifies *upstream* PRs. Existing upstream-side comments the
steward posted earlier today (14 of them landed at 02:47Z per result
`entries/2026/05/29/024700Z-result-steward-d5e6f7.md`) remain in place;
deletion is a separate, more destructive decision the maintainer can
direct if the fellow maintainers want the historical comments removed
too.

## Files touched and commit

Commit `f952ef01` on `origin/main` (4 edits + 1 deletion):

- `roles/boatman/AGENT.md` — "Two-way mirror cross-link via tagged
  one-liners" norm replaced with "Garden-side cross-link comment via
  tagged one-liner". The symmetric upstream-side bullet, the
  `message: boatman → steward` handoff at end-of-ferry, and the
  superseded-asymmetric premises are gone. Done section drops the
  upstream-side responsibilities. Notes-from-the-field row records the
  retirement and cites the precipitating maintainer directive.
- `roles/steward/AGENT.md` — `## Mirror cross-link postings` section
  removed in its entirety. The steward no longer drains
  boatman-to-steward mirror messages (the boatman no longer produces
  them). The morning's maintainer-feedback-response section above it is
  unaffected; the gamut vocabulary section below it follows directly
  with no gap.
- `skills/pr-handoff/SKILL.md` — step 8 reduced from "Two-way mirror
  cross-link" to "Garden-side cross-link comment". The upstream-side
  bullet and the back-fill skill citation are removed. A short closing
  paragraph explicitly retires the upstream-side procedure.
- `skills/mirror-cross-link-backfill/SKILL.md` — deleted (the skill
  existed solely to back-fill upstream-side cross-links for historical
  ferries; with the going-forward process retired and existing comments
  left in place, the skill is moot). Directory `skills/mirror-cross-link-backfill/`
  removed.
- `CLAUDE.md` § Current inventory — `mirror-cross-link-backfill`
  dropped from the skills list.

Frontmatter `updated:` bumped to 2026-05-29 on `roles/boatman/AGENT.md`
and `skills/pr-handoff/SKILL.md`. The steward role file's frontmatter
was already 2026-05-29 from the morning's maintainer-feedback-response
edit; no second bump required.

## Verification

`grep -lE 'mirror-cross-link-backfill|two-way mirror|message: boatman →
steward'` over `roles/`, `skills/`, `CLAUDE.md`, and `WORKTREES.md`
returns only the deliberate retirement notes I added. No live citations
of the old process remain. Journal-side docs
(`journal/projects/*/README.md`, `journal/README.md`) carry no
references to the retired norm.

## Consequence for in-flight ferries

The next boatman dispatch will not write a `message: boatman → steward`
for an upstream-side cross-link, and the steward will not look for one
in its inbox. Any inbox entries currently queued from prior boatman
dispatches that would have been drained as upstream-side cross-link
postings should be allowed to age out naturally; the steward's drain
will see no matching section to act on. (If any are queued at this
moment the steward will simply not act on them; a follow-up note here
if any are observed in the next cycle's drain.)

## Notes

- No PR opened; meta-edits land on `main` directly per
  `CLAUDE.md` § Conventions.
- The two earlier gardener commits today (`002debba` commenter-parity,
  `ccb4599b` maintainer-feedback ownership, `7406cd35`
  requested_reviewers API fix) are unrelated to this change but
  together describe a busy gardener day.

Self-improvement: `roles/boatman/AGENT.md`, `roles/steward/AGENT.md`,
`skills/pr-handoff/SKILL.md`, `skills/mirror-cross-link-backfill/SKILL.md` (deleted),
`CLAUDE.md`; retired the upstream-side mirror cross-link comment process
per the upstream maintainers' request relayed through this session.
