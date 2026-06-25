# Encode the norm: every PR-touching job posts a top-level summary comment, not just inline replies

Wear the **gardener** role (garden meta-evolution). Encode a standing communication norm
into the library, from maintainer feedback on PR #474 (2026-06-25): when a job addresses
review feedback or makes follow-up changes on a PR in response to a directive, the doer
posts **inline thread replies AND a top-level SUMMARY comment** on the PR afterward. On
#474 the fixer posted the four inline Copilot-thread replies and pushed the fix, but
posted **no after-the-fact summary comment** — the maintainer expected one ("there simply
wasn't a summary posted after the fact … I expect feedback on the PR in general").

## The norm to encode

After pushing work to a PR in response to a maintainer directive, a review, or feedback,
the doer must **post a top-level summary comment** on the PR that: names the head SHA,
summarizes what changed (and what, if anything, was declined and why), and gives the
verification status (tests/lint/types) — in addition to any inline thread replies. Silent
pushes and inline-only replies are not enough; the PR conversation should carry a
human-readable acknowledgment of the work. "Feedback on the PR in general" is the
expectation.

## Where to land it

- The PR-touching roles that respond to feedback/directives — at least **fixer**,
  **builder**, **weaver**, **shepherd**, **conductor**, **botanist** — add (or strengthen)
  a "post a top-level summary comment on completion" norm. Reference, don't duplicate, the
  existing inline-reply skills (`skills/pr-review-thread-replies`,
  `skills/review-feedback-followup-commits`).
- Consider a small dedicated skill (e.g. `skills/pr-completion-summary-comment`) the roles
  cite, so the rule is written once: the comment shape (SHA + what changed + verification +
  declined-with-reasons), and that it is REQUIRED, not optional.
- Note it in `roles/COMMON.md` external-repo communication norms so it applies fleet-wide,
  honoring the endo-but-for-bots standing comment authorization.
- Have the relevant **juror** seat (the one that reviews PR communication/etiquette)
  check for a missing summary comment, so future PRs that push silently get flagged.

## Definition of done

The summary-comment norm encoded in the PR-touching roles (+ a skill if you judge it the
right home) and COMMON.md, with a juror check for its absence — committed and pushed to
`origin/main2` under the bot identity. Report the SHA and where the norm landed.

Posted by the liaison on behalf of the maintainer.
