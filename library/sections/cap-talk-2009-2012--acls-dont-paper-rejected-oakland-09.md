---
title: "\"ACLs don't\": the paper's rejection from Oakland 09 and the list's reaction"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-January.txt.gz
source_content_sha256: 98e2ac19fa805064090e4f4216f8b73b10bb1ab36d041b65937c1591d6fcef3a
source_authors: [Tyler Close, John Carlson, David Wagner, Toby Murray, Alan Karp, Raoul Duke, zooko, Bill Frantz, Steve Witham, Mike Samuel, Mark Miller, Ben Laurie]
source_date: 2009-01-28 to 2009-02-01
thread_subject: "\"ACLs don't\" paper rejected from Oakland 09"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary of the mailing-list reception of Tyler Close's paper, not the paper. The paper itself is ingested as papers--close-acls-dont-2009--*."
---

Abstract: In late January 2009, Tyler Close announces to cap-talk that his paper "ACLs don't" was rejected from the 2009 IEEE Symposium on Security and Privacy (Oakland), and posts the submission, the reviews, and a revised version at `waterken.sourceforge.net/aclsdont/`. The paper argues, in the wake of the clickjacking news, that access-control lists and their derivatives cannot do the job of access control in multi-user systems like the Web, refuting the *Protection* paper's premise that ACLs and capabilities are merely two implementations of a single access-matrix model. The rejection is instructive: reviewers rated it "convincing" and "well written" yet "probably done before" and marked it a weak reject — a reviewer wrote that the non-equivalence of ACLs and capabilities is "commonly agreed" and "has been around for decades", while simultaneously (in the community's reading) not grasping the point. The thread is the primary-source record of the capability community's recurring frustration: the argument is both dismissed as obvious and not actually absorbed. This section summarizes the list's reaction; the paper's technical content is in the `papers--close-acls-dont-2009` cluster.

## The announcement

Close set out in the fall of 2008, after clickjacking made the news, to write a paper explaining "why ACLs, and derived works, cannot possibly work for access control in multi-user systems like the Web." He submitted to Oakland and was rejected (26 of 254 submissions accepted). His frustration is explicit: "AFAICT, the reviewers believe the ACL model has already fallen into complete disrepute, but simultaneously don't seem to quite get it. Other reviewers seem to have missed sections of the paper where I thought I clearly answered questions they seem to still have. I'm feeling demoralized now. Constructive criticism and productive next steps appreciated."

## The reviews as posted

Close attached the rejection email and reviews. Review #31A: overall merit "3. Weak reject", correctness "4. Convincing", presentation "4. Well written", novelty "2. Probably done before". The reviewer concedes the core claim — "the view presented in the *Protection* paper that ACLs and capabilities are merely different implementation choices for a single access model embodied by the access matrix is incorrect" — but calls it decades-old knowledge: "ACLs differ from capabilities in dozen ways or more. Simply countering a claim made in the original papers on AC might not be very relevant." The contradiction the community seized on is that the same reviewer, reading carefully, "was trying to identify items that I was not aware of before" and was "not aware of another effort that discusses all these issues" together.

## The list's productive next steps

John Carlson's presentation advice: lead with the confused deputy, then the access-matrix argument, and show concretely how a capability system stops the confused-deputy examples — "the coherent story takes too much of people's time" if it walks history-then-problem-then-solution. David Wagner engaged the argument's rigor across several messages (the technical back-and-forth that seeded the separate February *Confused Deputies in Capability Systems* thread). Steve Witham suggested that only an already-well-respected author writing a memorable "considered harmful"-style screed can dislodge received opinion; Mark Miller followed up chasing the one Google hit for "ACLs considered harmful" (a taken-down EROS lecture, recovered from a mirror). Alan Karp, Toby Murray, Bill Frantz, Ben Laurie, and Mike Samuel weighed in on framing and venue.

## Why it matters here

The episode is the 2009 reprise of a debate the archive has carried since Shapiro's 1998 answers to the same "aren't ACLs and capabilities equivalent?" intuition (see [`../sources/cap-talk-1998.md`](../sources/cap-talk-1998.md)). The persistence — a "convincing", "well written" refutation rejected as already-known yet not understood — is itself the data point: the equivalence myth is unusually resistant to correction, which is why *Capability Myths Demolished* (2003) and this paper both exist. The paper's own contribution (three structural failures of ACLs; CSRF/clickjacking/click-fraud as confused-deputy instances; the web-key fix with no infrastructure change) is captured in the [`papers--close-acls-dont-2009`](../concepts/capabilities-vs-acls.md) sections.

Source: [cap-talk 2009-January archive](http://www.eros-os.org/pipermail/cap-talk/2009-January/) (Internet Archive original-bytes `id_` snapshot of `2009-January.txt.gz`, sha256 `98e2ac19`), thread "\"ACLs don't\" paper rejected from Oakland 09", 2009-01-28 to 2009-02-01.
