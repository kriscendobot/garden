---
role: builder
---

handler-timeout: 10800
Build the approved Turnkey Amazon garden host design in kriskowal/garden, from designs/turnkey-garden-host.md as introduced by commit 59c3ac065159ff30966222c400f75319853a2bef, incorporating the maintainer feedback at https://github.com/kriskowal/garden/commit/59c3ac065159ff30966222c400f75319853a2bef#r192426866: use the ordinary Claude device-auth workflow initiated from the operator's SSH CLI. Do not place Claude subscription credentials, GitHub tokens, or other user secrets in the AMI, launch template, repository, or user-data.

Implement the bounded first release on current origin/main2: ARM64 Ubuntu image recipe/build pipeline, reviewed garden checkout and prebuilt container, encrypted gp3/IMDSv2/security-group/instance-profile launch-template configuration, least-privilege SSM support as designed, an operator SSH entry path sufficient for the stated device-auth workflow, credential scrubbing before CreateImage, immutable AMI/source metadata, and a credential-free smoke test. Reconcile the comment with the design text explicitly (including any prior 'SSH stays closed' wording), record resolved choices and safe defaults in the design/operator documentation, and use the existing AWS administration skill and garden AWS account/region conventions rather than improvising credentials or policy.

Actually exercise the build and smoke path where the configured garden AWS authority permits it; do not claim success from templates alone. Avoid irreversible/public Marketplace actions: keep artifacts private, report created AWS resource IDs, costs or ongoing resources, cleanup/retention posture, exact verification evidence, and any truly human-only AWS/account step. This is the garden repo: work in the per-job worktree, commit exact pathspecs, run relevant tests/security checks, and push directly to origin/main2 with no PR.
