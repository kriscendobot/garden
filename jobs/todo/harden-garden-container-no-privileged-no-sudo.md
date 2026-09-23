---
role: builder
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: harden the garden container: no --privileged, no passwordless sudo

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).
Maintainer decision (kriskowal, 2026-09-23 muster): **harden the launcher.**

## Why
Maintainer inbox `msg-design-sysop-attested-exec-op-20260916-27885127eacb` and
`designs/sysop-attested-exec.md` (~line 280) found, and the liaison re-confirmed on the
REBUILT endolin-garden2 container today, that:
- `garden` launches the container with `--privileged` (`garden:307`);
- the Dockerfile grants the bot user `NOPASSWD:ALL` sudo (`Dockerfile:312-314`, `-G sudo`);
- host block devices are visible inside the container.
So any code a gardener runs (including code steered by injected text) can become container root
and plausibly mount the host filesystem. The ferry (`scripts/ferry.sh`) runs HOST-native with
the maintainer's `kriskowal` gh/ssh credentials on the same machine, so today the only barrier
between the fleet and those credentials is that nobody tries. The fleet's gh identity pin does
not defend against deliberate escalation.

## Ask
1. **Drop `--privileged`.** Replace it with the minimum that systemd-as-PID-1 needs (it
   already uses `--cgroupns=host`, the cgroup rw mount, tmpfs /run and /tmp, and
   SIGRTMIN+3). Research and state exactly which capabilities, if any, are still
   required (e.g. whether `SYS_ADMIN` is avoidable with cgroup v2 plus `--cgroupns=host`); add
   only what is proven necessary, with a comment per flag. No `/dev` passthrough, no host
   block devices, and no `--security-opt` weakening beyond what systemd provably needs.
2. **Remove passwordless sudo** for the bot user (the Dockerfile's `-G sudo` and `NOPASSWD:ALL`
   lines). Find everything that relies on it: at least `scripts/jobs/provision-node-lts.sh`,
   the entrypoint's root-phase work (usermod/home relocation must stay in the ROOT entrypoint
   phase, before dropping to the user), and any `scripts/aws/*` or `scripts/agoric/*` use. Move
   each to build time, the root entrypoint phase, or a user-space install. Where a genuine
   runtime root need remains, prefer a narrow, argument-pinned sudoers rule over `ALL`, and list
   it in the report.
3. **Acceptance probe** (a script under `scripts/` plus a test), run as the bot user INSIDE the
   container, asserting: effective caps are empty; `sudo -n true` fails; no host block devices
   in `/dev` (or `lsblk`); `mount` of a block device fails; no kriskowal `gh` account/token; no
   human SSH key or agent socket; `/.dockerenv` present (guard still works). Wire it into
   bring-up verification (`context/operations/starting.md` § Verify) and the
   `garden-root-repo-guard`-style periodic checks if cheap, so a regression gets noticed.
4. **Rollout without a flag day.** The change takes effect only on container RECREATION, so do
   NOT recreate any container yourself. Document the per-host recreate procedure (drain, stop,
   `./garden` recreate, stand up, run the probe) in `context/operations/` and note it for the
   maintainer. Existing containers keep running unchanged until recreated.
5. Verify the image builds and, if the environment allows, that a container started with the new
   flags boots systemd, runs `systemctl --user` units, and passes the probe. If the job
   environment cannot run docker, say so plainly and leave the boot verification as an explicit
   maintainer step. Do not claim it.
6. Update `designs/sysop-attested-exec.md` to record that the privileged/sudo prerequisite is
   addressed by this change (pending per-host recreation).

Report: commit sha(s), the final docker run flags with a justification for each, every former
sudo user and where it went, the probe output, and what verification was and was not possible.
