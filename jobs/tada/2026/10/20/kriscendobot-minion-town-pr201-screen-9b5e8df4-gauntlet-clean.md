# Gauntlet CLEAN stage: kriscendobot/minion.town PR #201

The clean stage is done: I added one test commit and CI is green at the new head (`aca81ed`).

**Starting point:** the PR was open and not a draft, with CI green at `9b5e8df`. Earlier commits on this branch had already done coverage work, so I re-measured coverage rather than skipping the stage.

**Coverage pass** (vitest with the v8 coverage provider, installed with `--no-save` so `package.json` and the lockfile are unchanged):
- **Fully covered already:** `src/endo/gateway/new-clip.ts` (100% of lines; two catch-fallback branches untested), `new-clip-pet-name.ts`, `src/auth/fetch-metadata.ts`, and the lines this PR added to `guest-self-endpoint.ts`.
- **`src/http.ts`:** the New Clip setup there only runs against a real daemon. The CI step "Test live-daemon New Clip acceptance" (`test/new-clip-daemon.test.ts`) runs it; that test skips locally.
- **`clips/new-clip/model.js`:** this one had gaps (2 of 10 functions and 4 branches untested). I added assertions to `test/new-clip.test.ts` for:
  - what the directory and app creators send to the power;
  - an unchosen app type falling back to `NEW_CLIP_APP_TYPES[0]`, the type list the power's guard checks;
  - an empty text field storing `""`;
  - an unknown app type, and an empty kind;
  - `http:` mapping to a `ws://` socket.
  
  It now has 100% coverage on every measure, and typecheck passes.

**Dead code:** none. The exports that nothing else imports are all used inside their own files. The `isCrossSiteForm` → `isCrossSiteRequest` move left nothing behind.

**Push and CI:** commit `aca81ed` ("test(new-clip): cover every creator's arguments, unknown kinds, and the local socket") went to `feat/new-clip-inventory` via `safe-push-pr-head.sh` as a fast-forward from `9b5e8df`. `ci-wait-merge.sh --no-merge` returned rc 0: 2 of 2 checks green.

**Follow-up:** a full local run of the test suite had 3 failures in `test/git-remote/*` (`capability.test.ts`, `git-remote-e2e.test.ts`). They are outside this PR's files and the same suites pass in CI, so they look specific to this host. Worth checking if they show up again.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr201-screen-9b5e8df4-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2047360 cached reads)
- Output: 12423 tokens
- Cost: $1.2192279999999998
- Wall-clock: 1913s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
