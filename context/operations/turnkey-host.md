# Turnkey Amazon garden host — bake, launch, and first entry

Command-level procedure for the one-click EC2 garden host: how to bake the private
AMI, publish the launch template, launch an instance, and complete first-run entry.
The *why* is [`designs/turnkey-garden-host.md`](../../designs/turnkey-garden-host.md);
credential mechanics are [`skills/aws-administration`](../../skills/aws-administration/SKILL.md).
The scripts live under `scripts/aws/turnkey/` and are **host-administration
scripts** — run them from a shell holding the `garden-fleet` credential, not off the
job board.

The whole point: **no Claude subscription credential, GitHub token, or user secret
ever enters the AMI, launch template, repository, or user-data.** The operator
supplies those interactively, after launch, over an SSM-tunnelled ssh CLI.

## What gets created (us-west-1, account 292378781985, tag `project=garden-turnkey`)

| Resource | Name | Notes |
| --- | --- | --- |
| IAM role + instance profile | `garden-turnkey-ssm` | `AmazonSSMManagedInstanceCore` only (least privilege) |
| Security group (launch) | `garden-turnkey` | **no inbound**, egress default |
| Security group (smoke test) | `garden-turnkey-test` | separate blast radius for test launches |
| AMI | `garden-turnkey-<commit>-<ts>` | private, ARM64, encrypted-gp3-backed snapshot |
| Launch template | `garden-turnkey` | encrypted gp3, IMDSv2 required, no user-data, no key pair |

## Bake a new AMI

```sh
export PATH="$HOME/.local/bin:$PATH"            # aws CLI (skills/aws-administration)
scripts/aws/turnkey/build-ami.sh                # bakes the current main2 tip
# or pin a reviewed revision explicitly (FULL 40-char sha):
scripts/aws/turnkey/build-ami.sh --commit <sha>
```

The bake launches a Graviton builder (`m7g.xlarge`) from the pinned Canonical
Ubuntu 24.04 ARM64 base, provisions it over SSM (Docker CE + buildx, a reviewed
`main2` checkout at `/home/ubuntu/garden`, and `./garden build` so the container
image is baked in), **scrubs every credential/identity artifact**, stops the
builder, and `CreateImage`s a private AMI tagged with `garden:source-commit`,
`garden:base-ami`, `garden:architecture`, and `garden:build-timestamp`. The builder
is terminated on exit. The last stdout line is the AMI id; resource ids are also
written to `scripts/aws/turnkey/.last-bake.env`.

The scrub is a **hard gate**: if any residual Claude/GitHub/AWS credential is found,
the bake fails rather than imaging a dirty host. It is defence in depth — the bake
never logs in to anything, so there should be nothing to find.

## Publish / update the launch template

```sh
scripts/aws/turnkey/create-launch-template.sh          # uses .last-bake.env AMI
scripts/aws/turnkey/create-launch-template.sh --ami <ami-id>
```

Immutable AMIs mean a new build is a **new launch-template version** (set default),
never an in-place patch. Rebuild on every garden release or security-base update.

## Smoke test (credential-free)

```sh
scripts/aws/turnkey/smoke-test.sh                      # uses .last-bake.env AMI
```

Launches a throwaway instance in the **separate** `garden-turnkey-test` SG and
proves the three properties the design requires, then terminates it:

1. the instance reaches SSM (the operator's secret-free entry path works);
2. `./garden create` starts the container from the **prebuilt** image;
3. the host has **no pre-existing** Claude or GitHub authentication.

## Launch a real host

Launch from the template (console "Launch instance from template", or CLI):

```sh
aws ec2 run-instances --launch-template LaunchTemplateName=garden-turnkey \
  --region us-west-1
```

No key pair, no user-data, no open port. The operator reaches it over SSM.

## First entry and device-auth (the operator's ssh CLI)

Two secret-free ways in; both keep port 22 closed to the internet.

- **Session Manager (simplest):**
  ```sh
  aws ssm start-session --target <instance-id> --region us-west-1
  ```
- **A real `ssh` over SSM** (add to `~/.ssh/config`, then `ssh ubuntu@<instance-id>`):
  ```
  host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h \
      --document-name AWS-StartSSHSession --parameters portNumber=%p --region us-west-1"
  ```
  Push your key at connect time with `aws ec2-instance-connect send-ssh-public-key`
  (an operator-side IAM permission), or open a scoped inbound-22 rule to your own
  CIDR: `scripts/aws/turnkey/ensure-security-group.sh --open-ssh <your-cidr>`
  and launch with your own key pair (the public key is not a secret).

Once you have the shell:

```sh
cd ~/garden
./garden                 # execs Claude Code; complete the device-login in your browser
```

- **Claude:** `./garden` runs the device-auth flow — open the printed URL in your own
  browser, sign in, paste the code back. (An API-key user exports `ANTHROPIC_API_KEY`
  on the host instead.) The subscription login is deliberately interactive; it is
  never delivered as a secret.
- **GitHub (bot):** either `gh auth login` interactively, **or** the opt-in scoped
  Secrets Manager PAT path — create the PAT secret out of band, bake/launch with
  `ensure-instance-profile.sh --with-secret <arn>`, and read it once into `gh` on the
  host. The secret *name* is configuration; the *value* never enters the image.

Then the first-run tour verifies the bot identity and **asks before starting the
fleet.** The AMI does **not** auto-enable workers, arm watchers, or make the host
leader — those are deliberate garden-level choices, and a second host must not
duplicate a leader's singleton services (see
[leader-follower.md](leader-follower.md)).

## Cost, retention, teardown

- **Bake cost:** a builder `m7g.xlarge` for the bake (~$0.16/hr, well under an hour)
  plus a `t4g.medium` smoke instance for a few minutes — cents.
- **Ongoing:** the private AMI's snapshot (~$0.05/GB-month for the gp3 snapshot of a
  ~10–15 GiB image ≈ under $1/month). No instance runs unless you launch one.
- **Teardown:**
  ```sh
  scripts/aws/turnkey/teardown.sh            # terminate transient builder/smoke instances
  scripts/aws/turnkey/teardown.sh --ami <id> # also deregister an AMI + delete its snapshots
  scripts/aws/turnkey/teardown.sh --all      # last-bake AMI + launch template + SGs + role
  ```

## Marketplace (deferred, maintainer-only)

Publication is a later distribution choice, not the security boundary. It adds
seller enrollment, product/version review, terms, regional copying, and a support
commitment, and must consume the same tested AMI artifact rather than fork the
build. It stays a maintainer-only decision; the first release is private.
