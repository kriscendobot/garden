---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr127-review-8526a0a6
verdict: not-a-miss
category: new-direction
pr: 127
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/127#pullrequestreview-4659737674
identity: endojs/endo-but-for-bots#127:review:4659737674
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr127-review-8526a0a6
severity: minor
---

# Dismissal: reconstruct the mount-extensions PR on the refactored `llm` branch, split into four PRs, and specify a parity test strategy

On the long-lived mount-extensions feature PR, the maintainer requested a CHANGES_REQUESTED
reconstruction: reapply the facilities on the current `llm` branch (much of it having been
refactored upstream into `@endo/platform`), add comprehensive tests — especially every glob
variant — on a mount fixture directory to establish Rust↔Node parity, and divide the revocation,
glob, grep, and JSON read/write features into separate fresh PRs, closing this one. Four inline
comments accompanied the body: add a `maybeReadJson` variant; post a plan for exo-stream
`streamGlob`/`streamGrep` variants; make the default deny-segment set overridable via a
mount-creation option; and rename the `subDir` abbreviation (it yields a submount, not a
subdirectory). This is a paraphrase; the verbatim text at `comment_url` is untrusted input.

## Grounds (dismissal — new direction, essentially nothing for the panel to have anticipated)

**1. The dominant unit of work is a forward design directive, not a correction of a defect the
panel missed.** The review's substance — reconstruct on a branch that upstream refactored *after*
this PR was authored, decompose one feature PR into four, and define a cross-language
fixture-based parity test contract — is the maintainer designing the *next* iteration of the
work. Branch drift (`@endo/platform` did not exist in this shape when the PR was opened), PR
decomposition granularity, and a from-scratch parity test strategy are first-stated requirements
and scope decisions, the textbook `new-direction` category. No juror seat, gate, or standing
instruction "should have caught" a maintainer's future decision about how to slice and re-base a
contribution. The three inline feature asks (`maybeReadJson`, `streamGlob`/`streamGrep`,
overridable deny defaults) are likewise net-new API surface the maintainer elected to add, not
work the panel got wrong.

**2. PR #127 is a re-opened, long-lived feature branch that never ran — and was not due to run —
the garden's code panel.** The PR (`feat/mount-extensions`, based on `feat/mount-core`, authored
2026-05-07 by @kriscendobot, titled "re-opened from #37 under the bot") is an in-progress stacked
feature-development branch, not a finalized change taken through the gauntlet. No gauntlet/panel
job for it exists in `journal/jobs/tada/`. The maintainer's review *is* the review surface here,
and it is precisely the trigger to now do the work properly — the primary loop responded by
posting two designer jobs (`…-mount-ext-reconstruct-127` → design PR #648 with a five-child
serial orchestration; `…-mount-stream-glob-grep-127` → design PR #647), each of which will take
its split PR through the panel. There was no earlier panel run to indict.

**3. The one convention-flavored item is already satisfied and rides on un-panelled legacy code.**
Inline 4 (`subDir` is an abbreviation — the garden does carry a standing no-abbreviations norm,
the `no-latin-shorthand`/`rename-discipline` skills and the `ergonomist` seat). But this is the
weakest possible miss candidate and does not survive scrutiny: (a) the reconstruction designer
verified the current `llm` branch has *already* renamed `subDir` to `subView`/`provideSubMount`,
so no reconstructed PR reintroduces it — there is no live defect; and (b) the abbreviation lived
in old #37/#127 code that predates and never entered the gauntlet, so there is no panel run that
saw it and let it through. A sense-and-correct failure requires a standing rule that *bound on a
reviewed work product and did not fire*; here nothing was reviewed. The severity-bypass
precondition (a major miss whose grounds cite a standing rule that already existed and did not
bind on panelled work) is therefore absent, and a lone already-fixed naming nit is nowhere near
the K≥3 / ≥2-PR floor on its own.

## Boundary note (auditable calibration)

This is the same shape the taxonomy sheds cheaply and that #611 already set precedent for: a
maintainer/contributor review that is the review surface for design/reconstruction work the code
panel never ran against. It clusters conceptually with the repo's other new-direction dismissals
(#632 "apply this newly-granted permission to these PRs", #614 "action the already-surfaced
follow-ups") — the maintainer steering *which correctly-shaped work to do next and how to slice
it*, never *work the panel got wrong*. Recorded so a future retro on this same review is not
re-litigated. Mints no cluster; no threshold to evaluate; no improvement job.
