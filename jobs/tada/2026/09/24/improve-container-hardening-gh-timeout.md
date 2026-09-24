## Completion report: improve-container-hardening-gh-timeout

**What I did:** The two direct gh calls in `scripts/check-container-hardening.sh` now have a time limit. A hung gh call can no longer run `garden-container-hardening.service` past its 120-second start limit, where systemd killed it before `self-heal-run.sh` could capture or diagnose anything.

**Changes (pushed to `main2`):**
- `1efe2afa24` fix(container-hardening): bound the real-gh calls with an explicit timeout
  - New `bounded_gh` helper runs `timeout --signal=TERM --kill-after=10s ${GARDEN_HARDENING_GH_TIMEOUT:-15s} "$gh" …`. If the `timeout` command is missing, it calls gh directly.
  - `logged_in_gh_logins` now runs `gh auth status --json hosts` through it, with the env tokens still removed (now done in a subshell). If the call hangs, the check falls back to reading `hosts.yml`.
  - `env_token_maintainer_login` now runs `gh api user` through it. If the call hangs, no login is resolved for that token.
  - The check still calls gh directly, skipping the fleet wrapper, so a leaked maintainer credential still shows up.
  - Worst case is now about 25 seconds per call and three calls in total, well inside the 120-second limit.
  - New Subtest 7 in `scripts/jobs/test/container-hardening-maintainer-cred-test.sh` uses a fake gh that hangs, with a 1-second limit. A maintainer login in `hosts.yml` is still reported as REACHABLE, a bot-only `hosts.yml` gives CLEAN, and both runs together finish in about 4 seconds. The whole test passes: 16 passed, 0 failed.
- `f0d3180698` fixes an older ShellCheck SC2020 warning on the maintainer-login `tr` split. That warning was already failing `tests/checks/test_container_hardening_probe.sh` before my change (I confirmed this against the previous commit). That test now passes too: 16 passed, 0 failed.

**Follow-ups:** None. The fix reaches each host at its next rolling deploy, and the next run of the hardening timer will use it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-container-hardening-gh-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (632395 cached reads)
- Output: 5408 tokens
- Cost: $0.6401589999999998
- Wall-clock: 70s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
