---
source: designs/daemon-guest-eval-simplification.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2b787690c940f563f8c567a8aac13a0c0ca49b91
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Twenty-eighth-comment-style design ingest. **First daemon-*
  design ingest after the endopi-* family closed at 9/9 (cycles
  112-131).** 160-line *Implemented* design (PR #92) — created
  2026-03-21, updated 2026-05-04. A design retrospective: the
  eval-proposal handshake was removed from the daemon in commit
  `90f8e910f9` (*Guests can eval without permission*); guest
  `evaluate` now calls `formulateEval` directly with endowments
  resolved in the guest's own pet store, *structurally identical
  to the host path*.

  §Three configurations of eval authority:
    1. **No eval** — *Mark Miller proposed this model early in
       Endo Familiar's development* (the §canonical-Mark-Miller-
       advisory-model); *agent advises on code but cannot execute
       it*.
    2. **Eval with approval** — was the *current EndoGuest
       behavior* at design time; *in practice, the proposal/
       approval handshake fatigues users*; *the hypothesis that
       approval adds safety has not been borne out — users
       approve reflexively, gaining neither security nor
       productivity* (the §reflexive-approval-without-security
       observation is the design's single-most-consequential
       empirical claim).
    3. **Eval with authority** — the EndoHost behavior and the
       model that lal-fae-form-provisioning uses; *object-
       capability discipline already constrains what evaluated
       code can do; this is the practical default*.

  Single most structurally interesting thesis: *Ocap discipline is
  the safety boundary, not message approval*. Cycle 105's
  daemon-capability-bank Design Principle 1 (*Capabilities are
  objects, not configurations*) is now the *only* safety boundary
  for guest eval.

  §`evaluate` is a "tool of tools" observation: *with eval, an
  agent can compose capabilities programmatically, drastically
  reducing the need for special-purpose tools; withholding eval
  forces building bespoke tools for each composition pattern*.
  The §tool-of-tools framing: one capability subsumes special-
  purpose tools.

  §Six items removed (the entire eval-proposal handshake):
  mail.evaluate / mail.grantEvaluate / mail.counterEvaluate /
  EvalProposalReviewer + EvalProposalProposer message types /
  host.grantEvaluate + host.counterEvaluate / the Responder exo
  (originally listed for removal but corrected in §Status —
  Responder is preserved because it's used by request and
  definition message types via persisted resolverId fields,
  *contrary to the design's assumption that they were specific to
  the eval-proposal flow*; the §honest-design-correction
  discipline applied to a *removal* rather than an *addition*).

  §Five items preserved: pet name resolution in guest namespace;
  formulateEval (the actual compilation + execution); the worker
  constraint (agents can only evaluate in workers they can access
  like @main); all other message types (request, package, value,
  definition); the regression test (`guest evaluate posts no
  message to host or guest mailbox`) that asserts zero mailbox
  growth so any future re-introduction of proposal-style send
  fails fast.

  §Three-configurations-remain-possible-at-a-higher-level defense
  — *an attenuating proxy could withhold evaluate from a guest's
  facet, restoring the "no eval" or "eval with approval"
  configurations*. The *attenuation-via-proxy-not-via-default*
  discipline: the design removes the approval flow from the
  default; users who want approval can build an attenuating proxy.

  Three §Dependencies: daemon-agent-tools (cycle 107; *simplifies
  the tool surface — eval covers many tool patterns*); daemon-
  capability-bank (cycle 105; *capability composition model that
  makes direct eval safe*); lal-fae-form-provisioning (*agents
  already use direct eval via this design*).

  Cycle 133 was nominally papers-lane (cycle 132 was comments).
  Papers-lane has been blocked for 27+ consecutive cycles. With
  the endopi-* family closed at 9/9, cycle 133 pivots to
  designs-lane to explore the daemon-* family (~25 unexplored
  designs as of cycle 131's note).
---

> Abstract: `daemon-guest-eval-simplification.md` (160 lines,
> *Implemented* status, PR #92) is a **design retrospective** —
> the eval-proposal handshake was removed from the daemon in
> commit `90f8e910f9` (*Guests can eval without permission*).
> Guest `evaluate` now calls `formulateEval` directly with
> endowments resolved in the guest's own pet store, *structurally
> identical to the host path*.
>
> §Three configurations of eval authority: (1) No eval (Mark
> Miller's early advisory-only model); (2) Eval with approval
> (was the EndoGuest default; *users approve reflexively, gaining
> neither security nor productivity*); (3) Eval with authority
> (now the EndoGuest default; ocap is the safety boundary).
>
> **Single most structurally interesting thesis**: *Ocap
> discipline is the safety boundary, not message approval*. The
> eval-proposal flow added *ceremony* without adding *safety*.
> Cycle 105's daemon-capability-bank Design Principle 1
> (*Capabilities are objects, not configurations*) is now the
> *only* safety boundary for guest eval.
>
> §`evaluate` is a "tool of tools" — one capability subsumes
> special-purpose tools. *Withholding eval forces building bespoke
> tools for each composition pattern*.
>
> §Status block correction: the Responder exo is preserved
> (contrary to the original design's assumption) because it's
> used by request and definition message types — the §honest-
> design-correction discipline applied to a *removal*.
>
> §Regression test asserts zero mailbox growth — *future
> re-introduction of any proposal-style send fails fast*.
>
> §Three-configurations-remain-possible-at-a-higher-level via
> attenuating proxy — *the default is authority; attenuation is
> opt-in*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval](../sections/endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval.md) | agent-conventions, capability-security | current |

Tight 160-line *Implemented* design. The whole argument hangs off
the §three-configurations taxonomy and the §ocap-is-the-safety-
boundary thesis. One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@2b787690` (the
  branch `origin/llm`) via the local bare-clone.
- Created 2026-03-21 by Kris Kowal; updated 2026-05-04. Last
  touched 2026-05-06 by Kris Kowal in commit `2b787690`. PR #92
  shipped the implementation.
- Status: *Implemented*. The design is a retrospective: the
  implementation commit `90f8e910f9` (*Guests can eval without
  permission*) preceded this Status update.
- **Twenty-eighth-comment-style design ingest.** First daemon-*
  family ingest after the endopi-* family closed at 9/9 (cycles
  112-131). The daemon-* family has ~25 unexplored designs as of
  cycle 131's note.
- Cycle 133 was nominally **papers-lane** (cycle 132 was
  comments). Papers-lane has been blocked for **27+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 133
  pivoted to designs-lane.
- Cohesion-honest one-section count.
