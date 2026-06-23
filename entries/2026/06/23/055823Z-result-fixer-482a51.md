---
ts: 2026-06-23T05:58:23Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/23/055823Z-dispatch-fixer-482a51.md
---

Retcon of PR #290 (feat/lal-pi-harness) complete. Tree-hash invariant confirmed.

**New commit shape** (4 commits, base: origin/llm-0458d1f):

- `9bafdbb62` refactor(daemon): export pet-name shapes from @endo/daemon/type-guards.js
- `4819a78e1` refactor(lal): adopt pi-based harness; vendor agent-round.js; encode/decode SmallCaps
- `dc6e69a0f` feat(chat,fae,jaine): wire model-detect into provider setup; keep iterateReader switch
- `77ee33f02` chore: Update yarn.lock

**New HEAD**: `77ee33f02`

**Tree hash**: `git rev-parse HEAD^{tree}` = `69cf92cb0881dcb2db4acfeceb53b13e42b0256b` (matches prior head `14affdaa5` exactly).

**Lease anchor**: prior head `14affdaa5` was used as `--force-with-lease` anchor; push succeeded.

**PR comment**: https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4776141949

Prior shape had 7 commits: the SmallCaps fix and the agent-round.js vendoring restore were tacked on top of the main lal commit rather than folded in. This retcon merges all three lal concerns (pi-based harness, BigInt/SmallCaps encode/decode, vendor agent-round.js + drop @endo/genie dep) into a single `refactor(lal)` commit.

Self-improvement: nothing this time.
