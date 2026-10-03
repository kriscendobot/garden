---
role: researcher
tier: mentor
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-03T05:49:05Z cleared=none -->

---
role: researcher
tier: mentor
fallback-tier: minion
handler-timeout: 3600
dispatch: automatic
---

# Research: `act` (nektos/act) feasibility + Linux-runnable CI inventory

Child 1 of 2 of orchestration `design-act-local-ci-screening-split` (split from
designer job `design-act-local-ci-screening`, which overran its 2400s wall once
trying to research AND write the design in one claim). This child does ONLY the
fact-finding; child 2 (`design-act-local-ci-screening-doc`) writes the design
from your findings. Do not write the design doc.

Maintainer directive (kriskowal, 2026-10-03): integrate `act` into gardener
pre-push workflows "to the extent it makes sense to screen", to save GitHub
Actions budget by anticipating CI failures locally. Mac/Windows jobs are out of
scope. Context: `local-verify` (`skills/local-verify/SKILL.md`,
`scripts/jobs/gardening/local-verify.sh`) and `pre-push-gates`
(`skills/pre-push-gates/SKILL.md`, `scripts/jobs/gardening/pre-push-gates.sh`)
already run CI's lint/test/typecheck locally from a hand-maintained parity
table; `act`'s intended role is a parity audit of that table against the real
workflow YAML.

## Answer, with evidence (commands run + output excerpts)

1. **Docker in the gardener execution path.** Does the environment where a
   gardener runs `local-verify.sh`/`pre-push-gates.sh` (the garden container;
   check `./garden` launcher, the container image/Dockerfile, how worker units
   are started) have a `docker`/`podman` binary or a reachable daemon socket
   (`/var/run/docker.sock`, `DOCKER_HOST`)? Does the HOST (outside the
   container) have one? Rootless podman possible? Be concrete; don't assume.
2. **`act` without Docker.** From act's CURRENT docs/source (fetch
   https://nektosact.com and the GitHub README/flags; do not rely on memory):
   is there a host/self-hosted execution mode (e.g. `-P ubuntu-latest=-self-hosted`),
   what does it support/skip (services, container: jobs, docker actions), and its
   caveats. Can `act` be installed in the container without root (static
   binary)? Optionally try `act -l` / `act -n` (dry-run) on one repo to show
   parsing works.
3. **Workflow inventory.** For `endojs/endo-but-for-bots` and
   `kriscendobot/minion.town` (and any other repo the fleet regularly
   gauntlets — check `repos/` in the journal and recent `jobs/tada/` for
   gauntlet targets), enumerate `.github/workflows/*.yml` jobs: name, `runs-on`
   (incl. matrix expansion), trigger, uses `services:`/`container:`/docker
   actions, secrets needed, approx runtime. Mark each Linux-runnable /
   not-Linux / Linux-but-impractical-locally, and which already have a
   `local-verify` candidate-table equivalent. Use project checkouts via
   `scripts/jobs/ensure-project-worktree.sh design-act-local-ci-screening-research <owner/repo> <branch>`
   or `gh api` reads; never git in the garden root.
4. **Cost data.** Rough local cost (image pull size of catthehacker/ubuntu or
   equivalent, per-run wall time if measurable) vs typical CI minutes per push.

## Deliverable

Commit `designs/act-local-ci-screening-findings.md` to `main2` (direct push,
rebase CAS loop per your job prompt) holding the four answers with evidence and
a one-paragraph bottom line (feasible in-container / feasible only on host /
infeasible — and what would unblock it). Mark it clearly as research input for
`designs/act-local-ci-screening.md`. If a question cannot be answered, say so
and why rather than guessing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T05:49:15Z
