---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr972-review-2f41d5f1
verdict: not-a-miss
category: new-direction
pr: 972
review_at: 2026-08-18T16:58:47Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/972#discussion_r3806203203
identity: endojs/endo-but-for-bots#972:review:4963649085:retro
producing_role: designer
producing_job: endojs-endo-but-for-bots-pr972-7d657cf2
severity: minor
---

# Dismissal: endo-but-for-bots #972 review 4963649085 (retro)

dckc's inline comment on `docs/justin.md:372` is a one-word wording suggestion,
paraphrased: he disliked the adjective the sentence used for the
`slot`/`slotToVal` endowments and, after trying and rejecting his own first
alternative, suggested "some modified form of 'expressive'" instead. This retro
judges whether the garden **review process** (panel/gauntlet/seats/standing
instructions) should have anticipated it and concludes it could not have — this
is a reviewer's live authorial taste on a single prose adjective, not a
review-catchable defect.

Grounds (drawn from #972's actual history, not the primary's report):

- **The reviewer settled his own word choice live, across three comments in 90
  seconds.** The thread (`r3806194029` → `r3806198841` → `r3806203203`, all
  2026-08-18 16:57–16:58Z) shows dckc first suggest replacing the original word
  with "correctness-critical", then reject *his own* suggestion ("no, I don't
  like correctness-critical either… but [the original] suggests that this is not
  by design"), then land on wanting a modified form of "expressive". No fixed
  target existed for a producer to hit; the target was being discovered in the
  thread. Nothing a panel could pre-empt.

- **The original wording was not wrong, only a matter of tone.** The doc said the
  endowments were the "dangerous" ones; dckc's objection is that "dangerous"
  wrongly connotes the `slot`/`slotToVal` capability grant is *not by design*,
  when in fact it is the deliberate capability hinge of the whole notation. That
  is a nuance of authorial voice, not an error of fact, spec, or convention.

- **The surface is itself a maintainer shaping surface.** #972 is a design
  reference document explicitly framed (its own header, and the primary gauntlet
  report `pr972-7d657cf2`) as "the working record for the maintainer to lock the
  dialect", carrying open questions for maintainer review. Word-level authorial
  steering on such a doc *is* the review working as intended, not a gap in it.

- **No seat, skill, or standing instruction encodes this preference.** No
  copyeditor/stylist/pedant seat brief flags "dangerous" as a wrong word; it is a
  legitimate English adjective. A review check that fired on it would be noise. No
  `evaluator-gaming` shape either: the doc ran a real attention/directive loop
  (`pr972-7d657cf2`, commit `9f14a243e`) and the change here altered nothing the
  panel measures.

- **First stated at review time, and the directive was genuinely executed
  (not a #721-style false no-op).** The preference appears only in the review
  comment. The primary loop's asserted resolution checks out against the world:
  commit `5b740e4f3` ("docs(justin): reword 'dangerous' endowments to 'most
  expressive'", touching only `docs/justin.md`) is present on
  `origin/design/justin-subset-pass-style` and its diff replaces "The dangerous
  endowments are" with "The most expressive endowments are" at line 372; reply
  `3806221326` acknowledges dckc in-thread. The deliverable genuinely exists.

Recorded as a durable dismissal so the same review is never re-litigated. No
cluster minted; no improvement dispatched. See comment_url for the verbatim
comment.
