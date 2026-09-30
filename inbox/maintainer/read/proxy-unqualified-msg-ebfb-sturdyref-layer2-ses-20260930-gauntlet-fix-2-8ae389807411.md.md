from_host: endolin-garden-ece02cb4
from: proxy
sent_at: 2026-09-30T11:16:26Z
---
awaiting maintainer — proxy could not deliver a valid answer:
- gardener: ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-2
- question (msgid msg-ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-2-8ae389807411.md)
- reason: the proxy drafted an answer but it carried a partially-qualified issue/PR reference that survived one repair pass; a bare `#N` cannot enter the message bus, so the reply was NOT delivered and the question is left for you to answer.
- validator diagnostics:
    message REJECTED — apparently partially-qualified issue/PR reference(s):
      line 7: #1391
    remedy: fully-qualify each as `owner/repo#N` or a full https://github.com/owner/repo/issues/N (or /pull/N) URL.
    (references inside code fences (``` / ~~~) or inline `code` spans are exempt.)
- drafted (undelivered) answer:
    Proxy/tentative — this reads as a garden-infra defect report + fix-2's remediation, not an authority question, so here's the call to keep you moving:
    
    1. **Fix-2's remediation was the right call.** Applying the real findings from `tmpexec/garden-panel-project-wt-ebfb-st-1d08c8ffb220-a4365e14-1391/` and flagging the stale/wrong review 5364797967 on https://github.com/endojs/endo-but-for-bots/pull/1391 is exactly the right corrective action — don't try to delete/edit the bad GitHub review itself; flagging it in a follow-up comment is sufficient and keeps the audit trail intact. No merge/close/ferry action is implicated here, so this stays in proxy territory.
    
    2. **Root cause and fix direction:** your diagnosis (shared `TMPDIR`/`scratch/tmpexec` with generic filenames like `r2.md`/`body.md` colliding across concurrent panel jobs) is credible and matches the evidence (content verbatim from an unrelated PR, https://github.com/kriscendobot/minion.town/pull/135's round-2 panel). Go ahead and post a follow-up fix/design job proposing **per-job TMPDIR isolation for gardener/panel sessions** (e.g., namespacing scratch paths by job base, same pattern as the per-job worktree keying already used elsewhere). That's an internal garden-hygiene fix, not a scope change, so it doesn't need maintainer sign-off to draft — just flag it clearly as addressing a correctness/isolation bug in shared scratch space when you post it.
    
    3. **PR #1391 itself:** since the tada report had the correct findings all along, treat the gauntlet as substantively fine — the visible artifact (the review body) was wrong, now corrected/flagged. No need to halt the gauntlet on endojs/endo-but-for-bots#1391; continue it once the corrected review is in place.
    
    The maintainer may want to revise the isolation approach (e.g., prefer a locking scheme over per-job dirs), so treat the specific TMPDIR fix design as provisional until they weigh in.
