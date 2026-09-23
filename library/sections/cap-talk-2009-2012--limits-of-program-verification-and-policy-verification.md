---
title: "The limits of program verification, and where policy verification pays"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-September/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-September.txt.gz
source_content_sha256: 62af27536b2d680415d70eecbe5cbdfc952abf7bd65baff4f632453e83252f6c
source_authors: [Jed Donnelley, Jonathan S. Shapiro, Dave Chizmadia, Ben Kloosterman, John R. Strohm, Carl Hewitt]
source_date: 2011-09-29
thread_subject: "Hoare's 1980 Turing Award Lecture ... and program verification mea culpa"
ingested: 2026-09-16
ingested_by: scholar
topics: [programming-language-design, capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages. A friam cross-post thread that ran on cap-talk; continues briefly into 2011-October."
---

Abstract: Prompted by Hoare's 2009 retrospective *mea culpa* ("verification cannot protect against errors in the specification itself"), Jed Donnelley posted two long-standing doubts about formal program verification: (1) a program can be *verified correct within its model yet remain insecure through a channel the model omitted* — his example is a password-checker that verifiably compares one character at a time but leaks the password through page-fault timing when the string straddles a virtual-memory boundary; and (2) a program is already "a proof that it does exactly what it says," so a separate verification is just another, possibly-harder-to-understand, statement of the same behavior. Jonathan Shapiro replied with the thread's clarifying analysis: the "within the model" gap is a *failure of modeling, not of verification*, and any testing regime shares the identical modeling failure; the interesting security breaches are exactly the ones that reveal flawed model assumptions and force the whole testing regime to be re-examined. Crucially, verification can do something testing and type-checking cannot: affirmatively show that a proposed *mitigation* works, once the model is enriched to include the threat. Shapiro separated "internal-consistency" verification (type safety) from "correspondence-to-a-model" verification, held that most of the value comes from the rigor of *writing* the formal specification rather than from the mechanized proof, and named the case where verification unambiguously pays: **policy verification** (Doerrie's mechanized confinement proof), which gives high, rigorous, affordable confidence that confinement constrains information flow across a broad class of capability systems.

## Correctness within a model is not security

Donnelley's page-fault example is the durable point. A password checker can be *proved* to compare the supplied string against the stored password correctly, and still be uselessly insecure, because an attacker who places the string across a page boundary learns, character by character, how far the comparison got before faulting. The proof is sound; the model simply did not include virtual-memory timing. Shapiro's response reframes this so it does not indict verification specifically: *every* validation technique — testing, type checking, or proof — establishes a property only with respect to an assumed model, and a conventional test suite would very likely embed the same omission. What distinguishes the classes of failure is what you can do about them: an incorrect *specification* can be partly guarded by sanity-checking the model against known-good properties, whereas behavior *lost in the model by a layering failure* (the page-fault channel) is much harder to capture, and often traces to abstracting away something important for the sake of generalization or of making the proof tractable.

The asymmetry Shapiro drew is the one worth keeping: testing and type checking can demonstrate the *absence* of certain bugs (up to the model's assumptions), and advanced type systems can preserve certain properties, but only verification can affirmatively demonstrate that a *mitigation* is effective once the model is enriched to represent the threat. "Copy the whole password first" can be *shown* to close the timing channel only inside a model that represents paging.

## Most of the value is in writing the specification

Shapiro agreed with the debrief-lore reported by Dave Chizmadia — that verification efforts often deliver their value socially, by forcing a team to think through and state requirements clearly — but corrected the terminology: the simpler statement of behavior is the *formal specification*; the *verification* is the separate demonstration that the program corresponds to it. The rigor of writing a specification in a language designed for rigor is simultaneously the main source of confidence and the main source of obscurity, and the marginal proof step frequently adds little beyond what disciplined implementation already secured — which is an argument for calibrating rigor to cost, not for abandoning it.

## Where verification unambiguously pays: policy

Shapiro's exception is policy specification. Doerrie's mechanized confinement verification is worth it because it gives high confidence both in *what* the constructor is supposed to test and in the claim that confinement, used as intended, constrains information flow across a broad class of capability systems — known rigorously, at acceptable cost. The stakes justify the rigor: the migration cost to capability systems is measured in tens to hundreds of billions of dollars, so adopters are entitled to know why one allegedly-secure design is better than another (Shapiro noted OK Labs/seL4 repeatedly getting properties wrong, formalizing them, and then proving them). This is verification of *policy*, not of software.

## Bearing on Endo

The thread is the reasoning frame behind Endo's confidence story. "Correctness within a model is not security" is why Hardened JavaScript's guarantees are stated against an explicit threat model (a frozen, tamed realm with no ambient authority) rather than as blanket claims: a property proved about SES holds only where its model assumptions — no monkey-patchable primordials, no ambient `this`, no unfrozen intrinsics — actually hold, which is exactly what `lockdown()` establishes and what a broken taming would silently violate. Shapiro's "value is in writing the specification" is why Endo's security rests on a small, carefully-specified taming layer and a reviewable permits graph rather than on after-the-fact proof. And "policy verification is where proof pays" is the lineage of Endo's posture: the object-capability *discipline* is the policy that is argued rigorously (no authority without a reference), while individual application code is trusted to the extent its reachable authority is narrow — the same division of labor Shapiro drew between proving confinement policy and trusting the modules it confines.

Source: [cap-talk 2011-September archive](http://www.eros-os.org/pipermail/cap-talk/2011-September/) (Internet Archive original-bytes `id_` snapshot of `2011-September.txt.gz`, sha256 `62af2753`), thread "Hoare's 1980 Turing Award Lecture ... and program verification mea culpa", 2011-09-29.
