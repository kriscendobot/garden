---
created: 2026-07-14
updated: 2026-07-14
author: gardener (job issue-kriskowal-garden-44)
---

# Turnkey Amazon garden host

| Created | 2026-07-14 |
| Author | gardener (issue `#44`) |
| Status | Proposed |

Offer a one-click EC2 launch for a garden host without putting a Claude
subscription credential, a GitHub token, or any other user secret in an AMI,
launch template, repository, or instance user-data. The first release is a
private AMI plus a launch template in the garden AWS account. An AWS Marketplace
listing is a later distribution choice, not the security boundary or a
prerequisite for a useful host.

## Product shape

The button launches an ARM64 Ubuntu instance with Docker, the garden checkout,
and its container image already built. It also attaches an instance profile
that permits SSM access and, only if the operator chooses secret delivery, read
access to one named Secrets Manager secret. SSH stays closed. The launch
template supplies the security group, encrypted gp3 volume, IMDSv2 requirement,
and tags. It does not supply credentials.

At first interactive entry, the operator completes the same device-login flow
as `./garden` on any fresh host. A Claude subscription login is deliberately
interactive: it is an account session, not bootstrap material that the garden
can safely receive, serialize, or replay. A user who instead uses an API key
enters it directly on the host at that time.

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

## Decisions needed before implementation

1. Confirm ARM64 Ubuntu and the initial private-AMI, launch-template scope.
2. Choose interactive GitHub login or the Secrets Manager PAT path for the
   first usable release.
3. Name the AWS account and region that own the artifact, and the operator who
   owns Marketplace seller enrollment if public distribution remains desired.

With those decisions, the implementation is a bounded build job: image recipe,
least-privilege instance profile, launch template, credential-free smoke test,
and a documented operator launch URL.
