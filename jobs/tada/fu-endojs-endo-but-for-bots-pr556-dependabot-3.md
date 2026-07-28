Landed on `main2` as `fcc45ac2f3`.

## What I did

Extended `roles/botanist/AGENT.md` with the check unique to `github-actions` Dependabot PRs: proving the pinned commit SHA actually resolves to the tag the PR claims. Additive only, no existing rule rewritten.

Two things shaped the result:

1. **A peer had already landed part of this while I was interrupted.** Commit `5228849d28` (07:46Z, 20 minutes before my claim) added a `github-actions` substitution note to step 4 containing a one-line version of the tag resolution. I deepened it rather than duplicating it.
2. **I ran the check before writing it, and the naive form is wrong in two ways** — both verified live against the GitHub API, not assumed:
   - **Annotated tags need a deref.** `git/ref/tags/<tag>` returns the *tag object* SHA for an annotated tag, not the commit, so a straight comparison against the pin reports a mismatch that is not real. Both shapes are common: `actions/cache`, `actions/checkout`, `docker/setup-buildx-action` tag lightweight; `pnpm/action-setup`, `codecov/codecov-action` tag annotated.
   - **Commit-existence proves nothing.** GitHub serves a whole fork network from the parent's endpoint. A commit living only on a `kriscendobot/endo-but-for-bots` branch returned 200 from `repos/endojs/endo-but-for-bots/commits/<sha>`, while `compare/<base>...<sha>` returned 404 on the same repo. Only the tag-to-commit direction establishes provenance.

The landed snippet branches on `.object.type` and derefs; I tested it on the annotated, lightweight, and deliberate-mismatch cases. Mismatch disposition is REJECT-and-surface, carried into the anti-patterns and the definition of done. It also tells the botanist to confirm the `uses:` owner (a typosquat passes every hash check) and to record tag, resolved commit, and resolution date in the verdict, since a git tag is mutable.

## Changed

`roles/botanist/AGENT.md` (+17): a `github-actions` pin-verification block after the step-4 substitution note, one anti-pattern bullet, one definition-of-done line.

Push hit a conflict against a concurrent `main2` commit (`5950325550`, maturity floor from the freshest moved version) in the anti-patterns list; both bullets were independent, so I kept both and pushed clean.

## Follow-ups

Items 1, 3, 4, 5 of the proposal in `inbox/liaison/unread/20260728T073516Z-b2ee8f.md` remain the maintainer's call, item 3 especially (making the step-5 advisory rule directional). I messaged the liaison that item 2 is landed, with the caveat that items 1 and 4 have partly landed since the proposal was written, so a re-read before directing them will save duplicated work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr556-dependabot-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 63 tokens (2039506 cached reads)
- Output: 17763 tokens
- Cost: $2.1526229999999997
- Wall-clock: 335s

<!-- garden-usage-end -->
