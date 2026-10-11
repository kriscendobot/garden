# Clean stage: kriscendobot/minion.town PR #180

The clean stage is done: I added unit tests for the new git-remote code, found no dead code, and CI is green on the new head. PR #180 is still a draft.

**Coverage:** PR #180 adds a loopback control app (`src/endo/git-remote/control.ts`) and a guest `git` caplet (`src/endo/git-remote/git-caplet.ts`). The only tests for them were in `test/endo-daemon-integration.test.ts`, which covers the happy path and skips unless an Endo checkout is present (CI provides one). I pushed one follow-up commit, `94b7f46`, adding two test files:
- **`test/git-remote/control.test.ts`** covers:
  - the 400 responses for create, mint and revoke when the owner, pet name, attenuation or token hash is bad, or the partition is unknown;
  - that create is idempotent;
  - the shape of the minted capability URL;
  - that revoke only works through the facet that minted the URL.
- **`test/git-remote/git-caplet.test.ts`** (needs `@endo/init`) covers:
  - the install check, which requires an owner and a control origin, and refuses any origin that isn't `http://127.0.0.1`;
  - the partition objects, run against a real loopback control app: create is idempotent, `readOnly` narrows access to read, revoke works only through the facet that minted the URL, and control-app errors reach the caller.

**Checks:**
- Both new files pass locally: 8 of 8 tests.
- `tsc --noEmit` is clean and the files are prettier-formatted.
- **Dead code:** nothing the change removed or replaced is left unused.
- I pushed with `safe-push-pr-head.sh` in advance mode (`1f7f463 → 94b7f46`).

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All three checks passed on `94b7f46`: `test` and Claude harness on amd64 and arm64.

**Follow-up:** One existing test fails locally but not in CI: `test/git-remote/capability.test.ts` › "propagates a git failure rather than reporting the ref absent". The PR doesn't touch `projection.ts`, so this is probably something about the local environment, not this change. Worth looking into separately if it shows up again.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1776612 cached reads)
- Output: 12565 tokens
- Cost: $1.1873024000000003
- Wall-clock: 936s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
