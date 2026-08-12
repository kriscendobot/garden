---
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# builder: run the test workflows on `llm`, the branch this fork actually uses — own PR

Repo `endojs/endo-but-for-bots`. Open this as its **own PR** against `llm`. Do NOT
push it into the draft PR https://github.com/endojs/endo-but-for-bots/pull/124.

## The problem

This fork's workflows inherited `on: push: branches: [master]` from upstream
`endojs/endo`, where `master` IS the trunk. Here it is not:

    origin/master  last commit 2026-07-22   (3 weeks stale)
    origin/llm     last commit 2026-08-12   (today)
    diverged; llm is 2672 commits ahead of master

So every `[master]`-only workflow's **push** trigger is dead in practice. Nothing
pushes to `master`. `pull_request:` (unfiltered) still fires, so PRs are gated —
the loss is **post-merge validation on the trunk**: once a PR merges to `llm`,
nothing re-runs, so a bad interaction between two independently-green PRs is not
caught until someone opens the next PR.

`browser-test.yml` already gets this right with `branches: [master, llm]`. That is
the pattern to match — not `ci.yml`.

Precipitating case: `rust.yml` (renamed from `rust-endor.yml` in commit `1e153052d`)
was deliberately set to `[master]` to "match the repo's other test workflows
(ci.yml)" — https://github.com/endojs/endo-but-for-bots/pull/124#issuecomment-5272688338.
The reasoning was sound; the exemplar was the wrong one.

## Scope — and the hazard that bounds it

Add `llm` to the push branches of the **test/validation** workflows only.

**DO NOT add `llm` to any workflow that PUBLISHES OR RELEASES.** `release.yml` and
`typedoc-gh-pages.yml` push artifacts to the outside world; making them fire on
every `llm` push would publish from the bot's working trunk. If you are not certain
a workflow is read-only validation, leave it alone and say why in the report.

Enumerate the workflows yourself on current `llm` and classify each as
test/validation vs publish/release before editing. Known `[master]`-only at the
time of writing: `ci.yml`, `ci-docs.yml`, `depcheck.yml`, `rust.yml`,
`typedoc-gh-pages.yml`, `release.yml`. That list is a starting point, not the
answer — re-derive it.

Also consider, and decide explicitly with a stated reason: whether `master` should
stay in the trigger list at all (harmless but dead), and whether any workflow's
cost profile makes running it on every trunk push a bad trade — `rust.yml` builds
XS from the moddable submodule and is expensive. If a workflow is too costly for
every push, say so and propose the alternative (a schedule, or merge-group) rather
than silently including or excluding it.

## Definition of done

- One PR against `llm`, test/validation workflows triggering on pushes to `llm`.
- Every publish/release workflow explicitly examined and left alone, named in the PR
  body with the reason.
- The PR body explains why `[master]` alone was wrong here and cites the branch
  divergence, so the next reader does not "fix" it back toward `ci.yml`.
- Report the PR URL.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-12T21:17:46Z
