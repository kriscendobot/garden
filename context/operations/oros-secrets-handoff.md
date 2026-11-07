---
created: 2026-11-07
updated: 2026-11-07
author: builder
---

# Oros provider-secrets hand-off

Do not release the provider-secrets change to
`oros-studio-garden-ce242c49` until its replacement container passes the
checks below.
Commit `1e1968c0781` makes a missing `bwrap` a deliberate
fail-closed condition: a secret-bearing harness exits 75 instead of starting
without its mount boundary.

Oros runs on a Mac, but the garden does not run `bwrap` on macOS.
Bubblewrap is
Linux-only because it constructs its sandbox from Linux user, mount, PID, IPC,
network, UTS, and cgroup namespaces, Linux bind mounts and procfs.
Docker Desktop, or another Docker-compatible Linux VM, supplies that Linux kernel.
The
garden image inside the VM supplies the executable.

## The change already on `main2`

The required source changes are in `1e1968c0781` and `443d1f15cd4`; both are
contained in `main2`:

- `Dockerfile` adds `bubblewrap` to the `apt-get install` package list.
  An old
  image does not gain it merely because the root checkout advances; it must be
  rebuilt with `./garden build`.
- `garden` creates `<garden-root>/.garden-state/secrets` with mode `0700` and
  adds the exact nested mount
  `-v "${SECRETS_DIR}:${SECRETS_DIR}:ro"` after the broader writable home
  mount.
  An old container does not gain that mount; it must be removed and
  recreated.
- `scripts/host/seccomp-garden.json` is Docker's default seccomp profile plus
  the one syscall bubblewrap additionally needs, `pivot_root`.
- `garden` passes that profile with
  `--security-opt "seccomp=${SCRIPT_DIR}/scripts/host/seccomp-garden.json"` and
  passes `--security-opt systempaths=unconfined` so Docker does not mask the
  procfs paths on which bubblewrap must mount the sandbox's new `/proc`.

The rest of the launcher posture needed for nested namespaces is also already
on `main2`: no `--privileged`, the narrow custom seccomp profile remains active,
`--cap-add SYS_ADMIN` is present for root/systemd PID 1, and
`--security-opt apparmor=unconfined` is present because `docker-default`
AppArmor blocks the mount operations needed by systemd and bubblewrap.
The
container has its normal procfs, and the sandbox replaces `/proc` with a procfs
for its new PID namespace.

## What the container must permit

The bot user starts with no effective Linux capabilities.
Bubblewrap therefore
needs unprivileged user namespaces; it acquires namespace-scoped mount authority
inside the user namespace rather than inheriting host or container-root
`CAP_SYS_ADMIN`.
Do not add capabilities to the bot process and do not replace
the current launcher with `--privileged`.

The complete runtime contract is:

| Surface | Requirement | Garden use |
| --- | --- | --- |
| User namespaces | `kernel.unprivileged_userns_clone=1` where that sysctl exists, and a nonzero `/proc/sys/user/max_user_namespaces` | lets a zero-capability bot create the user namespace in which the remaining namespace and mount setup is permitted |
| Seccomp | use `scripts/host/seccomp-garden.json`, not Docker's unmodified default and not `seccomp=unconfined` | retains Docker's default allowlist and adds only `pivot_root`, which bubblewrap needs to install its new root |
| AppArmor | use a profile that permits the mount operations and unprivileged user namespace; the shipped launcher uses `apparmor=unconfined`, and `kernel.apparmor_restrict_unprivileged_userns` must be `0` where that sysctl exists | avoids `Permission denied` while mapping the unprivileged user namespace and creating the nested mount namespace |
| Container capabilities | retain the launcher's `--cap-add SYS_ADMIN` for root/systemd PID 1 | the bot and `bwrap` itself still have an empty effective capability set; no additional `--cap-add` is required for the harness |
| `/proc` | outer `/proc` must be visible, procfs mounts must be allowed, and Docker's system-path masks must be disabled with `systempaths=unconfined` | `run-sandboxed.sh` passes `--proc /proc` so the child sees only its sandbox PID namespace |

`scripts/secrets/run-sandboxed.sh` invokes bubblewrap with all of the following
features:

- `--die-with-parent` and `--new-session` for child lifetime and session
  isolation;
- `--unshare-pid`, with the non-setuid bubblewrap build implicitly creating an
  unprivileged user namespace;
- `--ro-bind / /`, followed by `--proc /proc` and `--dev-bind /dev /dev`;
- `--chdir <worktree>`, a private `--tmpfs /tmp`, and a read-write bind of the
  selected worktree;
- tmpfs overlays for every present secret or credential-bearing path:
  `.garden-state/secrets`, `/run/environment.d`, the secret-broker state, and
  `~/.aws`;
- tmpfs overlays for the other harnesses' private homes; and
- explicit read-write binds only for the selected harness home, requested
  `--rw` paths, and the selected Git worktree's git directory and common object
  store;
- a fresh per-job `TMPDIR` (`$TMPDIR/sbx-tmp.*`) and a fresh per-job
  `GARDEN_STATE` (`$GARDEN_STATE/sandbox-state/sbx-state.*`), each bound
  read-write and exported. Inherited journal-clone paths
  (`GARDEN_WORKER_CLONE`, `GARDEN_PRODUCER_CLONE`, `GARDEN_INBOX_CLONE`,
  `GARDEN_JOURNAL_CLONE_BASE`, `JOURNAL_REMOTE_CACHE`) are unset so they are
  re-derived under the job's own state. Only the host's
  `$GARDEN_STATE/repo-locks` is shared, which keeps same-host pushes to the
  garden repository serialized. Directories older than 1 day (tmp) or 2 days
  (state) are swept when the next job starts.

It does not unshare the network namespace, so provider access remains
available.
It requests no `--cap-add` from bubblewrap.
Its Linux-capability
requirement at the bot boundary is therefore **none**; its kernel requirement is
working unprivileged user namespaces plus permitted namespace/mount syscalls.

Run this inside the newly created container as the bot user:

```sh
command -v bwrap
cat /proc/sys/kernel/unprivileged_userns_clone 2>/dev/null || true
cat /proc/sys/user/max_user_namespaces
cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns 2>/dev/null || true
bwrap --ro-bind / / --unshare-all true
printf 'bwrap smoke rc=%s\n' "$?"
scripts/secrets/run-sandboxed.sh \
  --worktree "$PWD" --allow-home none -- /bin/true
printf 'garden sandbox rc=%s\n' "$?"
```

Success is a path ending in `/bwrap`, `1` for
`unprivileged_userns_clone` when the file exists, a positive namespace limit,
`0` for `apparmor_restrict_unprivileged_userns` when that file exists, no output
from either sandbox command, and exactly:

```text
bwrap smoke rc=0
garden sandbox rc=0
```

If the executable is absent, the garden wrapper fails with exit 75 and exactly:

```text
bubblewrap unavailable; refusing a secret-bearing harness
```

A namespace or LSM refusal is also a stop condition.
Bubblewrap exits nonzero
and writes a `bwrap:` diagnostic to stderr; a common user-namespace denial is:

```text
bwrap: Creating new namespace failed: Operation not permitted
```

Do not proceed by weakening the secret launcher or setting `GARDEN_TEST=1`;
that bypass is for hermetic tests only.

## Operator procedure for Oros

All key placement and import commands are maintainer operations on the Mac
host.
No agent receives, reads, pastes, or transports a value.

1) On Oros, engage an operator drain before the provider-secrets SHA is
   released, then wait for every live worker to finish:

   ```sh
   scripts/jobs/drain-fleet.sh on "provider-secrets container migration"
   find "$GARDEN_STATE" -mindepth 3 -maxdepth 3 -name busy -print
   ```

   The `find` must print nothing.
   Keep the drain in force throughout the rebuild and recreation.
   Confirm the source used for the build contains
   both `1e1968c0781` and `443d1f15cd4`; building the old `2c082b9acbc` tree
   does not install bubblewrap, add the secret mount, or apply the required
   seccomp and procfs posture.

2) In the Mac shell, make the six legacy variables available only for this
   compatibility migration.
   They are:
   `ANTHROPIC_API_KEY`, `MOONSHOT_API_KEY`, `FIREWORKS_API_KEY`,
   `OPENROUTER_API_KEY`, `OLLAMA_CLOUD_API_KEY`, and `TYPESAFE_API_KEY`.
   Do not put values in command arguments, logs, this document, or an agent
   prompt.

3) From the Oros garden root on the Mac, build the image, remove the old
   container, and create the replacement from the new launcher:

   ```sh
   ./garden build
   ./garden reset
   ./garden create
   ```

   The persistent operator-drain marker is in the bind-mounted garden state, so
   recreation does not authorize new claims.
   If the source has not yet been
   staged on Oros, stop here rather than letting the autonomous rolling deploy
   advance it first; coordinate a maintenance release that keeps the workers
   quiescent through this sequence.

4) Enter the new container and run both smoke tests from the preceding section.

   Also confirm the installed package and launch posture without exposing any
   secret:

   ```sh
   bwrap --version
   awk '/^CapEff:/{print}' /proc/self/status
   mount | grep ' on /proc '
   ```

   `CapEff` for the bot must be all zeroes.
   A nonzero sandbox result is a failed
   migration.

5) Back in the Mac host shell, import the six allowlisted creation-environment
   variables and inspect only value-free status:

   ```sh
   scripts/secrets/import-environment.sh
   scripts/secrets/status.sh
   ```

   Each enabled kind must report `present`, `valid`, and an age.
   An absent disabled kind is acceptable.
   The importer does not overwrite an existing
   file unless the maintainer deliberately reruns it with `--replace`.

6) Verify one enabled, secret-bearing harness end to end with a harmless,
   host-pinned canary whose task is only create → read back → remove a scratch
   file.
   Write `canary.md` with this content:

   ```md
   ---
   requires: host=oros-studio-garden-ce242c49
   ---

   In this isolated worktree, use tools to create a scratch file containing a
   nonce, read it back, then remove it.
   Report the three tool results and make no
   external change.
   ```

   Post it with one enabled provider and a fresh basename, for example:

   ```sh
   scripts/jobs/post-job.sh --provider-canary anthropic minion \
     oros-bwrap-canary-20261107 canary.md
   ```

   Confirm its `jobs/tada/` report names Oros, the
   expected provider and worker kind, and tool evidence for all three file
   operations.
   Plausible prose without tool output is not a pass.

   A drained host cannot claim even a canary.
   Keep the deploy release held,
   briefly lift the claim drain only for this host-pinned canary, and re-engage
   it as soon as the canary is claimed.
   Wait for the canary to complete while no
   other Oros worker is allowed to take new work.
   If it fails or exits 75, leave Oros drained.
   Coordinate this bounded window with the leader by pausing
   `garden-rolling-deploy.timer` before the temporary lift, confirming no Oros
   release token is outstanding, and restoring the timer only after the final
   lift.
   Do not stop Oros's sysop; it is the recovery path for a remote drain.

7) After the sandbox smoke, value-free status, and real harness report all pass,
   lift the final operator drain:

   ```sh
   scripts/jobs/drain-fleet.sh off
   ```

   Then allow the leader to release Oros into the rolling deploy.

## Holding the rolling deploy

`$GARDEN_STATE/deploy/upgrade-ready` is a host-local cryptographic fact saying a
newer `main2` exists.
It is not operator approval and should not be forged or
deleted as a hold.
A follower advances only when that fact is joined by the
leader's journal release token at `deploy/roll/<GARDEN>`.

The supported operator hold is Oros's local operator drain. `self-deploy.sh`
publishes `roll_status: operator-drained` and declines a release; the leader's
`rolling-deploy.sh` treats that as an inviolable operator pause, skips Oros, and
never lifts the drain.
If Oros is the only available follower, the leader must
hold rather than advance with no validated canary.
If another follower passes,
the current conductor may proceed while recording Oros as skipped, so the
operator must keep `garden-rolling-deploy.timer` paused during the bounded
validation window and confirm no Oros release token is outstanding until this
hand-off is complete.

An Oros that cannot run bubblewrap is not a degraded-but-usable canary.
Leave it
operator-drained, do not count it as passed, and do not advance it to the
provider-secrets release.
A failed canary must halt that release path; the
leader may continue serving its already deployed version but must not infer
fleet compatibility from Oros being offline or skipped.

## Rollback

The safe rollback is to abort before release: keep Oros at its known-good
pre-provider-secrets SHA (`2c082b9acbc` at the time of this hand-off), retain or
recreate its prior image/container, and leave the operator drain in force until
that known-good container is running.
Do not import keys into a container whose
sandbox smoke failed.

There is no automatic backward deploy: `deploy-garden.sh` is intentionally a
strict fast-forward deploy.
If Oros has already advanced, keep it drained and
either land a forward fix on `main2` or perform a maintainer-directed recovery
to the recorded prior deployed SHA and prior image.
Never "roll back" by
removing the `command -v bwrap` refusal, setting `GARDEN_TEST=1`, adding
`--privileged`, or exposing secret files read-write.
Clear any stale Oros release
token before bringing the known-good host back, then lift the drain only after
its ordinary non-secret harness path is healthy.
