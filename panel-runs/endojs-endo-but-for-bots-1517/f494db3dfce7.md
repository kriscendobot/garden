---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1517
panel_kind: design
provider: openai
base_ref: f02cd81b22887aae14e6db8f38e64f3a93ebc06a
pr_body_hash: 56e7ddf3d5b6a3a8e68115d1cc4aff9e329d40ea9e2eb3640de2d9a7cf4b052d
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: b9c751e8ba04c9e414b80ab2e4ca946d1b172063
must_fix_total: 11
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: f494db3dfce7
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1517 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `b9c751e8`

seat verdicts (9): copyeditor=must-fix critic=must-fix decomplector=must-fix ergonomist=pass novice=must-fix orthographer=pass pedant=comment skeptic=must-fix thesaurus=pass
must-fix items (11):
- copyeditor: **Must-fix:** The new totals paragraph says the listed buckets sum to 250, but they sum to 251 (`77 + 83 + 18 + 33 + ...
- copyeditor: **Should-fix:** In the test plan, “A removal racing formulation” is grammatically malformed. Use “A removal rac...
- copyeditor: **Should-fix:** “Its existing fragment-envelope coupon path” has an ambiguous antecedent after “The daemon impl...
- copyeditor: **Should-fix:** The test-plan phrase “host and guest accepters” uses a nonstandard noun and interrupts an otherwi...
- critic: **must-fix** — `## Inspection and acceptance` requires every accept to call `Invitation.enclosures()` before `Invit...
- critic: **must-fix** — `## Creation and authority` calls a crash after formula persistence but before the correspondent-slo...
- decomplector: **Must-fix** — The ownership map contradicts the persistence design and leaves enclosure lifetime coupled to an uns...
- decomplector: **Should-fix** — The minimum viable abstraction is not justified against the existing fragment-envelope coupon path...
- novice: **must-fix** — `designs/invitation-enclosures.md`, “Creation and authority” introduces local-versus-remote iden...
- novice: **should-fix** — `designs/invitation-enclosures.md`, “Same-daemon, cross-daemon, and coupon flows” says a fresh...
- skeptic: must-fix — The creation sequence releases all transient pins in step 4 before
