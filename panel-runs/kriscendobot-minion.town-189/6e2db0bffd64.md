---
kind: panel-run
repo: kriscendobot/minion.town
pr: 189
panel_kind: design
provider: openai
base_ref: origin/main-ad0257e
pr_body_hash: 94c141561afc6a64c0be2326a7ff3023aa200948f694a46f9a46ca5391a389ab
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 42bc9dcaa9a5014ba56023107b11e31044ae9d60
must_fix_total: 8
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 6e2db0bffd64
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #189 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `42bc9dca`

seat verdicts (9): copyeditor=must-fix critic=must-fix decomplector=pass ergonomist=pass novice=must-fix orthographer=pass pedant=comment skeptic=must-fix thesaurus=pass
must-fix items (8):
- copyeditor: The acceptance-and-rollout paragraph (`designs/clip-shell-framework.md:367-388`) is one very long sentence with sever...
- copyeditor: The deferred session-link sentence (`designs/clip-shell-framework.md:312-324`) buries its subject and main verb benea...
- copyeditor: The design is substantially more readable after replacing section-symbol references with named sections, but the new ...
- critic: **must-fix** `designs/clip-shell-framework.md` section 3.1 requires site-wide CSP anti-framing while claiming route C...
- critic: The three-browser acceptance suite’s harness belongs to the implementation PR. [rule: roles/jurors/critic/AGENT.md]
- novice: **must-fix** `designs/clip-shell-framework.md:119-204` The embedding argument separates its two necessary halves. The...
- skeptic: **must-fix:** Section 2 calls the id “validated base32,” but section 3.7 only rejects a non-`*.ocap.site` host. T...
- skeptic: **should-fix:** Section 3.1 correctly relies on CSP checking every ancestor, but section 3.7’s “different ancesto...
