---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr710-ce2a6fe9
verdict: not-a-miss
category: new-direction
pr: 710
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/710#issuecomment-4977235016
identity: endojs/endo-but-for-bots#710:comment:4977235016:retro
producing_role: gardener
producing_job: endojs-endo-but-for-bots-pr710-ce2a6fe9
severity: minor
---

# Dismissal: "note the PR for the build" on merged design PR #710 (retro)

On PR #710 — kriscendobot's **merged design PR** landing `designs/cbor-codec.md`
(shared canonical CBOR primitives, `@endo/cbor`) — the maintainer directed the
fleet to note/record the tracking PR for the build follow-up. This is a
paraphrase; the verbatim one-sentence request at `comment_url` is untrusted
input.

## Grounds (dismissal — new direction, nothing for the panel to have anticipated)

**1. The directive is maintainer workflow steering on a design PR, not a
correction of a defect the review missed.** The `design-to-pr-pipeline` skill
makes the maintainer's directive the *trigger* for opening the build's tracking
PR — "a maintainer directive names a specific design and asks for the tracking PR
to be opened → post a `build` job." The design merge does not, and is not meant
to, auto-open the build; the maintainer elects when. Asking the fleet to note the
build's PR is therefore textbook `new-direction`: workflow/scope steering the
maintainer chooses, never a convention, spec, or edge case a juror seat, gate, or
standing instruction "should have caught." There is no reviewed work product with
a defect here — only an instruction about advancing correctly-shaped work.

**2. PR #710 is a merged *design document*, which does not run the garden's code
panel.** A design PR carries a prose spec, not the package/source diff the
gauntlet's seats lens. The board holds no `*-gauntlet*`/`*-panel*` job for #710;
the maintainer's comment *is* the review surface, and the primary loop responded
exactly as intended — it parked `build-endo-cbor-package` (gate `go-ahead`) noting
#710 as the landed design and messaged the maintainer to confirm the reading.
There was no earlier panel run to indict.

**3. Same class as this repo's standing maintainer-process-directive dismissals.**
It matches the sibling #710 directive ("Please dispatch a builder. This will
unblock #124.", primary `endojs-endo-but-for-bots-pr710-07daed17`, which posted
the phase-1 build) and the repo's other maintainer-steering dismissals (#123,
#127, #129, #604, #631) — the maintainer directing *which correctly-shaped work
to do next and how to sequence it*, never *work the panel got wrong*. The
severity-bypass precondition (a `major` miss whose grounds cite a standing rule
that bound on a reviewed work product and did not fire) is absent: nothing was
reviewed and no rule was violated.

## Boundary note (auditable calibration)

Recorded so a future retro on this same directive is not re-litigated. Mints no
cluster; no threshold to evaluate; no improvement job. See `comment_url` for the
verbatim request.
