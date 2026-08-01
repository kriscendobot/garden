---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T08:30:00Z
---
repo: endojs/endo-but-for-bots
project: endo-but-for-bots

SturdyRef hourly assessment, 2026-08-01T08:30Z.

Current cuts:
- Design endojs/endo-but-for-bots#510 is merged. endojs/endo-but-for-bots#511 remains deferred and draft. The chosen closely-held-network design endojs/endo-but-for-bots#539 is open draft at e1f5435722; its prior review directives are addressed in the branch, but the review state remains CHANGES_REQUESTED.
- The live code stack has advanced beyond the dispatch summary: endojs/endo-but-for-bots#774 -> endojs/endo-but-for-bots#737 -> endojs/endo-but-for-bots#541 -> endojs/endo-but-for-bots#698 -> endojs/endo-but-for-bots#700 -> endojs/endo-but-for-bots#701 through endojs/endo-but-for-bots#704 -> endojs/endo-but-for-bots#871. All remain OPEN DRAFT.
- endojs/endo-but-for-bots#701 through endojs/endo-but-for-bots#704 implement daemon mint/export, the closely-held OCapN identity, foreign internalization, and the three-party round trip. endojs/endo-but-for-bots#871 implements the agent-facing provide/accept surface in @endo/daemon, @endo/agent-tools, Lal, Fae, and Genie.

Latest observed execution evidence:
- gh pr view over endojs/endo-but-for-bots#541, endojs/endo-but-for-bots#698, endojs/endo-but-for-bots#700, endojs/endo-but-for-bots#701, endojs/endo-but-for-bots#702, endojs/endo-but-for-bots#703, endojs/endo-but-for-bots#704, and endojs/endo-but-for-bots#871 reported respectively 21, 24, 24, 22, 21, 22, 22, and 21 completed SUCCESS checks, with zero non-success checks at their current heads.
- GitHub compare for build/sturdyref-bridge-6-three-party-roundtrip...build/sturdyref-agent-surface reported behind_by=0 at endojs/endo-but-for-bots#871 head c3fa894c9.
- No local suites were rerun because no project code was changed this tick.

Coordination and blocker:
- Did not touch endojs/endo-but-for-bots#700 because jobs/todo/endojs-endo-but-for-bots-pr700-rebase is queued for a peer.
- The next artifact is the panel/gauntlet for endojs/endo-but-for-bots#871. jobs/plan/endo-sturdyref-agent-surface-build-gauntlet remains poisoned and human-held; zero reviews exist. Re-escalated via maintainer inbox message 20260801T082922Z-3968c7.
- The finish line is not landed: the implementation stack and agent surface are drafts, and the gauntlet is not complete.

Distributed Confinement preserved: this tick made no behavioral changes. The current stack retains no-location mediation through the closely-held OCapN capability, no-identification through fresh per-grant unlinkable opaque tokens, and opaque/unforgeable identity-keyed resolution. Current CI is green as cited above; the dedicated confinement tests were not rerun locally this tick.
