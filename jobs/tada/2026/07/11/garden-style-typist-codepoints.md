Completion report:

**Job `garden-style-typist-codepoints` complete.** Encoded kriskowal's standing instruction from `endojs/endo-but-for-bots#124` review `r3548802060` ("Avoid code points that are difficult for a typist to maintain") into the garden library at all three requested tiers, landed on `main2` as commit `79ae6035bf`.

**What I did:**

1. **Style guidance.** New skill `skills/typist-friendly-code-points/SKILL.md`: names the to-avoid glyphs with their ASCII spellings, split into a mechanically substitutable set (arrows including `→` U+2192, ellipsis, curly quotes, `≤`/`≥`/`≠`, multiplication and minus signs, no-break space) and a judgment-only set (bullet, check/ballot marks). Scope matches no-latin-shorthand (bot-authored text; verbatim quotes, vendored references, and glyph-valued fixtures exempt). The em dash stays owned by em-dash-style (its rewrite is judgment, not substitution); a cross-reference note landed there. Indexed in `roles/COMMON.md` § Style and § House style (now five standing-style skills) and the `CLAUDE.md` inventory (drift check passes).

2. **Jury wiring.** The **typist** seat (always-on in every code panel per panel-hints) and the **copyeditor** seat (every design panel, cross-fired on markdown-heavy code PRs) each gained an operating norm flagging typist-hostile code points as should-fix; the **pedant** carries the rule among its layered project rules as a Chicago-Manual override, same shape as the em-dash override. The seats are the always-on backstop for PRs whose gauntlet never runs.

3. **Auto-fix.** New pre-push-gates probe `scripts/jobs/gardening/pre-push-gates/probes/typist-friendly-code-points.sh`, the first probe with a paired `--fix` mode: probe mode scans added lines of changed `.md` files; `--fix` mechanically rewrites the substitutable glyphs across each changed file (fix on encounter) and re-stages. Fenced blocks and glyph-quoting inline spans are exempt, but a glyph inside a longer span (a signature like `stmt.get(...) → object`) is treated as content and fixed. Per-file opt-out: `typist-code-points-exempt` marker. Documented as a table row plus procedure note in `skills/pre-push-gates/SKILL.md`.

**Verified** (real execution): probe fires on the precipitating `designs/daemon-endor-pet-store-sqlite.md` (from the fork's `slot-machine` branch) and `--fix` clears all five of its U+2192 arrows while correctly leaving its em dash alone; end-to-end scratch-repo test covered staged and unstaged diffs, re-staging, vendored/exempt skips, and judgment-only glyphs failing without rewrite; glyph-quoting spans (including the new skill's own tables) pass. The repo check suite shows no regressions (the two failing suites also fail on clean `origin/main2`).

**Follow-ups:** the gate driver `pre-push-gates.sh` remains contract-only (pre-existing); when it is implemented, it should run this probe's `--fix` in the auto-fix stage per the new procedure note. The four other seats' review prose and journal entries will pick the rule up through `roles/COMMON.md` automatically.

Self-improvement: nothing this time.
