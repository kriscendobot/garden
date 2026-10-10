**Viability report: kriscendobot/minion.town PR #166.** The gauntlet can go ahead.

**PR state:** open, still a draft, not merged.
- Head: `feat/prod-objectives-probe` @ `1f84e580`
- Base: frozen `main-50aa690`, which is 20 commits behind `main`

**Deciding question:** Does `main` still lack an automatic, scheduled production check of the primary-phase objectives in kriscendobot/garden#58, with no newer PR or design doing that job in place of #166? **Yes.**

**Evidence:**
- **Nothing on `main` does this yet.** `main` has no `deploy/probe/` directory. Its only workflows are `ci-runner-selftest.yml`, `deploy.yml` and `test.yml`; there is no `prod-probe.yml`.
- **The 20 commits since the base are about other things.** They cover the guest-recovery preflight (#169), the CD runner switch (#175) and hardening of the Claude harness and Node supply chain (#122). None of them touches the objective probe.
- **The other open probe PR builds on #166 rather than replacing it.** #171 ("validate the pinned Claude harness in production") is based on `feat/prod-objectives-probe-f432a51`, a frozen copy of #166's branch. It adds a separate check on top of this probe.
- **The reason for the PR still holds.** kriscendobot/garden#58 is open. The 2026-10-07 standing order says an objective only counts as done while production validates it automatically, and that is what this PR implements.
- **The review history points the same way.** It is all bot panel and fix-round reviews; nobody has suggested closing the PR or said something else replaces it. The Actions secrets the probe needs were provisioned on 2026-10-08.

**Notes for later stages:**
- The base is 20 commits behind `main`, but none of those commits are probe work. A later weave may still be needed before merge.
- #171 is stacked on this PR and will need restacking once #166 lands.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261010-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (169559 cached reads)
- Output: 1540 tokens
- Cost: $0.4120158
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
