Wear `roles/designer/AGENT.md`. **Design only — do not implement.**

**Project: the garden itself** (`kriscendobot/garden`, formerly `kriskowal/garden`). Override the designer role's default PR output: per CLAUDE.md § Conventions the garden opens no PRs against itself. Commit the single design file `designs/post-verdict-addressee.md` directly to `main2` from your per-job garden worktree with a rebase CAS push. Touch nothing else — no `scripts/`, no `roles/`, no units.

## The gap

A botanist that renders **MERGE-NOW** hands the PR to `scripts/jobs/gardening/ci-wait-merge.sh`, which blocks at the maintainer-approval gate (`scripts/jobs/handlers/pr-maintainer-approval-gh.sh`; see `ci-wait-merge.sh:288-294`) and reports the PR "left claimable: not merged, not stranded." The reviewing job then **completes**, and `complete-job.sh` tears down `inbox/<base>/`. From that moment the disposition is un-executed but **no living agent is addressable for it**.

Any later correction therefore has nowhere to land. `inbox-send.sh` dead-letters it into `inbox/dead/`, and `deadmail.sh` promotes it to a generic `deadmail-<msgid>` gardener job that carries the message text but none of the reviewing job's context, so a fresh gardener must re-derive the whole review to act on one correction.

**Precipitating evidence.** `endojs/endo-but-for-bots#269`: MERGE-NOW posted 2026-07-28 07:17Z, overturned by a base-ref census at 07:51Z (the diff was a proven no-op — all 28 base call sites already at the target hash). The correction had to travel through dead-letter job `deadmail-20260728T074423Z-6bee53`, and *this* design job is that job's follow-up. `roles/botanist/AGENT.md:108` now documents the anti-pattern ("a verdict you already posted is not final") but only as discipline; it does not close the delivery gap. Had the correction been lost instead of rescued, a maintainer's approval would have been spent merging a no-op.

## The asymmetry worth interrogating

**EMBARGO already has a durable follow-up; MERGE-NOW does not.** An embargoed PR gets a ledger row, a precise self-deleting one-shot recheck at the maturity floor (`set-schedule-once.sh`), and a daily backstop heartbeat (`roles/botanist/AGENT.md:73-100`) — the PR is *guaranteed* re-assessed. MERGE-NOW is classed a **terminal** verdict (it *removes* the ledger row, `AGENT.md:98`) even when the merge did not actually happen because the gate blocked. Treat "terminal verdict" vs. "executed disposition" as the likely root cause and decide explicitly whether the fix belongs at that classification, at the delivery layer, or both.

## Prior art to weigh (do not reinvent it)

- **Parked-doer delivery.** `inbox-send.sh:80-124` already distinguishes *parked-but-unclaimed* (a base sitting in `plan/`/`todo/` — pre-create `inbox/<doer>/unread/` and stage; `claim-job.sh`'s non-clobbering `mkdir -p` preserves it) from *gone/completed* (dead-letter). A successor job parked under a stable PR-keyed base would be a live addressee for free.
- **Schedule carry-forward.** `deadmail.sh` already special-cases a recurring schedule's dead mail into a durable, timestamp-free per-name mailbox (`schedule_carry_forward_dir`) injected into the next tick — the closest existing instance of "a durable addressee that outlives the ephemeral doer."
- **Self-deleting one-shots** (`set-schedule-once.sh`) and the **daily heartbeat** backstop — the embargo pattern's two legs.
- **Orchestration** (`skills/orchestration/SKILL.md`, `roles/orchestrator/AGENT.md`, the leader-only `orchestrate.sh` watcher, `--on-child-failure halt|continue`) — a supervisor that outlives its children, already deterministic and `claude -p`-free.
- **Watchers** as re-post triggers: `dependabot-watcher.sh`, `ci-watcher.sh`, `comment-watcher.sh`, `unblock.sh`, and the `blocked_on` + promote substrate.

## Decisions the design must land

1. **Which mechanism** — durable addressee, re-post on gate-clear, supervising orchestration, or a composite — with the alternatives-considered reasoning, not just the winner.
2. **Scope.** Is this botanist/MERGE-NOW-specific, or the general shape "a job whose disposition is blocked on an external gate it cannot itself clear"? Name which other roles share it (conductor at the same gate, shepherd, weaver) and whether the mechanism generalizes or should deliberately not.
3. **The wake trigger.** What re-animates the addressee: `reviewDecision` flipping to APPROVED, the merge landing, a timer, an inbound message, PR close? Who evaluates it, and is that evaluation deterministic (no LLM) like `unblock.sh`/`orchestrate.sh`?
4. **Liveness and cost.** Twenty gardener slots exist and jobs block cheaply, but a parked-forever supervisor per gated PR is still a leak. Specify the **termination** condition and a garbage-collection story, including the interaction with `reaper.sh` / `GARDEN_CLAIM_TTL` and with the proxy's `plan/` parking.
5. **Context carried.** What must survive from the reviewing job so the woken addressee acts on a correction without re-deriving the review — and where it durably lives (job body, ledger row, `work/<base>`, a journal record).
6. **Idempotency and dedup.** Interaction with `post-job.sh` basename idempotency and the `jobs/index/<hash>` directive-identity map; a stable PR-keyed base must not collide with a re-post of the same directive or swallow a fresh one.
7. **Leader-only vs. every-host**, if the design adds or extends a service (CLAUDE.md § Leader and follower hosts — singletons are leader-gated; gardeners race everywhere).
8. **What the dead-letter path keeps.** The generic `deadmail.sh` promotion must remain the backstop; state explicitly what the new mechanism does *not* replace.
9. **Migration/adoption** — what changes in `roles/botanist/AGENT.md` (including whether the `AGENT.md:108` anti-pattern text stays, changes, or points at the mechanism), and the incremental path.
10. **Out of scope** and known gaps.

Diagrams in mermaid, parse-validated per `skills/mermaid-validation/SKILL.md`. Ground every claim in the actual scripts before asserting it — the file:line pointers above are leads to verify, not facts to copy. The implementing build is a separate follow-up job, not part of this one.
