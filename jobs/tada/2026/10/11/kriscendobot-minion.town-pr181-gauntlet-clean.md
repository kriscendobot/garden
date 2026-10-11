Clean stage for PR #181 (`git-remote-served-clip`) is finished: I added one test commit, and CI is green on the new head.

**What I did**
- Worked in an isolated checkout of `kriscendobot/git-remote-served-clip`, starting from head `f24eff0`.
- Ran a coverage pass (vitest + v8) over `src/endo/git-remote/**` and `src/endo/gateway/**`, using the 8 git-remote and partition-vhost test files: 144 tests, all passing. Most of the new code was already well covered:

  | File | Line coverage |
  | --- | --- |
  | `projection.ts` | 100% |
  | `partition-store.ts` | 98% |
  | `html-rewrite.ts` | 95% |
  | `served-clip.ts` | 91% |
  | `vhost-table.ts` | 80% |

- The main new code with no test was the reconciler's `start()`/`stop()` timer lifecycle and the log line written when a background sweep fails. I added one test in `test/git-remote/served-clip.test.ts` for both. It checks that `start()` runs a full sweep right away and serves the clip, that calling `start()` or `stop()` twice is harmless, and that a sweep failure is logged as `full sweep failed: …`. Typecheck is clean.
- **Dead code:** none. Every new export is used, though some are exported but only used inside their own module. The two helpers removed from `git-http.ts` have no remaining references.
- Pushed commit `eb610a6` with `safe-push-pr-head.sh`, which advanced the branch from `f24eff0` to `eb610a6`.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0 (3 checks, none failed). `test` and the amd64/arm64 Claude harness checks all passed.

**Follow-ups**
- One test fails only on garden hosts, not in CI: `capability.test.ts › propagates a git failure rather than reporting the ref absent`. The garden's `git` wrapper (`scripts/jobs/bin/git`) is first on PATH. When `git -C` points at a missing directory, the wrapper's `cd` fails and it exits 1 instead of git's 128. The project code treats exit 1 as "ref absent", so the error never surfaces. With `/usr/bin/git` first on PATH the test passes. Garden workers that run this repo's tests locally will see this false failure. The fix belongs in the wrapper: it should keep git's exit code for a bad `-C` path.
- The PR is still a draft; the panel stage comes next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr181-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1632399 cached reads)
- Output: 8355 tokens
- Cost: $1.0203238
- Wall-clock: 921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
