---
child-endojs-endo-but-for-bots-pr475-retcon-20260819-reap-count: 0
child-endojs-endo-but-for-bots-pr475-consolidate-bytes-20260819-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr475-consolidate-bytes-20260819-reap-count: 0
child-endojs-endo-but-for-bots-pr475-advance-base-20260819-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr475-advance-base-20260819-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr475-advance-base-20260819 endojs-endo-but-for-bots-pr475-consolidate-bytes-20260819 endojs-endo-but-for-bots-pr475-retcon-20260819 endojs-endo-but-for-bots-pr475-feedback-20260819 endojs-endo-but-for-bots-pr475-gauntlet-20260819
on-child-failure: halt
state: running
created_by: weaver
created_at: 2026-08-19T02:59:01Z
---

# Campaign: land PR #475 (immutable byte arrays) on an advanced llm base

Maintainer campaign directive (kriskowal), 2026-08-19:
https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5336908307
"Let's update the llm base instead ... please proceed to advance the llm base,
rebase, retcon, respond to pending feedback, run a gauntlet, and wait for a
review of the incremental changes. This is a sufficiently large campaign as to
require an orchestration. The budget for this orchestration is not limited."

Serial, halt-on-child-failure. Children in run order:
  1. advance-base    — cut fresh llm-<sha> frozen base, rebase #475 head (a
                       curated reconstruction: ocapn CBOR codec was rewritten on
                       llm), repoint PR base.
  2. consolidate-bytes — consolidate thawedBytes/frozenBytes onto a shared impl
                       exported from @endo/immutable-arraybuffer (shim stays at
                       @endo/immutable-arraybuffer/shim.js); no back-compat.
  3. retcon          — reset & restage per-package, separate yarn.lock commit.
  4. feedback        — respond to pending review feedback.
  5. gauntlet        — clean → panel → fix-loop → un-draft.
Then: wait for maintainer/@erights review of the incremental changes.

Follow-up NOT in this orchestration (maintainer, separate later plan): after
landing the immutable byte-array changes, rebuild the affected stack on `master`
as a stack of individually-reviewable packages, projecting the packages not yet
on master.

Origin: rebase job endojs-endo-but-for-bots-pr475-rebase (comment-watcher),
which recognized only the first verb; this orchestration owns the whole campaign.
