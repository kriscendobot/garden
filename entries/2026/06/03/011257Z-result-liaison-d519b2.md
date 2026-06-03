---
ts: 2026-06-03T01:12:57Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--d519b2
cycle: 133
---

# Cycle 133 — daemon-guest-eval-simplification.md (Kris Kowal, endo-but-for-bots) — first daemon-* design after endopi closure

Ingested `designs/daemon-guest-eval-simplification.md` (160 lines,
*Implemented* status, PR #92) from
`endojs/endo-but-for-bots@2b787690` (branch `origin/llm`).
**Twenty-eighth-comment-style design ingest.** **First daemon-*
design ingest after the endopi-* family closed at 9/9 (cycles
112-131).** One cohesion-honest section:

- **three-configurations-of-eval-authority-with-ocap-as-safety-
  boundary-not-message-approval** — a design retrospective:
  the eval-proposal handshake was removed from the daemon in
  commit `90f8e910f9` (*Guests can eval without permission*).
  Guest `evaluate` now calls `formulateEval` directly,
  structurally identical to the host path.

## The single most structurally interesting thesis

*Ocap discipline is the safety boundary, not message approval*.

The eval-proposal flow added *ceremony* without adding *safety*.
Cycle 105's daemon-capability-bank Design Principle 1
(*Capabilities are objects, not configurations*) is now the
*only* safety boundary for guest eval.

## The §three-configurations taxonomy

1. **No eval** — Mark Miller's early advisory-only model;
   *agent advises on code but cannot execute it*; *reasoning
   about capability composition is tractable*.
2. **Eval with approval** — was EndoGuest's default; *in
   practice, the proposal/approval handshake fatigues users*;
   *the hypothesis that approval adds safety has not been borne
   out — users approve reflexively, gaining neither security
   nor productivity*. The §reflexive-approval-without-security
   empirical claim is the design's single-most-consequential
   observation.
3. **Eval with authority** — now EndoGuest's default; ocap as
   safety boundary.

## §`evaluate` is a "tool of tools"

*With eval, an agent can compose capabilities programmatically,
drastically reducing the need for special-purpose tools.
Withholding eval forces building bespoke tools for each
composition pattern.*

One capability subsumes special-purpose tools.

## §Status block correction

The §Status block carries the *honest-design-correction*
discipline (visible in cycles 114, 124) applied to a *removal*:

> *The `Responder` exo and its `resolveWithId` method are
> preserved because they remain in use by `request` and
> `definition` message types via persisted `resolverId` fields,
> contrary to the design's assumption that they were specific to
> the eval-proposal flow.*

Implementing the design surfaced a cross-cutting use of
`Responder` the original analysis missed.

## §Regression test prevents reintroduction

PR #92 added a regression test (*guest evaluate posts no message
to host or guest mailbox*) that asserts zero mailbox growth.
*Future re-introduction of any proposal-style send fails fast.*

## §Three-configurations-remain-possible-at-a-higher-level

*An attenuating proxy could withhold evaluate from a guest's
facet, restoring the "no eval" or "eval with approval"
configurations. But EndoGuest itself does not impose approval by
default.*

The *attenuation-via-proxy-not-via-default* discipline: the
default is *authority*; attenuation is *opt-in*. The capability
discipline is the *mechanism*; the configuration is the *policy*.

## Rotation note

Cycle 133 was nominally **papers-lane** (cycle 132 was
comments). Papers-lane has been blocked for **27+ consecutive
cycles** (97/100/102/104/106/108/110/112/113/114/116/117/118/119
/120/121/122/123/124/125/126/127/128/129/130/131/132) due to
lack of PDF-fetching infrastructure. With the endopi-* family
closed at 9/9, cycle 133 opened a new design family direction:
daemon-* (~25 unexplored designs remain).

## Counts

- 636 → **637** sections (+1).
- 177 → **178** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row),
  `capability-security.md` (+1 row).
- Keywords index extended with ~30 guest-eval-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 134 wakes in 1500s. Rotation lands on **chat-lane**
nominally (exhausted at 20/20). Expect another pivot. Two
candidate paths: continue daemon-* family exploration (24
unexplored), or pivot to comments-lane (more @endo source
files available).
