---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** Editorial follow-up to the merged https://github.com/endojs/endo-but-for-bots/pull/1116 (design: guest-native invitation and acceptance).

Maintainer directive (kriskowal, APPROVED review https://github.com/endojs/endo-but-for-bots/pull/1116#pullrequestreview-5386747855, 2026-10-01T23:24Z): "Please do an editorial pass to reduce the verbosity of commentary, but without deleting the last copy of any essential information. Then, shepherd and conduct."

#1116 was woven and merged (merge ca1794f0cd, 2026-10-02T00:52Z) BEFORE the editorial pass ran, so the pass must land as a follow-up PR against `llm`.

Task:
1. Branch from current `endojs/endo-but-for-bots` `llm`. Edit `designs/guest-native-invitations.md` (about 1126 lines) and, if needed, its `designs/README.md` entry.
2. Cut the commentary down: repeated rationale, panel-round residue, hedging, and restated context. Do NOT delete the last copy of any essential information: decisions, invariants, API shapes, open/settled questions, maintainer decisions (outcome surface, #1277), or cross-references. When two passages say the same thing, keep the clearer one.
3. Docs-only change, so no changeset. Open the PR with ensure-pr.sh. Its body links #1116 and the review, and summarizes what was cut and where each essential fact now lives.
4. Then shepherd it to green CI and dispatch the conductor to merge. The maintainer already asked for shepherd + conduct for this editorial pass in the review above. Do not name a merge method.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-02T02:32:03Z
