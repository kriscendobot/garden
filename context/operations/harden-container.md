# Hardening the garden container (drop `--privileged`, drop bot-user sudo)

The `garden` launcher and Dockerfile were hardened (job
`harden-garden-container-no-privileged-no-sudo`, 2026-09-23) so a gardener — even
one steered by injected text — can no longer become container-root and mount the
host filesystem to reach the maintainer credentials the host-native ferry uses.
The change takes effect **only on container recreation**. Existing containers keep
running with their old (privileged) posture until deliberately recreated. There is
**no flag day**: recreate host by host, on your own schedule.

## What changed

- **`garden` launcher:** the container is launched **without `--privileged`**. It
  keeps Docker's default reduced capability set (default seccomp + AppArmor
  profiles in force) and adds back only **`--cap-add SYS_ADMIN`**, the single
  capability systemd-as-PID-1 provably needs (mount its API filesystems / service
  sandboxes and set the hostname). No `/dev` passthrough by default. A new
  `GARDEN_DEVICES` env var lets a host opt IN to GPU device nodes explicitly
  (`GARDEN_DEVICES="/dev/kfd /dev/dri/renderD128"` for AMD local inference) — a
  deliberate per-host weakening, never the default.
- **Dockerfile:** the bot user no longer gets `-G sudo` or a `NOPASSWD:ALL`
  sudoers rule, and the `sudo` package is removed entirely (defense in depth — no
  setuid-root binary to exploit). Everything that once relied on runtime root is
  done at build time or in the ROOT entrypoint phase (usermod/home relocation, GPU
  group grants). The LTS-Node root `/usr/local/n` is chowned to the bot user so a
  live `provision-node-lts.sh` top-up still works without sudo.
- **Acceptance probe:** `scripts/check-container-hardening.sh` asserts the posture,
  wired into bring-up verification (`starting.md` § Verify) and a twice-daily
  `garden-container-hardening` timer on every host. Until a host's container is
  recreated, the timer reports **PENDING RECREATE** (exit 3, a clean unit exit,
  one coalesced watchdog notice). The first all-pass run records the per-host
  marker `.garden-state/container-hardening/hardened-verified`. From then on any
  failure is a **regression**: exit 1 and a failed unit. The unit is advisory for
  rolling deploys either way, so it never fails a canary or drains a host.

## Why `SYS_ADMIN` and not zero caps

Dropping `--privileged` alone removes the overwhelming majority of the attack
surface: all capabilities beyond Docker's default ~14, the ability to mount host
block devices (none are present without `--device`), and it re-enables the default
seccomp + AppArmor confinement that `--privileged` disables. systemd as PID 1 does
still perform mount operations at boot and for per-service sandboxing, and calls
`sethostname`; both require `CAP_SYS_ADMIN`. `SYS_ADMIN` lives in the container
**bounding** set (held by root/PID-1); a `docker exec -u <botuser>` process drops
to **empty effective caps**, which the probe verifies. With no device nodes present
there is nothing for that capability to mount from the host.

Whether cgroup v2 + `--cgroupns=host` makes `SYS_ADMIN` fully avoidable was **not
provable in this job's environment** (no clean Docker host to boot-test against),
so the conservative, widely-used unprivileged-systemd recipe was chosen. If a
future boot-test shows systemd and the `--user` fleet come up cleanly with
`--cap-drop` narrowing SYS_ADMIN away, tighten it then — the probe will confirm.

## Per-host recreate procedure

Do this per host, one at a time. It is a normal drain → recreate → stand-up, plus
the probe at the end.

1. **Deploy the hardened launcher first.** Ensure this host's root checkout is at
   or past the commit that hardened `garden`/`Dockerfile` (a normal deploy). The
   launcher on disk is what creates the container, so it must be the hardened one
   before you recreate.
2. **Drain the fleet on this host** so no job is mid-flight when the container
   stops:
   ```sh
   scripts/jobs/drain-fleet.sh on "recreating container for hardening"
   ```
   Wait for in-flight gardeners to finish (watch `systemctl --user list-units
   'garden-gardener@*' --state=active`).
3. **Rebuild the image** (the Dockerfile changed — sudo removed):
   ```sh
   ./garden build
   ```
4. **Remove the old container** so the next launch creates a fresh one from the
   hardened flags + image:
   ```sh
   ./garden reset
   ```
5. **Recreate and stand up** (headless bring-up, then re-arm units per
   `starting.md`):
   ```sh
   ./garden create
   ```
   Then follow `context/operations/starting.md` to install/enable units and lift
   the drain (`scripts/jobs/drain-fleet.sh off`).
6. **Run the probe** (as the bot user, inside the new container):
   ```sh
   scripts/check-container-hardening.sh    # want: all PASS, exit 0
   ```

## GPU hosts (AMD local inference)

Dropping `--privileged` removes GPU device nodes too. A host that serves local
inference must opt back in **explicitly** by exporting `GARDEN_DEVICES` before
`./garden create`:

```sh
export GARDEN_DEVICES="/dev/kfd /dev/dri/renderD128"
./garden create
```

`entrypoint.sh` still grants the bot user the node group host-adaptively. These are
char devices, not block devices, so the probe's block-device check still passes.
Only pass the GPU nodes — never a block device.

## Maintainer follow-ups (not fixed by recreation alone)

- The probe found the maintainer account **`kriskowal` logged into the bot's `gh`**
  in the live container (`~/.config/gh/hosts.yml`). Recreation does not clear this
  because the config lives in the bind-mounted home. Clear it so the bot cannot act
  as the maintainer over the API:
  ```sh
  gh auth logout --user kriskowal
  ```
  Then re-run the probe; check 6 should pass.
- The ferry (`scripts/ferry.sh`) still runs host-native with the maintainer's
  credentials. Hardening the container does not change that; it removes the
  in-container escalation path that could have reached those host credentials.
