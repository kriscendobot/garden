Nothing needed changing for the clean stage on endojs/endo-but-for-bots PR #1427 ("ci: correct dorny/paths-filter pin comment to v3.0.3"), so I made no edits and pushed nothing.

- **PR state:** open and not a draft. Head is `endojs:fix/zizmor-paths-filter-pin-comment` at `1b1ead43c8e1`, and the base is the frozen `master-6ee3fda`.
- **CI:** the GitHub status rollup for that head commit shows all 15 checks finished and passed. That includes lint, build, zizmor, cover, every test leg (Node 22.x and 24.x on Ubuntu and macOS), both test262 legs, test-hermes, test-xs, test-ocapn-python, check-action-pins and viable-release.
- **Coverage and dead code:** the only file touched is `.github/workflows/ci.yml`, and the change just corrects a version comment next to the `dorny/paths-filter` pin. No package source changed, so there is nothing to add coverage for and no code left unused.

Because CI was already green at the current head and nothing was pushed, I skipped making a project checkout and running `ci-wait-merge.sh`. No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1427-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (64862 cached reads)
- Output: 759 tokens
- Cost: $0.3607204
- Wall-clock: 12s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
