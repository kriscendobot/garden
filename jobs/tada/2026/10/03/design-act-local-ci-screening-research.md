## Completion report: `design-act-local-ci-screening-research`

**Delivered:** `designs/act-local-ci-screening-findings.md`, pushed to `main2` as `4fc29503362`. It answers all four questions with the commands I ran and their output, and is marked as research input for `designs/act-local-ci-screening.md`. I did not write the design doc; that belongs to the doc child.

**Bottom line:** `act` (v0.2.89) works in the container only in host (`-self-hosted`) mode. Container mode won't work with the current image.

1. **Docker:**
   - **Container:** there is no Docker or Podman binary and no socket, and that is deliberate: the launcher leaves out `--privileged` and the socket mount as hardening.
   - **Rootless Podman:** the kernel prerequisites are present (user, mount and network namespaces, `/dev/fuse`, a `subuid` range, seccomp and AppArmor unconfined). `podman` and `uidmap` are missing, so a Dockerfile change, which is the maintainer's call, would be needed. I installed nothing, so whether it works end to end is unverified.
   - **Host:** it runs Docker Engine (the container's root filesystem is a containerd snapshot), but a gardener can't reach it. Whether the host has rootless Podman can't be checked from inside the container.
2. **`act` without Docker:** the static binary installs without root (`/tmp` is `noexec`, so it has to live elsewhere). Findings the docs don't mention:
   - **`-n` (dry run) still executes steps in host mode.** It ran a real `npm ci` and the full vitest suite.
   - **False failure:** the minion.town `test` job ran in 29 s, but one test failed only because of the garden's `scripts/jobs/bin/git` wrapper. With the wrapper removed from PATH, all 41 tests in that file pass.
   - **ebfb's `ci.yml` does not parse:** `act` rejects its `parallel:` step groups (upstream nektos/act#6124, still open).
   - **`uses: $/…` is rejected:** five PR-gating ebfb workflows call their shared job selector this way and fail at run time. A one-line rewrite to `./` fixes it, and with that `ci-changes` ran in 80 s and printed exactly which CI jobs a change would trigger.
   - **No cleanup:** each run leaves about 1 GB in `~/.cache/act`, and nothing prunes it.
   - **Interactive prompt:** without `-P` or a config file, `act` asks for an image size and dies when run headless.
3. **Workflow inventory:** every job in ebfb (15 workflows) and minion.town (2 workflows) is listed with its runner and matrix, trigger, measured median and max runtime, Docker needs, and secrets. Each is classed as Linux-runnable, Linux but impractical locally, or not Linux, and mapped to `local-verify` coverage.
   - **Impractical locally:** ebfb's zizmor action needs Docker (but `local-verify` already runs zizmor directly), `sandbox-drivers` needs Podman, and minion.town's harness image jobs need Docker buildx plus arm64 emulation.
   - **Parity gaps found:** several CI commands have no `local-verify` equivalent, for example ebfb's `lint:types`/`test:types` and `check-security-md`, and minion.town's `claude-harness:check`.
4. **Cost:**
   - **Images:** `catthehacker/ubuntu` act image 0.58 GB compressed, full image 18.97 GB.
   - **ebfb:** a change touching every path triggers about 208 Linux and 82 macOS runner-minutes per push. The repo is public, so these minutes aren't billed; the cost is wall-clock and queue time.
   - **minion.town:** about 8 billed minutes per push. Draft minion.town#145 is moving its CI to a self-hosted runner because of an account billing block.

**Follow-ups for the design child:**
- The cheapest wins need no Docker: run ebfb's `ci-changes` selector locally (with the `$/` rewrite) to see which jobs a change will trigger, and audit `local-verify`'s table against the workflows' `run:` lines with a plain YAML reader.
- Container-mode `act` would need the maintainer to approve adding Podman to the image.

**Cleanup:** I deleted `~/.cache/act` (3.9 GB) and the scratch research directory. The two project checkouts I used are keyed to this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-act-local-ci-screening-research.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3855969 cached reads)
- Output: 29079 tokens
- Cost: $2.2454198
- Wall-clock: 617s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
