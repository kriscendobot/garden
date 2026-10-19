---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1403-review-1cfc544e
verdict: miss
category: style-convention
pr: 1403
repo: endojs/endo-but-for-bots
cluster: botese-in-pr-metadata
cluster_pattern: A Botese cliché (notably bare "seam") ships in a PR title or description because the thesaurus seat and its grep scanned only the diff, never the PR metadata.
review_at: 2026-10-11T19:27:08Z
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1403#pullrequestreview-5484623670
identity: endojs/endo-but-for-bots#1403:review:5484623670:retro
producing_role: builder
producing_job: build-endo-inference-seam-1357
missed_by: thesaurus seat (seat-gate-thesaurus.sh / thesaurus-cliche-grep.sh scanned only the diff) across six code-panel rounds
severity: minor
grounds: >-
  The PR title read "add the provider-neutral @endo/inference seam" and the
  description used the same word. Botese avoidance was a standing garden
  convention: the thesaurus seat, the curated cliché TSV, and the deslopper
  landed in e21884be41 (2026-09-16), and botese-normalization names "seam" as
  a known Botese word. Six gauntlet panel rounds ran on #1403 (tada
  pr1403-gauntlet-panel-4..6, "all 33 seats ran"), so the phrase passed through
  an active evaluator, not around one. The evaluator's scope was too narrow:
  the grep read only the diff, so PR title and body were never measured, and
  bare "seam" was not a listed collocation. The maintainer approved and asked
  for conduct while flagging the miss. Verified in the world: the PR title was
  renamed to "...@endo/inference interface" at 2026-10-11T20:40:23Z and the body
  edited at the same time; garden commit 78f9dacc938 (same timestamp) feeds the
  live PR title/body into the thesaurus grep as pr-metadata rows with a
  metadata-only bare "seam" entry. Replaying the grep with the original title
  and a seam-bearing body now flags both PR_TITLE:1 and PR_BODY:1, and
  thesaurus-cliche-grep-test.sh passes 21/21.
---

The PR title and description named the new interface with the Botese word
"seam". Six panel rounds ran, including the thesaurus seat, but its grep read only
the diff, so the PR metadata went unscanned. The primary loop retitled the PR, and
garden commit 78f9dacc938 extended the thesaurus grep to the live PR title and body.
