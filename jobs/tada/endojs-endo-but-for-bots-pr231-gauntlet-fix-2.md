CI is green. The fix stage is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #231 gauntlet — FIX round 2. PR is the design doc `designs/familiar-release.md` (head `endojs:design/familiar-release`, base `llm`).

**Applied the panel round-2 must-fix items** (request-changes seats: critic, skeptic, decomplector, ergonomist, novice; plus the comment-only copyeditor/pedant nits):

- **decomplector** — Split the folded `**Severity:**` field into separate `**Severity:**` (intrinsic impact) / `**MVR disposition:**` / `**Resolved by:**` fields across G2, G3, G4, G6, G8, G10, G11; declared the per-gap block the single source of truth that the MVR/Followups/Out-of-scope tables derive from.
- **novice** — Resolved the dead "Axis-2 followups" cross-reference (11 occurrences, several line-wrapped) to the real Followups section; forward-pointed the first `(resolved 2026-05-19)` tag to the Open questions section (via the new G2 `Resolved by` line).
- **critic** — Added a "Platform coverage of the runtime tiers" subsection and extended the Tier-1 CI runtime smoke into a matrix across all three MVR runners (macos-14, macos-13, ubuntu-latest) so the Blocker G16 gap is verified on every shipped platform, not macOS alone; dropped the misleading "Familiar sandbox" containment language in G12.
- **skeptic** — Reconciled the contradictory MVR-table build-pipeline rows (the release matrix already exists; folded G15/G4 into the confirm row and removed the stale "multi-day build" row); added a parallel Linux exit-criterion acknowledging the `chrome-sandbox` suid setup as the sharper no-dev-tooling exception; parametrized the mock gateway over both the registry-provider and `ollama/<id>` sentinel-token paths.
- **ergonomist** — Required the macOS `xattr` workaround to surface at the point of friction (download page / DMG background), not only the README; added a daemon-start-failure dialog line item to G9/MVR; renamed the Familiar shell log to `familiar-shell.log` for sibling coherence.
- **copyeditor/pedant** — Sentence-cased the "What is the problem being solved?" heading; recast G1/G8/G16 gap headings as noun phrases; fixed the G2 pronoun; normalized the G9 citation form and port backtick formatting; made the Out-of-scope list parallel; "at 8%" → "in 8%".

**Pushed** as one follow-up commit `07c19a83677` to the PR head (`64eed591de6 → 07c19a83677`).

**CI:** GREEN — `total=5 failed=0` (rc 0).

Did NOT re-run the panel (the driver re-posts panel-3).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3310437 cached reads)
- Output: 33735 tokens
- Cost: $3.4719605000000007
- Wall-clock: 844s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
