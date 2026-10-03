# `act` local CI screening: research findings

> **Research input for [`designs/act-local-ci-screening.md`](act-local-ci-screening.md).**
> This is not a design. It is the fact-finding child (`design-act-local-ci-screening-research`)
> of orchestration `design-act-local-ci-screening-split`. The design child
> (`design-act-local-ci-screening-doc`) owns the recommendations. Everything below
> was measured on `endolin-garden2-5bcdff64` on 2026-10-03, inside the garden
> container, as a monk gardener. Measured with `act` v0.2.89 (released
> 2026-06-01; it is the latest release, and the last commit on `nektos/act` master
> is the version bump on that day).

## Bottom line

**`act` is feasible in the container only in host (`-self-hosted`) mode. Container mode is infeasible as the image stands.** Gardeners have no Docker or Podman binary and no daemon socket. They can still run the static `act` binary without root. With `-P ubuntu-latest=-self-hosted`, `act` ran the real minion.town `test` job end to end in 29 s warm. It also ran ebfb's `ci-changes` job selector in 80 s.

Host mode is not a parity oracle. Steps run with the gardener's own PATH, tools, and credentials, and the garden's `scripts/jobs/bin/git` wrapper produced a false red (§2.4). `-n` does not dry-run (§2.3). Two pieces of ebfb syntax also fail `act`'s parser:

- **`parallel:` step groups.** These make `ci.yml` unparseable.
- **The `uses: $/.github/workflows/ci-changes.yml` reusable-workflow form.** It is used by every PR-gating ebfb workflow except `zizmor.yml` and `copilot-setup-steps.yml`, and `act` rejects it at run time.

Running ebfb therefore needs a rewrite shim. Two things together would unblock container-mode `act`, which has real isolation and the catthehacker image:

1. A maintainer decision to add `podman` + `uidmap` to the Dockerfile. The container already permits unprivileged user, mount, and network namespaces, has `/dev/fuse`, has a `subuid` range, and runs with seccomp and AppArmor unconfined.
2. About 0.6 GB per host for `catthehacker/ubuntu:act-24.04`.

Two other limits hold in either mode:

- **ebfb minutes are not billed.** ebfb is public, so its standard GitHub-hosted runner minutes are free. The real saving there is queue time and the agent-turn round trip.
- **minion.town minutes are billed, but CI is moving off them.** minion.town is private and billed. Its CI is moving to a self-hosted runner because of an account billing block (minion.town#145).

The best cheap win is to run ebfb's `ci-changes` selector locally, with the `$/` shim, so the screen knows which CI jobs a change will trigger. The second is a parity audit of `local-verify`'s candidate table against workflow `run:` lines. Neither needs Docker.

## 1. Docker in the gardener execution path

**Inside the container (where gardeners run `local-verify.sh` / `pre-push-gates.sh`): no Docker, no Podman, no socket.**

```
$ ls /.dockerenv; which docker podman act buildah; echo DH=$DOCKER_HOST
/.dockerenv
DH=
$ ls -l /var/run/docker.sock /run/docker.sock /run/user/1000/podman
ls: cannot access '/var/run/docker.sock': No such file or directory
ls: cannot access '/run/docker.sock': No such file or directory
ls: cannot access '/run/user/1000/podman': No such file or directory
$ ./act -l   # in any repo
level=warning msg="Couldn't get a valid docker connection: no DOCKER_HOST and an invalid container socket ''"
```

This is deliberate. The `garden` launcher's `docker run` (`garden`, around line 346) passes `--cap-add SYS_ADMIN --cgroupns=host -v /sys/fs/cgroup ... --tmpfs /run --tmpfs /tmp -v $INSTANCE_PATH:$INSTANCE_PATH`. It mounts no socket and passes no `--privileged`. Its own comments say it is device-less by design, because of prompt-injection hardening (`context/operations/harden-container.md`). Mounting the host Docker socket would hand container-root-equivalent host access to any code a gardener runs. Nobody should propose that lightly.

**Rootless Podman inside the container: the kernel prerequisites are present, but the binaries are not.**

```
$ unshare -Urmpf --mount-proc true && echo ok          -> userns+mountns+pidns+procfs OK
$ unshare -Urm sh -c 'mount -t tmpfs none /mnt'        -> tmpfs-in-userns-ok
$ unshare -Urn true                                     -> netns-ok
$ ls -l /dev/fuse                                       -> crw-rw-rw- 1 root root 10, 229
$ cat /etc/subuid                                       -> kris:100000:65536
$ ls /usr/bin/newuidmap                                 -> No such file or directory
$ grep Seccomp /proc/self/status; cat /proc/self/attr/current
Seccomp: 0      unconfined
$ sudo -n -l   -> (ALL) NOPASSWD: ALL
```

`podman`, `uidmap` (`newuidmap`/`newgidmap`), and `fuse-overlayfs` are absent from the image; the Dockerfile has `FROM ubuntu:24.04` and installs none of them. Because the bot user has NOPASSWD sudo, `sudo apt-get install podman uidmap` would *work* in a live container. It would also vanish on the next container recreation and drift the image from its build contract. The durable path is a Dockerfile change, which is a maintainer-weighted hardening decision. **I did not install anything and did not try a nested container,** so whether rootless Podman works end to end in this exact container is **unverified**. The prerequisites above make it likely.

**The host (outside the container): Docker Engine exists, but I could not inspect it from here.** The launcher is entirely `docker build` / `docker run` / `docker exec`, and the container's rootfs is a containerd overlay snapshot (`overlay on / ... lowerdir=/var/lib/containerd/io.containerd.snapshotter.v1.overlayfs/...`). So the host runs Docker with the containerd image store. A gardener cannot reach it, and nothing in the fleet runs host-side except `scripts/ferry.sh`, which runs under the maintainer's identity and is out of scope here. Whether the host has rootless Podman is **unknown**. It cannot be checked from inside the container, and the job forbids host-side probing.

## 2. `act` without Docker

### 2.1 What the current docs say

From <https://nektosact.com/usage/runners.html>, fetched 2026-10-03:

- Self-hosted mode: `act -P ubuntu-latest=-self-hosted` (likewise `windows-latest`, `macos-latest`) "bypass[es] Docker containers and run[s] workflows directly on your host system".
- Image tiers: Micro (`node:16-buster-slim`), Medium (`catthehacker/ubuntu:act-latest`), Large (`catthehacker/ubuntu:full-latest`). The default images "do **not** contain **all** the tools that GitHub Actions offers"; "Docker containers cannot run `systemd`". `nektos/act-environments-ubuntu` is ">18GB".
- README: act "uses the Docker API to either pull or build the necessary images ... then uses the Docker API to run containers for each action."

In self-hosted mode the following need Docker and therefore do not work: `services:`, job `container:`, and Docker-type actions (`runs.using: docker`, `docker://` steps). Composite actions that shell out to `docker` also fail; the zizmor action is one of these (§3). JavaScript and composite actions run on the host's `node`/`bash`. **Unsupported workflow syntax** (§2.3) fails in either mode.

### 2.2 Install without root

The binary is static, so no root is needed:

```
$ curl -sSL -o act.tgz https://github.com/nektos/act/releases/download/v0.2.89/act_Linux_x86_64.tar.gz   # 8.2 MB
$ tar xzf act.tgz act; ldd act      -> not a dynamic executable
$ ./act --version                  -> act version 0.2.89     (21 MB on disk)
```

It must live on an exec-capable filesystem. `/tmp` is `noexec` in the container (`tmpfs on /tmp ... noexec`), so I used `scratch/`.

### 2.3 Caveats observed (not in the docs)

1. **`-n/--dryrun` is not a dry run in self-hosted mode.** `act -n -P ubuntu-latest=-self-hosted -j test pull_request` on minion.town ran `npm ci` ("added 271 packages"), cloned the pinned Endo daemon, ran `yarn install` (building `better-sqlite3`), and ran the full vitest suite ("Tests 1 failed | 711 passed"). Every line is prefixed `*DRYRUN*`, but the steps execute. Any design must treat `-n` as unsafe in host mode. Use `-l` and `--validate` for parse-only checks.
2. **ebfb's `ci.yml` does not parse.** Its `lint` job uses a `parallel:` step group (ci.yml line 99), which act's schema rejects:
   ```
   Error: workflow is not valid. 'ci.yml': Line: 42 Column 5: Failed to match job-factory:
   Line: 99 Column 9: Failed to match run-step: ... Unknown Property parallel
   ```
   Upstream issue nektos/act#6124, "Add support for concurrent steps execution", opened 2026-06-28, is still open. `--strict` only tightens validation. There is no lenient switch.
3. **The `$/` reusable-workflow path is rejected.** `browser-test`, `ci`, `depcheck`, `ironhorse-sanitizers`, and `ocapn-guile-interop` all start with `changes: uses: $/.github/workflows/ci-changes.yml`. `act -l` lists these workflows except `ci.yml`, which fails on `parallel:` first. Running one fails:
   ```
   Error: `uses` key references invalid workflow path '$/.github/workflows/ci-changes.yml'.
   Must start with './' if it's a local workflow ...
   ```
   A one-line shim, `sed 's#uses: \$/#uses: ./#'` into a scratch copy of the workflow passed with `-W`, fixes it (§2.5).
4. **Per-run cache leak.** Every run creates a fresh `~/.cache/act/<hash>/hostexecutor` holding a full copy of the workspace, including `node_modules`. Three minion.town runs plus one ebfb run produced 3.9 GB, and nothing reuses or prunes it. `$HOME` is the garden root, so a fleet-wide integration needs an explicit cache dir and cleanup. That matters here because inode and disk exhaustion has wedged hosts before. `act` also writes `~/.cache/act/.notices.etag`, so it fetches a notices feed over the network.
5. **The interactive first-run prompt.** With no `~/.config/act/actrc` and no `-P`, `act` asks interactively to choose an image size. Headless, that dies with `level=fatal msg=EOF`. Always pass `-P` or ship an actrc.

### 2.4 Host mode inherits the gardener environment (parity hazard)

`act -P ubuntu-latest=-self-hosted -j test pull_request` on minion.town `main` (`ec8db3f`) finished in **29 s wall, warm**. CI's median for the same job is 2.3 min. One test failed:

```
FAIL test/git-remote/capability.test.ts > projectPartition > propagates a git failure rather than reporting the ref absent
AssertionError: promise resolved "{ fileCount: +0, skipped: [] }" instead of rejecting
```

Re-running that test file with `scripts/jobs/bin` removed from PATH gives `Tests 41 passed (41)`. **The garden's git wrapper (`scripts/jobs/bin/git`, first on PATH) changes git's failure behavior**, and host-mode `act` inherits it. The checkout action's own git calls also went through the wrapper and took the garden repo lock (`garden repo lock: cleared dead-holder metadata ... after acquiring .../repo-locks/...`). This is the "host-env git-remote test failure is pre-existing" previously noted for minion.town. It is an environment divergence, not a code bug.

Host mode also exposes the gardener's environment, `gh` wrapper, and credentials to workflow steps. A container-mode run would isolate them.

### 2.5 ebfb's job selector runs under act

The `$/` shim plus a minimal synthetic `pull_request` event (`base.sha = HEAD~3`, `head.sha = HEAD`) ran `ci-changes` successfully in **80 s** (`setup-python` 19 s cold, selector script 40 s):

```
$ sed 's#uses: \$/#uses: ./#' .github/workflows/depcheck.yml > shim/depcheck.yml
$ act pull_request -e pr.json -W shim/depcheck.yml -j changes -P ubuntu-latest=-self-hosted
... ::set-output:: jobs={"test":false,"cover":false,"lint":true, ... "depcheck":false,"check-action-pins":false,...}
🏁  Job succeeded
```

That output is the exact set of ebfb CI jobs a change range will trigger: here, a docs-only change triggers `lint` only. It is the most useful screening primitive act gives ebfb. It costs no Docker and needs no `ci.yml` parse.

## 3. Workflow inventory

The fleet's regular targets are those named in `jobs/tada/` since 2026-09-01: `endojs/endo-but-for-bots` (1216 mentions), `kriscendobot/minion.town` (580), and the garden itself (158, which has no CI gauntlet). `endojs/endo` (65) is the upstream that the ferry targets, and others are in single digits. The journal `repos/` watch set lists 15 `kriscendobot-*` repos, but only these two are gauntleted regularly. The open gauntlets in `jobs/gauntlet/` (17) are all ebfb or minion.town.

Runtimes are medians and maxima over the jobs of the last 40 completed `pull_request` runs per repo (`gh api .../actions/runs` → `/jobs`, completed minus started). The ebfb sample is thin, n=1–6 for most jobs, because many recent runs were `zizmor` or `copilot-setup-steps` only.

Legend: **L** = Linux-runnable under host-mode act. **L‑imp** = Linux but impractical locally. **X** = not Linux, out of scope. **LV** = whether `local-verify.sh`'s `STEPS="format build lint zizmor package-uniformity root-types codegen test test-xs docs"` covers it.

### 3.1 `endojs/endo-but-for-bots` (default `llm`, public → standard-runner minutes free)

No job uses `services:` or `container:`, and no step uses `docker://`. The only secret referenced anywhere is `RELEASE_TOKEN`, in two places. `ci-changes.yml` (a `workflow_call`) gates every PR job below through `changes.outputs.jobs`.

| Workflow / job | runs-on (matrix) | trigger | median / max | Docker need | class | LV |
| --- | --- | --- | --- | --- | --- | --- |
| ci-changes / changes | ubuntu | workflow_call | 0.3 / 0.5 m | none | **L** (ran, §2.5) | — (selector) |
| ci / lint | ubuntu | push, PR | 10.0 / 14.3 m | none | **L** but `parallel:` blocks parse | yes: build, lint, package-uniformity, root-types, codegen (`build:types`), docs; **not** `check-security-md.sh`, `build:types:check`, `run-ci-task.py lint:types` / `test:types` |
| ci / test | ubuntu ×{22,24}, **macos-15** ×{22,24} | push, PR | 26–27 m ubuntu, 28 m mac | none | ubuntu **L** (long); macOS **X** | yes (`test`; CI runs `run-ci-task.py test`) |
| ci / cover | ubuntu ×{22,24} | push, PR | 2.8–3.0 / 7.3 m | none | **L** | no (`test:c8`) |
| ci / viable-release | ubuntu ×{22,24} | push, PR | 3.9–4.5 m | none | **L** | no (`smoketest:publish`) |
| ci / sandbox-drivers | ubuntu | push, PR | 7.9 m | `sudo apt install bubblewrap`, **`podman pull alpine`** | **L‑imp** (needs Podman plus apt mutation) | no |
| ci / test-xs | ubuntu | push, PR | 7.3 m | none (downloads xst, `make`) | **L** (network + build) | yes (`test:xs`) |
| ci / build-xsnap | ubuntu | push, PR | 5.2 m | none | **L** | no |
| ci / familiar-bundle | ubuntu | push, PR | 0.8 m | none | **L** | no |
| ci / test-hermes | ubuntu | push, PR | 1.4 m | none | **L** | no |
| ci / test-async-hooks | ubuntu ×{22} | push, PR | 1.8 m | none | **L** | partial (`test`) |
| ci / check-action-pins | ubuntu | push, PR | 0.7 m | none | **L** | no |
| ci / format-ironhorse | ubuntu | push, PR | 0.6 m | none | **L** | no (cargo fmt) |
| ci / test-ironhorse (debug, release) | ubuntu | push, PR | 25.1, 14.2 m | none | **L** (long Rust) | no |
| ci / test-ironhorse-macos | **macos-latest** | push, PR | 26.4 m | — | **X** | — |
| ci / test-ironhorse-oracle | ubuntu | push, PR | 16.2 m | none | **L** (long) | no |
| ci / test-ironhorse-calibration | ubuntu | push, PR | 2.2 m | none | **L** | no |
| ci / test-thixotrope-ironhorse | ubuntu | push, PR | 9.3 m | none | **L** | no |
| ci / compare-ironhorse-math | ubuntu (needs test-ironhorse artifact) | push, PR | 0.2 m | none | **L** (needs act artifact server) | no |
| ci / fuzz-ironhorse | ubuntu | push, PR | 10.0 m | none | **L** (long) | no |
| ci / test-ocapn-python | ubuntu | push, PR | 2.0 m | none | **L** | no |
| ci / build-wasm | ubuntu | push, PR | 0.5 m | none | **L** | no |
| browser-test / browser-tests | ubuntu | push, PR, schedule | no sample | none (browsers via npm) | **L**, `$/` shim | no |
| depcheck / build | ubuntu | push, PR | 0.7 m | `sudo apt install graphviz` | **L** (apt mutation) | no |
| ironhorse-sanitizers / oracle-sanitizers | ubuntu | push, PR | 19.4 m | none | **L** (long), `$/` shim | no |
| ocapn-guile-interop / test-ocapn-guile-interop | ubuntu | PR, dispatch | 4.6 / 4.8 m | none (builds Guile; `nick-fields/retry`) | **L‑imp** (Guile toolchain) | no |
| zizmor / zizmor | ubuntu | push, PR | 0.2 / 0.5 m | **composite action runs `docker pull/run ghcr.io/zizmorcore/zizmor`** (`action.sh` line 32: `installed docker \|\| die`) | **L‑imp** under act; already native | **yes** (`zizmor` step reads the action's `with:`) |
| copilot-setup-steps | ubuntu | dispatch, push, PR | — | none | **L** | n/a |
| familiar-release / make | macos-14, macos-13, ubuntu | dispatch, push(tag) | — | none | ubuntu **L**, mac **X**; release-only | n/a |
| release / Release | ubuntu | push | — | none; `RELEASE_TOKEN` | not a screen target (publishes) | n/a |
| typedoc-gh-pages | ubuntu | push, dispatch | — | Pages deploy | not a screen target | n/a |
| ironhorse-full-test262 (5 jobs), ironhorse-deep-fuzz | ubuntu | schedule, dispatch | 30–350 m timeouts | none | **L‑imp** (hours) | n/a |
| update-action-pins{,-major} | ubuntu | schedule, dispatch | — | opens PRs | not a screen target | n/a |

When every path changes, an ebfb PR push triggers about **208 Linux runner-minutes plus 82 macOS minutes** (sum of the medians above). A JS-only change, without the ironhorse, xs, or guile legs, comes to about 92 Linux minutes. The longest leg, `test` on ubuntu, takes about 26 minutes of wall time. This repo is public, so on standard runners these minutes are not billed. The cost is concurrency and wall-clock, and a gardener idling or re-claiming while it waits.

### 3.2 `kriscendobot/minion.town` (default `main`, private → minutes billed)

| Workflow / job | runs-on | trigger | median / max (n=40) | Docker need | class | LV |
| --- | --- | --- | --- | --- | --- | --- |
| test / test | ubuntu | push, PR | 2.3 / 5.9 m (4 fails) | none | **L** (ran: 29 s warm, §2.4) | yes: `typecheck`→build/lint, `build`, `test`; **not** `claude-harness:check`, Endo-daemon checkout+install, the two dedicated vitest integration files |
| test / Claude harness (amd64, arm64) | ubuntu | push, PR | 1.5 m, 4.3 / 13.5 m | **`docker buildx build`** plus `docker/setup-qemu-action` (arm64 emulation) | **L‑imp** (needs Docker/buildx plus binfmt; arm64 is impossible without privileged qemu) | no |
| deploy / deploy | ubuntu | push(main), dispatch | not sampled | AWS OIDC (`aws-actions/configure-aws-credentials`), SSM deploy scripts | **not a screen target** (production CD) | n/a |

Per PR push that is about 8 billed minutes. **Draft minion.town#145** (`ci: self-hosted ephemeral runner at ci.minion.town`) moves `test.yml` to `[self-hosted, ci-minion-town]`. Its PR body says this is because "GitHub Actions refuses to start hosted-runner jobs on this account (billing block)". `gh api repos/kriscendobot/minion.town/actions/runners` already shows one runner online, `ci-minion-town-0fdb85b6-*`. Once #145 lands, minion.town's hosted-minute cost is roughly zero and act's budget case for it disappears. Act's only remaining value there would be screening latency.

### 3.3 Parity gaps found while inventorying (inputs for the design)

Each of these CI `run:` lines in a PR-gating Linux job has no `local-verify` step:

- **ebfb `lint`:** `bash scripts/check-security-md.sh`, `yarn build:types:check`, `python3 scripts/run-ci-task.py lint:types`, and `python3 scripts/run-ci-task.py test:types`.
- **ebfb jobs `cover`, `viable-release`, `familiar-bundle`, `test-hermes`, and `check-action-pins`:** none of their commands have a local equivalent.
- **ebfb `depcheck`:** no local equivalent.
- **minion.town `test`:** `claude-harness:check`.

A static extraction of `run:` lines from YAML caught all of these. I used about 20 lines of Python, with no `act` and no Docker. That suggests the parity audit the directive describes needs only a YAML reader that understands `parallel:` and `$/`, which `act`'s parser does not.

## 4. Cost data

| Item | Measured |
| --- | --- |
| `act` binary | 8.2 MB download, 21 MB on disk, static |
| `catthehacker/ubuntu:act-latest` / `act-24.04` (medium, container mode) | **0.58 GB compressed**, 6 layers (ghcr manifest, amd64) |
| `catthehacker/ubuntu:full-latest` (large) | **18.97 GB compressed**, 18 layers |
| Host-mode per-run workspace copy | ~1 GB per minion.town run, never pruned (3.9 GB after 4 runs) |
| minion.town `test`, host-mode act | 29 s wall warm vs CI median 2.3 m (the cold first run was not wall-timed; its Endo-daemon checkout step alone took 15 s and the install step 6 s) |
| ebfb `ci-changes`, host-mode act | 80 s wall cold (19 s Python tool-cache fetch, 40 s selector) vs CI median 0.3 m |
| ebfb full-change CI per push | about 208 Linux + 82 macOS runner-min, free (public); critical path about 26–28 m |
| minion.town CI per push | about 8 runner-min, billed (private); moving to a self-hosted runner (#145) |
| Host | 32 cores, 125 GB RAM, 2.0 TB free on `/` |

I did not time a container-mode run, because no container runtime was available. I did not time an ebfb `lint` or `test` under act, because `ci.yml` does not parse; `local-verify` already runs those commands natively, and the CI medians above are the comparison point.

## Unanswered or unverified

- **Host-side Docker and Podman details.** I could not inspect them from inside the container, and host probing is out of bounds for a gardener.
- **Whether rootless Podman works in this container.** The prerequisites are present, but I installed nothing (§1).
- **Container-mode act timing.** It was not measurable.

## Cleanup

The research created `~/.cache/act` (3.9 GB) and the scratch dir `scratch/act-research/`, holding the `act` binary, logs, and the workflow snapshots. I deleted both after writing this note. To reproduce, use the commands above.
