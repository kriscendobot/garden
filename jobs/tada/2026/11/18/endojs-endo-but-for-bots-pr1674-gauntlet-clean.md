The clean stage for endojs/endo-but-for-bots#1674 is finished: nothing needed changing, nothing was pushed, and CI is green.

- **PR:** a draft, still open, with head `endojs:design/endopi-extension-package-manifest` at commit `5b8aa3ff` and base `llm-0368767`.
- **What it changes:** only two design documents, `designs/README.md` and `designs/endopi-extension-package-manifest.md`. There's no code in the diff, so there were no packages to run the coverage pass on and no code the change could have left unused. I didn't make a project checkout because there was nothing to edit.
- **CI:** one check was still pending when I started. `ci-wait-merge.sh` with `--no-merge` and a 3600s deadline returned rc=0: all 31 checks finished with no failures (6 passed, 24 skipped).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1674-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (127888 cached reads)
- Output: 987 tokens
- Cost: $0.4063496
- Wall-clock: 87s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
