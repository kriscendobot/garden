---
kind: result
role: scholar
host: endolin-garden-ece02cb4
at: 2026-09-28T23:11:13Z
---
project: garden
source_repo: NVIDIA/OpenShell
source_commit: 1358941b818d4126a7374aaf5216d87fc960e122

Completed a focused read-only assessment of NVIDIA OpenShell for garden confinement and secret masking.

- Wrote `projects/garden/openshell-confinement-fit.md` and indexed it from `projects/garden/README.md`.
- Surveyed the README, architecture overview, sandbox, security policy, gateway, sandbox limits, compute runtimes, support matrix, Docker and Podman drivers, provider overview/AWS guide, license, security policy, provider profiles, and relevant credential/proxy source. No OpenShell binary was installed or run and no real credential was used.
- Headline verdict: pilot OpenShell alongside the existing garden container as a per-job egress and credential boundary. Do not replace the container fleet yet. GitHub HTTPS and AWS SigV4 are strong first candidates; gateway-managed Codex OAuth is promising but needs live CLI validation; Anthropic subscription OAuth and SSH keys are not currently masked by shipped profiles.
- The note grounds the integration in the bind-mounted shared home, container-hardening probe, bot-pinning `gh` wrapper, Claude/Codex auth files, AWS/SSM, ferry boundary, `GIT_CEILING_DIRECTORIES`, root-repo guard, per-job worktrees, rootless Podman, systemd user units/linger, noexec `/tmp`, and multi-host subscription topology.
- Foreign-content gate: 15 fetched documents were classified with Jev 1.13.0. Fourteen were `proceed`; the product README was `proceed_with_caveat` for mixed factual and persuasive framing. All injection verdicts were clean (0.04-0.12). Metered usage was 81,408 input tokens and 1,065 output tokens.
- Maturity check: release v0.1.2 and active 2026-09-28 development; Apache-2.0; no entries returned by the public GitHub security-advisory API at the snapshot. The note explicitly treats this as no advisories found, not evidence of no escapes or an independent audit.
- Integrity: project-only write, so library section/source link and projected-index regeneration were not applicable. The committed `projects/garden/README.md` link target exists at the current `origin/journal2` tip. No deferred source backlog or follow-on job was needed for the requested decision note.

Self-improvement: nothing this time.
