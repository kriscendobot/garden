---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr771-review-c92c5d14
verdict: not-a-miss
category: new-direction
pr: 771
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/771#pullrequestreview-4719365581
identity: endojs/endo-but-for-bots#771:review:4719365581
producing_role: builder
producing_job: (npm-migration experiment; draft, probe-shaped)
severity: minor
---

# Dismissal: pin the drifted base + do the yarn→npm migration properly (no npm.lock)

On PR #771 — a deliberately-DRAFT fleet npm-migration experiment authored by
kriscendobot — the maintainer left a CHANGES_REQUESTED review with a two-part
top-level body and no inline comments. Paraphrase (verbatim untrusted text at
`comment_url`): **(1)** pin the PR base to a `master-xxx` frozen branch at the
hash of the original base so it stops drifting, and rebase to only the germane
commits; **(2)** there is no `npm.lock` — a blind global `yarn`→`npm` text replace
will not suffice; the analogous lockfile is `package-lock.json`; study the
yarn↔npm migration properly.

## Grounds (dismissal — new direction / experiment steering, nothing a panel missed)

**1. #771 is a deliberately-draft experiment (probe-shaped), which by design does
not run the gauntlet/panel.** `isDraft=True`; the body reads "Npm migration
*experiment* based on upstream master commit `46d4edf…`." No `build`, `clean`,
`panel`, or gauntlet job for #771 exists in `journal/jobs/tada/` — only this
review-primary and an auto-shepherd. Per the orchestrator vocabulary, the
auto-gauntlet invariant (clean→panel→fix-loop→un-draft) is for **mergeable-feature
builds, not probes**; an experiment PR legitimately stays draft and never invokes
the panel. So there was **no review-process instance** that could have "missed"
these items — the maintainer's review IS the intended review-of-record for an
experiment, whose explicit purpose is to surface gaps on a tentative direction.

**2. Directive 1 is branch maintenance, not a reviewed defect.** The base pointed
at the fork's moving `master` (drifted to `fcbb540`, producing 17 phantom commits
and a CONFLICTING state). "Pin the base so it stops drifting and rebase to the
germane commit" is an operational/temporal request — the base moved under the
branch — identical in shape to the already-recorded `pr19-review-af733b76`
dismissal, and the subject of the `frozen-base-branch` / `rebase-before-followup`
skill family. It indicts no bug, spec breach, or violated convention in a reviewed
work product; no juror seat or gate could "catch" that a fork's master would drift
later. Canonical `new-direction` steering.

**3. Directive 2 is first-stated domain guidance on a genuinely novel/hard task.**
"npm's lockfile is `package-lock.json`, not `npm.lock`; a global text replace is
the wrong migration model" teaches the correct approach to a yarn→npm workspace
migration. No standing garden seat brief, skill, gate, or COMMON norm encodes
npm-migration lockfile mechanics — the garden has no yarn↔npm-parity check. The
`npm.lock` sloppiness (references to a nonexistent file left by a blind replace)
surfaced *precisely because* this was an experiment probing a tentative direction;
producing exactly this kind of gap report is a probe's designed output, not a
panel miss. It is a requirement first stated in the comment, on work the panel
never reviewed.

**4. Severity-bypass precondition absent.** The bypass needs a `major` miss whose
grounds cite a standing rule that bound on a *reviewed* work product and failed to
fire. Nothing here was reviewed-and-wrong: no panel ran (draft experiment) and no
existing rule was violated. Both directives are workflow/approach steering, not
sense-and-correct on a defect a known lens should have caught.

## Boundary note (auditable calibration)

Recorded so a future retro on this same directive is not re-litigated. Mints no
cluster; no threshold to evaluate; no improvement job. It clusters conceptually
with the fleet's maintainer-steering / branch-maintenance dismissals (the
base-drift/refresh family and the "how to approach a novel experiment" family),
never with "work the panel got wrong." Should the fleet later promote an npm
migration from a draft experiment to a *mergeable* build that then runs the panel,
a recurrence of the `npm.lock`-class error at that stage would be a different,
reviewable event.
