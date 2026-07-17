---
role: designer
---
# Design: recast Agoric ERTP evolution (esp. the dormant ERTP v2) as a migration to `@endo/ertp`

Research the Agoric ERTP-evolution issue corpus and produce a **design PR on
`endojs/endo-but-for-bots`** that recasts it as a migration of ERTP into a standalone Endo package,
`@endo/ertp`.

## Phase 1 — Research the ERTP-evolution corpus (READ-ONLY on agoric)
- Search **`agoric/agoric-sdk`** issues (and closed ones) for everything pertaining to the evolution
  of **ERTP** — the Electronic Rights Transfer Protocol (Amount, Brand, Issuer, Mint, Purse, Payment,
  AmountMath / AssetKind). Prioritize the **long-dormant "ERTP v2" proposition** and related threads:
  issuer/mint/purse redesign, durable/upgradable ERTP, ERTP decoupled from Zoe/SwingSet, amount-math
  and asset-kind rework, invitation/rights modeling, etc. Use `gh search issues`/`gh issue list`
  against `agoric/agoric-sdk`. Compile the corpus: issue number, title, the core proposition, current
  state, and how they interrelate (especially the ERTP v2 vision and why it stalled).
- **Read-only, strictly.** Do NOT comment on, react to, review, open, close, or otherwise touch
  `agoric/agoric-sdk`. Reading issues is fine; interacting is not (`roles/COMMON.md` § External-repo
  etiquette; CLAUDE.md § Monitoring — agoric upstream stays comment-and-link-free).

## Phase 2 — Design `@endo/ertp` (the recast)
Synthesize a design for **`@endo/ertp`**: ERTP recast as a standalone Endo package, and a migration
path from agoric-sdk's ERTP. Cover at least:
- **The core model as an Endo package** — Amount, Brand, Issuer, Mint, Purse, Payment,
  AmountMath/AssetKind — built on Endo primitives (`@endo/pass-style`, `@endo/marshal`, `@endo/exo`,
  `@endo/far`, `@endo/patterns`), **decoupled from vats / Zoe / SwingSet**. Where ERTP needs
  durability, map it onto Endo's durability story (the daemon / vfs / exo state) rather than
  SwingSet's baggage.
- **How the dormant ERTP v2 propositions fold in** — treat the recast as the vehicle that finally
  realizes the v2 ideas, noting which v2 goals `@endo/ertp` satisfies and which it defers.
- **Migration path & interop** — how existing agoric ERTP users migrate; compatibility/adapter story
  with agoric-sdk's ERTP; what stays in agoric-sdk vs what moves to `@endo/ertp`.
- **Open questions & risks**, and a phased roadmap.

## Phase 3 — Deliver the design PR (endo-but-for-bots, base `llm`)
- Open a **DRAFT design PR** on `endojs/endo-but-for-bots`, **base `llm`** (design docs live on `llm`,
  the roadmap branch — a frozen `llm-<sha>` base per `skills/frozen-base-branch/SKILL.md`), adding
  `designs/endo-ertp-migration.md`. Follow `skills/design-to-pr-pipeline/SKILL.md` and the designer
  norms. Do NOT touch or recreate `master`.

## CRITICAL constraint — keep agoric/agoric-sdk comment-and-link-free
The design PR must **not create GitHub cross-reference backlinks** onto `agoric/agoric-sdk`. When you
cite the ERTP issues, use **plain, non-linking text** — e.g. write `agoric-sdk issue 1234: <title>`
(NO `agoric/agoric-sdk#1234` shorthand, NO pasted `https://github.com/agoric/agoric-sdk/issues/1234`
URLs), so no notification or backlink lands upstream. This is a hard etiquette bound, not a style
nit.

## Skills
`skills/design-to-pr-pipeline/SKILL.md`, `skills/design-dependency-walk/SKILL.md`,
`skills/pr-formation/SKILL.md`, `skills/frozen-base-branch/SKILL.md`.

## Done
A DRAFT design PR on `endojs/endo-but-for-bots` (base `llm`) adding `designs/endo-ertp-migration.md`:
the `@endo/ertp` recast + migration plan, grounded in the surveyed agoric ERTP-evolution / ERTP-v2
corpus (cited link-free), with interop story, open questions, and a phased roadmap. The `tada` report
lists the surveyed issue corpus (by plain number+title), links the new design PR, and confirms no
agoric cross-links were created.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-17T05:39:43Z
