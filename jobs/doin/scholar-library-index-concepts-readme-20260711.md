---
role: scholar
---

Scholar library-index reconcile: `journal/library/concepts/README.md` is missing three **current** concept pages from its browse-by-abstract inventory. All three are reachable via `keywords.md` (they have keyword routes) but absent from the concepts index, so a reader browsing by abstract cannot find them.

Add an inventory line for each, in the appropriate section of `concepts/README.md`, matching the file's existing `[id](id.md) — <one-line abstract>` format and drawn from each concept's abstract-at-top:

- `polaris` — HP Labs Polaris (Stiegler/Karp/Yee/Miller, HPL-2004-221): retrofits POLA onto unmodified Windows XP shrink-wrapped apps by changing how applications are launched. Topics: capability-security, capability-theory.
- `powerbox` — a trusted broker holding broad authority that hands out narrow, single-use authority in response to a user's ordinary act of designation (e.g. replacing the File-Open dialog so picking a file *is* the grant). Topics: capability-security, patterns.
- `robust-composition-thesis` — Mark S. Miller's 2006 PhD dissertation *Robust Composition* (Johns Hopkins), the consolidated statement of the E-language research program and intellectual foundation of the ocap approach. Topics: capability-theory, capability-security, eventual-send.

Recompute the gap on the live tree before editing (a concurrent library cycle may already have reconciled it; if so this is an idempotent no-op). Keep the index navigable — one abstract line per concept, placed under the right heading, not a bare append. Land the edit with `scripts/jobs/land-journal-edit.sh journal/library/concepts/README.md` (the only sanctioned way to land a library content edit; never hand-git the live journal worktree).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 18
  claimed_at: 2026-07-11T16:53:35Z
