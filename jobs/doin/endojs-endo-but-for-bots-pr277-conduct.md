# conduct (merge) directive on endojs/endo-but-for-bots PR #277

Map: **conduct** -> conductor merge of PR #277 once CI is green.

Source: pr-comment by kriskowal
Comment: https://github.com/endojs/endo-but-for-bots/pull/277#issuecomment-4850500173
Maintainer said: "Please retcon and conduct. This is ready to merge."

Context: the **retcon half is DONE** (job endojs-endo-but-for-bots-pr277-retcon).
The branch feat/endo-mount-follow-name-changes was rebased onto current
origin/llm and force-pushed as a single clean commit
(67aad4c99 feat(daemon): EndoMount.followNameChanges live entry-name stream);
net PR diff is byte-identical to the pre-retcon diff. The force-push restarted
CI, so do NOT merge until the checks are green. Confirm CI green on the new tip,
then conduct (merge) per roles/conductor/AGENT.md (let the conductor pick the
merge method). Base branch is `llm`.

---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-01T05:24:56Z
