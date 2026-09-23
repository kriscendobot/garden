Everything checks out. `--expect 2` correctly treats all-pass (0) and off-container-skip (2) as clean while a real hardening failure (exit 1) alarms via self-heal. The work is complete, committed, and pushed to `origin/main2` at `3d453e30784`; working tree is clean and no one has advanced main2 past it.

## Completion report

**Status:** Already complete. A prior attempt of this job committed and pushed the full deliverable to `main2` as `3d453e30784` ("harden(container): drop --privileged and bot-user sudo"). On this clean re-run I re-derived state from committed history, verified every deliverable against the job spec, ran the test suite, and confirmed the unit wiring. Nothing needed re-doing; no new commit was required.

**Commit:** `3d453e30784` on `origin/main2` (direct push, no PR per garden convention). 12 files, +491/−18.

**Final `docker run` flags (garden launcher) with justification:**
- `--cap-add SYS_ADMIN` — the *only* capability added back over Docker's default reduced set; systemd-as-PID-1 needs it to mount its API filesystems / per-service sandboxes and set the hostname at boot. Held in the container bounding set (root/PID-1); a `docker exec -u <bot>` process drops to empty effective caps (the probe asserts this).
- `--cgroupns=host` + `-v /sys/fs/cgroup:/sys/fs/cgroup:rw` — cgroup v2 access systemd needs (unchanged).
- `--tmpfs /run --tmpfs /run/lock --tmpfs /tmp` and `--stop-signal SIGRTMIN+3` — containerized-systemd essentials (unchanged).
- **Removed `--privileged`** — it would grant every cap, drop seccomp+AppArmor, and expose all host block devices. Default seccomp + AppArmor now stay in force.
- **No host devices by default.** New `GARDEN_DEVICES` env (empty default) is the explicit, per-host opt-in for GPU char nodes only (AMD/ROCm local inference), never a block device.

**Former sudo users and where each went:**
- Dockerfile `-G sudo`, the `NOPASSWD:ALL` sudoers line, **and the `sudo` package itself** — all removed (defense in depth: no setuid-root sudo binary at all).
- `provision-node-lts.sh` — build now `chown`s `/usr/local/n` (and `/opt/rustup`) to the bot user, so a live top-up takes the writable-tree branch; the `sudo -n` fallback is kept only for a legacy still-privileged host.
- Entrypoint root-phase work (usermod / home relocation / GPU group grants) — already runs in the root entrypoint phase before dropping to the user; no sudo (confirmed by grep).
- `scripts/aws/turnkey/*` and `scripts/agoric/fetch-chain-snapshot.sh` — **out of container scope**: these run host-native (EC2 turnkey provisioning as the host `ubuntu`/owner; agoric snapshot controls an external validator node via a configurable `sudo systemctl`). Neither is a garden-container runtime path.

**Acceptance probe:** `scripts/check-container-hardening.sh` asserts empty effective caps, `sudo -n true` fails, no host block devices, block-device `mount` fails, no maintainer `gh`/SSH credential or agent socket, and `/.dockerenv` present (guard intact). Wired into `starting.md` § Verify and a twice-daily `garden-container-hardening` timer auto-enabled on every host via the `install-units.sh` `garden-*.timer` glob (`WantedBy=timers.target`); the service runs it through `self-heal-run.sh --expect 2` so all-pass (0) and off-container-skip (2) are clean while a real hardening regression (exit 1) alarms.

**Test output:** `tests/checks/test_container_hardening_probe.sh` → **16 passed, 0 failed**. `shellcheck` on both scripts exits clean (only info-level SC2015 notes on the test's own `&&/||` idiom).

**Rollout:** `context/operations/harden-container.md` (new, 113 lines) documents the no-flag-day per-host recreate procedure (drain → stop → `./garden` recreate → stand up → run probe); effective only on container recreation, existing containers unaffected. `designs/sysop-attested-exec.md` updated to record the privileged/sudo prerequisite as addressed pending per-host recreation.

**Verification done vs. not possible:**
- Done: probe test suite green; shellcheck clean; unit auto-enable path confirmed; `--expect` semantics confirmed correct; remaining `sudo` call sites audited as host-side/out-of-scope; working tree clean and synced to `origin/main2`.
- **Not possible here:** image build and new-flags boot verification — **docker is unavailable in this job environment** (no daemon). This remains an explicit maintainer step: recreate a host per `harden-container.md` and confirm systemd boots, `systemctl --user` units come up, and the probe passes. Not claimed as done.

**Follow-up for the maintainer (from the prior probe run, unchanged by this code):** the live still-privileged container had the maintainer account `kriskowal` logged into the bot's `gh` — recreation alone does not clear that; needs `gh auth logout --user kriskowal` as a separate credential cleanup.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/harden-garden-container-no-privileged-no-sudo.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 116 tokens (5828198 cached reads)
- Output: 50684 tokens
- Cost: $6.171392999999999
- Wall-clock: 781s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
