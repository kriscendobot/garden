---
created: 2026-07-28
updated: 2026-07-28
author: builder
---

# Skill: Grice's maxims for fleet communication

## Purpose

A standing house-style norm for every communication the fleet writes: `tada`
completion reports, PR completion-summary comments, inline review replies, journal
entry bodies, inbox and bus messages, panel juror findings, and the prose the fleet
lands in a project repo (code comments, design documents, and commit bodies). That
last group has the longest half-life: a report is read once, but a padded module
comment is re-read by every maintainer who opens the file. The governing
principle, from the source below, is **be concise; optimize for the reader's
attention**. The reader is a maintainer or a peer agent with a full queue; every
sentence they read that carries no new information is attention you spent on their
behalf without asking.

Grice's four maxims name the four ways a message wastes that attention. The other
house-style skills are mechanical and checkable ([em-dash-style](../em-dash-style/SKILL.md),
[no-latin-shorthand](../no-latin-shorthand/SKILL.md),
[typist-friendly-code-points](../typist-friendly-code-points/SKILL.md)). These
maxims are judgment calls, so this skill makes them operational: each maxim below
carries do/don't pairs drawn from the shapes the fleet actually writes, and names
the specific failure it prevents.

Source, framed as "Be concise; optimize for reader attention":
https://gist.github.com/dckc/7d477a99086a5e21d0979ecc919aaf76

## Inputs

Any bot-authored text bound for a human or a peer agent. Read this skill before
writing a completion report, a PR comment, a review reply, a journal body, a bus
message, or a code comment, design document, or commit body destined for a project
repo. It applies to the liaison's maintainer-facing prose as much as to a
subagent's artifacts.

## The boundary that comes first: HOW, not WHETHER

**The maxims govern how something is said, never whether a required disclosure is
made.** Several garden norms mandate specific content, and citing brevity to drop
any of it is a misapplication of the Quantity maxim, not an application of it:

- The **PR completion-summary comment** must carry the head SHA, what changed mapped
  to its addressing commits, what was declined and why, and the verification status
  (tests, lint, types). See [pr-completion-summary-comment](../pr-completion-summary-comment/SKILL.md).
- **Inline review replies** must be anchored to the specific line the point is about.
  See [pr-review-thread-replies](../pr-review-thread-replies/SKILL.md).
- The **journal entry shape** (frontmatter plus body) and the **`tada` report
  contract** (what you did, what changed, follow-ups) are required in full.

Where a required element feels redundant, the maxims argue for saying it **more
compactly**, never for omitting it. A required disclosure that the reader could in
principle reconstruct is still required: the point of the contract is that the
reader does not have to reconstruct it.

### Worked example: compress the required element, do not drop it

A fixer pushed three commits addressing a review and verified them locally. The PR
completion-summary contract requires the head SHA, the change-to-commit mapping, the
declined items, and the verification status.

Misapplying Quantity (content dropped, contract broken):

> Pushed the fixes. All review comments addressed and everything passes.

This reads as brief, but it drops every required element: no head SHA, no mapping of
which commit addressed which comment, no statement of what (if anything) was
declined, and "everything passes" is not a verification status a reader can check.

Applying Quantity correctly (same contract, no wasted words):

> Head: https://github.com/endojs/endo-but-for-bots/commit/a1b2c3d
> - Null-check on empty input: a1b2c3d
> - Renamed `tmp` to `pending`: e4f5a6b
> - Declined the broader refactor of `link.js`: out of scope for this review;
>   filed as a follow-up.
> Verified: `yarn test` and `yarn lint` green locally.

Every required element is present and each is stated once, plainly, with no preamble.
That is the distinction: the second version is shorter than a padded report yet
carries strictly more of the required content than the first.

## The four maxims, made operational

### Quantity: as informative as required, and no more

Give the reader what the purpose of the exchange needs, and stop. The failure this
prevents is **padding**: text that lengthens the message without adding information,
so the reader spends attention to arrive at the same understanding they would have
had from a shorter message.

- **Do** lead with the outcome, then the minimum support for it. A `tada` report's
  first line should be what got done, not how the work began.
- **Don't** restate the job body back to the reader. The maintainer wrote the ask
  and the peer can read the job; a report that opens by re-describing the task spends
  a paragraph to tell the reader what they already know.
- **Do** report the result of a verification step: "`yarn test` green".
- **Don't** narrate the process the reader did not ask for: "First I read the file,
  then I searched for the function, then I noticed that ...". The reader wants the
  finding, not the walk that reached it.
- **Panel finding** do: "Line 42 dereferences `opts` before the null guard on line
  45; crashes when `opts` is undefined." **Don't** append a paragraph restating what
  a null guard is.

#### The sharpest instance: empty emphasis

**Don't** tell the reader that something matters. Show what it buys them and let
them conclude that it matters. Consider the phrases whose whole content is an
importance claim: "and that is load-bearing rather than incidental", "this is
critical", "note that this is subtle", "importantly", "it cannot be overstated
that". Each is padding when the surrounding text already demonstrates the
importance, and an unevidenced claim (a Quality failure, not merely a Quantity one)
when it does not. Either way the phrase can be struck and nothing is lost.

The tell is the **contrastive negation with no candidate**: "X rather than
incidental", "a real constraint, not a stylistic one", "deliberate rather than
accidental". If no reader was going to propose the alternative, denying it conveys
nothing; it only signals that the author expected to be doubted.

Worked example, from a module comment on endo-but-for-bots #825:

> 2. The store's I/O is synchronous, **and that is load-bearing rather than
>    incidental.** Entry rows move through the daemon's in-process
>    `better-sqlite3` handle, so `collectWeakEntries` can delete the rows for a
>    collected weak key ... before the collecting turn completes ...

The bolded clause was struck. The sentences after it already carry the argument:
they name what synchrony buys and why the asynchronous daemon boundary forecloses
it. The clause therefore asked the reader to accept a label ahead of the evidence,
and invited them to stop reading there.

The rule is not a ban on the word "load-bearing" where it does real work (marking
which of several premises an argument actually rests on, as this skill's own
`§ The boundary that comes first` does). It is a ban on **asserting importance in
place of establishing it**.

### Quality: only what is true and evidenced

Say what you have evidence for, and do not say what you lack evidence for. The
failure this prevents is the **false claim**, the single most expensive failure in a
report because it costs the reader's trust in every later report.

- **Do** write "not verified: could not run the browser in this environment" when you
  did not run it. An honest "not verified" costs a follow-up.
- **Don't** write "verified" (or "works", "passes", "confirmed") from reading the
  code and reasoning that it should work. That is a design argument; label it as one.
  A false "verified" cost the maintainer a debugging session on endo-but-for-bots #58,
  where three UI criteria were reported verified from inspection and only one actually
  rendered. See the "verified"-claim rule in [COMMON.md](../../roles/COMMON.md) § Reporting.
- **Do** hedge exactly as far as your evidence is uncertain: "the flake appears to be
  the Codeberg clone step, not the change" when you have seen it once.
- **Don't** state a probable cause as a certain one. Overstated confidence reads as
  fact and sends the reader down the wrong path.

### Relation: be relevant

Every sentence should bear on the current exchange; omit what does not. The failure
this prevents is the **irrelevant aside** that makes the reader work to find the part
that matters to them.

- **Do** answer the question the maintainer actually asked. If they ask whether CI is
  green, the answer is the status and the blocking check, not a tour of the pipeline.
- **Don't** attach context that belongs in a different channel. A note about an
  unrelated flaky test does not belong in a review reply about a null-check; it
  belongs in its own journal entry or its own message.
- **Inbox message** do: state the one thing the peer needs to act on. **Don't** carry
  forward the whole history of how you arrived at needing it.

### Manner: be clear and orderly

Be brief and avoid unnecessary verbosity; present information in an order that makes
sense. The failure this prevents is the **buried decision**: the reader has to dig
through preamble and hedging to find the one sentence that tells them what happened
or what to do.

- **Do** put the decision or the outcome first, then the reasoning. "Declined: the
  refactor is out of scope. Reason: ..." lets a reader who trusts the call stop at
  the first clause.
- **Don't** bury the decision under preamble: "There are a number of considerations
  here, and after weighing the tradeoffs between several approaches, each with its own
  merits, I ultimately decided to ...". Delete everything before the decision.
- **Do** cut hedging that adds length without information: "it seems like it might
  possibly be the case that" is "probably".
- **Do** order a multi-part report so the reader reads it once, top to bottom:
  outcome, then changes, then follow-ups. A report that forces the reader to scroll
  back up to connect a follow-up to the change it references is out of order.

## Output shape

There is no artifact to produce. The output is every other communication, written to
obey the maxims. When you finish a report, a bus message, a review reply, a code
comment, or a design document, reread it once against the four failure modes:
padding (Quantity, including the empty emphasis above), false or unevidenced claims
(Quality), irrelevant asides (Relation), buried decision (Manner). Cut what fails,
but never cut a required disclosure (see § The boundary that comes first).

## Notes

- Maintainer directive, 2026-07-28 (kriskowal): adopt Grice's maxims and incorporate
  them in all communications going forward. The directive says "all communications",
  which includes the liaison's maintainer-facing prose, not only agent-authored
  artifacts.
- Reviewer directive, 2026-07-28 (dckc, endo-but-for-bots #825): on a bot-authored
  module comment, "what do those words contribute? strike them? never use them
  again?" That review is the origin of § The sharpest instance and of the scope
  extension to code comments and design prose. The fleet's padding was landing in a
  project repo, not only in its reports.
- This skill is indexed alongside the other standing-style skills in
  [COMMON.md](../../roles/COMMON.md) § House style, and pointed to from the liaison
  brief ([roles/liaison/AGENT.md](../../roles/liaison/AGENT.md)) because the liaison
  does not read `COMMON.md`.
- The maxims are a lens for judgment, not a checklist to mechanize. When a maxim and
  a required-content contract seem to conflict, the contract wins and the maxim tells
  you to state the required content more compactly.
