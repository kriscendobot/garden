---
created: 2026-07-14
updated: 2026-07-30
author: gardener (job issue-kriskowal-garden-44), gardener (issue #44 comment 5136303236)
---

# Turnkey Amazon garden host

| Created | 2026-07-14 |
| Author | gardener (issue `#44`) |
| Status | Implemented (first release) — see § Implementation |

Offer a one-click EC2 launch for a garden host without putting a Claude
subscription credential, a GitHub token, or any other user secret in an AMI,
launch template, repository, or instance user-data. The first release is a
private AMI plus a launch template in the garden AWS account. An AWS Marketplace
listing is a later distribution choice, not the security boundary or a
prerequisite for a useful host.

## Product shape

The button launches an ARM64 Ubuntu instance with Docker, the garden checkout,
and its container image already built. It also attaches an instance profile
that permits SSM access and, only if the operator chooses the GitHub-PAT delivery
path, read access to one named Secrets Manager secret. No inbound port is open at
launch. The launch template supplies the security group, encrypted gp3 volume,
IMDSv2 requirement, and tags. It does not supply credentials.

The operator reaches an interactive **ssh/shell CLI over SSM** — either
`aws ssm start-session` (Session Manager) or a real `ssh` tunnelled through the
`AWS-StartSSHSession` document — so the same terminal the device-auth workflow
needs is available with **no world-open port 22**. "SSH stays closed" is preserved
in its real sense (no inbound SSH exposed to the internet), while the operator
still has the ssh CLI the maintainer asked for. An operator who wants a *direct*
`ssh` may opt into a single inbound-22 rule scoped to their own CIDR, using their
own key (a public key is not a secret and never enters the AMI). This reconciles
the review note "use the ordinary Claude device-auth workflow from the operator's
ssh CLI" with the original "SSH stays closed": the port stays closed; the CLI
arrives over SSM.

At first interactive entry, over that SSM-tunnelled CLI, the operator completes
the same device-login flow as `./garden` on any fresh host. A Claude subscription
login is deliberately interactive: it is an account session, not bootstrap material
that the garden can safely receive, serialize, or replay — so it is **not** placed
in a secret store, an AMI, the launch template, the repository, or user-data. This
answers the review note about "a secret store on AWS … to submit credentials
sufficient for his AMI to authenticate itself": for the Claude subscription the
answer is device-auth, not a secret. A user who instead uses an API key enters it
directly on the host at that time. The secret-store idea survives only as the
optional, scoped **GitHub-PAT** path below (a secret *name*, not a *value*, is
launch configuration).

A bot GitHub credential has two supported paths:

1. The operator completes `gh auth login` interactively on the host.
2. The operator creates a narrowly scoped fine-grained PAT in Secrets Manager
   and launches with an instance profile restricted to that one secret. The
   bootstrap reads it once into the bot's local `gh` credential store, then
   removes its temporary file. The secret name, not its value, is launch
   configuration.

The existing first-run tour then verifies the bot identity and asks before
starting the fleet. The AMI must not auto-enable workers, arm watchers, or make
the newly launched host leader. Those are garden-level choices and a second host
must not accidentally duplicate a leader's singleton services.

## Build and release path

An image build pipeline should start from the pinned Ubuntu ARM64 base already
used for the current EC2 host, install Docker and the dependencies needed by
`./garden`, clone a reviewed `main2` revision, and build the garden container.
It must scrub package caches, machine identity, shell history, Docker
credentials, and every home-directory credential before `CreateImage`.

The pipeline publishes these immutable outputs together:

- an AMI tagged with its source garden commit, Ubuntu base AMI, architecture,
  and build timestamp;
- a versioned launch template that names that AMI and the least-privilege SSM
  instance profile;
- a small smoke result showing that the instance reaches SSM, `./garden create`
  starts the container, and the host has no pre-existing Claude or GitHub
  authentication.

Promotion begins private, with an explicit test launch in a separate security
group. Rebuild on every garden release or security-base update; do not patch an
old AMI in place. Marketplace publication comes only after that loop is stable:
it adds seller enrollment, product support, version review, terms, regional
copying, and an end-user support commitment. It should consume the same tested
AMI artifact rather than fork the build.

## Why a sparsecap is not an input yet

The issue proposes supplying a Claude subscription sparsecap. The garden has no
specified capability format, verifier, revocation rule, scope, or secure
handoff for such a value. Treating an opaque string as an auth token would turn
the image launcher into a credential-ingestion service without a security
model. This proposal therefore does not accept it. A future capability-based
login needs a separate design that specifies issuer, audience, expiry,
attenuation, revocation, and local storage before it is connected to launch.

The review note here — "use the ordinary Claude device-auth workflow from the
operator's ssh CLI" — is exactly the resolution the first release adopts: no
sparsecap, no secret handoff, just the interactive device-login over the
SSM-tunnelled ssh CLI described in § Product shape.

## Decisions (resolved for the first release)

1. **ARM64 Ubuntu, private AMI + launch template** — confirmed. Base pinned to the
   same Canonical image the existing EC2 host uses,
   `ami-0b9023009667261d9` (`ubuntu-noble-24.04-arm64-server-20260626`).
2. **GitHub login: interactive `gh auth login` is the default**; the scoped
   Secrets Manager PAT path stays available as an opt-in
   (`ensure-instance-profile.sh --with-secret <arn>`) but is off by default.
3. **Account `292378781985`, region `us-west-1`** (the garden's one account, per
   `skills/aws-administration`). Marketplace seller enrollment is deferred and
   remains a maintainer-only decision; the first release is private.

## Implementation

The bounded first release lives in `scripts/aws/turnkey/` (host-administration
scripts, not fleet jobs — run from a shell holding the `garden-fleet` credential;
see `skills/aws-administration`). Operator runbook:
[`context/operations/turnkey-host.md`](../context/operations/turnkey-host.md).

| Piece | Script | Resolved default |
| --- | --- | --- |
| Least-privilege SSM instance profile | `ensure-instance-profile.sh` | role/profile `garden-turnkey-ssm`, `AmazonSSMManagedInstanceCore` only |
| SSM-only security groups (launch + separate test) | `ensure-security-group.sh` [`--test`] | `garden-turnkey` / `garden-turnkey-test`, **no inbound**, egress default; `--open-ssh <cidr>` opt-in |
| Bake pipeline (base → Docker+buildx → reviewed `main2` checkout → prebuilt container → scrub → private `CreateImage`) | `build-ami.sh` | builder `m7g.xlarge`, encrypted gp3, IMDSv2 required |
| On-builder provisioner / credential scrub | `provision.sh` / `scrub.sh` | scrub fails the bake if any residual credential is found |
| Encrypted-gp3 / IMDSv2 launch template | `create-launch-template.sh` | `garden-turnkey`, no user-data, no key pair |
| Credential-free smoke test | `smoke-test.sh` | separate test SG; proves SSM-reachable + `./garden create` starts the prebuilt container + no pre-existing Claude/GitHub auth |
| Teardown | `teardown.sh` | terminates transient instances; `--all` reaps AMI/LT/SG/role |

**Immutable AMI metadata.** Each AMI carries `garden:source-commit`,
`garden:base-ami`, `garden:architecture`, and `garden:build-timestamp` tags; a new
build is a new AMI + new launch-template version, never an in-place patch.

**Safe defaults recorded.** No secret in the AMI/launch-template/repo/user-data;
scrub is defence-in-depth *and* a hard gate; the AMI is never shared public here;
promotion begins with the separate-SG test launch above.

**Known follow-up (Graviton + the shared Dockerfile).** The garden `Dockerfile`
fetches an **amd64** Ollama ROCm bundle unconditionally (it targets the maintainer's
AMD host). On a Graviton/ARM64 turnkey host there is no AMD GPU, so that overlay is
inert dead weight (the arm64 `ollama` binary from the installer is what runs, CPU
only). The turnkey image should skip the GPU overlay on non-amd64 to shrink the
bake; tracked as a Dockerfile arch-guard follow-up rather than folded into this
release, since it touches every host's build.

## Alternatives considered (distribution widget)

The question arose on the issue ([#44](https://github.com/kriscendobot/garden/issues/44)) of whether
an AMI is the right delivery "widget" — vs a Docker Compose file, Kubernetes, a
Terraform module, or Google Cloud Run. The analysis below grounds each in what the
garden actually needs a host to run, then states where each lands.

### What the garden needs on a host

The garden is not a stateless request handler. `./garden` launches a **containerized
systemd** host (`Dockerfile`: systemd as PID 1, privileged, `--cgroupns=host`,
tmpfs `/run` and `/tmp`, `STOPSIGNAL SIGRTMIN+3`). Inside that container run many
long-lived **user-mode systemd units** — `garden-gardener@N`, the repo watchers,
the reaper, the comment/CI/dependabot watchers, the scheduler, the bulletin, the
scaler, the mentor — each a timer or service managed with `systemctl --user`. A
host also holds long-lived git state: per-job worktrees under `$GARDEN_SCRATCH`, a
journal worktree on `journal2`, bare fork clones under `worktrees/`, and the bot's
`gh`/ssh credentials in the bind-mounted home. Workers contribute local inference
(an Ollama or OpenAI-compatible endpoint) and are pinned to capability tiers.

So the distribution widget must deliver: a long-lived single-tenant host that runs
systemd, holds persistent on-disk git state, runs background timers indefinitely,
and accepts an interactive first-entry device-auth flow. None of those are
request-scaled.

### AMI + launch template (chosen)

A private AMI bundles the OS, Docker, the reviewed garden checkout, and the
prebuilt container image as one immutable, smoke-tested artifact. The launch
template fixes the security posture (no inbound, SSM-only, encrypted gp3, IMDSv2)
so a one-click launch is safe by construction. The operator enters over SSM and
completes the interactive device-auth once. This is the closest thing to "push a
button and get a garden host" that does not put a credential in the artifact.
Rebuild on every release; a new build is a new AMI + new launch-template version.

### Docker Compose file

A `compose.yaml` can express the one container and is attractive for a contributor
who already runs Docker. But the garden's launcher (`scripts/garden`, the `create`
subcommand) already **is** a thin `docker run -d … --privileged --cgroupns=host`
wrapper around the same container; a compose file would re-express exactly that and
add a second source of truth for the privileged/systemd flags that must not drift.
Compose does not solve distribution of the container *image* (it still needs a
registry or a per-host `docker build`), it does not provide the launch posture
(SSM, no-inbound SG, IMDSv2), and it does not provide the interactive entry path.
A compose file is a reasonable **local developer** convenience on top of an
existing Docker host — `./garden` already covers that — but it is not a one-click
*host* delivery and adds a drift surface for the systemd-in-container flags. Not
chosen as the distribution widget; the launcher remains the single wrapper.

### Kubernetes

A garden host is a single-tenant, stateful, systemd-inside-a-container workload
with persistent on-disk git state and long-lived background timers. That is the
opposite of the horizontally-scaled, request-routed, ephemeral-pod workload
Kubernetes is built to schedule. Running it on k8s would mean one StatefulSet pod
per host with a PersistentVolume for the git/journal/worktree state, a
privileged/security-context-escaped container (systemd needs `--privileged`,
`--cgroupns=host`, writable cgroup — the k8s equivalent fights the pod security
model), and you would still enter the pod's shell interactively to do device-auth.
You gain the k8s control plane and lose the simplicity of one EC2 host with SSM,
for a workload that does not want to be scaled or restarted-on-liveness-probe. k8s
is the wrong shape; the AMI keeps the single-host model explicit.

### Terraform

Terraform is not an alternative *widget* — it is an alternative *provisioning
language* for the same AWS resources. The turnkey scripts (`scripts/aws/turnkey/`)
already create the IAM role/profile, security groups, AMI, and launch template as
shell; rewriting that in Terraform would express the same resources declaratively
and add `terraform apply` as the "button." That is a real ergonomics win for an
operator who lives in Terraform, and it is **complementary, not exclusive**: a
Terraform module that wraps the AMI id + launch template (the outputs of the bake)
would be a good later addition, consuming the same tested artifact. It does not
replace the AMI as the artifact that carries the OS/Docker/checkout/image, and it
does not change the host model. Tracked as a possible follow-up, not a fork.

### Google Cloud Run

Cloud Run runs stateless request-scaled containers that cold-start to zero and have
no persistent local disk, no background timers, no systemd, and a request-timeout
ceiling. A garden host is the opposite on every axis: it is a long-lived,
stateful, timer-driven, single-tenant host that must stay up to run its watchers
and workers and must hold git state on disk. There is no inbound HTTP request to
scale on — the workload is the timers and the job board pollers. Cloud Run would
force the garden into a request-handler shape it does not have, and it would
externalize all the persistent git state the host keeps locally. Not a fit for the
host; it could host an unrelated *frontend* one day, but not the garden fleet node.

### Summary

The garden needs a long-lived, stateful, systemd-running single-tenant host with
persistent git state and background timers, plus an interactive first-entry
device-auth. Of the candidates, only an AMI + launch template delivers that as a
one-click artifact with a safe-by-construction launch posture and no credential in
the image. Docker Compose and Terraform are **complementary** (a local-dev wrapper
and a declarative provisioning layer respectively) and could be added later
without forking the artifact; Kubernetes and Cloud Run are the **wrong shape**
because they assume horizontal/request-scaled stateless workloads. The first
release stays AMI + launch template; a Terraform module wrapping the baked AMI is
the most natural follow-up if an operator wants `terraform apply` as the button.
