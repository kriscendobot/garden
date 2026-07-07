---
created: 2026-07-07
updated: 2026-07-07
author: gardener
---

# Skill: AWS administration

Administer AWS for the garden fleet: install the CLI without root, manage the
single IAM credential the fleet uses, propagate that credential into every
container home by hard link, and verify the resulting identity. This encodes the
setup already live on host `endolin` (account 292378781985, IAM user
`garden-fleet` with `AdministratorAccess`, one access key, region `us-west-1`) so
a fresh host or a rotation follows the same shape rather than being reconstructed
by hand.

The four scripts live under `scripts/aws/` (executables never live in `skills/`;
the split is strict). This skill is the operator's map to them.

## Purpose

Give the garden fleet a working `aws` and a single, safely-shared credential:

- **Install the CLI** user-locally so no host needs root to get `aws`.
- **Hold exactly one IAM credential** (an IAM user, never the account root) and
  propagate it to every checkout home so `HOME=<checkout> aws ...` works from any
  gardener container.
- **Rotate that credential** without breaking the propagation or leaving a window
  with no working key.
- **Verify** that every home resolves the expected identity, account, and region.

## Inputs

- No arguments for the common path; each script discovers what it needs.
- Overridable environment knobs (defaults match the live `endolin` setup):
  - `GARDEN_AWS_IAM_USER` (default `garden-fleet`)
  - `GARDEN_AWS_ACCOUNT` (default `292378781985`)
  - `GARDEN_AWS_REGION` (default `us-west-1`)
  - `AWS_SOURCE_DIR` (default `$HOME/.aws`) — the canonical credential directory.
  - `AWS_CLI_INSTALL_DIR` / `AWS_CLI_BIN_DIR` (default `$HOME/.local/aws-cli`,
    `$HOME/.local/bin`) for the installer.
- To use the scripts you must already possess the IAM user's access key (to seed
  `$HOME/.aws/credentials` the first time) and be able to reach IAM (for
  rotation). Seeding the very first key is a manual step done in the AWS console
  or by a maintainer who already has admin access; these scripts manage the
  credential from that point on.

## State

The credential architecture (what the scripts maintain):

- **One IAM user, `garden-fleet`, with `AdministratorAccess`.** The fleet never
  authenticates as the account root. `AdministratorAccess` is the current broad
  grant; prefer a scoped policy once a workload's real permission set is known
  (see § Security posture).
- **One access key** for that user. IAM caps a user at two keys; the fleet holds
  exactly one in steady state, and rotation briefly uses the second slot.
- **One credential file, shared by hard link.** `~/.aws/credentials` is a single
  inode with several names: `~/.aws/credentials`, `~/garden/.aws/credentials`,
  `~/garden2/.aws/credentials`, and any further checkout root. Because they are
  the same inode on the same filesystem, editing one edits all, and there is no
  "primary" copy to drift out of sync.
- **Hard links, not symlinks.** The `./garden` container bind-mounts only the
  checkout path and relocates the bot user's home onto it, so a symlink that
  pointed at the host `~/.aws` would dangle inside the container. A hard link is
  just another directory entry for the same on-disk inode, so it resolves
  identically inside the mount and out. This is why all names must sit on the same
  filesystem (the shared home): a hard link cannot cross filesystems.
- **Region `us-west-1`,** carried in `~/.aws/config` (`[default]` profile) and
  propagated alongside `credentials` by the same hard-link discipline.
- **`.aws/credentials` is gitignored.** At a checkout root the whole `.aws`
  directory is excluded by the top-level `/.[!.]*` rule in `.gitignore`, so the
  secret never enters tracked history. The credential lives only on disk.

## Procedure

Run everything on the host that holds (or will hold) the credential.

1. **Install the CLI (once per host, safe to repeat).**
   ```sh
   scripts/aws/install-aws-cli.sh
   ```
   Installs AWS CLI v2 into `~/.local` and prints the `aws --version` it verified.
   If `~/.local/bin` is not on `PATH` it prints the line to add. The install uses
   the official v2 installer's `--update`, so a re-run upgrades or no-ops.

2. **Seed the credential (first time only).** Put the access key into the
   canonical file, `[default]` profile:
   ```sh
   aws configure          # or write ~/.aws/credentials directly
   ```
   Set the region to `us-west-1` (writes `~/.aws/config`).

3. **Propagate to every checkout home.**
   ```sh
   scripts/aws/relink-aws-creds.sh
   ```
   Discovers every garden checkout root (a directory with `CLAUDE.md` + `roles/`
   + `skills/`) and hard-links its `.aws/{credentials,config}` back to the
   canonical files. Idempotent: a name that already shares the source inode is
   left alone. Run it after any manual key edit as well.

4. **Verify.**
   ```sh
   scripts/aws/verify.sh
   ```
   Runs `sts get-caller-identity` for the host home and for each checkout home and
   asserts user `garden-fleet`, account `292378781985`, region `us-west-1`.

5. **Rotate when needed (leaked key, scheduled hygiene).**
   ```sh
   scripts/aws/rotate-key.sh
   ```
   Uses create-new-before-delete-old ordering so there is never a window without
   a working key, and preserves the hard links (see § Rotation).

### Rotation (how the links survive it)

`rotate-key.sh` rotates the single key while keeping the shared inode intact:

1. Reads the currently-active key id (the one to retire) and confirms the active
   identity is `user/garden-fleet` before touching anything.
2. Confirms the user holds exactly one key, so there is a free slot (IAM's
   two-key cap means rotation needs one). If two keys already exist it stops and
   tells you to delete the unused one first.
3. Creates a **new** access key.
4. Writes the new key into `~/.aws/credentials` **in place** (truncate and write,
   never create-a-temp-and-rename). The `>` redirect reuses the existing inode,
   so every hard-linked checkout sees the new secret immediately. A rename would
   allocate a fresh inode and silently unshare the links, which is the failure
   this ordering exists to avoid.
5. Runs `relink-aws-creds.sh` to repair any link that had drifted.
6. Verifies with `sts get-caller-identity` (retried for IAM's eventual
   consistency), asserting `user/garden-fleet`.
7. **Only on a clean verify,** deletes the old key.

If any step after the new key is written fails, the script restores the previous
credential in place and deletes the just-created key, so a failed rotation leaves
the old working key active.

## Security posture

- **Never mint root access keys.** The account root is for account-level actions
  in the console, not for programmatic use. Every fleet key belongs to an IAM
  user.
- **Delete any legacy root access keys.** If the account root has an access key,
  remove it; a root key is a standing account-takeover risk.
- **Enable MFA on the root account.** Root sign-in should require a second factor.
- **Prefer scoped policies over `AdministratorAccess`.** `garden-fleet` currently
  holds `AdministratorAccess` because the workloads are still being discovered.
  When a workload's real permission set is known, attach a policy scoped to it and
  narrow the user (or give the workload its own least-privilege user), so a leaked
  fleet key cannot do everything.
- **Rotate on any suspicion of exposure** with `rotate-key.sh`, and treat a key
  that ever reached a log, a screen share, or an untrusted process as exposed.
- The credential is gitignored and lives only on disk; keep it that way. Do not
  echo it into commit messages, journal entries, PR bodies, or inbox messages.

## Output shape

- `install-aws-cli.sh`: `aws` on `~/.local/bin`; prints the verified version.
- `relink-aws-creds.sh`: `.aws/{credentials,config}` in each checkout root sharing
  one inode with `~/.aws`; one status line per link.
- `rotate-key.sh`: a fresh access key active everywhere, the old key deleted, the
  links preserved; a `done` line naming the new key id.
- `verify.sh`: one `ok`/`FAIL` line per home; non-zero exit if any home is wrong.

## Notes

- These are host-administration scripts, not fleet jobs: run them from a shell on
  the host, not off the job board.
- Discovery keys on the checkout-root markers (`CLAUDE.md` + `roles/` + `skills/`)
  rather than hard-coding `garden`/`garden2`, so a third checkout is picked up
  automatically. Pass explicit roots to `relink-aws-creds.sh` / `verify.sh` to
  override discovery.
- Hard links require one filesystem. If a checkout ever lives on a different
  filesystem than `~/.aws`, `relink-aws-creds.sh` reports the failure instead of
  silently copying, because a copy would not stay in sync through a rotation.
