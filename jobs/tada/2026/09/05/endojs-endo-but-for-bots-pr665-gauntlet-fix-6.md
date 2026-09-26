CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr665-gauntlet-fix-6 — FIX round 6 for PR #665 (design: release-automation notice for `.js` exports-key cleanup on major bumps).

**What I did:**
- Got an isolated project worktree at the PR head (`design/release-automation-major-bump-exports-trigger`, was `4b2670a41d`).
- Read the panel round-6 request-changes verdict and applied its findings to `designs/release-automation-major-bump-exports-trigger.md`.

**Changes (one follow-up commit `ddd1465aa2`):**
- **Must-fix (pedant/copyeditor):** removed all 21 em-dashes (rewritten as periods, colons, or parentheses) per `skills/em-dash-style`, and replaced both `…` (U+2026) occurrences with ASCII `...` per `skills/typist-friendly-code-points`.
- **Should-fix (critic + skeptic, factual):** corrected the changeset key-spelling survey — only single- and double-quoted forms are attested in the repo; fixed the double-quoted count from six to five and dropped `lucky-planes-resolve.md` from that list (it is the malformed-fence example, not a double-quoted entry); marked bare/unquoted as defensively-handled-but-unobserved rather than "actually used."
- **Should-fix (copyeditor):** untangled the double-negative deep-equality sentence.
- **Should-fix (ergonomist):** folded `--base` into the enumerated flag list in "The script and its wiring."

Left unchanged: the design-decision-level findings (decomplector's manifest-immutability CI gate, critic's `@changesets/cli status` alternative, ergonomist's parameter-name nit) — those are judgment/scope items for the maintainer/panel to iterate, not textual must-fixes.

**Push & CI:** pushed via `safe-push-pr-head.sh` (advanced `4b2670a41d → ddd1465aa2`). Watched CI bounded (deadline 3600s): rollup went GREEN, 5 checks, 0 failed (rc 0).

Did not re-run the panel (driver re-posts panel-7).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr665-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2506107 cached reads)
- Output: 17373 tokens
- Cost: $2.4372665
- Wall-clock: 823s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
