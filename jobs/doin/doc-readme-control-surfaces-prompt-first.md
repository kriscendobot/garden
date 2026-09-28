---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
token-budget: 400000
---
# Reorient README's "Control surfaces" section around what a maintainer says, not what runs

Follow-up to yesterday's `mentat-garden-docs-refresh-20260927` pass and
today's `doc-readme-dispatch-tier-section` job. Repository:
`kriscendobot/garden`, branch `main2` — land direct, no PR, per CLAUDE.md's
own-repo convention (unless you find real open questions). Work in an
isolated project worktree (`ensure-project-worktree.sh <base>
kriscendobot/garden main2`). Never run git against `$GARDEN_ROOT`.

## Maintainer directive (kriskowal, 2026-09-28), verbatim

> Let's also update the section on control surfaces such that it is oriented
> not on the mechanism the garden will use to effect the will of the
> maintainer, but the example prompts a maintainer might use to request
> those effects.

## The specific problem

README.md `## 2. Control surfaces`, and especially its
`### Lever semantics: what each control does not reach` table, leads with
the SCRIPT/MECHANISM as the primary, scannable identifier — the table's
first column is literally `promote-plan.sh <job>`, `drain-fleet.sh on`,
`set-workers.sh <kind> <N> [host]`, `deploy-garden.sh`, etc. — with the
natural-language phrase a maintainer would actually say folded in secondarily
(`` `promote-plan.sh <job>` / "go ahead on X" ``, command first). A
maintainer skimming this section has to translate mechanism-into-prompt
themselves; it should read the other way.

Other subsections in the same `## 2` section (the claude-CLI/liaison
subsection, the GitHub-issues subsection, the other-repos subsection) already
lead with prompt examples reasonably well — use those as your in-document
model for the register/voice to match, and check them too for any residual
mechanism-first framing worth fixing while you're in the section, but the
Lever semantics table is the primary, acute target.

## What NOT to lose

The table's real value is its precise, hard-won boundary knowledge — what
each lever does *not* reach, and which interacting lever to check when it
looks like something is stuck (the `gate: go-ahead` doesn't auto-promote
distinction, the drain-vs-foreman-target distinction, the sysop benign vs.
attested tier distinction, etc.). Reorienting means changing what LEADS each
row, not deleting the mechanism/caveat detail — a maintainer who wants to go
deeper still needs the script name and the "what it doesn't reach" column.
Keep every existing caveat; just make the natural-language phrasing the
primary, first-glance content and the mechanism the supporting reference
(a parenthetical, a secondary column, a "how" link — your call on the exact
table/prose shape, but the prompt phrasing must be what a reader's eye hits
first).

## A precedent already in the repo

`context/control-surface-gallery.md` narrates ~40 real maintainer dispatches,
each already framed prompt-first. Read it for the register/voice to match.
Do not duplicate its worked examples into README — README's job stays the
compact reference table; the gallery stays the narrated deep-dive. Just make
sure README's own framing no longer contradicts the gallery's in emphasis.

## Validate

Run whatever doc-gate checks `mentat-garden-docs-refresh-20260927` used
(relative-link resolution, frontmatter/whitespace checks — look at its
landed commits or the CI run it references for the exact gate names) before
completing.

## Report

Quote the reworked table's new lead-in shape (one or two example rows) in
your completion report, and name the commit that landed it.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T08:54:29Z
