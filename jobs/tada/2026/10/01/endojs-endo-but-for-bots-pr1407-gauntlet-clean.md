Clean stage for endojs/endo-but-for-bots PR #1407: no changes needed and nothing pushed. CI is green at the current head `969337438`.

- **PR state:** open and still a draft. Head branch is `endojs:bot/build/guest-scoped-daemon-bootstrap`, base is `llm-d4124e6`.
- **Checkout:** I got an isolated checkout through `ensure-project-worktree.sh`. The first try timed out at 10 minutes on this busy host; a retry with a longer timeout worked.
- **Coverage:** a coverage follow-up commit is already on the head: `969337438 test(daemon): unit-cover the guest path issuer's refusals and retry`. It adds `guest-bootstrap-path.test.js` and `serve-guest-path.test.js`. I could not run c8 locally because the checkout's dependencies are not installed, and I skipped a `yarn install` on this loaded host. Coverage here rests on CI: both `cover` jobs (Node 22.x and 24.x) passed.
- **Dead code:** none found. I checked the exports the source diff touches, and `resolveGuest`, `connectToDaemon`, `readFormulaId`, `DaemonConnection` and `ServerConstructionReason` are all still used. The `lint` check is green.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1407 --no-merge` with `GARDEN_CI_DEADLINE_SECS=3600` returned rc=0: 33 checks, 0 failed, CI GREEN.

Things to know about this host:
- The inbox drain was skipped because the journal clone timed out (rc=124), the known clone-livelock on oros-studio. Any message sent to this job's inbox was not read.
- The bot's GitHub API quota was briefly exhausted (403 rate limit) partway through.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1407-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (769924 cached reads)
- Output: 4598 tokens
- Cost: $0.6238327999999999
- Wall-clock: 963s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
