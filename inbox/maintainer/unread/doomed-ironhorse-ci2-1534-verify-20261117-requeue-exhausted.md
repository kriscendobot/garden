from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-17T10:34:01Z
doom_base: ironhorse-ci2-1534-verify-20261117
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-17T10:34:01Z
last_seen: 2026-11-17T10:34:01Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/ironhorse-ci2-1534-verify-20261117; it stays HELD until a human promotes it
(promote-plan.sh ironhorse-ci2-1534-verify-20261117) or removes it, so nothing is lost.
Original job base: ironhorse-ci2-1534-verify-20261117

--- original job body ---
---
role: fixer
tier: mentor
posted_at: 2026-11-17T10:06:48Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-17T10:08:07Z cleared=none -->

---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ironhorse #1534: confirm final CI state after the llm refresh

Repo endojs/endo-but-for-bots, PR https://github.com/endojs/endo-but-for-bots/pull/1534 (head `llm-endor-run-unit-tests-ci-lane`, base frozen llm-54d3d2a, kept). This is a split child of ironhorse-ci2-refresh-1298-1534-20261117. The head was rebased onto llm 0368767778 as f67903d1c0, a single ci.yml commit. The old build red was `scripts/graph.sh: tred: command not found` in check-dependency-cycles, fixed on llm by fc2b4719a3 (graphviz install). After the refresh, build, sandbox-drivers, and all ubuntu test/cover lanes are green. Two flakes went green on rerun: cover(24.x), the bwrap reap test, and test (22.x, macos-15), the daemon durable-environment test. test-ironhorse timed out at 45 minutes on a cold cache and was rerun. As of 2026-11-17T10:05Z, the only reds were test-xs and the two oracle lanes.

Task: confirm with `gh pr checks 1534 -R endojs/endo-but-for-bots` that nothing beyond the expected reds remains. Expected:
- test-xs: base-wide Node 26 caller baseline, fixed by open PR #1646
- test-ironhorse-oracle and ironhorse-oracle-sanitizers: until #1613
- compare-ironhorse-math: downstream of the oracle lane
If anything else is red, rerun it once if it's a known flake, otherwise diagnose and fix it. Do not merge. Report the final check state.
