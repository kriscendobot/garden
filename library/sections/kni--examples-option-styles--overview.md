---
title: "The option-notation reference (Q/A/QA threads)"
source: examples/option-styles.kni
source_repo: kriskowal/kni
source_commit: 435ec3cf062a40cee0dc1b8ec948c6fee4e516fd
source_date: 2016-07-30
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring]
status: current
---

> Abstract: The canonical reference for kni's second-person **option bracket notation**: an option weaves threads that appear in the *question* (the presented choice), the *answer* (the narration after selection), or *both*. The comment enumerates the forms — `+ [Q] A`, `+ QA []`, `+ QA [Q] A`, `+ [A1 [Q] QA] A2`, `+ [A1 [Q1] QA [Q2]] A2`, `+ [A1 [Q1] QA1 [Q2] QA2] A2` — with the two rules that *every option needs at least one bracketed expression* and *the question ends at the last closed bracket `]`*; the body gives one concrete option of each shape.

The notation exists so a single option string can serve both roles second-person interactive fiction needs — what the reader is *offered* and what they are *told they did* — with threads woven in order regardless of which role a given thread belongs to. The rule "the entire question ends at the last `]`" is the key parse: text and inner brackets up to that point form the question; text after it is the answer. The worked examples make each form concrete: `+ Hello [back!] right back to you!` is Kni-style (`QA [Q] A`); `+ [North. ] You head north.` is the abbreviated `[Q] A`; `+ [You b[B]uy an arrow. ]` shows the inner `[B]` — an `A [Q] QA` shape where the inner bracket both marks the keyword-addressable letter and splits question from answer; `+ [You s[S]hoot an arrow[.]], scoring a {~hit|miss}!` is the fullest shape (`A [Q] QA [Q] A`), with a second question-only bracket carrying alternate punctuation and a trailing answer that appends a random `{~hit|miss}` outcome.

For authoring, `option-styles` is the one file to read to understand kni's option grammar concretely — the reference that concretizes the abstract MANUAL options-and-questions section, and the key to reading the second-person options in `archery`, `subroutine`, `door`, `tree`, and `tetrominoes`.

Source: [examples/option-styles.kni](https://github.com/kriskowal/kni/blob/435ec3cf062a40cee0dc1b8ec948c6fee4e516fd/examples/option-styles.kni) at commit `435ec3cf`.
