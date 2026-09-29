---
role: builder
tier: mentat
dispatch: manual
---
**Role: builder.** Build a **host-side OpenShell pilot kit** for a one-host trial on `endolin-garden2`. The maintainer runs it by hand on the host, **outside the garden container** (like `scripts/ferry.sh`). Land it direct to `main2` in `kriscendobot/garden`.

Source report (read first, and treat its recommendations as the spec): https://github.com/kriscendobot/garden/blob/journal2/projects/garden/openshell-confinement-fit.md, pinned against NVIDIA/OpenShell `1358941b818d4126a7374aaf5216d87fc960e122` / `v0.1.2`.

Maintainer decision (kriskowal, liaison session 2026-09-29): "Let's run a trial on this host, endolin-garden2." The maintainer then chose the "host-side script I run" shape over a nested-in-container trial. **Do not install or run OpenShell or Podman inside the garden container**, and never give the container a Podman/Docker socket. You are building the kit, not running the trial.

The kit (suggested home `scripts/openshell-pilot/`, entry `scripts/openshell-pilot.sh <preflight|install|up|test|report|down|uninstall>`):
1. **preflight**: refuse to run inside the container (invert `scripts/check-in-container.sh`). Check that rootless Podman prerequisites exist (subuid/subgid, user namespaces, cgroup v2 delegation, linger) and that the kernel supports Landlock and seccomp user-notify. Check `/tmp` noexec. Print exactly which prerequisites need root (for example `apt install podman uidmap`) and never run sudo silently.
2. **install**: pinned OpenShell release to a user-owned executable prefix under `$HOME` with checksum verification. State under an explicit XDG/state path, not `/tmp`. Idempotent.
3. **up / down**: rootless Podman service plus the OpenShell gateway as **host systemd --user units**, separate from the garden container's user manager, with health gating.
4. **test**: the report's staged pilot with **synthetic credentials only** at first. A fake bearer secret against a local echo endpoint proves the workload sees only the placeholder and the upstream sees the real value. It also proves non-allowlisted egress is denied, the workload can't read host `$HOME` secrets (`.claude/.credentials.json`, `.ssh`, `.aws`, `.config/gh`), and Landlock/seccomp qualify. Then add **optional, separately-gated stages**, each needing an explicit flag plus a throwaway credential the maintainer supplies: a fine-grained read-only GitHub token over HTTPS (verify `/user`, denied `git-receive-pack`), and AWS SigV4 with a scoped STS role (plus the `aws ssm` caveat test). **Never** attach Anthropic subscription OAuth, the Codex auth dir, SSH keys, or any ferry/maintainer credential. Hard-code refusals for those paths.
5. **report**: write a results file the maintainer can land into the journal (suggested `projects/garden/openshell-pilot-results-<date>.md`) with pass/fail per check and versions.
6. **uninstall**: full teardown of units, state and prefix.

Also: a short README / `context/operations/openshell-pilot.md` telling the maintainer exactly what to type on the host. Add a container-side guard test that runs the kit's logic in dry-run/mocked mode (no real install), shellcheck-clean. Surface anything that needs a maintainer decision (root package installs, host kernel settings) in the completion report rather than guessing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T00:43:44Z
