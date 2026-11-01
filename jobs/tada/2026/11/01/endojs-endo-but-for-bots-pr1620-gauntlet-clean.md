Clean stage for endojs/endo-but-for-bots#1620 (draft, head `c27ef3d36f`): finished with no changes, and CI is green.

- **What the PR contains:** it changes only three ironhorse-262 test262 expectation files under `rust/engine/ironhorse-262/expectations/whole-tree/`: `Object/getOwnPropertyDescriptor@@0001`, `Proxy/has@@0000` and `Proxy/set@@0000`. These are data files, not source code.
- **Coverage and dead code:** neither applied. There was nothing to add coverage for and no orphaned code, so I didn't create a project checkout or push anything.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 after about 2 minutes. All 31 checks reached a final state with none failed (the one pending check, `cross-target-ironhorse`, passed).

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1620-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (123860 cached reads)
- Output: 851 tokens
- Cost: $0.40051200000000003
- Wall-clock: 196s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
