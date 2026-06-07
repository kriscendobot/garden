---
ts: 2026-06-07T06:18:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--a14165
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4424101026
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4628329171
---

# dispatch: researcher — separate no-spackle PR experiment per erights's premises on #417

User directive (2026-06-07): *"RSVP
https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4628329171"*.

The cited kriskowal comment is the RSVP authorization for an
erights-authored directive in review `4424101026` on the same PR:
*"start a separate PR experiment with the following premises"*.

erights is a topic-scoped senior contributor on the immutable-
ArrayBuffer / hardened-JS surface per
[`journal/projects/endo/README.md`](../../projects/endo/README.md)
§ Authority structure; kriskowal's RSVP closes the maintainer-
authorization loop.

## erights's premises (verbatim from review `4424101026`)

> @kriscendobot, I am posting these review comments here so we
> (you, me, @kriskowal) all have access to them. But do not act on
> them in this PR unless @kriskowal asks you to. Instead, building
> on my same original commits, please start a separate PR
> experiment with the following premises:
>
> - No spackle.
> - Neither the immutable ArrayBuffer ponyfill nor the freezable
>   ArrayBuffer ponyfill visible outside the immutable-arraybuffer
>   package. The immutable-arraybuffer package exports only the
>   shim.
> - We extend the shim so it also builds on the freezable
>   TypedArray pony to replace each of the concrete global
>   constructors with the pseudo constructors built using maker
>   from the pony's exports.
> - Do not export *anything* from the immutable-arraybuffer
>   package that should remain encapsulated.
> - The shim should race to install only so that a prior apparent
>   native implementation causes the shim to not install anything.
> - Since there's no spackle and the only race is this simple, we
>   don't need new symbols.
>
> For each improvement you did in this PR, if it does not
> conflict with the above premises, apply the improvement to the
> new PR as well. Use a review comment to ask about anything
> you're unsure of.
>
> Within the immutable-arraybuffer package, keep the pony tests
> you've done in this PR. But each pony test should have a
> corresponding shim test if it makes sense.
>
> Please break the new PR experiment into separate commits as
> you've done in this PR, so it is easily reviewable
> commit-by-commit. But do not include anything in early commits
> that will be overwritten by later commits.

## PR #417 state at dispatch

- Branch `mirror/3164-freezable-typedarrays`, head `e1f4541`,
  base `master`, 24 commits.
- Title: `feat(immutable-arraybuffer): freezable virtual
  typedarrays (mirror of endojs/endo#3164)`.
- Original first commit: `96e4fd4 feat(immutable-arraybuffer):
  freezable virtual typedarrays` — likely what erights means by
  "my same original commits" along with the fixups.

## What the downstream builder will need to do

> Open a separate PR experiment that builds on erights's original
> commits from PR #417 with the six premises above. Specifically:
> drop spackle-related commits (d334dcc through 5cfbb05 sweep);
> keep the freezable-typedarrays substance (96e4fd4 + fixups
> 24ac8fa, 59dfbc6, 984b5d4, 08b6bcd, f6d919e, 0bf3dc8);
> restructure so only the shim is exported from immutable-
> arraybuffer; build the shim on the freezable TypedArray pony's
> pseudo constructors; race-to-install pattern; no new symbols.
> Break into commit-by-commit reviewable commits.

This is substantive work the researcher should ground in
`journal/library/` and the project history before the builder runs.

## What you should look for

- **erights's authority scope.** Per
  `journal/projects/endo/README.md` § Authority structure: which
  topics are in scope? Immutable ArrayBuffer is named; freezable
  TypedArray is the contiguous-but-separate proposal. Confirm the
  RSVP authorizes builder work on both.
- **The substance of the proposals.** Librarian cycle 201
  (`journal/library/sources/endo--packages-immutable-arraybuffer.md`)
  documents the ponyfill+shim architecture, the Purposeful-
  Violation pattern, the three-tier fallback, the WeakMap-as-
  brand-check. The new shortcuts in
  `journal/library/keywords.md` (added in the prior researcher
  dispatch this cycle) point at it.
- **The spackle pattern.** The spackle pattern (d334dcc onwards)
  is what erights wants dropped. Find any library entries on
  spackle's purpose — was it a register-symbol-for-cross-realm
  install thing? understanding what's being removed is
  load-bearing for the builder.
- **"Original commits" boundary.** What does erights mean by "my
  same original commits"? The first 6-7 commits (through the
  ses freezable-typedarray-prototype annotation) likely form the
  pony-side substance erights wrote. The spackle commits (d334dcc
  onwards) are likely the kriscendobot expansion erights wants
  rolled back.
- **Race-to-install pattern.** Memory of any prior race-on-shim-
  install in the codebase (immutable-arraybuffer itself? other
  shims like ses?). Useful for the builder to copy the canonical
  shape.
- **Pseudo constructor / maker pattern.** What does erights mean
  by "pseudo constructors built using maker from the pony's
  exports"? Library entries on the pony's exported maker, or
  source code surfaces, would help the builder pick the right
  composition.
- **PR-experiment naming convention.** `experiment/no-spackle-
  3164` or `mirror/3164-freezable-typedarrays-experiment` or
  something else? Past precedent for "separate PR experiment"
  shape on the bot fork.
- **PR-shape constraints**: frozen-base (probably yes,
  `master-<sha>`), DRAFT, title carrying the experiment framing.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section. The
steward will inline that section verbatim into the builder's
dispatch brief.

Keep your dispatch under five minutes wall time (this one merits
a slightly longer walk than the standard three minutes because
the substance is novel; do not exceed five). No project worktree
was prepared (journal-and-library work only).
