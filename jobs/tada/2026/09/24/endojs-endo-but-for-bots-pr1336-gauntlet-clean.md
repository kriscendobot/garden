# Gauntlet CLEAN stage: endojs/endo-but-for-bots PR #1336 — CI green

The clean stage is done. I fixed the one red check, added tests for the code nothing was running, and all 33 CI checks passed on the new head `64ca00f9fb`.

**What I found:** At head `3c3d8cfd3c` the `lint` job was red. `scripts/check-security-md.sh` requires every package's `SECURITY.md` to be byte-identical to `packages/skel/SECURITY.md`. The copy in `packages/agent-mcp-stdio/` had been reformatted: bullets changed from `*` to `-`, curly quotes to straight quotes, and one list collapsed onto a single line.

**What I pushed:** two commits on `build/endo-guest-stdio-mcp`, pushed with `safe-push-pr-head.sh` (fast-forward from `3c3d8cfd3c` to `64ca00f9fb`).
1. **`bbdd025ff6` — `chore(agent-mcp-stdio): restore canonical SECURITY.md`.** The file is back to the canonical copy. The check script passes, and Prettier's check passes on the file too.
2. **`64ca00f9fb` — `test(agent-mcp-stdio): sweep every tool against a recording guest`.** Before this, 33 of the tool handlers in `src/agent-interface.js` were never run by any test. The new test calls every tool twice, once with only its required arguments and once with every declared argument. Each call goes against a stand-in guest that records calls, and the test checks that each tool actually reaches a guest method.

**Coverage after the change:**

| File | Lines before | Lines after | Functions before | Functions after |
|---|---|---|---|---|
| `agent-interface.js` | 92.6% | 99.4% | 37.5% | 98.2% |
| `@endo/agent-mcp-stdio` package overall | 94.3% | 98.5% | — | — |

The one other touched source file, `@endo/agent-tools`' `src/adapters/mcp.js`, is at about 95% of lines, so I left it alone.

**Dead code:** none. Every new export in both packages is referenced somewhere.

**Checks run locally:** all 23+2 tests in `@endo/agent-mcp-stdio` pass, and `yarn lint` (eslint + tsc) has 0 errors. It still shows 10 `safe-await-separator` warnings, the same kind the package's other tests already produce.

**CI:** `ci-wait-merge.sh --no-merge` returned rc=0: 33 checks, 0 failed, CI green. The PR is still a draft.

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1336-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2497431 cached reads)
- Output: 12914 tokens
- Cost: $1.3988702000000002
- Wall-clock: 2325s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
