The fix is pushed, but CI was still running when the 1-hour deadline ran out, so this round ends as still-pending.

**Fix applied:**
- **Spell-out probe failure (`ok` in `test/home-page.test.ts`):** The test checks the `{ ok, message }` result that `submitWaitlist` returns. `deploy/aws/www/home.js` already marks that field `spell-out-exempt` as an established API name, and renaming a wire field is outside this PR's scope. So I added the same `spell-out-exempt` marker, with a reason, near the top of the test file. The probe now reports `pass` on the change.
- **Pruner advisory (`deploy/aws/www/home.js:28`), non-blocking:** I kept the comment. It records a privacy rule the code can't show: the session-storage key holds only `'1'`, never the email address. It doesn't just narrate the next line.

**Push:** commit `9c79d18` ("test(home): mark the waitlist API's ok field spell-out-exempt"), added on top of `7e64541` on `kriscendobot/minion.town` branch `feat/waitlist-soon-page` with `safe-push-pr-head.sh`.

**CI at the deadline:** `changes` and `test` passed; `gate (chromium)`, `gate (firefox)` and `gate (webkit)` were still pending; there were no failures. The last `ci-wait-merge.sh` window returned rc 4. CI started late: for about 40 minutes after the push, every Actions run in the repo sat queued with none in progress (10 queued at the worst point). That is the known ci.minion.town runner stall, not something in this PR, and the runners recovered at about 18:40. I first called the canonical waiter with the full 3600-second deadline in the background. The harness stopped it at its 10-minute limit, so I covered the hour with `gh pr checks` polling and two bounded `ci-wait-merge.sh` runs.

**Other notes:**
- `ensure-project-worktree.sh` failed with a read-only file system error (EROFS) on the shared bare repo inside the monk sandbox, which is a known issue. As a workaround I cloned the branch into `$TMPDIR` and worked there.
- The driver needs to re-post this stage to wait for the browser gates to finish.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr253-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1236946 cached reads)
- Output: 5885 tokens
- Cost: $0.8243292000000002
- Wall-clock: 3572s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
