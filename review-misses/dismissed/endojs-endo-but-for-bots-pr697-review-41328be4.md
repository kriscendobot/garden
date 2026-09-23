---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr697-review-41328be4
verdict: not-a-miss
category: new-direction
pr: 697
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/697#pullrequestreview-4701159069
identity: endojs/endo-but-for-bots#697:review:4701159069:retro
producing_role: designer
severity: minor
grounds: >
  PR #697 ("design(sturdy-refs): cross-peer bridge, wire codec, foreign-locator
  internalization, and three-party handoff", authored by kriscendobot) is a
  DESIGN-DOC PR — a draft that edits only designs/sturdy-refs-cross-peer-bridge.md
  and designs/README.md (+489/-0, no application code). kriskowal (the repo owner
  and OCapN/Endo architect) submitted review 4701159069 (CHANGES_REQUESTED, empty
  body, body_len=0 confirmed by a read-only gh re-check in this retro) carrying
  six inline comments, judged here one by one against the PR's actual state and
  the design's own structure. Every comment is the architect steering his own
  design — several literally ANSWERING open questions the design posed — not a
  defect any review surface could have anticipated. (1) line 157, on the design's
  separate `swissNum -> formulaIdentifier` mapping store: a simplification
  QUESTION asking whether the store can be collapsed by using the formula
  identifier AS the swiss-num — an architectural preference held by the domain
  owner, first stated here. (2) line 439, on the acceptance criteria: a proposal
  to bring @endo/captp and slot-machine to parity as a FOLLOW-UP design plan —
  pure new scope, explicitly framed as a separate future plan. (3) line 447: a
  design DIRECTIVE that OCapN delegate swiss-num resolution to the daemon so
  swiss-nums are formula identifiers — the architect's chosen architecture. (4)
  line 463, landing on the design's Open-questions bullet "Should the daemon offer
  opt-in reuse of its `endo://` node key as its OCapN identity...?": the architect
  ANSWERS "Yes. The node key is intended to be the ocapn identity by design. The
  formula id is intended to be the ocapn swissnum." — resolving an open question
  the design correctly surfaced. (5) line 466, on the Open-questions bullet "Which
  netlayers arm by default...?": the architect SPECIFIES the transports (OCapN
  Noise Protocol Network, WebSocket, TCP-with-CBOR-frame) — again answering an
  open question. (6) line 463, on the enlivenment-lifetime open question: the
  architect specifies session-partitioning semantics (values enlivened by a
  session are bound to it and partitioned when the session ends). Dispositive
  structural reason, identical to the #682 design-doc dismissals: a design PR's
  scope and architecture being set by the domain owner — including direct answers
  to the doc's own Open Questions — is the INTENDED design-review workflow, not a
  work-product defect. No panel seat, pre-push gate, or standing instruction
  encodes (or could encode) kriskowal's private architectural intent that "the
  formula id is the ocapn swissnum" or which transports a given design should arm;
  that intent lives with the architect and is exactly what a design review elicits.
  The single-major severity bypass does not apply: no standing garden rule existed
  and failed to bind — there is nothing to have bound. The PR history confirms the
  garden acted correctly: the primary job (pr697-review-41328be4) read the review
  as data, aligned the bridge to formula identifiers in e4a0a614b816 (removed the
  separate mapping store, delegated swiss-num resolution to daemon formula
  resolution, set node-key=OCapN-identity / formula-id=swiss-num, specified the
  three transports, recorded session partitioning, and logged the captp/slot-machine
  parity follow-up), synced designs/README.md, replied in all six threads, and
  posted a summary comment. New direction on a design doc, not a garden
  review-process miss. Recorded as a durable dismissal so this review is never
  re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #697 review 4701159069 (retro)

PR #697 is a DESIGN-DOC PR (`design(sturdy-refs): cross-peer bridge...`,
kriscendobot) — a draft editing only `designs/sturdy-refs-cross-peer-bridge.md`
and `designs/README.md`, no application code. kriskowal (repo owner and Endo/OCapN
architect) submitted a CHANGES_REQUESTED review (empty body) with six inline
comments.

Not a garden review-process miss. Every comment is the architect steering his own
design, several answering open questions the design itself posed:

1. **Formula-id as swiss-num** (line 157) — a simplification question on the
   design's separate `swissNum -> formulaIdentifier` store; collapsing it is the
   architect's preference, first stated here.
2. **captp / slot-machine parity** (line 439) — proposed explicitly as a
   *follow-up design plan*. Pure new scope.
3. **OCapN delegates to the daemon** (line 447) — a design directive selecting the
   architecture (swiss-nums are formula identifiers).
4. **Node key = OCapN identity** (line 463) — the maintainer answers "Yes" to the
   design's own Open Question about reusing the `endo://` node key as the OCapN
   identity; the formula id is the swiss-num.
5. **Transports** (line 466) — specifies Noise Protocol Network / WebSocket /
   TCP-CBOR, answering the design's Open Question on which netlayers arm.
6. **Session partitioning** (line 463) — specifies enlivenment lifetime semantics,
   narrowing an open question the design flagged.

A design PR's architecture being set by the domain owner — including direct
answers to the doc's Open Questions — is the intended design-review workflow, not
a defect a panel seat, gate, or standing instruction could catch. Nothing encodes
kriskowal's private architectural intent ("the formula id is the ocapn swissnum")
or the transport set. The severity bypass does not apply: no standing rule existed
and failed to bind.

Same class as the #682 design-doc dismissals (review-6fca982b / 4631723f, the
architect answering a design's Open Questions and extending its scope) and the
#706 dismissal (a review that is direction and refinement, not a critique of a
work product the panel should have caught). The primary job folded all six into
the bridge design in e4a0a614b816 and replied in-thread. New direction, not a
miss. See comment_url for the verbatim review. No cluster minted; no improvement
dispatched.
