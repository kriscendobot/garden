Fix stage complete. CI is green.

## Completion report

**Stage:** FIX round 6 of the endojs/endo-but-for-bots PR #1228 gauntlet (design PR: "finish the bare CLI caplet contract"). Applied the panel round-6 must-fix and high-consensus findings once, pushed as a follow-up commit, watched CI to green, and stopped (did not re-run the panel).

**What changed** — one commit `9c3485beb2` on `design/endo-claude-bare-caplet`, touching `designs/endo-claude.md` and `designs/README.md`:

- **copyeditor (must-fix):** fixed "unconfined" flipping subjects — the two uses naming the *child* now read "confined"; dropped the stray "unconfined credential module" third sense.
- **pedant (must-fix):** synced `README.md` "Current totals" to the endo-claude Not Started → In Progress flip (In Progress 36→37, Not Started 49→48, appended the pass sentence) and replaced the four U+2192 arrows on that line with ASCII `->`. Verified the direction against `origin/llm` (base row was "Not Started", head is "In Progress").
- **critic:** hoisted the two premise-falsifying probes to a new work-item 0; named token burn as a load-bearing residual beside entitlement; tiered the `/dev/fd` "read-once" premise as assumed; put the README graph-edge hedge in a rendered mermaid label.
- **skeptic:** made acceptance step 4 satisfiable (record credential source, fail on a metered-key shadow or dropped `--bare`, defer the tier proof to the DD5 residual); added a concurrent two-`infer` acceptance step 8; marked `--max-turns` still-assumed (accepted but undocumented); noted `--restricted`/`--max-budget-usd`; preferred `memfd` and stated the `/proc` precondition.
- **ergonomist/decomplector:** unified the MCP surface's `cancel`→`revoke` (shared verb + sessionTag with the credential pool), made it return whether a session matched, annotated `close() -> Promise<void>`, gave the per-spawn socket/dir its own per-spawn release, renamed `serverDescription`→`serverConfig`, traced `serverName` to an input option, and recorded the settled make-only public API.
- **pedant/copyeditor/novice:** American `-ise`→`-ize` prose, glyph fixes (`!=`, `...`), open "defense in depth", backticked bare `endo-claude.md` citations, subject-verb agreement, sentence-clarity rewrites, inline glosses for the four forward-referenced terms, and a staleness note on the per-commit #1015 audit table.

**Verification:** `prettier --check` clean on both files (the docs-only CI lint); CI terminal GREEN (7/7 checks, 0 failed).

**Follow-ups / deliberately not done (design-authorship or large structural reorgs the panel is itself split on):** moving § Status after § Problem, physically relocating the 33-row #1015 audit table into the PR body, and collapsing the `options.isolation` enum to a single axis. These are opinionated restructures better decided by the design author/maintainer; the DD6 body already extensively caveats the enum's check-only semantics. The driver re-posts panel-7 to reassess.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 162 tokens (8352847 cached reads)
- Output: 51105 tokens
- Cost: $6.750807499999999
- Wall-clock: 1171s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
