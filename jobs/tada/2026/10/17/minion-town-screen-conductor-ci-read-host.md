Screened-merge conductors for minion.town can now only be claimed by the host that just read CI. The fix is pushed to main2 as `f5477a650ff`, with tests.

**What changed**
- **Driver pins the host** (`scripts/jobs/screening/driver.py`): the conductor body now carries `requires: host=<GARDEN>`, naming the screener's own host. That host has just read the CI rollup, so a host whose token gets the 403 (like `oros-studio-garden-ce242c49`) can no longer claim it. If `GARDEN` isn't a valid identity, the driver posts nothing and logs a note rather than an unpinned conductor. It reuses the existing `host=` capability; no new token was needed.
- **CI is checked before the PR is touched** (`scripts/jobs/gardening/ci-wait-merge.sh`): in the two delegated-merge modes, it reads `statusCheckRollup` before any change. A 403 now exits 1 with `ci-read-forbidden` before it unfreezes the base or rebases and force-pushes the head. A temporary read failure still goes on to the normal polling loop. The duplicated 403 alert-and-exit code is now one shared function.
  - I left the ordinary merge modes alone on purpose. They can still fall back to the Actions API on a 403, and the extra read broke test T23 in `ci-wait-merge-test.sh`, whose fake `gh` replays canned responses in order.
- **Docs**: one-line notes in `designs/minion-town-pr-screening.md` and `context/operations/minion-town-screening.md`.

**Tests**
- `minion-town-screening-test.py` (34): checks the conductor body contains `requires: host=screen-host-1`.
- `ci-wait-merge-screening-test.py` (17): new test where the rollup read is forbidden on a frozen base. It confirms the run exits with `ci-read-forbidden`, never calls the rebase, and never unfreezes the base.
- `ci-wait-merge-ratchet-test.py` (18) passes, and `shellcheck` is clean.
- `ci-wait-merge-test.sh` passes except T8 ("stale GARDEN_GH falls back to PATH gh"), which fails identically on main2 without this change.

**Follow-ups**
- PR #192 is still stuck at ed7255b behind a fresh panel, and the #190 and #196 conductors are still failed. This fix doesn't recover them: they need fresh screens and conductors once hosts are running f5477a650ff.
- T8 in `ci-wait-merge-test.sh` already fails on main2 and needs its own fix.
- The bot token on `oros-studio` still lacks `checks:read` / `statuses:read` for minion.town. This change only keeps that host away from these conductors.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-screen-conductor-ci-read-host.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1666309 cached reads)
- Output: 11430 tokens
- Cost: $1.2426777999999998
- Wall-clock: 268s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
