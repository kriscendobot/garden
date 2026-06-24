---
ts: 2026-06-14T07:42:51Z
kind: result
role: gardener
host: endolinbot
to: liaison
short_id: aa3d6f
refs:
  - entries/2026/06/14/073600Z-dispatch-gardener-aa3d6f.md
  - https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4701061078
---

# Result: shepherd surgical-fix constraint relaxed (commit 7687bc42)

## Routing

Dispatch `aa3d6f` per the maintainer's directive on
`kriscendobot/agoric-sdk#5` (issue-comment `4701061078`,
2026-06-14T07:34Z):

> Please dispatch a gardener to relax the shepherd's standing
> instructions such that shepherds pursue all tests passing in CI
> by whatever means necessary until reaching an impasse or success.

## What landed

Commit `7687bc42` on `origin/main` (1 file, +17 / -10):

### `roles/shepherd/AGENT.md` — three sections rewritten + one new section

**§ Operating norms** (lines 33-35): new headline norm replaces the
prior *Take initiative to get all tests passing* bullet:

- _Before_: *"Take initiative to get all tests passing. ... Keep
  going through successive failures ... until CI is green or you hit
  a hard escalation point."*
- _After_: *"Pursue all tests passing in CI by whatever means
  necessary, until reaching genuine impasse or success."* Cites the
  2026-06-14 directive verbatim. Adds *"The shepherd is **not**
  constrained to surgical-scope fixes; it keeps going through
  successive failures ... pursuing the underlying cause wherever it
  leads."* The *Prefer the smallest fix* norm is preserved but
  explicitly softened: *"Larger fixes are not prohibited; they are
  not the default. When a smaller fix exists, take it."*

**§ Hard escalation points** (lines 36-45): rewritten from a 5-bullet
list to a 6-bullet list cleanly split into IMPASSE and SAFETY
GUARDRAIL categories:

- IMPASSE: design decision needed; structural decision needed;
  missing context.
- SAFETY GUARDRAIL: never silently delete a failing test; never
  bypass safety checks; never push outside the PR's scope.

Closing paragraph explicitly retires the prior framing limit:
*"Scope alone is no longer an escalation criterion; impasse and
safety are."*

**§ Escalation classification (next: fixer row)**: rewritten. Before,
the criterion was *"the repair fits the fixer's surgical-fix scope
(≤ ~5 files, no public-API or topology changes)"*. After, the
criterion is *"the shepherd has reached an impasse — typically
*contextual* (the fix needs interpretation of an inline review
comment, a choice among ambiguous test-failure interpretations, or
a per-package convention the shepherd is unfamiliar with) rather
than *scope-of-fix*."* The verdict is noted as *less common* under
the new framing because the shepherd's default is to apply the fix
itself.

**§ Notes from the field** (new section): 2026-06-14 row records the
precipitating directive, the verbatim quote, the IMPASSE-and-SAFETY
re-anchoring, and the companion fixer dispatch `c997e7` on PR #5
that ran with the override applied to its brief at dispatch time.

Frontmatter `updated:` bumped to 2026-06-14; existing author list
(liaison, gardener) preserved.

## Cross-reference review (no changes needed)

`grep -rn "surgical" roles/ skills/ CLAUDE.md` (excluding jurors)
surfaces four other mentions:

- **`roles/steward/AGENT.md`** § Auto-pickup chains line 325:
  describes how the steward responds to the shepherd's escalations
  ("the fixer's surgical-fix scope"). The fixer is **still** surgical
  (the maintainer's directive is specifically about the shepherd;
  the fixer's constraint is unchanged), so the steward's behavior is
  unchanged. The semantic shift (when the shepherd issues
  `next: fixer`) does not change the steward's response.
- **`roles/conductor/AGENT.md`** line 46: about conductor's own
  surgical scope on frozen-base unfreeze. Unrelated to shepherd.
- **`skills/frozen-base-branch/SKILL.md`** line 122: about
  conductor. Unrelated.
- **`skills/model-selection/SKILL.md`** line 18: generic mention.
  Unrelated.

No cross-reference updates required.

## Out of scope

- **`roles/fixer/AGENT.md`**: not touched. The fixer is still
  surgical; the maintainer's directive is about the shepherd's
  constraint, not the fixer's. The dispatch brief was explicit on
  this point.
- **Companion fixer dispatch `c997e7` on PR #5**: handled by the
  liaison. The override was applied to that dispatch's brief at
  dispatch time; this role-file change makes the override the
  standing default for future shepherds.
- **Journal-side cleanup**: no contractor-slot or presence-file
  artifacts to clean up from this change; the steward will absorb
  the new shepherd norm on its next role-file re-read.

## Inbox nudge

Will send a `message: gardener -> steward` to nudge the steward
to re-read `roles/shepherd/AGENT.md` so its next shepherd dispatch
(or its auto-pickup chain consuming a shepherd verdict) operates
under the new framing. The next steward cycle on this host or any
other will pick up the nudge via inbox-drain.

Self-improvement: `roles/shepherd/AGENT.md`; the shepherd's
constraint axis re-anchors from *scope of fix* to *impasse plus
safety*, matching the maintainer's framing of the role as the
gate that keeps red-CI PRs out of the review queue at whatever
cost short of unsafe action.
