---
kind: panel-run
repo: kriscendobot/minion.town
pr: 238
panel_kind: design
provider: anthropic
base_ref: 919689231495f6b62fd5a7a80c712acd667881a2
pr_body_hash: 9608b8a19ebf10e0039fd19dd2f798cef70ac52cb582f842ff85d8fef86a62cf
rounds: 1
disposition: passed
exit_code: 0
reviewed_head: d94936ffb7340030dcc547c8a096be444d4e0e0e
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: da3ed9f3f7fd
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #238 (design)

Terminal disposition: **passed** after **1** round(s).

## Round 1 — head `d94936ff`

seat verdicts (9): copyeditor=comment critic=comment decomplector=comment ergonomist=comment novice=must-fix orthographer=comment pedant=must-fix skeptic=must-fix thesaurus=pass
must-fix items (20):
- novice: **must-fix. The Status and Grounded-against rows front-load unexplained jargon and open questions.**
- novice: The Status row refers to "open question 3" and "open question 6" before the reader knows what a workbench mount or a ...
- novice: The Grounded-against row is a single paragraph of about 200 words. It packs in `glorp`, `EndoMount.edit`, `EndoProvis...
- novice: It makes the reader's first contact with the design a wall of unverified claims.
- novice: Fix: shorten both rows to one sentence each, and move the five-claim list into § Gating checks.
- novice: **must-fix. § Budget opens on a worked example that uses terms defined later.**
- novice: The example uses "parent reserve", "`grantPath` `gP/gA/`", "oversubscription", and "deferred for budget" before the R...
- novice: The line "The rules below are what make each step hold" tells the reader to hold seven unexplained ideas while readin...
- novice: Step 3 is the worst case: it does the arithmetic (85,000 + 5,000 leaves exactly the 10,000 reserve) without saying wh...
- novice: Fix: give a two-sentence intuition first (one shared pot, children capped, the parent keeps a reserve). Or put the ru...
- novice: **should-fix. The "Reuse inventory" table comes before the reader knows what is being built.**
- novice: It is 18 rows, each dense with links and design names, placed right after the capability graph.
- novice: The reader has to absorb the whole dependency surface before seeing the endowment, spawner, or workbench sections.
- novice: Fix: move it to an appendix or after the three core sections, and keep a three-line summary up front.
- novice: **should-fix. Two terms are used before the reader has a model for them.**
- novice: "Pinned" and "responder": the Terms paragraph says an agent is "pinned: a responder answers its mail". It never says ...
- novice: "Admission", "reservation", and "settlement" arrive in the Terms paragraph (the usage ledger) and in § Budget as if ...
- novice: **should-fix. § Serialization and the broker lease is a long run of dense paragraphs.**
- novice: The *One transaction owner* and *Mechanism* paragraphs each carry five or more claims.
- novice: It is not clear why the reader should care about the per-owner queue until the W3 gate paragraph, which comes later.
