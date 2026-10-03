---
role: orchestrator
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Split build-confined-application-makers-p2 into claim-sized orchestrated children

Maintainer (kriskowal, muster 2026-10-03) approved the proxy's suggested split.

build-confined-application-makers-p2-20261002 failed (too large for one session) and
halted orchestration build-confined-application-makers-orch-20261002. Read the original
p2 job, the proxy answer (inbox/maintainer/read/20261002T172515Z-24b6b5.md), and p1
(https://github.com/endojs/endo-but-for-bots/pull/1417, branch llm-confined-application-makers-p1;
its CI is being resumed by ebfb-red-ci-gauntlets-resume-20261003).

Decompose into serial children, each with full self-contained bodies:
1. p2-scan: node-modules-with-map/scan capture, with its own tests.
2. p2-mount: canonical mount hook, on child 1.
3. p2-makefromtree: EndoHost.makeFromTree layout/entry + tests, opening the draft PR
   stacked on #1417.
Park each with post-plan.sh --orchestrated --orchestrated-by build-confined-application-makers-p2-split-20261003,
then post-orchestration.sh --serial. Retire the halted orchestration so it does not
re-fire. Report the child bases.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-03T04:57:45Z
