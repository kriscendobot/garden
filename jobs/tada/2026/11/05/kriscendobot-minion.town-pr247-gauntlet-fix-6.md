Fix round 6 for kriscendobot/minion.town#247: I applied the panel-6 must-fix and should-fix items to the design, pushed one follow-up commit, and CI is green (`ci-wait-merge.sh` returned rc 0, 3 checks, 0 failed).

There was no deterministic pre-pass block in the job, so I worked from the latest panel review (5781565532, "Must-fix before merge").

**Fixes in `designs/ordered-gutter-context-menu.md`:**
- **Who owns membership (decomplector, must-fix):** the catalog's store record is now the only authority for membership and names. `clips/` is described as a copy of that record that exists to keep each controller alive. Reconciliation now covers outside changes to `clips/`:
  - An unknown live controller is adopted as a new entry.
  - An outside rename of an entry's only binding is recorded as a rename (new row in the reconciliation table).
  - An outside removal of a binding is repaired by the catalog and does not remove the entry.
  - Only Destroy and the `unheld` drop remove an entry.

  For create and clone, the step 5 Bind, the commit-point table and the ownership map now agree: membership commits when the record is written, and a crash after the binding but before that write finishes from the saved intent.
- **Refused operation ids (decomplector, must-fix):** a refused creation is now final. Its `operationId` goes into `retiredOperations` in the same write as the refused receipt. A retry after the receipt has dropped out of the 256-entry cache gets `operation-retired` instead of being treated as a new request. Only an id that was never attempted starts a creation.
- **Which `+` ships when (novice, must-fix):** where `+` is first introduced, the design now says that until #142 and #231 land it is #201's REST mint, without catalog naming, order or retry. The shell switches to `newClip()` once both are available.
- **Copyeditor:** "hash is stable today", with the order and naming problems now linked. "drops the entry" replaces the unclear "it". The #238 aside now explains the API-key-agent workbench, the attenuated capability and the provider key. §5.1 names the #230 methods it replaces and what the handle would wrap.
- **Pedant:** the `new-clip.md` link is now relative.

**What changed:** commit `e83913be`, "docs(shell): apply panel-6 findings to the gutter design", pushed with `safe-push-pr-head.sh --mode advance` (967f708a → e83913be). Nothing changed in the garden repo.

**Follow-ups:** none. The driver posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr247-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1236700 cached reads)
- Output: 8691 tokens
- Cost: $0.9688879999999999
- Wall-clock: 1524s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
