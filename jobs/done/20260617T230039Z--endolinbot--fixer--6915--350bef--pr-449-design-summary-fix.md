---
job: 350bef
posted_by_role: solicitor
posted_by_host: endolinbot
posted_at: 2026-06-17T22:42:19Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 449
  issue: null
  design: packages/immutable-arraybuffer/designs/freezable-typedarray.md
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - fixer
preconditions: []
refs:
  - entries/2026/06/17/221538Z-result-solicitor-2c53c2.md
---

# Summary-fix bundle for PR #449 (design/immutable-arraybuffer-freezable-typedarray-emulation)

All three rounds' accumulated summary-fix items for the design document
`packages/immutable-arraybuffer/designs/freezable-typedarray.md`
at head `f16f143bc`. Apply as a single fixer dispatch; no panel re-run needed.

## Round 3 additions (8 distinct items)

1. **permits.js delta sub-section:** Clarify that the conditional
   sentence ("if that test surfaces an unexpected gap the builder patches
   the permits entry at that time") describes the expected-no-gap case.
   Add a brief parenthetical: "this is the expected-no-gap case; the
   builder verifies the SES integration test passes and patches permits.js
   only if a gap surfaces, at which point escalation (not silent
   absorption) is the right response." The current wording could be
   misread as permission to defer the entry. (critic + decomplector,
   two-seat overlap; one prose revision.)

2. **Cross-package consumer touchpoints regression signals:** The first
   named signal (concordance-routed Buffer.from TypeError) does not name
   which test file would surface it. Add: "the parallel of PR #435's
   13 failures was in the ocapn codec test files" so the builder can
   triage CI failures at first glance. (skeptic)

3. **Future adapter withdrawal sub-section:** Add one sentence that the
   wrapper is not automatically frozen. The sub-section shows
   `new Uint8Array(ab.sliceToImmutable())` as the direct alternative
   but does not state the caller must call `Object.freeze` explicitly.
   Add: "note: the wrapper is not automatically frozen; the caller writes
   `Object.freeze(new Uint8Array(ab.sliceToImmutable()))` to obtain a
   frozen view." (ergonomist)

4. **Same sub-section, semicolon clause order:** "No new permit row is
   required; the existing `buffer: getter` entry covers the shim-installed
   replacement without modification." Reverse to lead with the conclusion:
   "The existing `buffer: getter` entry covers the shim-installed
   replacement without modification; no new permit row is required."
   (copyeditor)

5. **Heading title-case:** `#### Future adapter withdrawal from `@endo/bytes``
   should read `#### Future Adapter Withdrawal from `@endo/bytes``
   (nouns "Adapter" and "Withdrawal" are capitalized; preposition "from"
   is lower-case per Chicago Manual; the code term `@endo/bytes` is
   correct as a proper name). (copyeditor + pedant, bundled as one item)

6. **Decisions body cross-references:** The body text still says
   "section 1", "section 2", "section 3" in cross-references to the
   three decisions. The headings were renamed to `### Decision 1: ...`,
   `### Decision 2: ...`, `### Decision 3: ...`. Update the
   cross-references to read "Decision 1", "Decision 2", "Decision 3".
   (pedant)

7. **"that adapter shape" backward reference:** In the final paragraph
   of the Future Adapter Withdrawal sub-section, replace "that adapter
   shape" with the explicit direct-construction pattern name:
   "the direct-construction pattern
   (`new Uint8Array(ab.sliceToImmutable())`)". (novice)

## Accumulated from round 2 (not yet addressed)

8. **designs/README.md list-item body structure:** The two list-item
   bodies use different sentence structures (one a fragment, one a
   grammatical sentence). Pick one shape and apply consistently.
   (copyeditor r2)

9. **Worked example inline comment arrow:** Line 226 inline comment uses
   `=>` instead of prose ("with value"). Replace with "creates an own
   data property '0' with value 42." (copyeditor r2)

10. **designs/immutable-arraybuffer.md Status field:** The `Status: Proposed`
    value is stale; PR #435 has merged. Change to "Implemented" or
    "Accepted (PR #435 merged)". (pedant r2)

11. **Decisions heading cross-reference form (r2 carryover):** Same item
    as round-3 item 6 above; appears here in case the r2 pedant's note
    was not forwarded. Dedupe with item 6.

12. **Forward reference in Cross-package consumer touchpoints:** Add
    a one-line forward reference at the top of that section to the
    Future Adapter Withdrawal sub-section below it. (critic r2)

13. **designs/README.md collision-handling convention:** Add a sentence
    for what happens when two designs in the same package have slugs that
    would collide. (decomplector r2)

14. **Ergonomist r2 pattern recommendation:** Add a one-paragraph note
    on the recommended freeze-immediately-after-construction pattern
    for callers who need strict-mode throw on indexed write.
    (ergonomist r2)

15. **designs/README.md index entry sentence structure consistency.**
    (copyeditor r2 - same as item 8 above; dedupe.)

## Accumulated from round 1 (not yet addressed)

16. **designs/README.md "intended reader" per-entry tag:** Add a
    one-line "intended for:" tag per entry in the README index to help
    a novice pick the right entry point. (novice r1)

17. **"silent swallow" term gloss:** Add a one-sentence definition
    of "silent swallow" at the top of the "Indexed assignment never
    modifies the underlying buffer" section. (novice r1 and r2, repeated)

