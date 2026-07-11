---
title: Conclusion — capabilities as computer security's germ theory
source_kind: web-essay
source_url: https://habitat-chronicles.com/2017/05/what-are-capabilities/
source_content_sha256: e16d5cf32c414a9030be031eb61e56e4c80a0fa9d1110c58ed7701d1d123f66f
source_author: Chip Morningstar
source_date: 2017-05-07
ingested: 2026-07-11
ingested_by: scholar
topics: [capability-theory]
status: current
---

## Abstract

Morningstar's closing thesis and the essay's acknowledgements. **The capability paradigm
is about organizing access control around specific acts of authorization rather than
around identity.** Identity is so fundamental to human and institutional interaction that
we assume it should be central to our interactions with tools too — but "identity is not
always the best place to start, because it often fails to tell us what we really need to
know to make an access decision." Organizing access control around **"who are you?"** is
*incoherent* because "the answer is fundamentally fuzzy": on any web interaction the
intentional agent is not just *you* but the tens of thousands of authors of the OS,
browser, server, libraries, page scripts, ads, routers, and proxies in the path — "Do you
really want to grant all those people the power to act as you? ... but that's pretty much
what you're actually doing, quite possibly thousands of times per day." He frames
capabilities as **computer security's germ theory** — an imperfect analogy he keeps
returning to "largely because of the ugly and painful history of germ theory's slow
acceptance": presenting capability ideas to security people, engineers, and bosses
usually meets not argument but *indifference* ("you may well be right, but…"), because
"people have trouble absorbing ideas that they don't already have at least some tentative
place for in their mental model of the world." The acknowledgements list situates the
essay squarely in the ocap community — the Friam group and cap-talk list — naming (among
others) **Norm Hardy, Alan Karp, Mark Miller, Kevin Reid, and Kris Kowal**.

## Content

"At its heart, the capability paradigm is about organizing access control around specific
acts of authorization rather than around identity." Identity is central to how humans and
institutions interact, so it is easy to assume it should be central to how we organize
interactions with our tools — "But identity is not always the best place to start, because
it often fails to tell us what we really need to know to make an access decision (plus, it
often says far too much about other things, but that's an entirely separate discussion)."

**Why "who are you?" is incoherent.** "The answer is fundamentally fuzzy." The driving
intuition is that the human who clicked the button is the one who wanted the thing to
happen — "But this is not obviously true, and in some important cases it's not true at
all." Interacting with a website, who is the intentional agent? You — but also the authors
of every piece of software between you and the site: your OS, the browser, the web server
and its OS, "the thousands of commercial and open source libraries," the page's own
scripts (site content plus ads plus "another unpredictably large bundle of libraries and
frameworks"), and intermediaries "like your household or corporate wireless access point,
not to mention endless proxies, routers, switches." "Is it really correct to say that any
action taken by this vast pile of software was taken by you? Even though the software has
literally tens of thousands of authors ... Do you really want to grant all those people
the power to act as you? I'm fairly sure you don't, but that's pretty much what you're
actually doing, quite possibly thousands of times per day. The question that the
capability crowd keeps asking is, 'why?'"

**Germ theory.** Morningstar cites security guru Marcus Ranum — "After all, if the
conventional wisdom was working, the rate of systems being compromised would be going
down, wouldn't it?" — and offers his recurring analogy: "I'm on record comparing the
current state of computer security to the state of medicine at the dawn of the **germ
theory of disease**. I'd like to think of capabilities as computer security's germ
theory." The analogy is imperfect (germ theory is about causality; here we mean "the right
sort of building blocks"), but he keeps returning to it "largely because of the ugly and
painful history of germ theory's slow acceptance." Presenting capability ideas to people
"who ought to know about them — security people, engineers, bosses," the typical response
"is not argument, but indifference," the most common pushback "some variation of 'you may
well be right, but…' usually followed by some expression of helplessness or passive
acceptance of the status quo." People "have trouble absorbing ideas that they don't
already have at least some tentative place for in their mental model of the world; this is
just how human minds work. My hope is that some of the stuff I've written here will have
given these ideas a toehold in your head."

## Acknowledgements

The essay "benefitted from a lot of helpful feedback from various members of the
Capabilities Mafia, the **Friam** group, and the **cap-talk** mailing list, notably David
Bruant, Raoul Duke, Bill Frantz, **Norm Hardy**, Carl Hewitt, Chris Hibbert, Baldur
Jóhannsson, **Alan Karp**, **Kris Kowal**, William Leslie, **Mark Miller**, David Nicol,
**Kevin Reid**, and Dale Schumacher." (This roster situates the essay directly in the ocap
lineage this library documents — the same community behind the E language, KeyKOS/EROS,
SES/Hardened JavaScript, and Endo.)

Source: [What Are Capabilities?](https://habitat-chronicles.com/2017/05/what-are-capabilities/) by Chip Morningstar, 2017-05-07 (content sha256 `e16d5cf3`).
