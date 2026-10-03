---
gate: orchestrated
orchestrated_by: design-act-local-ci-screening-split
priority: normal
posted_by: producer
posted_at: 2026-10-03T05:48:26Z
---

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: `act` local CI screening (write the doc from the findings)

Child 2 of 2 of orchestration `design-act-local-ci-screening-split`. Child 1
(`design-act-local-ci-screening-research`) committed
`designs/act-local-ci-screening-findings.md` on `main2` with the feasibility
facts (Docker availability, act's non-container mode, Linux-runnable workflow
inventory, cost data). Read it first and build on it; re-verify only what looks
doubtful. If that file is missing, block and say so rather than redoing the
research.

Maintainer directive (kriskowal, 2026-10-03): "There's a tool called 'act' for
running GitHub Actions locally. We might be more efficient with CI action limits
if we were anticipating failures by running the jobs that we can locally. Please
post a job to integrate 'act' in our gardener workflows in advance of pushing to
GitHub, to the extent it makes sense to screen. That is, we have neither the
means nor the need to run the Mac-specific or Windows-specific CI jobs."

Read `skills/local-verify/SKILL.md` and `skills/pre-push-gates/SKILL.md` in
full. `act` is NOT a replacement for that layer: design it as a
**parity-auditing cross-check** of `local-verify`'s hand-maintained candidate
table against the real workflow YAML (catching setup/env/matrix/repo-root drift,
cf. the `endo-root-tsc-checkjs-ci-gap` precedent). A discrepancy `act` catches is
a `local-verify` coverage-gap bug, per that skill's own disposition. Linux
(`ubuntu-*`) jobs only; skip anything else, never emulate it.

## Deliverable

`designs/act-local-ci-screening.md` covering: the feasibility finding (if
infeasible as asked, say so plainly, cite the concrete blocker, and propose the
real alternative — e.g. a host-level run gated behind a `designs/sysop.md` op —
or recommend not integrating; that is a complete deliverable); in-scope
Linux workflow jobs per repo; where it hooks in (a `pre-push-gates.sh` step, a
`local-verify.sh` mode, or a separate opt-in/periodic audit script — containers
are heavier than script runs); cost/benefit (CI minutes saved vs local
compute/time per push); and an explicit `## Open questions` section for genuine
maintainer calls. Follow `roles/designer/AGENT.md`: land direct-to-`main2` if
open questions are empty, else the review-PR carve-out. Do not implement; a
build job follows once the design lands.
