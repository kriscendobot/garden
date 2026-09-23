---
host: endolin
role: liaison
dispatch_id: 1efd4a
date: 2026-06-02
kind: result
---

# result(librarian, cycle 101): daemon-commands-as-messages — commands-as-self-addressed-messages design (1 section)

**Cycle**: 101 (first non-chat endo-but-for-bots design ingest — chat-cluster fully ingested as of cycle 99).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/daemon-commands-as-messages.md` (253 lines), last touched 2026-03-11 by Kris Kowal (prompted).
**Lane rotation**: cycle 101 was scheduled for chat-lane but chat-cluster is exhausted (21 sources). Pivoted to daemon-design-lane within the same endo-but-for-bots root.

## What

Ingested the *Not Started* `daemon-commands-as-messages` design — a proposal that every user/agent command be logged as a *self-addressed message* (`from === to`) in the issuer's own inbox, with results delivered as `replyTo` replies. Single-section cohesion-honest ingest for this unified Problem → Design → Enables/Costs → Dependencies argument.

### Section drafted

1. **Commands-as-self-addressed-messages design** (full file, lines 1-253) — single cohesive ingest. The §opening Problem block frames four downstream consequences of *commands settle and vanish* behavior: (1) *asymmetric transcript* — the user can't reconstruct what they did; (2) *no agent visibility* — Lal/Fae cannot see the user's commands so inbox-follow context is incomplete; (3) *no audit trail* — capability-confined agent tool invocations are invisible; (4) *chat UI workaround* — the `chat-pending-commands` UI-only region duplicates bookkeeping the daemon should own. The §Design proposes a new `command` message type carrying `commandName` + `args` + `promiseId`/`resolverId`; a one-line type-aware lift of `mail.js`'s self-delivery suppression (`if (from !== to) await deliver(message);` becomes type-aware for `type: 'command'` only). The §Which-operations-become-commands table maps 8 operations (`dismiss`/`adopt`/`resolve`/`reject`/`evaluate`/`request`/`send`/`grant`) from current *promise, no trace* to *command + reply* form, with `evaluate` subsuming the existing `eval-proposal-proposer`/`eval-proposal-reviewer` paired-message pattern. The §Agent tool audit-trail bonus extends the design to `daemon-agent-tools` — Fae's `readFile`/`exec` calls become commands too, giving `daemon-capability-bank` a built-in observability surface without a separate logging system. The §design-dependency graph names six related designs (chat-pending-commands as predecessor, chat-command-bar as dispatcher, daemon-form-request + daemon-value-message as reply-pattern donors, daemon-agent-tools as parallel consumer, daemon-capability-bank as audit-trail beneficiary). The §Affected-packages list (mail.js + types.d.ts + host.js + inbox-component.js) is small enough to land cleanly but spans two packages (daemon + chat) so the work must be coordinated.

### Library state after this cycle

- **601 sections** (was 600) / **146 sources** (was 145) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~35 daemon-commands-as-messages keywords (self-addressed messages / asymmetric transcript / type-aware self-delivery lift / 8-operation table / evaluate subsumes eval-proposal / agent tool audit trail / minimal-mechanism-maximal-semantics / new-design-deprecates-predecessor / one-design-solves-two-problems).

## Rotation discipline pivot

Cycle 101 was scheduled for chat-lane but chat-cluster is exhausted (all 21 chat-* designs ingested through cycle 99). Pivoted to *daemon-design-lane* within the same endo-but-for-bots root. The §rotation discipline (papers / chat / comments) extends gracefully when a lane runs out — pick the next-best candidate in another lane.

The broader designs corpus is large: ~100 unverified designs in `endo-but-for-bots/llm/designs/` covering daemon-* (~40), familiar-* (~10), endopi-* (~12), ocapn-* (~7), endor-* (~5), endoclaw-* (~12), lal-* (~3), inventory-* (~3), and miscellaneous. The daemon-* subset is the most architecturally rich.

## Notes

- The §central design move (`from === to` self-sends as the intentional surface, with one-line type-aware suppression lift) is structurally elegant — *minimal mechanism, maximal semantics*. The existing message infrastructure (`followMessages`, `replyTo`, durable formulas) carries everything; only the type discriminator and the suppression check change.
- The §agent-tool-audit-trail bonus is the *one-design-solves-two-problems* cross-cutting payoff. The same design that fixes the *user-can't-see-what-they-did* problem also makes capability-confined agent tool invocations observable to the host who granted the capability.
- The §`evaluate subsumes eval-proposal pair` line is a structural simplification — the existing two-message `eval-proposal-proposer`/`eval-proposal-reviewer` pattern *collapses* into one command + one value-reply, removing a special case in favor of the general pattern.
- The §design-dependency graph at the end of the doc (six related designs in a table that names the relationship type — predecessor/dispatcher/donor/consumer/beneficiary) is the canonical *design-graph-footer* shape. The reader can navigate to neighboring designs to understand the architectural context.
- Single-section ingest (cohesion-honest). The 253-line file is *one tight argument-cluster* — one problem, one central design move, one set of consequences. Forcing a 2-section split would create an artificial divide between motivation and resolution.

## Next

- Cycle 102 (papers-lane): consider trying *Saltzer-Schroeder 1975 Principle of Least Privilege* (canonical, well-known); *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999); or fresh URL search for Stiegler-Miller HPL-2006-116.
- Cycle 103 (chat-lane): chat-cluster exhausted. Pivot to broader endo-but-for-bots designs corpus — many candidates remain (daemon-*, familiar-*, endopi-*, ocapn-*, endor-*, endoclaw-*, lal-*). Promising daemon-* candidates: daemon-form-request, daemon-value-message, daemon-agent-tools, daemon-capability-bank, daemon-capability-bus, daemon-mount (this last one is 718 lines — would need 3+ sections).
- Cycle 104 (comments-lane): `packages/ses/src/error/tame-console.js` (197 lines / ~24% density); `packages/exo/src/exo-makers.js`; `packages/patterns/src/keys/checkKey.js`; `packages/marshal/src/marshal-justin.js`.

ScheduleWakeup 1500s for cycle 102.
