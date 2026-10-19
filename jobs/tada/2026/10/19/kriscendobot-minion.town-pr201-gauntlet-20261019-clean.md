The clean stage for kriscendobot/minion.town PR #201 is done, and CI is green at the new head `fca3abb6654`.

**Coverage pass.** I ran vitest with coverage on the touched source files, in an isolated checkout of `feat/new-clip-inventory`:
- **`src/endo/gateway/new-clip.ts` and `new-clip-pet-name.ts`:** already at 100% lines and functions before I started.
- **New `POST /account/clips/new` route in `src/auth/guest-self-endpoint.ts`:** already fully covered. The uncovered lines in that file are older code outside this PR.
- **`src/http.ts`:** none of its changes are covered by the unit tests. That code wires the route to the live `@sites` path, which these tests don't exercise.

I added two tests to `test/new-clip.test.ts` for branches in `mintNewClip` that nothing tested:
- When publishing returns a warning and releasing the names also fails, the publish warning comes first, followed by the release warning.
- The mint runs in the `@main` worker when the daemon has one, and uses the default random 12-hex-character suffix when none is supplied.

Branch coverage of `new-clip.ts` went from 73.7% to 91.7%. Typecheck passes. The commit is `fca3abb` ("test(new-clip): cover the @main worker, random suffix, and joined warnings"), pushed with `safe-push-pr-head.sh` as a fast-forward from `bd264ae`.

**Dead code.** I found nothing the change left unused. A few exports have no callers outside their own file, but they are used internally or are documented public types, so I left them.

**CI.** On the first run, the browser gate's firefox job failed on one check ("storage works inside the frame — undefined"); webkit and chromium passed. The same gate passed on the previous head, and this push changed only a vitest file, so I treated it as a flake and reran the failed job once. The rerun passed. `ci-wait-merge.sh --no-merge` then returned rc 0 (2 runs, 0 failed). It reads the Actions runs API because the bot token can't read the status-check rollup, so commit statuses and non-Actions checks aren't visible to it.

**Follow-ups:**
- The firefox frame-storage check may be intermittent; it's worth watching in later gauntlet runs.
- minion.town CI runs on one self-hosted runner, one job at a time, so jobs sat queued for about 20 minutes.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-20261019-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1618034 cached reads)
- Output: 10127 tokens
- Cost: $1.0293548
- Wall-clock: 2689s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
