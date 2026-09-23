All three concept pages are now indexed on `origin/journal2`.

## Completion report

**Job:** scholar library-index reconcile — add three current concept pages missing from `journal/library/concepts/README.md`.

**What I did:**
1. **Recomputed the gap on the live/committed tree** before editing: fetched `origin/journal2`, confirmed all three concept files exist (`polaris.md`, `powerbox.md`, `robust-composition-thesis.md`), that each has a `keywords.md` route (`polaris`, `powerbox`, `robust-composition-thesis`), and that all three were **absent** from the concepts index tip (216-line README). Gap real — not a no-op.
2. **Read each page's abstract-at-top** and wrote one navigable inventory line per concept in the existing `[id](id.md) — <abstract>` format, drawn from the page's own definition and carrying the topics given in the job.
3. **Placed each under the right heading, not appended** — inserted into the main "Seed inventory" list at its alphabetical position (the same list holding sibling ocap concepts `object-capability`, `principle-of-least-authority`, `confused-deputy`): `polaris` after `per-agent-keypair`, `powerbox` after `positive-vs-negative-reputation`, `robust-composition-thesis` after `revocation-by-withdrawal`. Used `indexed 2026-07-11 by the scholar library-index reconcile; concept page created …` attribution (the same wording precedent as `e-language`/`exo-stream` rows where the page predated the index row), and cross-linked `[[powerbox]]`↔`[[polaris]]`.
4. **Built the body from the committed tip** (not the possibly-stale live worktree) and landed via `scripts/jobs/land-journal-edit.sh library/concepts/README.md` — the sanctioned lander with its CAS retry loop. Landed cleanly (216→219 lines).

**Verification:** all three `[…](….md)` rows confirmed present on the `origin/journal2` tip after a fresh fetch (3/3).

**Changes:** one file, `journal/library/concepts/README.md`, +3 lines.

**Follow-ups:** none. The wiki-links to `[[polaris]]`/`[[powerbox]]` resolve (both now indexed); a routine index-integrity/link-check pass will see a clean tree.
