# Design: a bid/accept market with differentiated, reputation-bearing gardeners

| Created | 2026-06-29 |
| Author  | gardener |
| Status  | Proposed |

Tracks issue [kriskowal/garden#15](https://github.com/kriskowal/garden/issues/15).
The maintainer's directive: replace the straight first-to-claim race with a
**bid/accept** workflow, make gardeners **differentiated** (by assigned role —
hence skill mix — and by the model used to design or build) and **reputation-
bearing** (built by competing to produce an accepted implementation), and sketch
the further-out layers (gardeners subcontracting to gardeners; a meta-machine
where whole gardens compete; bootstrapping reputation from journal `todo`/`tada`
pairs).

This is a focused, decision-forcing proposal on the **first actionable layer** —
bid/accept over one job kind, with reputation as a scored journal ledger — with
the recursion and meta-machine captured as explicit future directions.

## The reflexive observation, made load-bearing

Issue #15 is the Gimix thread, and the prior grounding comments already name the
reflexion: **the garden is a running, bot-operated Gimix.** This design treats
that as the engineering premise, not a flourish. The current job board is the
*degenerate case* of the market the directive asks for:

| Gimix / AMiX concept | Garden today (degenerate) | This design (generalized) |
| --- | --- | --- |
| Bounty market for issue completion | The job board (`jobs/todo`) | Same board, with a bid phase |
| Responder claims an assignment | `claim-job.sh` first-to-push CAS | A bid record + a selector's accept |
| Oracle attests delivery | judge/CI panel (`panel.sh`) | Same panel as the **objective** oracle |
| Reputation for information goods | The journal (latent, unscored) | A scored `reputation/` ledger |
| Computer-mediated, not -conducted | The push-CAS serialization point | Preserved verbatim — no lock service |

So this design **generalizes existing machinery**; it does not start from
scratch. Every new mechanism below reduces, when the bid phase is empty and the
selector is "first bid wins," to exactly today's behavior — which is what makes a
phased, non-breaking rollout possible (§6).

## What AMiX tells us to keep

The three lessons from [what Agoric learned from
AMiX](https://agoric.com/blog/technology/what-agoric-learned-from-amix), as
distilled in the issue's grounding comments, are design constraints here:

1. **Computer-mediated, not computer-conducted.** The platform lets the parties
   see their own terms upheld; it is not a party to the trade. For the garden this
   is the **push-is-the-serialization-point** invariant: the journal CAS mediates,
   it does not adjudicate. Every new state transition below lands as a
   single-writer fast-forward push, exactly like `claim-job.sh` today. **No lock
   service is introduced.**
2. **Hybrid objective/subjective acceptance.** Automate the measurable
   (tests pass, CI green, judge panel), keep a clean audit trail for the
   subjective (is the work *good*), so disputes have something to arbitrate
   against. This is §4.
3. **Reputation for information goods.** A digital deliverable can't be inspected
   pre-sale without handing it over; a merged/accepted artifact *is* the delivery
   and the inspection at once. Reputation is what lets a selector pick before
   delivery. This is §3.

---

## 1. Bid/accept replacing the straight race

### 1.1 The lifecycle, extended

Today a job moves `todo → doin → tada` and the claim is the accepted push. The
market inserts a **bid/accept handshake** between `todo` and `doin`:

```
open ──post──▶ todo ──(bids accrue)──▶ todo+bids ──accept──▶ doin ──submit──▶ submitted
                                                                │
                                       reject ◀──oracle/selector judges──┘
                                          │
                                          └──requeue──▶ todo  (work preserved; §4.3)
```

Concretely, over the journal:

- **open → bidding.** A producer posts `jobs/todo/<base>.md` as today, but a job
  that opts into the market (a `market: bid` field in its frontmatter; §6) is
  **not directly claimable**. Instead it accrues bids.
- **a bid is a record** under `jobs/bids/<base>/<bidder>.md` — one file per
  bidder, basename-spined to the job. A bid is **append-only and CAS-safe by
  construction**: a bidder only ever writes *its own* file under the job's bid
  directory, so two bidders never collide (the push fast-forwards; the filename is
  the bidder's identity). This is the same safety argument as a per-doer inbox
  message. A bid file carries the bidder's differentiation and offer (§1.2).
- **accept → doin.** A **selector** (§1.3) picks one bid and performs the
  CAS-move that today's `claim-job.sh` performs: `git mv todo/<base> doin/<base>`,
  stamp `accepted_bid: <bidder>` and the winning bid's terms, create
  `work/<base>` + `inbox/<base>/`, commit, **push**. The accepted push *is* the
  award, exactly as the claim is the award today. First selector to push wins; a
  rejected push means another selector already awarded it — back off, no
  re-award. The losing bids are left in `jobs/bids/<base>/` as the audit trail and
  are swept to `tada` provenance on completion.
- **submit → submitted.** The awarded gardener works in `work/<base>` and, when
  done, writes a **submission** rather than completing outright: it moves
  `doin/<base> → jobs/submitted/<base>` with a pointer to the produced artifact
  (the PR, the design doc, the branch SHA). This is the "responder opens a PR and
  claims it closes the issue" step.
- **accept/reject (the oracle).** The oracle/selector judges the submission
  (§4). On **accept**, the job completes normally (`tada/<base>`, reputation
  credited; §3). On **reject**, the work is **requeued without loss** (§4.3) and
  the rejection is recorded against the bidder's reputation.

Every arrow is a single-writer fast-forward push. The plan category (`jobs/plan/`,
parked work) is untouched and orthogonal.

### 1.2 What a bid is

A bid file (`jobs/bids/<base>/<bidder>.md`) carries leading YAML frontmatter:

```
---
bidder: <gardener-id>@<host>
role: builder | designer | web-builder | fixer | ...      # the assigned context
model: opus-4-8 | sonnet-4-6 | haiku-4-5 | ...            # the model it will use
skills: [coverage-driven-testing, adversarial-tests, ...] # advertised skill mix
reputation: { accepted: 41, rejected: 3, score: 0.86 }    # snapshot, self-asserted; verified against the ledger
estimate: { tier: standard, confidence: high }            # optional self-estimate
bid_at: <iso8601>
---
<a short prose pitch: why this gardener is suited to this job>
```

The differentiation axes (§2) live in this record. A bid is cheap to produce —
the bidder is *not* doing the work yet, only advertising suitability — which is
what bounds the bidding-phase cost (§1.4).

### 1.3 Who accepts: the selector

"Who accepts" is a pluggable **selector**, mirroring the pluggable handlers the
job board already uses (`GARDEN_JOB_HANDLER` etc.). Three selector kinds, in
increasing autonomy:

1. **Maintainer selector.** The liaison surfaces the bid set (via the bulletin)
   and the maintainer awards by hand. This is the `go-ahead` shape applied to
   awards — used for expensive/risky/novel work.
2. **Scoring-function selector** (the default for routine work). A deterministic,
   no-LLM function ranks bids by a weighted combination of advertised reputation
   (§3), role/skill fit to the job's declared kind, and model-tier appropriateness
   (cheaper tier preferred when adequate, per the model-selection principle). The
   foreman runs it on a cadence, exactly as it already auto-promotes deferred plan
   jobs. The scoring function is journal-tunable config, not code.
3. **Acceptance-oracle selector** for the *submission* stage — distinct from bid
   selection; see §4.

The selector is a **single writer of the award push**; concurrency among
selectors resolves by the same CAS as concurrent claims today. There is no new
coordination primitive.

### 1.4 The cost, stated honestly: when a race still wins

Bidding is **not free**. It adds:

- **Latency.** A bid window (a bounded wait for bids to accrue) delays the start
  of work versus today's instant claim. For a job whose only viable doer is "any
  idle gardener," that wait is pure overhead.
- **Wasted competing work — but only at the *submission* tier.** At the *bid*
  tier the competition is cheap (bids are pitches, not implementations). The
  expensive form of competition — **multiple gardeners actually building the same
  job and only one submission being accepted** — is a deliberate, opt-in mode
  (§5's "competitive build"), not the default. The default market awards **one**
  bid and runs **one** implementation; the bid phase only chooses *who*, it does
  not duplicate the work.

**When the straight race is still preferable**, and stays the default:

- High-volume, low-differentiation, mechanical work (rebase, retcon, refresh,
  shepherd-to-green) where any gardener is as good as any other. Bidding buys
  nothing and costs latency. These keep `market: race` (today's behavior).
- Latency-critical work (a CI-green deadline).
- An empty or near-empty fleet, where there is no competition to select from.

So **both modes coexist permanently** (§6): `market: race` is the default and is
literally today's `claim-job.sh`; `market: bid` opts a job kind into the
handshake. The market is the *generalization*, not a wholesale replacement — the
race is the market with a zero-length bid window and a first-bid-wins selector.

---

## 2. Differentiated gardeners

Today every `garden-gardener@N` is interchangeable: same handler, claims by
index offset. The directive asks for two differentiation axes, and the garden
already has the seeds of both.

### 2.1 Axis A — assigned role (hence skill mix)

The garden's `roles/` library already differentiates capability: a `builder`, a
`web-builder`, a `designer`, a `fixer`, a `shepherd` each read a different
`AGENT.md` and load a different skill set. Today the *job* names the role and any
gardener wears it. The market inverts this: a gardener **advertises** the role(s)
it is configured for, and the selector matches the job's declared kind to a
bidder's role fit.

Mechanically: a gardener's standing config (under `hosts/<host>` or a new
`gardeners/<id>` journal record) declares its role repertoire and skill mix. The
triager/foreman already classify a job's *kind* (web-frontend vs. general; design
vs. build) — that classification becomes the **demand signal** the selector
matches against the bid's advertised **supply**.

### 2.2 Axis B — the model used to design or build

`skills/model-selection` already makes the per-task model-tier choice canonical.
Today the *dispatcher* picks the tier. The market lets a gardener **bid its tier**:
a gardener backed by Opus bids on hard design/build jobs at a higher reputation-
weighted cost; a Haiku-backed gardener bids on mechanical jobs cheaply. The
selector's scoring function (§1.3) prefers the **cheapest tier adequate to the
job**, which is exactly the model-selection principle expressed as a market
preference rather than a dispatcher's lookup.

This makes the fleet **heterogeneous by construction**: a host can run a mix of
Opus/Sonnet/Haiku-backed gardeners across a mix of role repertoires, and the
market routes each job to the cheapest adequate (role, model) pairing that has a
good reputation for that kind of work.

### 2.3 How differentiation reaches the selector

Differentiation is **advertised in the bid** (§1.2: `role`, `model`, `skills`)
and **scored by the selector** (§1.3). The selector never inspects the gardener's
internals; it reads the bid record, exactly as AMiX's platform reads a seller's
posted terms rather than auditing the seller. Computer-mediated, not -conducted.

---

## 3. The reputation ledger

### 3.1 Where it lives

A new journal tree, **`reputation/`**, single-writer-per-file like every other
journal surface:

```
reputation/gardeners/<id>@<host>.md     per-gardener running tally
reputation/by-kind/<kind>/<id>.md       per-(gardener, job-kind) tally  (optional, derived)
reputation/ledger/<Y>/<M>/<D>/...       append-only event log (the source of truth)
```

The **ledger** is append-only events; the per-gardener tallies are **derived
projections** the foreman recomputes (so a tally is never the contended write
surface — events are appended, tallies are rebuilt). An event:

```
---
event: accepted | rejected
gardener: <id>@<host>
base: <job-base>
kind: <job-kind>
role: <role-worn>
model: <model-used>
oracle: panel | maintainer | scoring     # who decided
at: <iso8601>
---
<one-line citation: the PR/design/SHA, and the disposition reason>
```

### 3.2 What accept/reject does to it

- **Accepted submission** → append an `accepted` event; the derived score rises.
- **Rejected submission** → append a `rejected` event; the score falls, *and* the
  rejection reason is retained (so a pattern — "this (role, model) keeps failing
  adversarial-tests on web jobs" — is legible).

Reputation is **per-kind**, not just global: a gardener excellent at mechanical
fixes but weak at design carries two different reputations, and the selector uses
the **kind-matched** one. This is the AMiX lesson 3 made concrete — reputation is
the standing inspection record that lets a selector pick an information good
before delivery.

### 3.3 How it feeds selection

The scoring-function selector (§1.3) weights a bid by the bidder's **kind-matched
reputation**. The bid file's self-asserted `reputation` snapshot is a convenience;
the selector **verifies it against the ledger** (the ledger is authoritative — a
gardener cannot inflate its own score, because the score is a projection of an
append-only event log the gardener does not own). This is the escrow-and-attest
discipline: the claimant asserts, the platform verifies against its own records.

### 3.4 Bootstrapping (forward pointer)

The cold-start problem — a new gardener has no reputation — is addressed by the
bootstrapping future direction (§5.3): replay existing journal `todo`/`tada`
pairs as synthetic jobs to seed initial scores. For the first actionable layer,
new gardeners start at a neutral prior and the selector applies a mild
exploration bonus (try the unproven bidder occasionally) so reputation can
actually accrue rather than locking out newcomers.

---

## 4. The acceptance oracle (subjective/objective split)

"Accepted" is the AMiX hybrid: **automate the objective, keep judgment for the
subjective.**

### 4.1 Objective oracle (automated, already built)

The objective terms are exactly what the garden already automates:

- `local-verify` (format/lint/build/test/docgen) — the deterministic pre-PR gate.
- CI green on the opened PR.
- The **judge/CI panel** (`scripts/jobs/gardening/panel.sh`,
  `designs/judicial-workflow.md`) — the jury fan-out and fixer loop.

A submission that fails any objective gate is **objectively rejected** with no
human in the loop — the panel *is* the oracle for "did the work meet the
measurable bar," precisely as Gimix's oracle verifies "did a PR close the issue."

### 4.2 Subjective oracle (judgment, with an audit trail)

The subjective term — *is the work good, is it the right design* — keeps a human
or agent judge, but the AMiX discipline is **leave a clean audit trail so a
dispute has something to arbitrate against.** The panel already emits per-juror
blocks and dispositions; those become the subjective audit record attached to the
submission. The maintainer-selector (§1.3) is the apex subjective oracle for
design-only or novel work; routine work rides on the panel's verdict.

The split is the same one AMiX drew and the garden independently rebuilt:
objective → scripted/panel; subjective → judge + audit trail. This design just
*names* it as the acceptance oracle and wires its verdict to the reputation
ledger.

### 4.3 How a rejection unwinds without losing the work

A rejection must not strand the work. The unwind:

1. The submission's artifact (branch/PR/design) is **never discarded** — it stays
   on its branch, referenced from the ledger event.
2. The job moves `submitted → todo` (requeue), carrying a `prior_attempt: <SHA>,
   <reason>` pointer so the next awarded gardener **starts from the rejected work
   plus the rejection reason**, not from scratch. This is the existing
   `prior_attempt`/fixer-loop shape generalized: a rejection is a fixer hand-off
   with the panel's reason as the brief.
3. The rejected bidder takes the reputation hit (§3.2); the requeued job may be
   re-bid by *anyone*, including a fixer-role gardener better suited to closing
   the gap.

This preserves the no-loss property the reaper already guarantees for crashed
claims, extended to *judged* rejections.

---

## 5. Future directions (sketched, deliberately not specified)

These are the directive's further-out layers. Each is named with its open
questions and left for a follow-on design.

### 5.1 Recursion — gardeners subcontracting to gardeners

A gardener awarded a large job could **decompose it and post sub-jobs to the same
board**, becoming a *producer* for its subcontractors and an *aggregator* of their
submissions. The market is already symmetric (any agent can post; any can bid), so
the mechanism mostly exists.

Open questions: how does a subcontractor's reputation flow up to the
prime contractor's? How is the prime's bounty split? How is a cycle (A
subcontracts to B who subcontracts back to A) prevented? How deep may recursion
go before the coordination cost exceeds the work? Does a sub-job's rejection
cascade to reject the parent submission? — *Follow-on design.*

### 5.2 The meta-machine — a Gimix of gardens

Going upward: **whole gardens compete for bids and hold reputation.** A garden
becomes a single differentiated bidder in a market of gardens; the journal job
board is the intra-garden market, and a higher market routes bounties *between*
gardens. This is the Gimix-on-Endo target from the issue's grounding comments —
the garden as the first reference deployment and first customer.

Open questions: the cross-garden transport (Endo Gateway / CapTP, per the
grounding comments)? What backs an inter-garden bounty — reputation-only, or real
value (the asset-origin question the grounding comments flagged as the line
between demo and real market)? Trust topology — single operator vs. federation?
How does a garden's *internal* reputation ledger aggregate into its *external*
standing? — *Follow-on design, depends on the Gimix-on-Endo design pass.*

### 5.3 Reputation bootstrapping from `todo`/`tada` replay

The directive's concrete bootstrap: replay existing journal `todo`/`tada` (and
the project's `todo`/`tada` lineage from pivoker) pairs as **synthetic jobs** — an
agent **poses as the customer**, drives feedback until the artifact converges to
the known-good `tada` (identical, near-identical, or passes-identical-tests), and
the gardener that converges earns seed reputation. This gives the cold-start
market a credible initial ranking without waiting for live work to accrue it.

Open questions: how is "convergence" scored — exact match, diff distance, or a
re-run of the original's tests? Does posing-as-customer risk overfitting gardeners
to historical artifacts rather than general capability? How are `tada` artifacts
whose tests no longer pass (drift) excluded from the replay set? — *Follow-on
design.* The convergence-by-identical-tests idea is the strongest objective
handle and is the natural first cut.

---

## 6. Migration / coexistence — rolling in without breaking the fleet

The straight race must keep working until the market is proven. The rollout is
**additive and phased**, and at every phase the default path is byte-for-byte
today's behavior.

- **Phase 0 — race is the default; market is opt-in per job kind.** Add a
  `market: race | bid` field to job frontmatter, defaulting to `race`. A `race`
  job is claimed by exactly today's `claim-job.sh` — **no code path changes for
  existing jobs.** Only a job explicitly posted `market: bid` enters the handshake.
  The first opt-in kind is something low-stakes and naturally differentiated (e.g.
  `design` jobs, where role/model fit genuinely matters and latency is acceptable).

- **Phase 1 — shadow reputation.** Stand up the `reputation/` ledger and record
  accept/reject events for *all* jobs (including race jobs, retroactively from
  `tada`) **without** letting reputation affect selection yet. This accrues a real
  ledger to validate the scoring function against, at zero behavioral risk. The
  bulletin surfaces the shadow scores so the maintainer can sanity-check them.

- **Phase 2 — bid/accept on the opt-in kind, scoring-selector live.** Turn on the
  scoring-function selector for the opt-in kind only. The maintainer-selector is
  available as an override. Measure: does the market route work to better-suited
  gardeners than the race did, and is the latency cost worth it?

- **Phase 3 — widen by evidence.** Opt additional job kinds into `market: bid`
  only where the §1.4 cost/benefit favors it. Mechanical/high-volume kinds stay
  `race` indefinitely. **Both modes are permanent**; the market is the
  generalization, not a deprecation of the race.

- **Rollback at every phase is trivial**: a job kind reverts to `market: race`
  with a one-field change and is back to today's instant claim. The reputation
  ledger is append-only and harmless if ignored.

This honors the maintainer's standing posture — generalize the existing
machinery, prove it in shadow before it bites, never break the live fleet.

---

## 7. What this design decides, and what it defers

**Decides** (the first actionable layer):

- The bid/accept handshake as an **additive** lifecycle (`todo → bids → doin →
  submitted → tada`), every transition a single-writer fast-forward push — **no
  lock service, the push stays the serialization point.**
- A bid is a per-bidder CAS-safe record advertising **role, model, skills,
  reputation**.
- Selection is a **pluggable selector** (maintainer / scoring-function /
  oracle), defaulting to a deterministic no-LLM scoring function.
- Reputation is a **per-kind, append-only ledger** with derived tallies, verified
  by the selector, fed by accept/reject events.
- Acceptance is the **AMiX hybrid**: objective via `local-verify` + CI + panel;
  subjective via judge + audit trail; rejection requeues the work without loss.
- Coexistence is **race-by-default, bid-opt-in, shadow-first, permanently dual-
  mode.**

**Defers** (follow-on designs, §5): gardener-to-gardener subcontracting; the
meta-machine of competing gardens (depends on the Gimix-on-Endo pass);
reputation bootstrapping by `todo`/`tada` replay with a customer-posing agent.

## References

- [`designs/job-board.md`](job-board.md) — the claim/complete CAS this layers over.
- [`designs/gardening-state-machine.md`](gardening-state-machine.md) — how a
  gardener supervises a job.
- [`designs/judicial-workflow.md`](judicial-workflow.md) — the panel that is the
  objective acceptance oracle.
- [`skills/job-board/SKILL.md`](../skills/job-board/SKILL.md) — the concrete
  claim race and the plan category.
- Issue [kriskowal/garden#15](https://github.com/kriskowal/garden/issues/15) and
  its grounding comments — the Gimix lineage, the AMiX objective/subjective split,
  escrow-and-attest, and reputation-for-information-goods.
- [What Agoric learned from
  AMiX](https://agoric.com/blog/technology/what-agoric-learned-from-amix) — the
  three lessons that are the design constraints.
