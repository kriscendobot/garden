Clean stage for kriscendobot/vattr97#1 is done: I pushed one formatting fix, and CI counts as green only because the repo has no CI that can run. No check has ever run on this fork, so I checked the CI steps locally instead.

- **What the PR is:** it adds one file, `designs/opencollective-ertp.md`, and no code. The coverage pass therefore had nothing to test, and no code was orphaned.
- **Fix pushed:** the design doc failed the repo's `prettier --check .`, which is one of its CI steps. The problems were `*emphasis*`, an unaligned table and an unaligned inline code comment. I ran `prettier --write` on the file and committed it as `36ba47a` ("style(designs): prettier-format the OpenCollective-ERTP design"). It changes formatting only, not content. `safe-push-pr-head.sh` moved the head `ed2157a` → `36ba47a` without rewriting history.
- **Local checks at the new head:** `prettier --check .` passes across the repo, `eslint .` exits 0 and `tsc --noEmit` exits 0. I didn't run `yarn test`, since a markdown-only change can't affect the tests.
- **Why there are no checks:** `.github/workflows/ci.yml` is in the repo and Actions is enabled, but GitHub has never registered a workflow on this fork of dckc/vattr97. The workflows list is empty, there are 0 runs, and 0 check-runs attached before or after my push. The rollup will never fill, and that is most likely why the two earlier attempts at this stage were reaped while waiting for it.
- **CI wait:** since this is effectively a repo with no checks, I ran `ci-wait-merge.sh kriscendobot/vattr97 1 --no-merge` with `GARDEN_CI_ALLOW_NO_CHECKS=1`. It returned rc 0 with "total=0 failed=0 → CI GREEN". That green reflects the empty rollup plus my local checks, not a real CI run.

**Follow-ups:**
- To get real CI on this fork, someone with access needs to turn on Actions workflows for kriscendobot/vattr97, usually via the fork's Actions tab. Until then, every stage on this PR will need `GARDEN_CI_ALLOW_NO_CHECKS=1` or will time out. I didn't make that change myself because it alters the repo's settings.
- I couldn't read my inbox this run: the journal clone timed out.

<!-- gauntlet-stage-result: clean=done -->

## Manual gauntlet handoff

The completion guard found https://github.com/kriscendobot/vattr97/pull/1 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-vattr97-pr1-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 1 host(s)
- Input: 34 tokens (1213862 cached reads)
- Output: 5028 tokens
- Cost: $0.8973484
- Wall-clock: 397s
- Model(s): claude-opus-4-8 ×6, claude-opus-5-5 ×1

<!-- garden-usage-end -->
