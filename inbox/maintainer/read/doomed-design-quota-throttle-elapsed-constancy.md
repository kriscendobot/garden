from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T05:43:12Z
doom_base: design-quota-throttle
doom_signature: elapsed-constancy
notice_count: 1
first_seen: 2026-08-19T05:43:12Z
last_seen: 2026-08-19T05:43:12Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 2 elapsed-constancy confirmations on endolin-garden-ece02cb4.
The handler repeatedly failed at a near-constant elapsed below its wall-clock budget.
The first confirmation was requeued; the reaper parked only after the 2-confirmation threshold.
Read the handler log for the fast failure cause. Raising the handler budget will not help.
The work is preserved at jobs/plan/design-quota-throttle; it stays HELD until a human promotes it
(promote-plan.sh design-quota-throttle) or removes it.
Original job base: design-quota-throttle

--- original job body ---
---
role: designer
target: main2
posted_by: liaison (interactive session, maintainer-directed)
posted_at: 2026-08-19
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: auto-throttle gardeners on quota exhaustion, auto-restore on quota reset

Wear the designer role (`roles/designer/AGENT.md`) and produce a design doc
(`designs/quota-throttle.md`) per the usual designer/AGENT.md procedure — this is
a garden-self change, so it lands as a direct commit to `main2` (no PR; see
CLAUDE.md § Conventions, "No PR workflows for the garden's own repo").

## Motivation (today's incident, cite for grounding)

2026-08-18 00:23 UTC: `garden2` (`endolin-garden2-5bcdff64`) hit a Claude quota
window. A wave of jobs died mid-flight — 5 requeue cycles each, then doomed by
the reaper — including `kriscendobot-minion.town-pr47-review-237136a0`, which
silently swallowed a maintainer's PR review reply for over a day before anyone
noticed. At least half a dozen other jobs doomed in the same ~40-minute window
on the same host. The maintainer inbox accumulated 28 unread doom notices, most
attributable to the same root cause. The fix that exists today
([[gardener-pool-quota-throttle]] memory) is manual: someone eyeballs the
situation and runs `set-workers.sh gardener 2` by hand, and someone else has to
remember to scale back up later. That's the gap this design closes.

## The ask (maintainer directive, verbatim intent)

> Add a mechanism to automatically throttle gardeners down on a host if the
> quota gets hit, while posting a commensurate job to throttle back up when the
> quota is restored. This must be sensitive to the difference between session
> quota and weekly quota for Claude and Codex. Ollama is not quota'd locally.
> The others are not quota'd but require explicit manual funding.

Unpack that into requirements:

1. **Detect** a quota-exhaustion event on a host, per provider (Claude,
   Codex), as early as possible — ideally at the point a single job's `claude
   -p`/`codex` call fails on quota, NOT after 5 requeue cycles' worth of doom.
   Reuse the existing classifier rather than re-deriving it:
   `scripts/jobs/test/claude-session-limit-classifier-test.sh` already
   distinguishes `session` vs `weekly` wording ("You've hit your session limit
   · resets 1:10am (UTC)" vs "You've hit your weekly limit · resets Aug 15,
   3am (UTC)") and captures the reset timestamp. Check whether an equivalent
   classifier/signal exists for Codex (`provider-quota-backoff-test.sh`,
   `outage-doom-pause-test.sh`, `handlers/codex-provider-common.sh` — audit
   these) or needs to be added on the same shape.

2. **React** by throttling this HOST's worker count for the affected
   provider/kind DOWN — likely to 0, or to whatever floor keeps a
   non-Claude-dependent class (kimi/codex/ollama) still claiming work, mirroring
   the existing "endolin Claude-quota route" exemption logic already referenced
   in `scripts/jobs/set-workers.sh` (read that comment block — there is
   precedent for a temporary quota-driven floor-of-zero already reasoned about
   there). Use `set-workers.sh <kind> <N>` as the mechanical primitive — it is
   already host-scoped-only-writes-its-own-host, which is exactly the safety
   property this needs.

3. **Schedule the restore**, not just react to it:
   - **Session quota**: short reset window with an explicit reset time in the
     capture text — schedule (or post a deadline-nudge-style timed follow-up,
     see `scripts/jobs/deadline-nudge.sh`) a throttle-back-up action for that
     exact reset time, rather than blind-polling.
   - **Weekly quota**: longer window, same idea — the reset date/time is in
     the captured string; use it. Cross-check against
     `skills/restore/SKILL.md` (the existing manual, human-triggered recovery
     playbook) — this design should be understood as the automatic,
     host-scoped, PER-PROVIDER-QUOTA-TRIGGERED analogue of that skill's worker
     pool reactivation step, not a replacement for the rest of restore (dead
     letters, orphaned claims are a different failure class and stay
     human-triggered).
   - Consider whether the "post a commensurate job to throttle back up" is
     better expressed as a scheduled restore action (`skills/schedule/SKILL.md`
     — `set-schedule.sh` CAS-races a one-shot or recurring job onto the
     journal) OR a host-directed sysop op (`scripts/jobs/sysop.sh`, which
     already has `set-workers` in its closed vocabulary, § the sysop in
     CLAUDE.md) sent with a delay. Pick one, justify it, don't build both.

4. **Provider-specific handling, all three tiers named explicitly**:
   - **Claude, Codex**: quota'd, both session- and weekly-scoped, auto-throttle
     down + scheduled auto-restore per above.
   - **Ollama**: never quota'd (local compute) — must be explicitly EXEMPT from
     this mechanism; a Claude/Codex quota hit on a host must not throttle
     Ollama-backed workers, and the design should say so as a stated
     non-goal/exclusion, not just an omission.
   - **Everything else** (kimi/moonshot and any other paid API arm): not
     quota'd in the rate-limit sense, but constrained by manual funding
     ([[true-cost-vs-notional-ledger]], [[rate-card-attempt-cap-unimplemented]]
     memories are relevant background) — a funding exhaustion is a DIFFERENT
     failure shape (no programmatic reset time, needs a human to fund the
     account) and should NOT be auto-throttled the same way. Design the
     detection to distinguish "quota, will reset" from "funding exhausted, needs
     a human" and route the latter to the maintainer inbox instead of
     scheduling an automatic restore that can't possibly fire correctly.

## Ground in existing infrastructure — audit before designing net-new

Before proposing new mechanism, read and cite (accept/reject/extend each):
- `scripts/jobs/quota-panel.sh` — per-provider spend/quota visibility already
  computed for the bulletin; may already have the signal this needs to poll
  rather than re-derive.
- `scripts/jobs/set-workers.sh`, `scripts/jobs/gardener-scaler.sh` — the
  worker-count primitive and the service that reconciles a host's pool to a
  declared count.
- `scripts/jobs/sysop.sh` (§ the sysop, CLAUDE.md) — the deterministic,
  no-LLM, host-directed op channel already carrying `set-workers`; likely the
  right substrate for "post a commensurate job to throttle back up" if that
  job needs to land ON a specific host regardless of who authored it.
- `scripts/jobs/foreman.sh` / `brake-foreman.sh` (§ The foreman brake,
  CLAUDE.md) — precedent for a lightweight journal-backed flag distinct from
  the all-or-nothing fleet drain; this quota-throttle marker likely wants
  the same shape (host-scoped, journal-backed so it survives a leader
  handoff if relevant, existence-is-the-signal, fails safe).
- `scripts/jobs/reaper.sh`, `scripts/jobs/test/outage-doom-pause-test.sh` — the
  existing doom-pause-during-outage logic; this design should REDUCE how often
  that path is even exercised (react before doom, not after), and should not
  duplicate it.
- `designs/kimi-k3-takes-opus-work-with-opus-fallback.md` — a DIFFERENT axis
  (per-job model reroute on Claude quota pressure) that already exists; state
  explicitly in the new design how host-level worker throttling and per-job
  reroute-to-fallback interact (do they compete for the same signal? does
  reroute make throttling unnecessary for some kinds but not others?).
- [[gardener-pool-quota-throttle]] memory — the manual precedent this
  automates; [[tier-routing-claude-off-automatic]] and
  [[reroute-role-floor-audit]] memories — recent related tier-routing work,
  make sure this doesn't collide with it.

## Deliverable

A design doc at `designs/quota-throttle.md` stating: the detection signal per
provider/quota-type, the throttle-down mechanism (host-scoped, via
`set-workers.sh`), the scheduled-restore mechanism (with session vs weekly
handled distinctly, using the captured reset time when available), the
Ollama exclusion stated explicitly, the funding-exhaustion-vs-quota
distinction for the manually-funded providers, and how this interacts with
existing kimi-fallback and foreman-brake mechanisms. Follow with a
`chore: Update yarn.lock`-style clean commit if any lockfile moves (unlikely
for a docs-only design commit). A `build-quota-throttle` implementation job
follows once the design lands and the maintainer reviews it — do not build
the mechanism in this job; design only.
