PR #1349's head is back at the reviewed `2262b4bafa`, and the out-of-scope CI commit is gone. GitHub confirms the new head SHA.

- **What I removed:** after the earlier cleanup, another stray commit had been pushed on top of `2262b4bafa`: `d8b86e158d` ("fix(ci): support Graphviz 14 dependency checks", 2026-10-29T00:20Z). It changed only `.github/workflows/depcheck.yml`, `scripts/check-dependency-cycles.sh` and `scripts/graph.sh`. It looks like the output of the "find another way to get `tred`" job (journal job `resolve-endo-pr1349-depcheck-ci-20261028`) landing on the wrong branch.
- **How:** I force-pushed `build/hardened-text-codecs-shim` back to `2262b4bafa`, with a lease pinned to `d8b86e158d` so nothing else could be overwritten. The PR's base is still `master-ebc7904`.
- **Comment posted:** https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6485235804. It records what was dropped and that the Ubuntu runner pin stays isolated in #1582. It says the Graphviz/`tred` work belongs with #1546 and #1566, and that the dropped commit can still be fetched by its SHA.

**Still open:**
- **CI decision for the maintainer:** on `ubuntu-latest` the dependency-cycle check on #1349 will keep failing until #1582 or an equivalent fix lands in the frozen base. Main CI was green at this same commit before. The question of whether the ferry should accept that known failure is still unanswered in https://github.com/endojs/endo-but-for-bots/pull/1349#issuecomment-6479686667.
- **Mis-targeted push:** whatever produced `d8b86e158d` pushed to #1349's branch instead of its own. If that job is supposed to deliver the Graphviz 14 change, it needs to go onto #1546/#1566 or a new PR. Its work is only kept as an orphaned commit SHA for now.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `d8b86e158d335474dcdba7207b57c4f6a3bc4719`; this job presented `2262b4bafa9f06177b311869b91c71d4fcd2ac96`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-fix-depcheck-scope-20261029.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (422868 cached reads)
- Output: 3730 tokens
- Cost: $0.5621896000000001
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
