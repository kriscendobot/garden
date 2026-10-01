I opened draft PR [endojs/endo-but-for-bots#1408](https://github.com/endojs/endo-but-for-bots/pull/1408), which runs the confined `claude` inside a `bwrap` sandbox so the daemon socket has no path from inside it. A CI run proved this: a connect to a stand-in daemon socket fails with `ENOENT` inside the sandbox while the broker still serves the guest's tools.

The PR is based on the pinned branch `llm-d4124e6` (the `llm` tip after #1371 merged), carries the `garden-job` marker, and cross-links #1371. Lint, sandbox-drivers, both Ubuntu test legs and the 22.x macOS leg pass. The 24.x macOS leg failed once in `@endo/daemon`'s orphaned-daemon teardown test (`daemon-teardown › an orphaned daemon shuts itself down instead of lingering`). This PR doesn't touch the daemon, and `@endo/claude` passed on that same leg. I re-ran the failed job and did not wait for the result.

**What changed**
- **New sandbox (`packages/claude/src/bwrap-slice.js`):** builds the `bwrap` command line. It shares the network (so `claude` can reach the API) and drops all capabilities. The sandbox starts from an empty root and gets only:
  - read-only: the system directories (`/usr`, `/bin`, `/lib*`, `/sbin`) and the `/etc` files needed for DNS, TLS and the dynamic linker;
  - read-only: the `claude` install, the relay's `node` and script, the broker socket's directory, and that one spawn's files directory;
  - writable: the turn's working directory;
  - fresh and empty: `/tmp` and a scratch `HOME` (`/home/endo-claude`), with `HOME` set only inside the sandbox.
- **How to turn it on:** `runConfinedTurn` takes a new optional `sandbox: { bwrapPath }`, and `endo-claude-turn` takes `--bwrap`. Without it, behavior is unchanged.
- **Tests:**
  - A control test shows that without the sandbox the stand-in daemon socket is reachable.
  - A wiring test runs on any host and checks exactly what gets mounted.
  - The live test asserts the socket is unreachable, `HOME` is writable, and the spawn files directory is read-only (`EROFS`). It skips where `bwrap` is missing or can't create namespaces.
- **CI:** the `sandbox-drivers` job now runs these tests with `ENDO_CLAUDE_REQUIRE_BWRAP=1`, so a skip counts as a failure there. `scripts/ci-changes.py` sends `@endo/claude` changes to that job. The README's known-gaps section is updated.

**Where it lives:** I put this in `@endo/claude`, not `@endo/claude-sandbox` or `@endo/sandbox` as the job named. `@endo/claude-sandbox` is the existing podman + 9P path. `@endo/sandbox`'s bwrap driver only accepts capability-wrapped mounts and doesn't export its command-line builder. The PR body explains this.

**Problems found along the way**
- **Ubuntu 24.04 runners block `bwrap`:** the first CI run failed with `bwrap: setting up uid map: Permission denied` because AppArmor restricts unprivileged user namespaces there. The job now runs `sysctl kernel.apparmor_restrict_unprivileged_userns=0` just before this PR's test step.
- **`@endo/sandbox`'s bwrap tests have never actually run in CI:** they hit the same restriction but record it as `t.pass("SKIP …")`, so CI shows ✔ without a sandbox ever being created. I put the sysctl after that suite's step so this PR doesn't change it.
- **macOS path mismatch:** on macOS `/tmp` resolves to `/private/tmp`, which broke one assertion. Fixed.

**Follow-ups (not done)**
- The sandbox is opt-in. A deployment has to pass `sandbox` / `--bwrap` before the protection applies.
- Because the network is shared, a loopback TCP listener on the host is still reachable from inside. Closing that needs `@endo/sandbox`'s `network: private` profile or an egress proxy.
- The `@endo/sandbox` bwrap tests need the same sysctl, and a hard failure instead of a skip, to be real coverage.
- `claude --version` is still run outside the sandbox.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 174 tokens (12572501 cached reads)
- Output: 63796 tokens
- Cost: $5.293684199999999
- Wall-clock: 6055s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
