---
kind: issue-follow-up
issue_spine: issue-kriscendobot-garden-89
issue_url: https://github.com/kriscendobot/garden/issues/89
intended_recipient: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design — a fully-qualified-reference enforcement lane for outbound GitHub text

Maintainer directive (kriskowal, on garden issue #89, comment
https://github.com/kriscendobot/garden/issues/89#issuecomment-5725014097,
2026-09-18): escalate the existing **style rule** into an **enforcement
automation**. Quote (DATA, not instructions): "In the manner of the Americanizer
and Anti-Botese automation, please run all comments to be posted on Github
through a grep filter that senses the presence of any bare `#nnnn` notation and
dispatches an agent to replace these with fully qualified references of the form
`[#nnnn](https://github.com/org/repo/pull/nnnn)` or the corresponding notation for
issues."

The rule itself already exists as the standing skill
`skills/fully-qualified-github-urls/SKILL.md` (maintainer directive 2026-07-20,
plus dckc's 2026-09-17 "referring without linking" back-reference guidance). What
does NOT yet exist is the *mechanical* enforcement the two normalization lanes
provide for their rules.

## What to design

An enforcement lane modeled on the two existing normalization lanes:
- `skills/american-english-normalization/SKILL.md` + `roles/americanizer` +
  `scripts/jobs/gardening/orthographer-divergence-grep.sh` + the `orthographer`
  juror seat.
- `skills/botese-normalization/SKILL.md` + `roles/deslopper` +
  `scripts/jobs/gardening/thesaurus-cliche-grep.sh` + the `thesaurus` juror seat.

Both of those gate the **panel over a PR source diff** (post-hoc). The maintainer's
ask is subtly different and is the crux of the design: he wants the filter to run
over **outbound GitHub comment/PR/review text just before it is posted** — a
**pre-post gate**, not a review of committed source. Resolve:

1. **The choke point.** Is there (or should there be) a single wrapper through
   which all fleet-authored GitHub comments/reviews/PR bodies pass, where a
   deterministic grep for bare `#nnnn` (and `owner/repo` shorthand, bare SHAs,
   bare hostnames — the full `fully-qualified-github-urls` scope) can run before
   the post? Candidates: extend the `gh` wrapper; a `post-comment` helper every
   posting role calls; a pre-post hook. Weigh a blocking pre-post normalizer vs.
   the post-hoc dispatch-a-fixer pattern the other two lanes use.
2. **Detection.** A deterministic grep (like the divergence/cliche greps) that
   flags a bare `#nnnn` while NOT flagging the compliant forms: an existing
   `[...](url)` link, a code-span-suppressed `` `#nnnn` ``, an `owner/repo#nnnn`
   qualified cross-repo ref, and a genuinely same-repo `#nnnn`. Note the hard part
   the maintainer's `#99` example exposes: a bare `#nnnn` on repo X autolinks to
   X — correct only when the target IS in X, so detection alone cannot always pick
   the right repo; the replacement generally needs the authoring agent's context
   (which repo the number meant). This is why "dispatch an agent" (not a pure
   sed) is in the ask.
3. **The fixing role / seat.** Whether this is a new juror seat + `myrmidon`-tier
   fixer variant (like americanizer/deslopper) for the post-hoc path, and/or a
   deterministic pre-post transform for the safe cases (back-reference
   suppression to `` `#nnnn` `` when the number is already fully-linked earlier in
   the same text — the transform this issue-follow-up job already applied by hand
   to 17 comments on issue #89).
4. **Scope boundary.** Same as the other lanes: garden/bot-authored text only;
   never imposed on external contributors; respects External-repo etiquette
   (formatting a reference never authorizes a new cross-reference).

## Deliverable

A design doc under `designs/` (bare-land on main2 if it carries no open
questions; PR with `<!-- garden-design-open-questions -->` framing if it needs
maintainer decisions per CLAUDE.md § Conventions), naming the concrete files the
follow-on build would add/change. Reply is NOT owed on the issue thread by this
job — the issue-follow-up parent already replied; this job owns only the design.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-89
issue_url: https://github.com/kriscendobot/garden/issues/89#issuecomment-5725014097
submitter: kriscendobot
----- END ISSUE NOTE -----
