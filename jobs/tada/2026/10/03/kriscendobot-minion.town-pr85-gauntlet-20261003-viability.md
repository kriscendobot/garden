**Viability gate for kriscendobot/minion.town PR #85: proceed**

I did not spend any clean, panel, fix, CI-wait or un-draft budget. I only read PR and repository facts, and I made no commits or changes.

**PR facts:**
- **State:** open, not merged, still a draft.
- **Title:** "feat(clip): in-place upgrade of both sides (front content and back powers) on the live @sites path".
- **Base:** `main-ec8db3f`, a pinned snapshot (the weave step has been done). It is exactly current `main` (`ec8db3fc`), 0 ahead and 0 behind.
- **Head:** `a5a2699d`, 4 commits.

**Deciding question:** Has the maintainer's most recent direction confirmed that #85's in-place upgrade (both the content and powers sides) should still go ahead, and does current `main` still lack it?

**Evidence:**
- **Design #88 might look like it supersedes this PR, but the maintainer has since moved on.** On 2026-09-04, kriskowal said design #88 (immutable content, upgrade by minting a fresh clip id) "supersedes all priors". But #88 is still an unmerged draft. Every maintainer action since then has kept #85 going:
  - 2026-09-30: a CHANGES_REQUESTED review asking for capability-based upgrade authorization. That is now implemented.
  - 2026-10-02 15:36Z: a review asking why upgrading the clip's powers was deferred.
  - 2026-10-02 15:53Z: "I am happy to expand scope to both sides of upgrade, run a gauntlet, and retcon."

  This gauntlet is the one the maintainer asked for in that last comment. The chain is weave, then this gauntlet, then the retcon, posted 2026-10-03.
- **The need still exists on the base.** At `ec8db3f`, `src/endo/gateway/daemon-site-registry.ts` still throws "upgrade is not yet supported on the live daemon @sites path" from `assertUpgradable` and `writeDirectory` (lines 331–347).
- **Nothing newer replaces it.** No other upgrade implementation PR exists. #88 is the only related PR, and it is an open draft design, not code.
- **The reason for the powers side still holds.** The prod powers plane is armed (`GATEWAY_ENDO_SOCK`, and the containment drop-in was disabled 2026-08-27).
- **The earlier halt is resolved.** The previous gauntlet run stopped because #85 was based on the floating `main`; it is now pinned. CI was green at `cfc1a9c`.

**For the panel and maintainer:** #88's immutable, fresh-id model still conflicts in principle with in-place upgrade. If #88 is accepted later, the maintainer will need to decide how the two fit together, but that does not block this gauntlet now.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (226296 cached reads)
- Output: 2339 tokens
- Cost: $0.46843120000000005
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
