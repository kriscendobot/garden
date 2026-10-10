Clean stage for PR #344 is done: there was nothing to clean, and CI is green.

- **What the PR is:** `docs: populate READMEs (mirror of endojs/endo#3047)`, branch `endojs:mirror/3047-readmes` at `5b5209af`, onto the frozen base `master-46d4edf`. It's open, not a draft, and mergeable.
- **Coverage and dead code:** all 28 changed files are documentation (`CONTRIBUTING.md` and 27 `packages/*/README.md`). No code changed, so there was nothing to measure coverage on and no dead code left behind. I pushed nothing and didn't create a project checkout.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN), with 1 check, 0 failed.

**Follow-up:** "green" here rests on a single check, `copilot-setup-steps`. The lint, test and browser workflows never ran against this head, most likely because the PR is based on a frozen `master-*` snapshot and those workflows don't trigger for it. For a docs-only change that's probably fine. Later gauntlet stages shouldn't read this as full-suite CI.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr344-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (118675 cached reads)
- Output: 1159 tokens
- Cost: $0.383331
- Wall-clock: 16s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
