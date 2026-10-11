---
kind: panel-run
repo: kriscendobot/minion.town
pr: 177
panel_kind: design
base_ref: c7bdf20
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 33c80302fd1690b9e31aaff81f9f90ca7e2d4b64
must_fix_total: 15
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: bfebbdf67602
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #177 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `33c80302`

seat verdicts (10): copyeditor=pass critic=comment decomplector=comment ergonomist=comment novice=comment orthographer=pass pedant=comment pruner=comment skeptic=must-fix thesaurus=pass
must-fix items (15):
- skeptic: **must-fix: the `/.content/<root>` containment check protects less than it claims.** [proposed-rule: a design that ad...
- skeptic: An attacker who knows a victim's `roots` value (it appears in rewritten HTML and in every URL) can push byte-identica...
- skeptic: A *pusher to the victim's own partition* can land any code, which § 5.3 does state.
- skeptic: The weak point is the retention list. A root pushed once by any writer stays servable, as immutable, for 24 h even af...
- skeptic: **must-fix: the rewrite's security claim ("every other byte stays exactly as pushed") is untested against parser diff...
- skeptic: An author-supplied `<base href>` is not addressed at all. It changes how the rewritten `/.content/<root>/...` absolut...
- skeptic: § 10 has no test for `<base>`, `<template>`, `srcset` edge forms, or documents that fail to tokenize.
- skeptic: **should-fix: the Model S premise "revalidated entry documents give coherence" depends on `no-cache` and the 5 s TTL....
- skeptic: **should-fix: failure handling around the sweep.**
- skeptic: **Marker race.** The marker is removed "only after the vhost record write succeeds". A push B arriving while push A's...
- skeptic: **Never-projectable ref.** A permanently failing partition (a tree over the size limit, say) retries forever and keep...
- skeptic: **Tombstone ordering.** `unserved/<id>` is checked "before any record write", but there is no stated ordering against...
- skeptic: **should-fix: § 2's backfill is underspecified.** "Backfilled on first projection" leaves a window where a partition...
- skeptic: **comment-only: no real-execution evidence is claimed for any behavior, which is appropriate for a spec-only PR.** Th...
- skeptic: **comment-only: Q1's framing is honest.** I agree it cannot be closed here. The maintainer should decide it before an...
