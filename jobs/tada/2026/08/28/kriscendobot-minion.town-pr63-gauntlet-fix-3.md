CI is green (rc 0). The fix is pushed and CI passed. I'll stop here per the stage instructions (the driver re-posts panel-4; I do not re-run the panel).

## Completion report

**Stage:** FIX round 3 — kriscendobot/minion.town PR #63 (`docs/reconcile-weblet-register-by-id`), a design-doc PR revising `designs/weblet-ocap-synthesis.md`.

**What I did:** Read the round-3 design panel's request-changes verdict (6 seats requesting changes: critic, skeptic, decomplector, copyeditor, pedant, novice; ergonomist comment-only), reconciled each must-fix against the actual landed code (`guestRegisterSource` / `freshDirectoryPetName` in `src/endo/gateway/daemon-site-registry.ts`, and the duck-typed serve path in `site-registry.ts`), and applied all items in one commit.

**Changes (`designs/weblet-ocap-synthesis.md`, +165/-70):**
- **§3.1 evaluate snippet** (critic/novice/decomplector): replaced the stale `"site-" + hash` pseudocode — which used `hash` before the directory that defines it exists and diverged from shipped code — with a faithful paraphrase of `guestRegisterSource`: wrapper-minted `weblet-<counter>-<entropy>` pet name, `storeValue`/`copy` by path, and `JSON.stringify`-encoded literals. Stated the encoding discipline that keeps the fixed-source premise (`front`/`powerPetName`/`directoryPetName` enter only as inert JSON, never crossing data→code), and clarified `front` is the interned content-root digest, not raw caller JS. Fixed the partial-failure paragraph's `site-<hash>` reference and added the repeated-failure-accumulation note.
- **Directory-shape invariant** (skeptic): new §2.2 subsection stating id-kind vs string-shape, the live path's by-construction directory-shape, and the fails-closed duck-typed serve reads; added a matching §7 acceptance criterion and a §9 residual.
- **Severity framing** (critic): retuned "zero authority amplification" to track the doc's own reachability-is-authority premise.
- **§1 forward-pointer** (novice) to the second, distinct risk class; **`owner` schema note** (decomplector) = registering identity, not authorship.
- **Naming** (ergonomist/copyeditor): introduced and reserved "operator registry" vs "site-registry service"; normalized variants; aligned mermaid labels (`directoryId`, `operator registry`).
- **Citation/label consistency** (pedant/copyeditor): `§§` form, comma-joined multi-section refs, colon run-in labels in §9, revision-note rewrite.
- Swept em-dashes I introduced back to ASCII per `em-dash-style`.

**Verification:** Doc-only change (no source touched; no test parses the doc body). Pushed as a follow-up commit `4208dca` via `safe-push-pr-head.sh` (rc 0, advanced cleanly). CI watched to terminal: **GREEN** (rc 0).

**Follow-ups:** None for this stage. The driver re-posts the panel (round 4); I did not re-run it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr63-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5848258 cached reads)
- Output: 37159 tokens
- Cost: $5.009237000000001
- Wall-clock: 567s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
