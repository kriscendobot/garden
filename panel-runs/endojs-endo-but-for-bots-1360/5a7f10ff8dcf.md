---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1360
panel_kind: design
base_ref: 47f6965d882b9c1c3eaaa836dd8d75971a924bb4
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: f52acf660909d4ea6ff33660331c0cc76493a266
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 5a7f10ff8dcf
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — endojs/endo-but-for-bots #1360 (design)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `f52acf66`

seat verdicts (10): copyeditor=must-fix critic=comment decomplector=must-fix ergonomist=comment novice=comment orthographer=pass pedant=must-fix pruner=must-fix skeptic=comment thesaurus=pass
must-fix items (20):
- copyeditor: **Typo in Security section (example URL).** Line 558: `https://rninion.town/#v=1&...` should be `https://minion.town/...
- copyeditor: **Awkward relative clause (line 538).** "Scripts on the page the base names read `location.hash`" omits the relative ...
- decomplector: **Durable state:** the daemon's pet-name store. The https base is dropped when a URL is parsed.
- decomplector: **Commit/discard decision:** `EndoHost.adoptFromLocator`, which resolves the value before writing the name. The CLI a...
- decomplector: **Restart/replay:** not in scope.
- decomplector: **Classification:** `parseCapabilityUrl`. It decides whether a string is not a locator, an invalid one, or a valid one.
- decomplector: **should-fix: the parser mixes classification with adoption policy.** Per § API, `parseCapabilityUrl` returns `undef...
- decomplector: **should-fix: `view` mixes presentation data into locator identity.** § Locator family fields calls `view` "non-auth...
- decomplector: **should-fix: `storeLocator` should not accept the https form.** § Daemon surfaces admits that the only thing separa...
- decomplector: **comment-only: one `v` key for two separately owned grammars.** Open question 2 already notes that sharing `v` makes...
- pedant: **Em-dashes must be eliminated** [rule: em-dash-style/SKILL.md]. The design contains em-dashes on line 49 (`— for e...
- pedant: **Heading capitalization is inconsistent within the document** [rule: Chicago Manual Style § 8.166]. Headings mix ti...
- pedant: **Minor: serial comma inconsistency** [rule: Chicago Manual Style § 6.19]. Some lists carry the Oxford comma (`\`nod...
- pruner: **PR body: Empty "Scaling Considerations" and "Upgrade Considerations" sections** (lines in the JSON body)
- pruner: Both sections state "None." and add no information.
- pruner: [Rule: gricean-maxims] A section that contributes no semantic content should be omitted.
- pruner: **Action:** Remove both sections entirely; a section that does not apply need not appear.
- pruner: **PR body: The "It covers:" bullet list (lines in Description) is redundant**
- pruner: The list mirrors the design doc's § headings. A reviewer will read the doc.
- pruner: [Rule: gricean-maxims] Enumerating the table of contents of a document the reviewer is about to read adds no value.
