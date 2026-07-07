Author a new garden skill: skills/aws-administration/SKILL.md, plus the proposed
scripts under scripts/aws/. This encodes the AWS setup already live on host
`endolin` (account 292378781985, IAM user `garden-fleet`, AdministratorAccess,
credentials hard-linked across host + both checkout roots, region us-west-1).

SKILL.md sections (follow the garden skill template: purpose, inputs, state,
procedure, output shape, notes):
- Purpose: administer AWS for the garden fleet — install the CLI, manage the
  single IAM credential, propagate it into container homes, verify identity.
- The credential architecture: IAM user (never root) + AdministratorAccess; one
  access key; hard-linked `.aws/credentials` across `~/.aws`, `~/garden/.aws`,
  `~/garden2/.aws` (one inode, same filesystem); why hard links not symlinks
  (container bind-mounts only the checkout path); region us-west-1; `.aws/credentials`
  is gitignored.
- Security posture: never mint root access keys; prefer scoped policies when a
  workload is known; enable MFA on root; delete any legacy root access keys.
- Rotation procedure that preserves the hard links (see rotate-key.sh).

Proposed scripts under scripts/aws/ (executables live in scripts/, never in
skills/ — respect the strict split):
- install-aws-cli.sh   — user-local AWS CLI v2 install to ~/.local (no root),
                         idempotent; verifies `aws --version`.
- relink-aws-creds.sh  — re-establish hard links from ~/.aws/credentials into
                         each checkout root's .aws/credentials; idempotent;
                         run after any manual key edit/rotation. Discover checkout
                         roots rather than hard-coding garden/garden2 where practical.
- rotate-key.sh        — mint a new garden-fleet access key, write it to
                         ~/.aws/credentials, call relink-aws-creds.sh, verify with
                         sts get-caller-identity, THEN delete the prior key
                         (create-new-before-delete-old ordering).
- verify.sh            — run `aws sts get-caller-identity` for the host and for
                         each container home (HOME=<checkout> aws sts ...),
                         asserting the ARN is user/garden-fleet (not :root) and
                         region is us-west-1.

Deliverable: the SKILL.md and the four scripts, added to the CLAUDE.md skills
inventory line. Open as a normal garden library change (no PR against ourselves;
push main2 directly per the garden's own conventions).
