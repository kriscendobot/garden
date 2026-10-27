orchestration-failed: true

The clean stage of PR #1573 (`feature/api-key-provider-registry`, head `43bf47ff`, still a draft) fails: CI is RED. I made no code changes and pushed nothing. I did not run the coverage pass or the dead-code sweep. Three jobs failed on both the old head `9d7ad83c` and the new head. The `test` jobs were still pending when I stopped, and I did not run `ci-wait-merge.sh` to a terminal state.

| Job | Evidence | Cause |
|---|---|---|
| `build` | "Check for cycles" step, `scripts/graph.sh: line 32: tred: command not found`, exit 127 | The runner has no graphviz `tred`. This is runner infrastructure, not PR-attributable. |
| `sandbox-drivers` | `bwrap › prlimit nproc cap is enforced inside the slice`: `/bin/sh: ulimit: Illegal option -u`. `bwrap › bwrap parent death leaves no owned process group`: "Test finished without running any assertions". | The failing tests are in `packages/sandbox/test/bwrap.test.js`, not in the PR's hosted-agent provider-registry area. |
| `cover (22.x)` and `cover (24.x)` | The `yarn test:c8` step fails. I read the log for `cover (22.x)`: it shows the same `prlimit nproc` bwrap failure. I did not read the `cover (24.x)` log. | Same bwrap failure as `sandbox-drivers`. |

These look like the known bwrap/`tred` reds noted in the garden memory (`endo-exo-dynamodb-testing`: "bwrap/tred CI reds are pre-existing"). I did not check them against the base branch, so that is unconfirmed. Someone with authority should decide whether to treat them as baseline or fix the runner.

Follow-ups:
- Someone should confirm whether the same three jobs are red on the base branch (`llm`), or on a PR that doesn't touch these packages.
- If they are baseline, the runner needs graphviz `tred` and a `ulimit -u`-capable shell for the bwrap tests. Alternatively the maintainer can waive them.
- Once the runner reds are resolved or waived, re-run this stage to cover the coverage pass.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 122 tokens (4273429 cached reads)
- Output: 21968 tokens
- Cost: $2.039445
- Wall-clock: 8336s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
