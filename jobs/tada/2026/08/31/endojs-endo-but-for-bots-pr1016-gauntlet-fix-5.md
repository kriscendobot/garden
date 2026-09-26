CI is **GREEN** (rc 0: 5 checks, 0 failed). The fix round is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1016 gauntlet — FIX round 5 (design-only doc: `designs/ironhorse-rejection-handling.md`).

**Round-5 disposition** was must-fix, driven by the **critic** (request-changes); the rest were should-fix/comment-only. I applied the critic must-fix plus the substantive should-fix items and the cheap conformance fixes in one follow-up commit (`4dc235600`), pushed to the PR head (`endojs/design/ironhorse-rejection-handling`), and watched CI to **green**.

**What changed:**
- **critic (must-fix):** § 2's reference-error/rejection taxonomy claimed a clean either/or (synchronous-swallow = panic-only vs. rejection = tracker's residue). Verified against the code that `step_async` (`rust/engine/ironhorse-vm/src/interp.rs:7936`) catches a `Halt::Throw` escaping an async body and rejects the result promise via `settle_via_function(reject_fn, reason)`, firing on the `is_start` run before any `await`. So a reference error as the first statement of any `async function` is both reference-error-caused *and* rejection-shaped. Added a paragraph making the overlap explicit, scoped the "armed panic is the only tool" claim to the *truly* synchronous case, and added **Open Question 5** for the tracker design to resolve panic-vs-tracker ownership (exclude to avoid double-reporting, or include and re-scope the panic claim).
- **ergonomist (should-fix):** gave the "Pending promises" panel the same explicit identity-keyed / creation-site-as-label commitment as its sibling panel.
- **decomplector (should-fix):** split the SES-knob naming decision out of Open Question 1's mechanism decision into its own lower-stakes, deferrable **Open Question 6**.
- **copyeditor:** glossed "oracle" at first use; completed the dangling "its failure to" infinitive; unnested the `config.tiemout` aside out of § 1's causal chain.
- **novice:** inlined the report-at-terminal-boundary gloss at first use; corrected § 2's lead-example citation from `config.tiemout` (a property access that raises nothing) to the bare-variable `timeuot` — a latent inconsistency my § 1 clarification would otherwise have made glaring.
- **pedant:** unspaced the two stray slash-joined identifier lists, replaced `e.g.`, dropped the redundant trailing provenance line absent from sibling designs.
- **Discipline:** my early drafts introduced 11 em-dashes; caught and rewrote every one (the committed doc is em-dash-free), and swept for arrows/ellipsis/curly quotes — all clean.

**CI:** rollup terminal, 5 checks total, 0 failed → GREEN.

**Follow-ups:** none for this stage. I did not re-run the panel (the driver re-posts panel-6). The two new open questions (panic-vs-tracker ownership; the `unwatched`/`unhandled` naming split) are carried in the doc for the future `design-ironhorse-rejection-tracker` job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1016-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3471256 cached reads)
- Output: 29947 tokens
- Cost: $3.4494459999999987
- Wall-clock: 833s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
