---
created: 2026-09-30
author: gardener (job book-ch4, orchestration garden-book-orch)
grounded-on: main2 649f5cdd617
---

# Chapter 4: Creating your own instance

Chapter 1 told the garden's history as a series of metamorphoses: from a lone
shepherd session, to a container with a bot, to a supervised always-on host, to
the current shape with deterministic scripts in the middle and model calls on
either side. This chapter is the practical counterpart. It covers what you do,
command by command, to stand up a garden of your own, and why each step exists.

It is grounded in the files that define the procedure: [`CLAUDE.md`][claude-md]
§ Host environment and § Container guard, [`scripts/check-in-container.sh`][guard],
the launcher [`garden`][launcher], the first-run track in
[`context/first-run/`][first-run] (especially [`identity.md`][identity] and
[`auth.md`][auth]), the bring-up procedure
[`context/operations/starting.md`][starting], the AWS turnkey design
[`designs/turnkey-garden-host.md`][turnkey-design] and its runbook
[`context/operations/turnkey-host.md`][turnkey-runbook], and
[`README.md`][readme] § Getting started. When this chapter and those files
disagree, the files win. Where the sources themselves disagree or the design
runs ahead of what is implemented, this chapter says so.

## Contents

- [4.1 The short version](#41-the-short-version)
- [4.2 The container model](#42-the-container-model)
- [4.3 Identity](#43-identity)
- [4.4 Bot credentials](#44-bot-credentials)
- [4.5 Bring-up, step by step](#45-bring-up-step-by-step)
- [4.6 The turnkey path: a disposable AWS host](#46-the-turnkey-path-a-disposable-aws-host)
- [4.7 What "creating your own" produces](#47-what-creating-your-own-produces)
- [4.8 Known gaps and stale spots](#48-known-gaps-and-stale-spots)
- [4.9 Checklist](#49-checklist)

## 4.1 The short version

The README's "Getting started" is three steps, once per host:

1. **Clone** the garden on a machine that runs Docker, and `cd` into it.
2. **Run `./garden`.** The launcher builds the image if it is missing, creates
   or starts the container, and drops you into a Claude Code session (the
   **liaison**, the garden's human-facing agent) in auto mode.
3. **Say `help`.** The liaison runs the first-run tutorial. It checks identity,
   authenticates the bot's GitHub account, starts the garden (units, worker
   pool, leadership, its own monitors), and posts a first job. It asks before
   each consequential step and runs every command itself. Say **start the
   garden** to skip the tour and go straight to bring-up.

What you have to supply yourself, because no agent can supply it:

- **Docker** on the host.
- **A Claude subscription or an API key.**
- **A bot GitHub account you control** (the garden's own is `kriscendobot`).
  Routine work happens as the bot and never as you. Your own identity is
  reserved for the **ferry**, the separate, permissioned path that carries
  approved work upstream under the maintainer's name.

The rest of this chapter explains what happens during steps 2 and 3, so you can
tell when the liaison has done a step correctly and fix it when it hasn't.

## 4.2 The container model

### Why a container

The garden runs its fleet inside one long-lived Docker container per instance.
Inside it, systemd runs as PID 1 and manages dozens of **user-mode units**:
`garden-monk@N` and `garden-cleric@N` workers (the **gardeners** that claim jobs;
monks use Anthropic, clerics use OpenAI), the watchers, the scheduler, the
reaper, the scaler, the **sysop** (a small per-host daemon that runs host
operations sent over the message bus), and more. HISTORY.md's second stage,
"containment, a container and a bot," is where this came from: once agents act
autonomously, they need to act under a bot identity, in an environment that
cannot reach the maintainer's own credentials.

The launcher (`./garden`, a bash script at the repo root) does the following:

- **Builds a per-user image** tagged `garden-<your-user>`. The container's unix
  user is baked to match the host user running `./garden` (same login name and
  uid), so the bind-mounted directory stays writable and nothing is hardcoded to
  one maintainer's account.
- **Bind-mounts the checkout at its own host path** and relocates the bot user's
  home there (`GARDEN_HOME`, applied by the entrypoint with `usermod -d` before
  systemd starts). This is the **mirroring** model: an absolute path means the
  same file inside the container and out. Everything the bot accumulates
  (`.ssh/`, `.config/gh/`, `~/.claude/`, worktrees, the journal) lives in that
  directory and survives `./garden reset`.
- **Runs the container unprivileged.** The launcher's comments are explicit: no
  `--privileged`, no host devices, Docker's default seccomp and AppArmor
  profiles kept. It adds back one capability, `SYS_ADMIN`, because systemd as
  PID 1 needs it to mount its API filesystems and per-service sandboxes. With no
  `--device` and no `/dev` mount, there is no host block device to mount even if
  code inside becomes container-root. That matters because gardeners run code
  that may be steered by text an outsider wrote, and the host holds maintainer
  credentials the ferry uses. GPU passthrough for local inference is a
  deliberate, per-host opt-in via `GARDEN_DEVICES`, never the default.
- **Pins public DNS resolvers** (`1.1.1.1 8.8.8.8` by default, override with
  `GARDEN_DNS`), because a systemd-resolved host's loopback stub cannot be
  passed into a container. Without this, a home-network host gets a container
  that cannot resolve `api.anthropic.com`.
- **Pins `--name` and `--hostname`** to the instance identity (§ 4.3).
- **Deliberately does not forward your SSH agent**, so a human identity cannot
  leak into bot actions.

Launcher subcommands you will use: bare `./garden` (enter and exec Claude Code
as the liaison), `./garden sh` (a login shell instead, the debugging escape
hatch), `./garden codex` (Codex CLI instead of Claude Code), `./garden create`,
`./garden build`, `./garden check`, and `./garden reset` (remove the container;
the next `./garden` starts fresh, and nothing in the bind-mounted directory is
lost).

`scripts/check-container-hardening.sh` proves the posture from inside: no
effective capabilities for the bot user, `sudo -n true` fails, no host block
devices, a block-device mount fails, no maintainer (`kriskowal`) `gh` account,
no loaded human SSH identity, and `/.dockerenv` present. A container that fails
the capability, sudo, or device checks predates the hardening and must be
recreated ([`context/operations/harden-container.md`][harden]). The
`garden-container-hardening` timer re-runs the check twice a day.

### The container guard: which side am I on?

Mirroring has a downside. Because the checkout is bind-mounted at its own path,
**the files look identical whether you are inside the container or in the same
directory on the host.** It is easy to forget `./garden`, open `claude` directly
on the host, and start operating. On the host, commands run under *your*
identity rather than the bot's, the `systemctl --user` fleet is not the
garden's, and a stray `git push` can land under the wrong name.

`scripts/check-in-container.sh` is the guard. It exits 0 silently when
`/.dockerenv` exists, or when PID 1's cgroup mentions docker, containerd, or
libpod. Otherwise it prints a prominent "NOT INSIDE THE GARDEN CONTAINER"
warning and exits 1. It deliberately does **not** compare `pwd` with `$HOME`:
gardeners run in per-job worktrees (cwd is not home) yet are inside the
container, while a host shell sitting in the bind-mounted directory has cwd
equal to home yet is not.

The guard fires in three ways:

1. **Liaison preflight.** `CLAUDE.md` makes it the first thing the liaison runs
   in every session, before anything else, including answering `help`. A
   host-side `help` must get the warning and `./garden`, never a tutorial that
   would arm the wrong fleet.
2. **A SessionStart hook.** At container creation the launcher seeds
   `.claude/settings.json` (only if absent) with a SessionStart hook that runs
   the guard. The file is host-side and bind-mounted, so the hook fires on the
   host too, which is where it matters most.
3. **By hand.** Run `scripts/check-in-container.sh; echo $?` whenever you are
   unsure.

A quick manual check: inside the container, `hostname` prints the instance
identity (something like `endolin-garden2-5bcdff64`). On the host it prints the
machine's own short hostname.

## 4.3 Identity

### The `GARDEN` identity is the checkout's location

Every instance has one logical name, its **`GARDEN` shard identity**. It keys
job claims, per-host worker counts (`hosts/<host>` in the journal), journal
index entries, and the **leader marker** (the journal file naming which host
runs the singleton services). Two running instances that share a name silently
corrupt each other's per-host state.

You do not choose this name. The launcher derives it from where the checkout
lives:

```
<hostname>-<basename>-<hash8>          e.g.  endolin-garden2-5bcdff64
```

- `hostname` is the host's short hostname, lowercased and stripped to
  `[a-z0-9-]`, so instances on different hosts do not collide in the shared
  journal.
- `basename` is the checkout directory's name: the readable middle.
- `hash8` is the first 8 hex digits of the SHA-256 of the full canonical path
  (`pwd -P`). It tells apart same-named directories at different paths on one
  host.

The launcher pins this string into the container's `--name` and `--hostname`
at creation. Inside, `scripts/jobs/common.sh` resolves the identity from an
explicit per-invocation `GARDEN` override if one is given, and otherwise from
`hostname -s`. There is **no `.garden` file and no environment knob** to seed.
Because the identity is a pure function of location and is fixed at container
creation, it cannot drift away from its container. That drift used to happen,
stranding containers under names that matched no checkout.

One warning from `identity.md`: do not persist `GARDEN` in the systemd user
manager's environment. It can shadow the container's identity and split one
instance into conflicting journal shards.

### Why uniqueness matters, and the one question only you can answer

On one host, uniqueness is automatic because different paths give different
ids. Across hosts, the tiebreaker is the short hostname. So the one thing you
must guarantee by hand is that **your hosts have distinct short hostnames**. The
first-run tutorial asks you exactly this in its identity stage, and the starting
procedure refuses to continue on a collision. If two hosts must share a
hostname, give one a different hostname or use the `GARDEN_HOSTNAME` override
(below) before standing up the second.

### The multi-instance recipe

Put each instance in its own directory:

```sh
( cd ~/garden  && ./garden create )    # -> <host>-garden-<hashA>
( cd ~/garden2 && ./garden create )    # -> <host>-garden2-<hashB>
```

Each gets its own container, its own mirrored home, and its own `.ssh/` and
`.config/gh/`. Both still point at the same `origin` and so at the same
`journal2` board. That makes them *collaborating* instances in one fleet (see
§ 4.7), not independent gardens.

To **rename** an instance, move or re-clone the checkout to a new path and
re-create the container:

```sh
./garden reset          # remove the old container
# move the checkout to its new path, then:
./garden                # re-create; the new path yields the new id
```

`GARDEN_CONTAINER` and `GARDEN_HOSTNAME` remain expert overrides for the rare
case where the container name or logical id must differ from the location-derived
default.

## 4.4 Bot credentials

A fresh clone holds no credentials. [`auth.md`][auth] lists exactly three that a
working instance needs. Each has a half the liaison runs and a click only a
human can make. All three land in the bind-mounted home and survive
`./garden reset`.

### 1. Claude

The `claude` that `./garden` execs runs its own first-launch onboarding. You
pick a login method, open the printed URL in a browser **on the host** (the
container has none), and paste the code back. Alternatively, export
`ANTHROPIC_API_KEY` before the first `./garden`; the launcher forwards it at
container creation and skips the login.

The scaler's monk backend probe (`claude_auth_ok`) checks for exactly this
credential on every tick. Until it exists, the host's *effective* monk count is
held at 0 even if a positive count is declared, and it ramps up on the first
passing probe. You can therefore declare workers before finishing the login.

### 2. The bot SSH key

The bot uses its own key under `<garden-root>/.ssh/` (which is `~/.ssh/` inside
the container, and gitignored). The liaison checks for `id_ed25519`, generates
one if missing, prints the public half, and waits while you paste it into the
**bot** GitHub account's SSH keys.

### 3. The bot `gh` token: two supported paths

**Path 1: interactive `gh auth login` (the default everywhere).** Inside the
container, the liaison checks `gh auth status`. If `gh` is unauthenticated, it
runs `gh auth login` and passes you the device-flow URL and code; you authorize
in your browser. The token lands in `.config/gh/`. The liaison then verifies by
asking the fleet's `gh` wrapper who it is: it must report the bot login, not
you. The wrapper pins every call to the bot identity. The ferry sidesteps it by
running host-native, outside the container.

**Path 2: a scoped Secrets Manager PAT (opt-in, turnkey AWS hosts only).** The
operator creates a narrowly scoped fine-grained PAT, stores it in AWS Secrets
Manager, and launches with an instance profile that can read exactly that one
secret (`ensure-instance-profile.sh --with-secret <arn>` attaches an inline
`secretsmanager:GetSecretValue` policy for that single ARN). The design calls
for a bootstrap that reads the secret once into the bot's local `gh` credential
store and removes its temporary file. The secret's *name* is launch
configuration; its *value* never enters the image. See § 4.8: the IAM half of
this path is implemented, but no read-once bootstrap script exists yet.

The design is deliberate about what is **not** a secret-store input: the Claude
subscription login. It is an account session, not bootstrap material the garden
can safely receive, serialize, or replay, so it is always interactive device
auth. The design also rejects the "sparsecap" idea from issue #44, a Claude
capability string supplied at launch. The garden has no specified format,
verifier, revocation rule, or scope for such a value, and accepting one would
turn the launcher into a credential-ingestion service with no security model.

### The bot's git identity

Separate from GitHub auth is the garden repo's local git `user.name` and
`user.email`, the identity on the bot's commits. The local `.git/config` is not
tracked and not baked into the image (the bind mount hides anything the image
would put there), so a reset or fresh checkout would lose it. Instead,
`scripts/jobs/bootstrap-bot-identity.sh` rebuilds it idempotently from durable
records, in precedence order:

1. **A per-host journal override**, `identity/<host>` on `journal2`, written by
   `scripts/jobs/set-bot-identity.sh "<name>" "<email>" [host]`. It propagates
   through the journal and applies on that host's next bootstrap.
2. **A tracked canonical default**, `scripts/jobs/bot-identity-defaults.tsv`,
   keyed on `GARDEN_BOT_LOGIN` (which defaults to `kriscendobot`). The one row
   today maps `kriscendobot` to `Kriscendo Bot` /
   `279080640+kriscendobot@users.noreply.github.com`.

The bootstrap runs from the container entrypoint on every start (applying the
tracked default) and again in the starting procedure (§ 4.5, step 2) once the
journal is reachable, so a per-host override lands too. It writes only when the
config is missing or wrong. As a further safeguard, `bot_name()` and
`bot_email()` in `common.sh` fall back to the tracked default, so an unset
config still resolves to the right identity and never to a generic
`garden-bot`. If `GARDEN_BOT_LOGIN` names a login with no TSV row, the fallbacks
become the login itself and `<login>@users.noreply.github.com`.

**If your bot is not `kriscendobot`,** set a per-host override with
`set-bot-identity.sh`, or add a row to the TSV and set `GARDEN_BOT_LOGIN`.
Otherwise the default identity is Kriscendo Bot's.

## 4.5 Bring-up, step by step

[`starting.md`][starting] is written for the agent, not for you. The liaison
runs it when you say **start the garden** (or reaches it as stage 4 of the
`help` tour), asking before each consequential step and verifying after. The
contract is the same throughout the first-run track: every mutating step is
proposed in one sentence with the command shown, run by the liaison when you
say yes, and verified. Read-only probes run without asking. The steps, in order:

### Precondition: a unique identity

Covered in § 4.3. Do not continue on a cross-host hostname collision.

### Step 1: verify the user manager (linger)

```sh
loginctl show-user "$USER" -p Linger
systemctl --user is-system-running
```

Headless `systemctl --user` needs **linger**, so the user's systemd manager
stays up without a login session. The image creates the bot's linger marker, so
a normal bring-up needs no `loginctl enable-linger` and no sudo. If the marker
or user manager is missing, the fix is in the image or entrypoint, not a
restored passwordless sudo. A `degraded` manager means inspecting failed units.

### Step 2: restore the bot git identity

```sh
scripts/jobs/bootstrap-bot-identity.sh
```

Described in § 4.4. A no-op when the config is already correct.

### Step 3: install and enable the units

```sh
scripts/jobs/install-units.sh install
scripts/jobs/install-units.sh enable-services
```

This renders the templated units under `scripts/systemd/` into
`~/.config/systemd/user/` and enables them. The liaison's session preflight
treats the absence of rendered `garden-*` units there as the sign of a
**virgin** instance, which is why it offers the tour.

### Step 4: size the worker pool

```sh
scripts/jobs/set-workers.sh monk 1 "$(hostname -s)"
```

This writes the declared count to journal state (`hosts/<host>`), and the
gardener-scaler reconciles running units against it. Start small, then size
against the host's physical capacity and subscription budget
([`scaling.md`][scaling], [`cybernetics.md`][cybernetics]). The leader's budget
leveler may adjust the count later.

Two properties protect a new host from a bad declaration:

- **Monks may be declared before Claude auth.** The effective count is held at 0
  until the backend probe passes (§ 4.4), then ramps to the declared target
  without rewriting it.
- **Other kinds are refused until their backend works.** `set-workers.sh`
  refuses a positive count for `cleric` (Codex, which needs `codex login`) and
  the other API-key kinds until that kind's probe passes on this host, and names
  the missing piece. `GARDEN_FORCE_DECLARE=1` stages a declaration ahead of a
  credential, and the runtime cap still holds it at 0. Setting a kind to 0 is
  always allowed. The local-Qwen `hermit` lane is retired and pinned to 0.

### Step 5: designate the leader

```sh
scripts/jobs/set-main-host.sh "$(hostname -s)"
```

On a first or only host, this makes the host its own leader. It writes the
journal `leader` marker via a compare-and-swap push. Every host's liaison
watches that marker, so naming a host *is* raising it; there is no automatic
failover. The **singleton services** run only on the leader, gated by
`scripts/jobs/is-main-host.sh`: the foreman, the scheduler, the watchers, the
bulletin, the recovery services, and two of the liaison's monitors. None of
these tolerate duplicates (two schedulers would double-dispatch). Gardeners run
on every host and race to claim safely through the job board's push CAS. The
sysop also runs on every host, and keeps running under drain so a drained host
can still receive its own "drain off". For a second host joining as a
follower, see [`leader-follower.md`][leader-follower].

### Step 6: check for a stale drain, and lift it

```sh
scripts/jobs/drain-fleet.sh status
```

A **drain** is a moratorium on taking new work while work in progress finishes;
**lift** ends it. A restart often follows a deploy, and an operator-engaged
drain, or a deploy killed before it could lift its own drain, leaves the
draining marker in place. A gardener that starts under the marker logs
`fleet draining; exiting cleanly` and exits. The result is a trap: units
installed, nothing failed, and zero gardeners running. If status reports
`DRAINING` and the pause is not intentional:

```sh
scripts/jobs/drain-fleet.sh off
systemctl --user start garden-gardener-scaler.service
```

After a deploy, the [restore][restore] skill is the companion step. It requeues
claims the drain stranded so the next gardener resumes them.

### Verify: prove the pool is live, not just not-failed

```sh
systemctl --user list-units 'garden-*' --state=failed --no-legend                    # want: empty
systemctl --user list-units 'garden-monk@*' 'garden-cleric@*' --state=active --no-legend
scripts/check-container-hardening.sh                                                  # want: all PASS
```

An empty failed list is necessary but not sufficient, because a drained fleet
shows no failures. Compare active counts per kind with the `monks:` and
`clerics:` lines in journal `hosts/$GARDEN`. The signature to catch is a
positive scaler target with zero active workers: suspect a stale drain or
backend health.

### Arming the liaison's four monitors

The liaison arms these as Claude Code **Monitor** tools in its own session, on
any bring-up that is not an explicitly interactive side session:

| Monitor | Where | What it does |
| --- | --- | --- |
| **Leader-marker watch** | every host | When the journal `leader` marker names this host, the liaison stands itself up as leader. The follower's half of the leader/follower contract. |
| **Maintainer-inbox watch** | leader only | Runs `scripts/jobs/maintainer-watch.sh`; you reply or dismiss with `maintainer-reply.sh` / `maintainer-archive.sh`. A singleton, because two would both answer. |
| **Deploy-on-upgrade watch** | leader only | Watches `$GARDEN_STATE/deploy/upgrade-ready`. The leader-orchestrated rolling deploy is autonomous; this monitor is an observer and human override. |
| **Liaison-bus watch** | every host | A standing loop over `read-msgs.sh` for `liaison-<host>`, `role/liaison`, `broadcast`, and `host/<GARDEN>`, with an `awk` filter that drops the session's own sends. On a drained host, it is the only reader of the bus. |

The liaison-bus watch is a standing monitor rather than a one-time read at
bring-up because of an incident: on 2026-08-02 a liaison that read the bus once
went about 36 hours without reading it again and missed four deploy broadcasts
and a direct request from a peer.

### Optional armings

- **Issue inbox.** Drive the garden from its own GitHub issues. This is
  per-instance journal state:

  ```sh
  scripts/jobs/set-garden-repo.sh <owner/name>
  scripts/jobs/add-maintainer.sh  <login>
  ```

  The timer is already enabled by step 3 but stays inert until both records
  exist, so writing them is the deliberate arming act. The trust gate is
  allowlist-only, with no org-membership fallback.

- **Transcript archive.** Claude Code's transcript deletion is disabled
  fleet-wide with no arming needed, and finished transcripts are spooled
  locally. Pushing them to a remote (`set-transcripts-remote.sh <url>`, a
  private repo) publishes the fleet's raw working memory, so the liaison offers
  this but does not arm it itself.

- **Bulletin PAT.** The GitHub Pages bulletin reads status without auth.
  Replying from the page needs a fine-grained PAT that only a human can create,
  following [`docs/bulletin/SETUP.md`][bulletin-setup].

Some things are described but never performed during bring-up: widening the
**watch set** (which repos' comments and PRs flow into model context) needs
explicit maintainer authorization recorded in a journal message, because
watched text is a prompt-injection surface. The ferry and identity switches are
maintainer-only.

### Then: a first job

The tour's final stage ([`first-job.md`][first-job]) offers to post a small real
job and watch a gardener claim it, which closes the loop end to end.

## 4.6 The turnkey path: a disposable AWS host

Everything above assumes a machine you provisioned by hand. For a host you want
to create, discard, and recreate from a script, [issue #44][issue44] produced
the **turnkey Amazon garden host**: a one-click EC2 launch that puts no Claude
credential, GitHub token, or user secret in the AMI, the launch template, the
repository, or instance user-data. Its status is "Implemented (first release)."

### What the button launches

An ARM64 (Graviton) Ubuntu instance with Docker, a garden checkout at
`/home/ubuntu/garden`, and the garden container image already built. The
instance profile allows SSM access and nothing else unless you opt into the PAT
path. **No inbound port is open.** The launch template sets the security group,
an encrypted gp3 volume, IMDSv2 as required, and tags. It sets no credentials,
no user-data, and no key pair.

### The resources (us-west-1, account 292378781985, tag `project=garden-turnkey`)

| Piece | Script (`scripts/aws/turnkey/`) | Default |
| --- | --- | --- |
| Least-privilege SSM instance profile | `ensure-instance-profile.sh` | role/profile `garden-turnkey-ssm`, `AmazonSSMManagedInstanceCore` only; `--with-secret <arn>` adds a one-secret read |
| Security groups (launch and separate test) | `ensure-security-group.sh` [`--test`] | `garden-turnkey` / `garden-turnkey-test`, no inbound; `--open-ssh <cidr>` opt-in |
| Bake pipeline | `build-ami.sh` | builder `m7g.xlarge`, encrypted gp3, IMDSv2 |
| On-builder provisioner / credential scrub | `provision.sh` / `scrub.sh` | the scrub fails the bake if it finds any residual credential |
| Launch template | `create-launch-template.sh` | `garden-turnkey`, no user-data, no key pair |
| Credential-free smoke test | `smoke-test.sh` | runs in the separate test security group |
| Teardown | `teardown.sh` | transient instances; `--ami <id>`; `--all` |

The directory also holds `lib.sh` (shared helpers) and `chromium-smoke.sh`.
These are host-administration scripts, run from a shell holding the
`garden-fleet` AWS credential ([`skills/aws-administration`][aws-admin]), not
jobs posted to the board.

### The AMI pipeline

```sh
export PATH="$HOME/.local/bin:$PATH"
scripts/aws/turnkey/build-ami.sh                 # bake the current main2 tip
scripts/aws/turnkey/build-ami.sh --commit <sha>  # or pin a reviewed revision (full 40-char sha)
```

The bake starts a Graviton builder from the pinned Canonical base
(`ami-0b9023009667261d9`, `ubuntu-noble-24.04-arm64-server-20260626`, the same
base the existing EC2 host uses). Over SSM it installs Docker CE and buildx,
checks out the reviewed `main2` revision, and runs `./garden build` so the image
is baked in. It then **scrubs** package caches, machine identity, shell history,
Docker credentials, and every home-directory credential, stops the builder, and
creates a private AMI tagged `garden:source-commit`, `garden:base-ami`,
`garden:architecture`, and `garden:build-timestamp`. The builder is terminated
on exit. The AMI id is the last line of stdout and is also written to
`scripts/aws/turnkey/.last-bake.env`.

The scrub is a hard gate. The bake never logs in to anything, so it should find
nothing; if it finds something, the bake fails rather than capture a dirty host.

AMIs are **immutable**: every garden release or security update to the base
image gets a new bake and a new launch-template version, never an in-place
patch.

### Launch template and smoke test

```sh
scripts/aws/turnkey/create-launch-template.sh           # uses the .last-bake.env AMI
scripts/aws/turnkey/create-launch-template.sh --ami <ami-id>
scripts/aws/turnkey/smoke-test.sh
```

The smoke test launches a throwaway instance in the separate
`garden-turnkey-test` security group, proves three properties, and terminates
the instance:

1. the instance reaches SSM, so the secret-free entry path works;
2. `./garden create` starts the container from the **prebuilt** image;
3. the host has **no pre-existing** Claude or GitHub authentication.

### Launching and first entry

```sh
aws ec2 run-instances --launch-template LaunchTemplateName=garden-turnkey --region us-west-1
```

You reach the instance over SSM, with port 22 still closed to the internet:

- **Session Manager:** `aws ssm start-session --target <instance-id> --region us-west-1`
- **Real `ssh` tunnelled through SSM**, via an `~/.ssh/config` `ProxyCommand`
  using the `AWS-StartSSHSession` document. Push a key at connect time with
  `aws ec2-instance-connect send-ssh-public-key`, or opt into a scoped inbound-22
  rule for your own CIDR with `ensure-security-group.sh --open-ssh <cidr>` and
  your own key pair. A public key is not a secret.

This resolves two review notes on the design that seemed to conflict: "SSH stays
closed" (no inbound SSH exposed to the internet) and "use the ordinary Claude
device-auth workflow from the operator's ssh CLI." The port stays closed, and
the CLI arrives over SSM.

Once in:

```sh
cd ~/garden
./garden        # device-login for Claude, then the liaison
```

Then comes GitHub (§ 4.4, path 1 or path 2), and then the ordinary first-run
tour. **The AMI does not start workers, arm watchers, or make the host leader.**
Those are garden-level choices, and a freshly launched second host must not
duplicate a leader's singleton services.

### The resolved decisions

The design's decisions table records three choices for the first release:

1. **ARM64 Ubuntu, private AMI plus launch template**, on the pinned base above.
2. **GitHub login: interactive `gh auth login` by default**, with the scoped
   Secrets Manager PAT as an opt-in (`--with-secret <arn>`), off by default.
3. **Account `292378781985`, region `us-west-1`.** AWS Marketplace publication
   (seller enrollment, version review, terms, regional copies, a support
   commitment) is deferred and remains a maintainer-only decision. It would
   consume the same tested AMI rather than fork the build.

### Why an AMI and not something else

The design weighs the alternatives against what a garden host is: a
long-lived, stateful, single-tenant host running systemd, holding git state on
disk, running timers indefinitely, and needing an interactive first login.

- **Docker Compose** would restate the flags `./garden` already passes and
  create a second source of truth for them. It would not supply the image, the
  launch posture, or the entry path. It is fine as a local convenience, but it
  is not a host.
- **Kubernetes** is built for scaled, request-routed, ephemeral pods. A garden
  host would be one StatefulSet pod fighting the pod security model to run
  systemd. Wrong shape.
- **Terraform** is not an alternative artifact but an alternative way to
  provision the same resources. A module wrapping the baked AMI and launch
  template is the most natural follow-up.
- **Google Cloud Run** is stateless, scales to zero, and has no systemd and no
  persistent disk. Wrong on every axis.

### Cost

The bake runs an `m7g.xlarge` for under an hour (about $0.16/hour) plus a
`t4g.medium` smoke instance for a few minutes: cents. At rest you pay only for
the private AMI's snapshot, under $1 a month for a 10–15 GiB image. Nothing
runs until you launch it.

```sh
scripts/aws/turnkey/teardown.sh             # transient builder/smoke instances
scripts/aws/turnkey/teardown.sh --ami <id>  # also deregister an AMI and its snapshots
scripts/aws/turnkey/teardown.sh --all       # AMI + launch template + SGs + role
```

## 4.7 What "creating your own" produces

It helps to be precise about what the procedure above creates, because there
are two different things you might want.

**A new host in an existing garden.** This is what the documented procedure
fully supports. A fresh checkout of `kriscendobot/garden` gets a new,
location-derived identity, its own container, credentials, and worker pool, and
it coordinates through the same `origin/journal2` board and bus as every other
host. On a first host it becomes leader. On a later host it joins as a
follower: gardeners race to claim jobs from the shared board, and the leader
keeps the singleton services. The leader rolls deploys to followers first as
canaries. Most of what this chapter describes, including the uniqueness rules,
exists because instances *share* a journal.

**An independent garden.** This is the "metamorphosis" sense from chapter 1: a
new garden running the same library of roles, skills, and scripts, against its
own journal and its own state, and free to evolve in its own direction from
this point. The pieces that make one instance distinct from another are already
data rather than code:

- **The journal** (`journal2`) holds the board, the bus, the leader marker,
  per-host worker counts, per-host bot identity overrides, the maintainer and
  trusted-sender allowlists, the watch set's arming records, schedules, and the
  instance's own record of what it has done. An independent garden owns its own
  journal.
- **`config/garden-repo`** and **`maintainers/allowlist`** (journal state) say
  which repo is "home" for the issue inbox and who may drive it.
- **`GARDEN_BOT_LOGIN`**, the bot-identity TSV, and the per-host override say
  who the bot is.
- **`config/fork-owners`** (journal) says which forks count as the garden's own
  for automatic watching.
- **The watch set** (`repos/`) is empty until a maintainer authorizes each repo.

Then the library itself (`roles/`, `skills/`, `scripts/`, `designs/`) is a
`main2` you can edit directly, with no PRs against yourself, as `CLAUDE.md`
§ Conventions puts it. From that point, the garden's standing self-improvement
loops (encoding lessons as skills, carving new roles, landing designs) work on
*your* `main2`, and your garden diverges from its parent the way each of the
four stages in HISTORY.md diverged from the one before. Each instance is a place
where the next metamorphosis can happen.

The honest caveat, repeated in § 4.8: the sources do **not** yet document a
procedure for this second kind of instance. Nothing tells you how to fork the
repo, create a fresh orphan `journal2`, or re-point the defaults that assume
`kriscendobot`. The mechanics above imply what has to change, but no tested
recipe exists.

## 4.8 Known gaps and stale spots

The job asked this chapter to say plainly where the sources run ahead of the
implementation, or disagree with each other. As of `main2` `649f5cdd617`:

1. **No read-once PAT bootstrap for the turnkey Secrets Manager path.** The
   design and runbook describe reading the secret once into the bot's `gh`
   credential store. The IAM half (`ensure-instance-profile.sh --with-secret`)
   exists, but no script under `scripts/` calls `GetSecretValue` for a GitHub
   PAT. The runbook's "read it once into `gh` on the host" is currently a manual
   step, something like `aws secretsmanager get-secret-value … | gh auth login
   --with-token`, that nobody has written down. Interactive `gh auth login` is
   the default and is complete.
2. **No independent-garden recipe.** See § 4.7. Nothing documents forking the
   repo, initializing a fresh orphan `journal2`, or changing the hardcoded
   defaults (`GARDEN_BOT_LOGIN` defaults to `kriscendobot`, and several
   `CLAUDE.md` passages name `kriscendobot/garden`, the `endojs`/`Agoric`
   org-membership trust fallback, and `kriskowal` as maintainer).
3. **README's multi-instance line is stale.** `README.md` § Getting started
   still says "Name each with `echo <name> > .garden` before its first
   `./garden`." The launcher, `CLAUDE.md`, and `identity.md` all say there is no
   `.garden` file and that identity comes from location. Follow `identity.md`.
4. **The turnkey design describes the old privileged container.** Its
   "Alternatives considered" section describes `./garden` as a "privileged,
   `--cgroupns=host`" `docker run`. The launcher has since dropped
   `--privileged` in favor of the default capability set plus `SYS_ADMIN`
   (§ 4.2). The launcher's comments are the current truth. The design's
   argument against Kubernetes is somewhat weaker than written but still holds.
5. **The Graviton image carries an unused amd64 GPU overlay.** The shared
   `Dockerfile` unconditionally fetches an amd64 Ollama ROCm bundle for the
   maintainer's AMD host. On an ARM64 turnkey host it does nothing but make the
   bake larger. The design tracks an arch guard as a follow-up that has not
   landed.
6. **Marketplace and a Terraform module** are deferred or proposed, not built.

## 4.9 Checklist

For a hand-provisioned host joining (or starting) a garden:

- [ ] Docker installed; the host's short hostname is unique across your hosts.
- [ ] `git clone` the garden into the directory whose path will be this
      instance's identity; `cd` into it.
- [ ] `./garden` → complete the Claude login (or pre-export `ANTHROPIC_API_KEY`).
- [ ] Confirm you are inside (`scripts/check-in-container.sh` is silent;
      `hostname` shows `<host>-<dir>-<hash8>`).
- [ ] Say **help** (or **start the garden**). The liaison will:
  - [ ] generate the bot SSH key (you paste it into the bot account);
  - [ ] run `gh auth login` (you authorize), then verify the wrapper reports the bot;
  - [ ] run `bootstrap-bot-identity.sh` (and `set-bot-identity.sh` first if your bot is not `kriscendobot`);
  - [ ] `install-units.sh install` + `enable-services`;
  - [ ] `set-workers.sh monk <n>`, plus other kinds only if their backends are provisioned;
  - [ ] `set-main-host.sh` on a first host, and not on a follower;
  - [ ] `drain-fleet.sh status`, and lift it if it is stale;
  - [ ] verify failed units are empty, active workers match the declaration, and the hardening check passes;
  - [ ] arm its monitors (leader-marker and bus on every host; inbox and deploy on the leader);
  - [ ] offer the optional armings;
  - [ ] offer a first job.

For a turnkey AWS host: `ensure-instance-profile.sh` → `ensure-security-group.sh`
(and `--test`) → `build-ami.sh` → `create-launch-template.sh` → `smoke-test.sh`
→ `aws ec2 run-instances --launch-template …` → SSM in → `cd ~/garden &&
./garden` → the same checklist from the Claude login onward.

[claude-md]: https://github.com/kriscendobot/garden/blob/main2/CLAUDE.md
[guard]: https://github.com/kriscendobot/garden/blob/main2/scripts/check-in-container.sh
[launcher]: https://github.com/kriscendobot/garden/blob/main2/garden
[first-run]: https://github.com/kriscendobot/garden/blob/main2/context/first-run/README.md
[identity]: https://github.com/kriscendobot/garden/blob/main2/context/first-run/identity.md
[auth]: https://github.com/kriscendobot/garden/blob/main2/context/first-run/auth.md
[first-job]: https://github.com/kriscendobot/garden/blob/main2/context/first-run/first-job.md
[starting]: https://github.com/kriscendobot/garden/blob/main2/context/operations/starting.md
[scaling]: https://github.com/kriscendobot/garden/blob/main2/context/operations/scaling.md
[cybernetics]: https://github.com/kriscendobot/garden/blob/main2/context/operations/cybernetics.md
[leader-follower]: https://github.com/kriscendobot/garden/blob/main2/context/operations/leader-follower.md
[harden]: https://github.com/kriscendobot/garden/blob/main2/context/operations/harden-container.md
[restore]: https://github.com/kriscendobot/garden/blob/main2/skills/restore/SKILL.md
[turnkey-design]: https://github.com/kriscendobot/garden/blob/main2/designs/turnkey-garden-host.md
[turnkey-runbook]: https://github.com/kriscendobot/garden/blob/main2/context/operations/turnkey-host.md
[aws-admin]: https://github.com/kriscendobot/garden/blob/main2/skills/aws-administration/SKILL.md
[bulletin-setup]: https://github.com/kriscendobot/garden/blob/main2/docs/bulletin/SETUP.md
[readme]: https://github.com/kriscendobot/garden/blob/main2/README.md
[issue44]: https://github.com/kriscendobot/garden/issues/44
