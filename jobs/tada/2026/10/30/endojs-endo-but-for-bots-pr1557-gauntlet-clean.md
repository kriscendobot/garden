The PR is green at its current head, so I'm reporting this stage as done without a coverage pass. Nothing was pushed.

- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0 ("rollup-terminal total=37 failed=0 → CI GREEN"). The earlier snapshot showed 8 CANCELLED checks, but the terminal rollup had no failures.
- **PR state:** #1557 is still a draft with a single commit, `feat(exo-git): adopt git capability URLs as GitRemotes without leakin…`.
- **Coverage pass not run:** I got an isolated checkout of `build/daemon-git-capability-urls`. `c8` isn't installed in that checkout (`c8: not found`), so I couldn't measure coverage of `packages/exo-git/src/git-remote-policy.js` locally. I didn't try the PATH-shim workaround from my notes.
- **Dead-code check not done:** I didn't look for code the change orphaned.
- **Possible follow-up:** If a coverage or dead-code review is wanted, a later stage would need a working `c8` shim.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1557-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 70 tokens (2086659 cached reads)
- Output: 9821 tokens
- Cost: $1.2571127000000002
- Wall-clock: 2089s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
