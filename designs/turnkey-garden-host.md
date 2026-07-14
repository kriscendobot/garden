---
created: 2026-07-14
updated: 2026-07-14
author: gardener (job issue-kriskowal-garden-44)
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
