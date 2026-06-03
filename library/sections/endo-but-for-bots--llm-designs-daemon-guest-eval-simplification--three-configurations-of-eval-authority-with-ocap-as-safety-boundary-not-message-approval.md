---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
---

# Three configurations of eval authority with ocap as safety boundary (not message approval)

> *`evaluate` is a "tool of tools" — having it drastically reduces
> the need for special-purpose tools.*
> *Ocap discipline is the safety boundary, not message approval.*
>
> — `designs/daemon-guest-eval-simplification.md` §Motivation

`daemon-guest-eval-simplification.md` (160 lines, *Implemented*
status, created 2026-03-21 / updated 2026-05-04, PR #92) is a
**design retrospective**: the eval-proposal handshake was removed
from the daemon in commit `90f8e910f9` (*Guests can eval without
permission*) on the `llm` branch. Guest `evaluate` now calls
`formulateEval` directly with endowments resolved in the guest's
own pet store, *structurally identical to the host path*.

## The §three-configurations-of-eval-authority taxonomy

The §Motivation enumerates the three eval-authority configurations:

1. **No eval** — *the agent advises on code but cannot execute it*.
   *Mark Miller proposed this model early in Endo Familiar's
   development: reasoning about capability composition is
   tractable, so agents should be able to *advise* on code without
   running it.* The §canonical-Mark-Miller-advisory-model.
   *Remains useful for advisory-only roles.*

2. **Eval with approval** — *the agent proposes code, the user
   reviews and grants execution. This is the current `EndoGuest`
   behavior* (at design time). *In practice, the proposal/approval
   handshake for eval fatigues users. The hypothesis that approval
   adds safety has not been borne out — users approve reflexively,
   gaining neither security nor productivity.* The §reflexive-
   approval-without-security observation is the design's
   single-most-consequential empirical claim.

3. **Eval with authority** — *the agent evaluates freely, bounded
   only by reachable capabilities. This is the current `EndoHost`
   behavior and the model that `lal-fae-form-provisioning` agents
   already use via direct eval. Object-capability discipline
   already constrains what evaluated code can do. This is the
   practical default.*

The §discipline-not-approval claim:

> *Ocap discipline is the safety boundary, not message approval.*

This is the design's *thesis*. The eval-proposal flow added
*ceremony* without adding *safety*. Object-capability discipline
(cycle 105's `daemon-capability-bank` codifies this as Design
Principle 1: *Capabilities are objects, not configurations*)
already bounds what eval'd code can reach. If the agent only has
a `Dir` for `/project`, eval'd code only has that `Dir`. *Approval
adds nothing.*

## The §evaluate-is-a-tool-of-tools observation

The §Design Decisions section restates the thesis as a structural
claim:

> *With eval, an agent can compose capabilities programmatically,
> drastically reducing the need for special-purpose tools.
> Withholding eval forces building bespoke tools for each
> composition pattern.*

The §tool-of-tools framing: a single `evaluate` capability
*subsumes* most special-purpose tools. Want to chain a `read` →
`transform` → `write` operation? Eval `({Dir}) => Dir.read('foo')
.then(transform).then(d => Dir.write('foo', d))` once instead of
inventing a *read-transform-write* tool. The agent's reach is
bounded by the capabilities passed in; the *composition pattern*
is free.

The §retreat-to-bespoke-tools observation is the cost: withhold
eval, and every composition becomes a *new tool design*. The
agent-tools surface grows linearly with use cases. With eval, *one
capability covers them all*.

## The §removed surface — what got cut

The §What is Removed list is six entries — *the entire eval-
proposal handshake*:

- **`mail.evaluate()`** — proposal-creation logic in `mail.js`
  (creates proposal message, sends to reviewer, awaits grant or
  counter-proposal)
- **`mail.grantEvaluate()` and `mail.counterEvaluate()`** —
  reviewer-side grant and counter-proposal flows
- **`EvalProposalReviewer` and `EvalProposalProposer`** message
  types
- **`host.grantEvaluate()` and `host.counterEvaluate()`** in
  `host.js` — host methods that handle eval-proposal review
- **The `Responder` exo and its `resolveWithId` method** — the
  intermediary that connects proposal responses to formula
  creation
- **Related type definitions** in `types.d.ts` for the removed
  message types and proposal/reviewer interfaces

But the §Status block adds a *correction-after-the-fact*:

> *The `Responder` exo and its `resolveWithId` method are
> preserved because they remain in use by `request` and
> `definition` message types via persisted `resolverId` fields,
> contrary to the design's assumption that they were specific to
> the eval-proposal flow.*

The §design-was-wrong-about-Responder-being-eval-specific note is
the *honest-design-correction* discipline visible in cycles 114
(familiar-unified-weblet-server's prospective status correction)
and 124 (endopi-iterative-compaction's anticipated-algorithm-vs-
shipped-substrate). Here it's a *what-the-design-thought-was-
removable-but-isn't* correction: implementing the design surfaced
a cross-cutting use of `Responder` the original analysis missed.

## The §What is Preserved list

Five items kept:

- **Pet name resolution** in the guest's own namespace — *the
  guest still resolves names against its own pet store*.
- **`formulateEval()`** — *the actual eval formula creation in
  the daemon, which compiles and evaluates code in a compartment
  with the specified endowments*.
- **The worker constraint** — *agents can only evaluate in
  workers they can access (e.g., `@main`). The worker reference
  is still resolved as a pet name*. The *ocap-bounds-which-
  worker* invariant.
- **All other message types** — *request, package, value, and
  definition messages are unaffected*.

## The §three-configurations-remain-possible-at-a-higher-level
defense

The §Design Decision 3 names the *don't-eliminate-the-other-
configurations* discipline:

> *An attenuating proxy could withhold `evaluate` from a guest's
> facet, restoring the "no eval" or "eval with approval"
> configurations. But `EndoGuest` itself does not impose approval
> by default.*

The §attenuation-via-proxy-not-via-default discipline: the design
*removes the approval flow from the default*; users who want
approval can build an attenuating proxy that withholds eval (or
implements its own approval). The capability discipline is the
*mechanism*; the choice is the *policy*. Endo's default is
*authority*; attenuation is *opt-in*.

## The §regression-test-prevents-reintroduction

The §Status block names a regression test:

> *PR #92 follows up by ... adding a regression test (`guest
> evaluate posts no message to host or guest mailbox`) that
> asserts a guest `evaluate` does not grow either side's mailbox,
> so a future re-introduction of any proposal-style send fails
> fast.*

The §regression-test-locks-in-the-removed-behavior discipline.
The eval-proposal flow *added* messages to mailboxes; the
simplification *removed* those messages. The regression test
asserts *zero mailbox growth* — a single integer invariant
that catches any future regression. The *what-was-removed-stays-
removed* invariant is now a test.

## The §three-dependencies — design-link cluster

The §Dependencies table names three sibling designs:

| Design | Relationship |
|--------|-------------|
| `daemon-agent-tools` (cycle 107) | *Simplifies the tool surface — eval covers many tool patterns* |
| `daemon-capability-bank` (cycle 105) | *Capability composition model that makes direct eval safe* |
| `lal-fae-form-provisioning` | *Agents already use direct eval via this design* |

The §design-link-cluster: cycle 105's `daemon-capability-bank`
provides the *ocap discipline that makes direct eval safe*; cycle
107's `daemon-agent-tools` is the *concrete-tool surface that eval
subsumes*; `lal-fae-form-provisioning` is the *already-uses-direct-
eval* prior art that proves the model works.

## Why this matters for the daemon family

The eval-proposal handshake was a *holdover from the No-eval and
Eval-with-approval* configurations. Removing it *commits the
default to capability-discipline-only safety*. Cycle 105's
`daemon-capability-bank` Design Principle 1 (*Capabilities are
objects, not configurations*) is now the *only* safety boundary
for guest eval. The simplification *aligns the implementation
with the discipline*.

The 2026-04-24 / 2026-05-04 update history (created 2026-03-21,
PR #92 merged later) shows the design's lifecycle:
*design-then-implement-then-correct*. The Status block has been
edited *after implementation* to reflect what actually happened
(the Responder preservation correction).

## Related sections

- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — Design Principle 1 (*Capabilities are objects, not
  configurations*) is the *ocap-is-the-safety-boundary* thesis
  this design rests on.
- cycle 107
  [[endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-and-git-as-claw-like-agent-capabilities]]
  — the concrete-tool surface this design's §tool-of-tools
  observation subsumes.
- cycle 101
  [[endo-but-for-bots--llm-designs-daemon-commands-as-messages--ai-agent-commands-routed-as-form-and-value-messages]]
  — the §evaluate-subsumes-eval-proposal-pair structural
  simplification cycle 101's table predicted (in the *promise,
  no trace* → *command + reply* migration table; this design is
  the deeper change that removed the proposal pair entirely).
- cycle 124
  [[endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking]]
  — sibling *partially-satisfied-by-already-shipped* lifecycle
  pattern; this design's *Implemented* status with §honest-
  correction (Responder preservation) is the same discipline
  applied to a *removal* rather than an *addition*.
