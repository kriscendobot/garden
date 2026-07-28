# Make the garden's `drain` / `lift` vocabulary precise

Garden-library prose job on **`main2`** (the garden's own repo — direct push, no
PR; CLAUDE.md § Conventions). No script behavior changes.

## The correction (maintainer, 2026-07-28)

The word **drain** in this garden names an **act**, not a fixture. Precisely:

> **Drain** = *enact a moratorium on undertaking further work, while allowing
> work already in progress to finish.* The `doin/` board drains — that is the
> thing being drained. **Lift** = *relax the moratorium*; workers resume
> claiming.

The metaphor is **draining as a process** (a pool emptying because inflow
stopped and outflow continues), **not a physical drain** (a plughole, a valve, a
cork). Every phrasing that treats it as a fixture is wrong and should be
corrected wherever it appears: *uncork the drain*, *plug the drain*, *open the
floodgate*, *unblock the drain*.

**Scope guard — this is NOT a rename.** The maintainer was explicit: "I am not
recommending a change but more precise language." Keep every existing name and
interface exactly as-is:

- `scripts/jobs/drain-fleet.sh on | off | status` — unchanged, all three verbs.
- The marker filename `.garden-state/draining` and `GARDEN_DRAINING_MARKER` —
  unchanged.
- The operator vocabulary `drain` / `lift` / `stand up` / `stand down` —
  unchanged.

The deliverable is **explanatory prose**, plus teaching these terms to new
operators. If you find yourself editing a script's behavior, an env var, or a
command name, you have left the job.

## Evidence this is worth fixing

In a liaison session on 2026-07-28 the *liaison itself* wrote "uncork the
drain" back to the maintainer, and the maintainer's own next message reached for
"plug the drain and open the floodgate" — then stopped to note the metaphor was
bad. Two participants, both fluent in the garden, both slid to the fixture
reading within one exchange. The prose is not carrying the concept.

Note also that `drain` is **overloaded** in the docs with a second, unrelated
referent: README.md ~line 261 says "when the board **drains** entirely, the
foreman ..." — there it means the **`todo/` board empties of work**, which is a
*consequence of the fleet working*, the near-opposite of a moratorium. And the
liaison "drains the broadcast bus" (reads unread messages). Decide per site
whether to disambiguate in place or leave it — do not mechanically rewrite every
occurrence; judgement over sweep.

## Surfaces to correct

Canonical page first; the rest should defer to it rather than restate.

1. **`context/operations/scaling.md` § Pausing: drain** — the canonical operator
   page and the right home for the definition above. Its current text ("Drain is
   the **graceful pause**: no work is killed, in-flight jobs run to completion,
   and no new jobs are claimed") is substantively correct but never names the
   moratorium framing or what is being drained. Add both, and the explicit
   not-a-fixture note.
2. **`context/operations/starting.md` step 6** — currently titled "Check for a
   stale drain and **uncork** it" and uses "uncork" again in the surrounding
   prose. This is the clearest instance of the wrong metaphor; it is also on the
   bring-up path every new operator walks. Fix to "lift".
3. **`roles/liaison/AGENT.md`** § Stand up / stand down (~lines 182–186) and the
   § Drain aftermath paragraph (~lines 227–238) — align the wording; these are
   the liaison's operating norms and set the language it speaks back to the
   maintainer.
4. **`README.md`** § Key vocabulary (~line 94, `stand up / stand down / drain`)
   and the operating verbs list (~line 129) — a one-clause gloss so the term is
   defined where a newcomer first meets it.
5. **`CLAUDE.md`** — the stand-up/stand-down/drain mention under § Orchestrator
   vocabulary. Keep it to a clause; CLAUDE.md is auto-loaded and space there is
   expensive.
6. **`context/first-run/README.md`** — the guided tour. This is the "explain
   these terms to new operators" half of the ask: a new operator should learn
   `drain` / `lift` *as a moratorium* the first time they meet it, not absorb the
   fixture reading and have to unlearn it.
7. **`scripts/jobs/drain-fleet.sh`** — **prose only**, inside the marker file it
   writes (lines ~34–46) and the header comment. The marker body already says
   "graceful pause, not a kill"; add the moratorium sentence so an operator who
   finds a stale marker reads the right concept. Do not touch the logic, the
   marker path, or the subcommand names.

Other files matched a `drain|uncork` grep (`skills/restore/SKILL.md`,
`context/operations/{deploy,leader-follower,health}.md`,
`designs/deliberate-deploy.md`, `roles/gardener/AGENT.md`, and others). Sweep
them for the fixture metaphor specifically; most are expected to be fine already
and should be left alone. Do not touch `designs/` history — a design doc records
what was decided at the time and is not retconned for wording.

## Definition of done

- `context/operations/scaling.md` carries the moratorium definition and the
  not-a-fixture note; the other surfaces defer to it rather than restating it.
- No occurrence of *uncork / plug / floodgate* framing survives in `roles/`,
  `skills/`, `context/`, `README.md`, or `CLAUDE.md`.
- A new operator reading `context/first-run/README.md` learns `drain` and
  `lift` correctly on first contact.
- **Zero behavior change**: `git diff` touches no script logic, no command name,
  no marker path, no env var. Prose and comments only.
- Committed and pushed to `main2` directly (no PR for the garden's own repo),
  with a `tada` report naming each file touched and quoting the one-sentence
  definition as landed.
