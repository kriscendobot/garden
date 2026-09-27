---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr72-review-e5ce867a
verdict: not-a-miss
category: new-direction
pr: 72
repo: kriscendobot/garden
identity: kriscendobot/garden#72:review:5098622457:retro
comment_url: https://github.com/kriscendobot/garden/pull/72#pullrequestreview-5098622457
review_at: 2026-09-03T06:41:31Z
severity: minor
grounds: |
  Review 5098622457 (CHANGES_REQUESTED, kriskowal) has a one-line "address
  feedback" body; its substance is four inline comments on
  designs/conductor-merge-queue.md. Each one DECIDES a question the PR body had
  explicitly listed under "Maintainer decisions flagged (not decided in the
  doc)": (1) the trivial/nontrivial boundary (lockfile regeneration exempt), plus
  the conductor's operative scope (may weave/fix/shepherd/retcon, with a mandatory
  pre-merge retcon and a final green CI); (2) the return-loop bound, answered as a
  per-PR run-time cap of about half an hour (journal-configurable) with return to
  review and a maintainer alert on failure; (3) the topo tie-break (approval age
  and sequence); (4) whether the Dependabot path stays outside the queue (the
  botanist should go through the conductor). The PR uses the open-questions
  carve-out (CLAUDE.md § Conventions) on purpose, as a maintainer answer surface,
  and these are the answers. They are requirements first stated in the review, not
  defects, spec violations, or missed conventions that a seat, skill, or standing
  rule already knew. No panel could have decided them ahead of the maintainer, by
  construction.

  Not evaluator-gaming. The design stated its open questions honestly and did not
  pre-decide them. Presenting it as a PR review surface is the sanctioned route for
  a design with open questions, not an attempt to skip a gate.

  The deliverable exists in the world, so there is no no-op discrepancy. Commit
  90a177ede93 ("fold in PR #72 maintainer decisions") is reachable from main2, and
  designs/conductor-merge-queue.md there contains all four decisions (§ 1
  botanist enqueue + approval-FIFO tie-break, § 3 lockfile exemption, § 4
  half-hour cap and return/alert). The bot replied to each thread citing the
  commit, the primary job is in jobs/tada/2026/09/03/, and the PR is MERGED.
  Companion retro on the same PR (review 5103330507) was also dismissed as
  new-direction.
---

Maintainer review 5098622457 on PR #72 (design: the conductor as a merge queue)
answered the design's four flagged open questions in inline comments: the
lockfile-exempt rebase boundary and the conductor's scope, a half-hour per-PR
cap with return and alert, approval-age ordering, and routing the botanist
through the conductor. Those are maintainer decisions on questions the design
deliberately left open, so this is new direction, not a review miss. The
decisions landed in 90a177ede93 on main2, and the PR is merged. Re-fetch the
verbatim comments at comment_url.
