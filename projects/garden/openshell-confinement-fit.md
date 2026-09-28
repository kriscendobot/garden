# NVIDIA OpenShell as a garden confinement and secret-masking layer

> Abstract: OpenShell is a young Apache-2.0 sandbox control plane that combines an unprivileged workload, Landlock, seccomp user notification, an outer no-network fence, a trusted companion supervisor, L7 egress policy, and endpoint-bound credential rewriting. It is unusually close to the garden's missing secret-masking layer: an agent can receive an opaque placeholder and cause an approved HTTPS request to be authenticated without learning the credential. It is not a drop-in replacement for the garden container, and it does not yet solve the garden's two subscription-auth cases equally. The best next move is a one-host, rootless-Podman pilot alongside the existing container, first brokering a throwaway GitHub token and AWS SigV4, while keeping the ferry and all real maintainer credentials outside the experiment.

## Scope and evidence

This assessment is against NVIDIA/OpenShell commit `1358941b818d4126a7374aaf5216d87fc960e122` (2026-09-28), release `v0.1.2`, and the garden at the job's 2026-09-28 checkout. The OpenShell README was classified `proceed_with_caveat` because product framing is mixed with technical claims; its architecture, sandbox, security-policy, gateway, limits, license, security, and provider documents classified `proceed`. The analysis below treats implementation and architecture documents as stronger evidence than the README's product claims. OpenShell was inspected read-only and was not installed or run.

## 1. What OpenShell is, and where the boundary sits

OpenShell is a gateway plus compute-driver system for creating and governing agent sandboxes. The ordinary Linux placement is a pair:

- an `openshell-sandbox` workload container runs the agent as one immutable non-root UID with zero capabilities and `no_new_privs`;
- a separate trusted `openshell-supervisor` companion owns policy, gateway identity, provider credentials, TLS interception, DNS/TCP mediation, and upstream connections.

The workload receives no usable external network interface. Docker uses `network_mode=none`, Podman uses `--network=none`, a VM has no guest NIC, and Kubernetes relies on a selecting default-deny `NetworkPolicy`. A seccomp user-notification broker virtualizes supported INET socket operations and attributes them to the calling executable. The supervisor then applies destination, port, binary-identity, SSRF, TLS, and optional HTTP/REST/GraphQL/JSON-RPC/MCP rules before it opens the upstream connection. Unsupported or missed paths meet the independent outer fence.

The other main primitives are:

- **Filesystem:** a mandatory Landlock ABI v3 baseline hides `/.openshell` control material and a policy can separately allow read-only or read-write paths. User mounts cannot cover the workspace or control tree. Docker bind mounts are disabled by default; enabling them requires an operator opt-in and disabling label admission, so sandbox-owned volumes or upload/export are the safer garden shape.
- **Process:** fixed non-root identity, all capabilities dropped, `no_new_privs`, runtime seccomp plus the nested notification filter, PID limits, bounded output queues, and recursive process ownership. OpenShell does not create a finer in-process capability boundary within `claude`, `codex`, Node, or their descendants.
- **Network:** default deny, process/binary-aware mediation, DNS answer pinning and SSRF checks, optional TLS termination and L7 method/path rules, generation-pinned relays that close on policy change, and bounded parsers/caches. General UDP is unsupported in the current Podman path.
- **Credentials:** gateway or external credential drivers store secrets. The supervisor gives the workload opaque environment placeholders and replaces them only in policy-admitted requests for the bound host, port, and path. It can also mint/refresh short-lived OAuth credentials, perform dynamic OAuth token grants, and re-sign AWS requests with SigV4.
- **Policy review:** a prover reports categorical expansion risks such as new credentialed reach, new HTTP methods, L7 bypass, or link-local reach. This is useful change review, not a proof that the Rust implementation, kernel, container runtime, or policy authoring is free of defects.

The trusted computing base is therefore the host kernel, container/VM/Kubernetes runtime and its enforcement configuration, OpenShell gateway, compute driver, supervisor, credential driver/database, TLS-interception key, and operator-authored policy. A host-root or Docker-daemon compromise defeats the boundary. In the Docker driver the companion deliberately has host networking and real credentials, so a supervisor escape is a host-side credential and network compromise. Kubernetes additionally assumes the CNI really enforces `NetworkPolicy`. Rootless Podman removes a rootful daemon from this trust base, but it does not turn a shared-kernel sandbox into a VM.

## 2. Secret masking, by garden secret class

OpenShell's central value is **non-disclosure, not non-exercise**. Printing a placeholder does not reveal the credential, and sending it to the wrong endpoint fails. A compromised agent can still exercise every operation the endpoint and L7 policy permit, consume quota, and attempt writes. Method/path restrictions, separate providers, and host-side operation brokers remain necessary where the authority itself is too broad.

| Garden secret | What OpenShell can do | Garden-specific conclusion |
| --- | --- | --- |
| Anthropic subscription OAuth (`~/.claude/.credentials.json`) | The shipped `claude-code` profile supports `ANTHROPIC_API_KEY`/`CLAUDE_API_KEY` header injection. The provider guide explicitly says the Anthropic credential is a Console API key, not a subscription token. | **Not solved for the garden's subscription login.** Mounting `.credentials.json` reveals it. Switching monks to an API key would enable masking but changes billing and account semantics. A custom gateway refresh adapter would need a supported Claude access-token input and an authorized token-refresh contract; OpenShell does not ship one. Keep this file out of any pilot sandbox. |
| OpenAI/Codex subscription OAuth (Codex auth under shared home) | The public `codex` example declares access, refresh, ID token, and account fields for the CLI, but does not mark them for header rewriting, so it is an endpoint allowlist more than secret masking. An internal `codex-gator` example is materially better: the gateway stores the refresh token, refreshes at `auth.openai.com`, and exposes only an endpoint-bound access-token placeholder plus account ID. | **Plausible, not ready to trust blindly.** Import an adapted `codex-gator` profile and verify the installed Codex version accepts `CODEX_AUTH_ACCESS_TOKEN` without reading or rewriting its normal auth file. The raw refresh token should remain gateway-side. Do not mount Codex's auth directory. Token rotation, account selection, logout, and resume all need live compatibility tests. |
| GitHub bot token | The `github` profile supplies a bearer placeholder to `gh` and Git HTTPS, bound to `api.github.com` and `github.com`. Its default policy permits API reads plus clone/fetch and denies `git-receive-pack`. | **Good pilot candidate.** Change the fleet `gh` wrapper from `gh auth token --user kriscendobot` (which reads and exports the raw token) to a fixed placeholder in `GH_TOKEN`; pin identity by the attached provider, then verify `/user` still returns `kriscendobot`. Writes need explicit REST/GraphQL method/path rules. HTTPS pushes need an explicit `git-receive-pack` grant. The present bot SSH private key is not brokered by OpenShell and must not be mounted. |
| GitHub bot SSH key | OpenShell mediates TCP and has an SSH service for entering a sandbox, but it does not offer an outbound SSH signing-agent provider equivalent to HTTP header rewriting. | **Not masked.** Convert GitHub remotes to HTTPS with the brokered bot token, or keep commit/push outside the sandbox behind a narrow host service. Mounting the private key or `SSH_AUTH_SOCK` recreates today's exposure. |
| AWS and SSM | A gateway can assume a role, rotate STS credentials, give the workload placeholders, and proxy-side re-sign admitted AWS HTTPS requests with SigV4. Long-lived source credentials or ambient gateway role stay outside the workload. | **Strong fit, with protocol tests.** Bind exact AWS service/region hosts and IAM roles. Test `aws ssm` and the Session Manager plugin specifically: websocket/session flows and unsupported chunk-signed streaming may not match ordinary REST/SigV4 behavior. Block EC2 metadata/link-local access; prefer gateway ambient role or STS over the current shared `~/.aws/credentials` hard links. |
| Garden journal/main2 push key | Same limitation as the GitHub SSH key. HTTPS git can use a token placeholder, but allowing `git-receive-pack` lets the agent exercise whatever ref writes the GitHub token permits. | **Masking is possible; attenuation needs a host broker.** The smallest conversion is exact-repository HTTPS plus brokered bot token. The safer end state keeps `land-journal-edit.sh`, completion, and `HEAD:main2` CAS pushes in the trusted host control plane, accepting only a patch/commit plus exact allowed ref and expected old SHA from the sandbox. That preserves journal CAS and prevents a masked-but-broad token from becoming arbitrary ref authority. |
| Maintainer ferry credentials | OpenShell could technically store credentials, but attaching them would let the workload exercise them within policy. | **Do not attach them.** The existing host-native, maintainer-started ferry is already a stronger separation. Keep ferry execution, human `gh` state, and upstream SSH material outside the gateway and every agent sandbox. |

OAuth refresh deserves one explicit distinction. OpenShell has generic gateway-side `oauth2_refresh_token` support: refresh token and client secret live in its credential driver, while a stable opaque handle in an already-running process resolves to the current short-lived token on each request. That is the desired pattern. It only helps a particular CLI when the provider's OAuth contract is supported and the CLI can operate on the placeholder access token without insisting on its own refresh-token file. The Codex gator example suggests that seam exists; the shipped Claude profile says it does not for Anthropic subscription login.

## 3. Fit with `gardener.sh`, handlers, worktrees, and hosts

A `claude -p` or `codex exec` process can run as the canonical command in an OpenShell sandbox. The hard part is not launching it; it is moving today's host-shaped state into an explicit per-job boundary.

Today `garden` bind-mounts the whole checkout as the bot's home. That exposes `.claude/.credentials.json`, Codex auth, `.config/gh`, `.ssh`, `.aws`, every worker's state, and every peer worktree to every handler. The hardening probe usefully removes privilege escalation, block devices, human GitHub accounts, and SSH-agent forwarding, but it does not stop same-UID reads of that bind-mounted home. `GIT_CEILING_DIRECTORIES` and the root-repo guard prevent or repair particular git mistakes; they are not filesystem secrecy boundaries.

The recommended OpenShell integration keeps `gardener.sh` as the trusted claiming/completion spine and replaces only the handler execution edge:

1. `gardener.sh` claims a job and creates or reopens one sandbox keyed by the job base.
2. A revised `monk-claude.sh` / `cleric-codex.sh` creates a sandbox from a pinned image, attaches only that worker's model provider and the job's explicitly required providers, uploads the job body and role material, and runs `claude -p` or `codex exec` through OpenShell exec.
3. The handler captures the completion report and exported work product, while the existing timeout, process-tree reap, usage accounting, completion sentinel, and requeue logic remain outside the sandbox.
4. Completion deletes the sandbox/volume. Same-host requeue reuses its sandbox ID; cross-host requeue remains a fresh start unless state is deliberately exported.

The current git worktree cannot simply be bind-mounted by itself. Its `.git` file points back into the shared garden repository's worktree administration and object store. Mounting those paths read-write would re-expose the root repository that per-job worktrees and the root guard are designed to protect. There are three viable shapes, in decreasing isolation:

- **Preferred:** a sandbox-owned per-job clone/volume. Clone/fetch through brokered HTTPS, work and commit inside it, then export a patch or commit bundle to a trusted host lander that performs the CAS push.
- **Transitional:** copy the already-isolated job/project worktree contents into a sandbox volume, excluding host credential/config trees and rewriting git metadata, then copy only the diff/result back.
- **High-risk compatibility mode:** explicitly mount the per-job worktree plus all referenced git administrative paths and constrain them with Landlock. This preserves more scripts but makes the shared object store part of the agent's write surface and should not be the pilot.

`ensure-project-worktree.sh` would similarly become either a sandbox-volume clone factory or a host-side copy-in/export-out adapter. The durable invariant remains one job base to one mutable checkout. The existing `GIT_CEILING_DIRECTORIES` can stay as defense in depth, but a sandbox with only its own clone cannot discover the deployed root in the first place. The host root-repo guard remains necessary for the trusted control plane.

### Rootless, systemd, `/tmp`, and multi-host

- **Rootless:** use OpenShell's supported rootless Podman driver for the first Linux host. Do not give the current garden container a Docker/Podman socket; that would hand an agent-adjacent container daemon authority over the host. Docker-backed OpenShell is still useful later, but it is Docker-based layering, not a replacement for Docker.
- **systemd user services and linger:** run the rootless Podman service and OpenShell gateway as host user units with linger, separate from the garden's current user manager inside its Docker container. Add explicit `After=`/health gating to any host-side OpenShell handler bridge. Preserve one gateway and one credential set per host rather than centralizing all subscriptions.
- **`/tmp` noexec:** install OpenShell and runtime binaries under a user-owned executable prefix and put persistent state under an explicit `$GARDEN_STATE`/XDG data path, not `/tmp`. OpenShell's Docker driver itself mounts workload `/tmp` as `noexec`; agent images and build tooling must execute from the workspace or image paths. The garden's AWS-host lesson already requires installers to extract under `$HOME`.
- **Multi-host:** configure and attest policy/provider profiles per host. This matches the garden's real subscription topology and limits a credential-driver compromise to one host. Record sandbox ownership with the job claim so a reaper does not assume another host can resume it. A shared gateway would couple availability, widen blast radius, and blur which subscription or AWS role a job is exercising.

## 4. OpenShell versus the garden's Docker container

OpenShell adds controls the current container does not have:

- per-job rather than per-host filesystem visibility;
- a default-deny outer network fence plus process-aware egress mediation;
- method/path-aware policy and endpoint-bound credential injection;
- gateway-side OAuth refresh and AWS SigV4/STS brokering;
- explicit credential, policy, sandbox, and audit objects;
- policy-expansion review and formal risk findings;
- removal of peer jobs, shared auth files, and the root checkout from an agent's namespace.

It also costs or loses things:

- the present monolithic home makes every installed tool, warm cache, systemd unit, absolute path, and worktree immediately available; per-job images/volumes require deliberate packaging and transfer;
- outbound UDP and some streaming/signing cases are unsupported;
- TLS/L7 rewriting depends on client compatibility and a trusted interception CA;
- the gateway/supervisor/credential database become critical services and a new trusted codebase;
- rootless Podman has kernel/user-namespace/AppArmor prerequisites, while Docker and Kubernetes retain their own daemons/CNI in the trust base;
- a broker hides a token but does not prevent misuse of the authority it exposes.

Therefore OpenShell should initially run **alongside** the garden container: the existing container remains the job-board/control plane, while selected handlers execute in host-side OpenShell sandboxes. Running OpenShell's Docker driver inside the current container would require nested daemon authority and conflicts with the hardening direction. Replacing the outer garden container is a later architecture choice, after worker scripts, caches, journal producers, and systemd ownership have been separated. OpenShell with its Docker driver layers on Docker; rootless Podman or its VM driver are the routes that can eventually remove Docker from the worker data plane.

`GIT_CEILING_DIRECTORIES`, the root-repo guard, per-job checkout ownership, the bot-identity invariant, and the ferry boundary all remain useful. OpenShell changes their enforcement location: the agent should no longer see the deployed root or raw bot token, while the trusted host spine continues to enforce CAS, identity, and cleanup.

## 5. Maturity, requirements, and security caveats

At the research snapshot OpenShell is Apache-2.0, about eight months old, actively maintained, and at release `v0.1.2` (published 2026-09-28). GitHub metadata showed 9,365 stars, 1,331 forks, 439 open issues, and commits on the day of the snapshot. The repository has extensive architecture documents, conformance/e2e suites, multiple drivers, a vulnerability-reporting policy, and fast release activity. Those are positive engineering signals, but `0.1.x` is still a young compatibility and security surface. The public GitHub security-advisory API returned no advisories at the snapshot; that is not evidence of an independent audit or absence of escapes.

Platform requirements relevant to the garden are Linux with Landlock ABI v3 (upstream Linux 6.2 or a passing vendor backport), nested seccomp user notification and `SECCOMP_IOCTL_NOTIF_ADDFD`, same-UID task-memory access for the broker, and Docker, rootless Podman, Kubernetes with an enforcing CNI, or the supported VM path. macOS uses a Linux VM. Windows WSL2 is described as experimental. Docker Desktop host networking is required by the Docker driver and is incompatible with Docker Desktop Enhanced Container Isolation.

Security caveats to carry into a pilot:

- the trusted supervisor holds credentials, interception authority, and host network access;
- a host/kernel/runtime escape defeats the model; shared-kernel rootless Podman is not VM isolation;
- Landlock and seccomp qualification fail closed, but policy/runtime support must be probed on every host;
- raw TCP or `tls: skip` cannot provide the same L7 credential boundary; an `allow_uninspected_credentials` escape hatch deliberately weakens safety;
- exact-host TCP policy does not necessarily distinguish virtual hosts or tenants behind shared infrastructure;
- already-forwarded requests can finish after revocation;
- ordinary static credential updates do not retarget placeholders already held by existing processes, whereas gateway-managed refresh handles do resolve the current token per request;
- local single-player Docker/Podman/VM deployments can use non-expiring launch-scoped gateway/sandbox protocol tokens (`exp = 0`), increasing the consequence of supervisor material leakage;
- legacy provider records may contain inline credentials; new deployments should start with a credential driver or encrypted database and no migrated legacy state;
- telemetry is enabled by default, although documented as aggregate-only; disable it during the pilot;
- the shipped Codex profile and the stronger internal gator profile have materially different masking properties, so profile review is security work, not configuration trivia.

No specific published sandbox escape was found in the repository or public advisory list. Treat that as “none found in this bounded review,” not “none exist.” Before production use, run OpenShell's qualification and conformance tests on the exact host kernel/runtime, inspect the release's SBOM/dependency scans, and arrange an adversarial test focused on supervisor/workload channel, placeholder exfiltration, DNS rebinding, binary identity, mount admission, and policy hot reload.

## 6. Recommendation and staged adoption

**Recommendation: adopt experimentally as a per-job secret and egress boundary alongside Docker, not as an immediate fleet-wide container replacement.** It directly addresses the garden's largest remaining confinement gap, but Anthropic subscription OAuth and git/SSH workflow compatibility prevent a clean cutover.

### Stage 0: synthetic, no-real-secret qualification

On one follower host, install a pinned `v0.1.2` (or later reviewed) build outside `/tmp`, use rootless Podman, disable telemetry, and run the upstream qualification/conformance suite. Create a sandbox image with `gh`, git, AWS CLI, Codex, and Claude paths matching policy. Use only a local fake HTTPS endpoint and fake tokens. Demonstrate that:

1. `cat`, `env`, `/proc`, crash output, child processes, and logs reveal only placeholders;
2. the fake credential appears only at the exact admitted host/path;
3. direct sockets, alternate DNS names/IPs, raw TLS, proxy variables, another binary, and a policy-reload race fail closed;
4. `/tmp` noexec, Landlock paths, PID/memory limits, process cleanup, and sandbox deletion behave as expected.

This is the smallest useful first step because it validates the masking claim and host compatibility without risking any garden credential.

### Stage 1: one narrow real secret class

Broker a short-lived, fine-grained test GitHub token for a disposable repository. Adapt the fleet `gh` wrapper to a placeholder, allow `/user`, repository reads, and clone/fetch only, and prove the identity remains the bot/test account. Then add one exact write operation and verify policy/audit denial everywhere else. In parallel, test AWS STS/SigV4 with a role restricted to a disposable bucket; defer SSM until its session transport passes compatibility tests.

Measure: raw-secret scans across sandbox files/env/proc/logs; allowed and denied request matrix; provider refresh/rotation latency; policy-reload revocation; sandbox startup time; CPU/RSS; job wall time; failure and retry rates; audit completeness; and whether any client bypasses mediation.

### Stage 2: a low-risk worker kind

Move a read-mostly scholar or diagnostic worker into an OpenShell sandbox, but keep journal landing and git pushes host-side. Give it a sandbox-owned clone or copied source tree, no shared home, and only providers its job declares. This tests `gardener.sh` lifecycle, report capture, requeue/resume, caches, and multi-host ownership without granting repository mutation from the workload.

### Stage 3: model OAuth experiments

Try the gateway-managed Codex gator pattern on one cleric account after confirming the CLI contract and rotation behavior. Do not expose the refresh token to the workload. Treat Claude subscription OAuth as blocked until Anthropic exposes a supported non-file access-token seam or OpenShell ships and documents one. An API-key-backed monk is a separate product/economics decision, not a transparent migration.

### Stage 4: narrow mutation, then reconsider the outer container

Add host-side journal/main2 landers with exact ref, old-SHA, and path attestations. Only after those prove reliable should HTTPS `git-receive-pack` be considered inside selected sandboxes. Keep the ferry permanently outside. If per-job images, caches, toolchains, and host user units are then operationally satisfactory, evaluate replacing the monolithic garden Docker container with host control services plus rootless OpenShell workers. Until then, the outer container remains a useful deployment/control-plane boundary.

## Sources

- [OpenShell README](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/README.md)
- [architecture overview](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/architecture/README.md)
- [sandbox architecture](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/architecture/sandbox.md)
- [security policy](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/architecture/security-policy.md)
- [gateway architecture and credential persistence](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/architecture/gateway.md)
- [sandbox limits](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/architecture/sandbox-limits.md)
- [support matrix](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/docs/about/support-matrix.mdx)
- [Claude Code provider profile](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/providers/claude-code.yaml), [Codex profile](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/providers/codex.yaml), [gateway-managed Codex gator profile](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/scripts/agents/gator/providers/codex-gator.yaml), [GitHub profile](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/providers/github.yaml), and [AWS profile](https://github.com/NVIDIA/OpenShell/blob/1358941b818d4126a7374aaf5216d87fc960e122/providers/aws.yaml)
- Garden grounding: `context/operations/harden-container.md`, `context/first-run/auth.md`, `designs/fleet-gh-identity.md`, `designs/root-repo-guard.md`, `designs/host-key-injection-proxy.md`, `scripts/check-container-hardening.sh`, `scripts/jobs/gardener.sh`, and its Claude/Codex handlers.
