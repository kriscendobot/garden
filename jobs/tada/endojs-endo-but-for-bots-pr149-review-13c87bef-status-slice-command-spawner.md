Disposition: 1. Already honored.

- Freshly observed `origin/llm`: [a54c3adbebf18fd837770d467433e480de498e8d](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d).
- Freshly observed [pull request 149](https://github.com/endojs/endo-but-for-bots/pull/149) head: [e0c8accb3235a340ce2b4e4307138429a7d1e5f3](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3).
- The pull-request feature originated in [a704d91e43d139379d1d505a6cd7dd94fad2138c](https://github.com/endojs/endo-but-for-bots/commit/a704d91e43d139379d1d505a6cd7dd94fad2138c). Current `origin/llm` independently introduced its refined implementation in [26975c9fd183803ed86af560d974fdc2e45d1262](https://github.com/endojs/endo-but-for-bots/commit/26975c9fd183803ed86af560d974fdc2e45d1262), followed by the remote-stream migration in [6d0e17fe9c9079f583a50ae55a9b169f949b7ea2](https://github.com/endojs/endo-but-for-bots/commit/6d0e17fe9c9079f583a50ae55a9b169f949b7ea2).

Current evidence:

- The sandbox adapter uses a structural `spawn` capability and has no runtime dependency on `@endo/sandbox`; it calls `E(handle).spawn`, bridges remote byte readers, and forwards wait/kill operations: [sandbox-spawner.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/sandbox-spawner.js#L31-L168).
- Shared process supervision drains both streams, retains timeout/SIGTERM handling, and preserves the structured result contract: [command.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/command.js#L228-L345).
- `bash`, `exec`, and `git` receive the injected sandbox spawner; omission retains the host-spawner implementation: [registry.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/registry.js#L113-L202) and [command.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/command.js#L394-L405).
- Environment propagation is stricter than the pull-request version. Command execution does not synthesize per-spawn environment values, the adapter forwards only explicitly supplied values, and daemon slices are minted with an empty hardened environment: [command.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/command.js#L499-L517), [sandbox-spawner.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/src/tools/sandbox-spawner.js#L130-L144), and [main.js](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie/main.js#L1248-L1285).
- Host mode remains available when no sandbox is configured. A configured sandbox now fails closed if slice minting fails, replacing the pull request's unsafe automatic relaxation.

Execution evidence: the lockdown-configured AVA run over `sandbox-spawner.test.js`, `command.test.js`, and `registry.test.js` exited 0 with all 44 selected tests green, covering environment forwarding, remote stream draining, result compatibility, host execution, and sandbox timeout/kill behavior.

All three discovery reports were read from `origin/journal2` at [7ccee4e5765b214a8c37800b938f95038ecdd007](https://github.com/kriscendobot/garden/commit/7ccee4e5765b214a8c37800b938f95038ecdd007) and corroborated against the fetched repository. No history migration is needed: the durable implementation rationale already exists in [TADA/43](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/43_genie_sandbox_spawner_power.md), [TADA/44](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/TADA/44_genie_sandbox_workspace_slice.md), and [PLAN/endo_posix_sandbox.md](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/PLAN/endo_posix_sandbox.md). The experimental branch's `TADA/35` can remain with that branch.

No project files, branches, remotes, or GitHub state were modified. No follow-up is required.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-slice-command-spawner.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 402s

<!-- garden-usage-end -->
