Inbox empty. The job is complete.

## Completion report

**Job:** `design-endo-ertp-migration` (designer) — recast Agoric ERTP (esp. the dormant "ERTP v2") as a migration to `@endo/ertp`, delivered as a draft design PR on `endojs/endo-but-for-bots` base `llm`.

**Delivered:** Draft PR **#778** → https://github.com/endojs/endo-but-for-bots/pull/778
- Base: frozen `llm-d396059` (reused existing snapshot of the current `llm` tip); head `design/endo-ertp-migration`.
- Adds `designs/endo-ertp-migration.md` (the recast + migration plan) and syncs `designs/README.md` (summary-table row, Milestone 10 row and count, recently-added note).
- Two mermaid diagrams (package layering + the Zone-seam) validated parse-only: both `OK flowchart-v2`.

**Phase 1 — corpus surveyed (READ-ONLY on agoric; no comments/reactions/links).** ~38 issues cited link-free in plain `issue NNNN` text. Key finding: there is **no single "ERTP v2" umbrella** — the ambition is distributed. Nearest anchors: amountMath-refactor Epic 2311 (shipped), Durability umbrella 5333 → merged 5283, audit Epic 4059 (open), NFT umbrella 2334/2230 (open). Grouped corpus:
- *Refactor/vision epics:* 2311, 2365, 2232, 3959, 4059, 12432
- *Durability/upgrade:* 5333, 5283, 5593, 4504, 2841, 3356 (a partial reversal), 3434
- *AmountMath/AssetKind:* 557, 2845, 2849, 3587, 3960, 2064, 4261, 6691
- *Issuer/mint/purse/payment:* 3167, 3717, 4237, 4320, 2140
- *Non-fungible/perf (live frontier):* 10920, 8862, 8132
- *Rights as patterns:* 2334, 2230, 397, 2355
- *Brand metadata/provenance:* 10235, 9220, 8627, 3717, 1378
- *Security/audit:* 4264, 4057, 3885, 3046

The survey established that **no upstream issue proposes extracting ERTP as a standalone package** — the design fills that gap.

**Phase 2 — the recast (in the doc):** Amount/AmountMath/AssetKind on `@endo/patterns` key algebra; Issuer/Mint/Brand/Purse/Payment as `@endo/exo` classes with `M.interface` guards; durability decoupled from SwingSet baggage via an **injected Zone power** (agoric supplies `@agoric/zone`; the Endo daemon supplies a vfs/exo-state zone). A fold-in table maps each v2 ambition to satisfied/deferred; migration is by **re-export** (preserving brand identity), not a parallel fork; interop, open questions (incl. `@endo/ertp` vs `exo-` convention, and whether Endo needs its own `@endo/zone`), risks, and a 5-phase roadmap included.

**Etiquette confirmed:** No `agoric/agoric-sdk` cross-reference backlinks created anywhere — design file, README additions, and PR body all scanned CLEAN (no `agoric-sdk#NNNN` shorthand, no pasted URLs). No writes of any kind to agoric upstream.

**Follow-ups:** Phase-4 items (non-scalar NFT Store per issue 10920; shared-rights model per issue 397; Want-Patterns per issue 2230) are flagged in the design as separate sibling designs to be filed. The design is Not Started / awaiting maintainer review; un-drafting is the maintainer's call.

No garden-repo (`main2`) changes were needed — all work landed in the isolated project worktree.
