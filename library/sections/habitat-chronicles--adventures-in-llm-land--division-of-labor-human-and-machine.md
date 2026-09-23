---
title: The division of labor between human and machine — the machine makes, the human wants ("the AI can make things for you, but it can't want things for you")
source_kind: web-essay
source_url: https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/
source_content_sha256: a4ddab90a5eb77fac616b8e9177dc7555f9086c787dad0ff39b4010f94094cc9
source_author: Chip Morningstar
source_date: 2026-02-18
ingested: 2026-07-11
ingested_by: scholar
topics: [agent-fleet-orchestration, patterns]
status: current
---

## Abstract

The essay's central design claim, and the one most germane to the garden:
successfully building with AI agents is a problem of **maintaining the proper
division of labor between you and the machine** — the machine "doing all the heavy
lifting involved in making the mechanical parts," the human "doing the expressive
parts." Morningstar reaches this through the difference between his two projects (a
functional "do *this*" target succeeded on the first try; an aesthetic
"everything-just-so" target took two months of correction) and through the axiom
*"the AI can make things for you, but it can't want things for you."* Because the AI
*wants nothing*, it can only guess at what *you* want; a vague, mushy want yields
"the kind of slop that everybody is criticizing," while a want articulated "with
completeness and precision" is one you have effectively already built yourself. The
human's irreducible job, in a world of capable agents, "is to want things" — to know
or figure out what is wanted and then express it. Note the phrase: Morningstar frames
this as a **division of labor**, the same term his separate [unum-pattern](../sources/habitat-chronicles--unum-pattern.md)
essay uses for factoring a distributed object across presences — here the axis is
human-versus-machine rather than presence-versus-presence, but the move (partition
authority by what each party is uniquely positioned to be authoritative about) is the
same. See the concept [[wanting-as-the-human-role]].

## Content

Morningstar draws the distinction from his own two projects. His first (the
book-catalog web app) had "a whole lot more stuff that needed to be *just so* for me
to be happy with it"; his second (the phone scanner app) "was defined in almost
purely functional terms: do *this*" and "worked perfectly on the first try." The
generalization:

> When you write a spec for something you intend to create yourself, you end up
> leaving out a lot of details, especially aesthetic details ... You can get away
> with omitting that stuff because you're going to automatically follow your own
> instincts anyway as you proceed to implement it.

Handing the spec to another implementer (human or machine) removes that
silent-instinct backstop, so "you've no doubt had the experience of getting results
very different from what you wanted." He crystallizes this into a parallel of Ed
Koch's line ("I can *explain* it to you, but I can't *understand* it for you"):

> "The AI can *make* things for you, but it can't *want* things for you."

Because the AI wants nothing of its own, it can only try to guess what *you* want:

> At best, the AI can try to guess what *you* want. If what you want is vague and
> mushy then its guess will be vague and mushy too, and you're going to get the kind
> of slop that everybody is criticizing. On the other hand, if what you want is
> *not* vague and mushy, then you have to communicate this with completeness and
> precision, at which point you don't need the AI to write the story for you because
> you've just written it yourself.

(He notes the qualifier that you *can* outsource your wanting — but "this amounts to
handing control of your mind over to someone else: what you get is what *they* want,"
and the AI's apparent wants "largely reflect the wants of whoever set it up.")

Software, unlike a pure work of art, "is much more of a functional mechanism than a
pure act of expression," which is exactly why the division of labor is tractable:

> The big challenge in using AI tools for software creation is maintaining the proper
> division of labor between you and the machine. The machine's job is doing all the
> heavy lifting involved in making the mechanical parts (which for a human could
> consume hours or days or even years of somebody's life to implement), while your
> job is to do the expressive parts.

He grounds it in a non-AI precedent — a sculptor who uses CAD, NC-machining, and 3D
printers, whose output "nobody would argue ... are not *her* creations" — and states
the resulting human role directly:

> In a world with AI, your job is to want things. The key to successfully creating
> things is the ability to know or figure out what you want, and then the ability to
> express this. Both the knowing and the expression are hard ... but they're still
> 100% human ... Note that this formulation goes beyond AI assisted software
> development. I think it applies equally well to using AI for anything.

For the garden, this is the human-maintainer half of the fleet contract made
explicit: the gardeners supply the mechanical heavy lifting; the maintainer (through
the liaison) supplies the wanting — the objectives, the taste, the "this is what I
want, precisely enough that you can execute it."

Source: [Adventures In LLM Land, With Thoughts On The AI Revolution](https://habitat-chronicles.com/2026/02/adventures-in-llm-land-with-thoughts-on-the-ai-revolution/) by Chip Morningstar, 2026-02-18 (content sha256 `a4ddab90`).
