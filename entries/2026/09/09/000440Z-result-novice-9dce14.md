---
kind: result
role: novice
host: endolin-garden2-5bcdff64
at: 2026-09-09T00:04:41Z
---
Panel seat `novice` (design panel) on `kriscendobot/endo-but-for-bots` PR #1227,
`designs/daemon-guest-bot-incarnation.md` (diff base `51b99651`, head `c98690585`).

### novice (top-down clarity, new-reader pass)

**Verdict:** request-changes

**Findings:**

- `designs/daemon-guest-bot-incarnation.md:109` — `provide` and `controllerForId`
  appear for the first time already load-bearing: the whole one-incarnation-per-guest
  invariant rests on "`provide` is memoized per formula identifier". The Background
  closes by listing the terms it equipped the reader with (formula, caplet,
  incarnation, bot, supervisor) and `provide` is not among them, so a new reader
  reaches the design's central argument without the mental model it needs. Add one
  Background sentence: providing a formula yields its incarnation, and the daemon
  memoizes that by formula identifier so one identifier means one live incarnation.
  Must-fix. [rule: roles/jurors/novice/AGENT.md § Operating norms (b) assumed background]

- `designs/daemon-guest-bot-incarnation.md:336,443` — two different counters are both
  called the failure count, and `getBotStatus` reports both as `failures`. Line 336
  distinguishes a consecutive count that drives backoff delay from a rolling-window
  rate that drives the breaker, then `backoff` and `blocked/crash-loop` each carry a
  bare `failures` field. The reader cannot tell which number each variant reports, and
  the answer changes what an operator concludes. Name them distinctly in the union.
  Must-fix. [proposed-rule: when a design defines two counters over the same events,
  the status surface must give them distinct field names]

- `designs/daemon-guest-bot-incarnation.md:107-137` — the one-incarnation rule is stated
  twice with opposite force. The first paragraph reads as "distinct identifiers give you
  distinct incarnations"; the next opens by saying that is not sufficient and distinctness
  is a checked precondition. A reader who stops at the first has the wrong model, and the
  second reads as a correction rather than a continuation. State the rule once: distinct
  `bot` identifier per guest is required, and provisioning rejects a collision.
  Should-fix. [rule: skills/gricean-maxims/SKILL.md § Manner]

- `designs/daemon-guest-bot-incarnation.md:454-484` — one 27-line paragraph carries at
  least five claims (what `stopBot`/`retryBot` do, process-locality, why this is not the
  re-probe rationale, the accepted scope risk, the rebind/collect lever, the deferral),
  and line 481's "Both resolve once..." then runs on with no break, 27 lines from its
  `stopBot`/`retryBot` antecedent. The referent is lost. Split, and restate the subject.
  Should-fix. [rule: skills/gricean-maxims/SKILL.md § Manner]

- `designs/daemon-guest-bot-incarnation.md:191` — "The manager owns a bot-incarnation
  supervisor" introduces "the manager" with no prior mention; the reader learns only in
  Affected Packages that it is `manager.js`. One clause in Background placing the manager
  relative to the daemon closes it. Should-fix.
  [rule: roles/jurors/novice/AGENT.md § Operating norms (b) assumed background]

- `designs/daemon-guest-bot-incarnation.md:512-519` — "retained-child ledger" and
  "retained-child slot" arrive as known quantities in the section that makes a
  load-bearing assumption about them. A new reader has no model of what a retained child
  is in Endo terms before being asked to accept the slot-once accounting. One defining
  sentence before the assumption. Should-fix.
  [rule: roles/jurors/novice/AGENT.md § Operating norms secondary surface]

**Notes (out of scope but worth flagging):**

- The document defines six states, a protocol, a hook, and two breakers but never traces
  one message end to end. A five-line walkthrough after The mailbox commit hook (mail
  arrives at a dormant guest, commit, wake, start, drain, clean exit to dormant) would
  carry a new reader through the whole design at a fraction of the cost of the prose that
  currently does that work in pieces. Test Plan item 3 is the nearest thing and it is a
  test, not a narrative. [proposed-rule: a design that introduces a state machine should
  include one worked end-to-end trace through the happy path]

Self-improvement: the novice's simulated-new-reader pass gets steadily less faithful on a
design already through four panel rounds, because accreted round-by-round paragraphs read
as corrections of earlier text rather than as first-pass prose. Findings 3 and 4 above are
both that shape. Worth noting in `roles/jurors/novice/AGENT.md` that on a late-round design
the seat should flag "this paragraph reads as a patch on the one before it" as its own
category; no other seat is positioned to see it. Routed to the gardener as a proposal, not
landed here.
