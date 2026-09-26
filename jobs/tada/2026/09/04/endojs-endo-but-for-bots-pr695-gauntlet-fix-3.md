CI is GREEN (rc 0). The fix round is complete.

## Completion report

**Job:** endojs/endo-but-for-bots PR #695 — gauntlet FIX round 3 (design: `sturdy-refs-agent-surface.md`).

**What I did:** Applied the panel round-3 must-fix/should-fix items as one review-feedback follow-up commit (`a9decaa54`) to the PR head `design/sturdy-refs-agent-surface`, pushed via `safe-push-pr-head.sh` (advance mode, `caf4eb64d → a9decaa54`), and watched CI to terminal — **all 5 checks green** (browser-tests, lint, build, zizmor, test).

**Changes to the design (`designs/sturdy-refs-agent-surface.md`) + `designs/README.md`:**
- **Markdown list breaks (copyeditor/pedant must-fix):** reformatted `## Phased Work` and `## Open Questions` so each list marker is line-initial — they were collapsing into single run-on items.
- **README date sync (pedant must-fix):** `Updated` 2026-07-15 → 2026-09-04 to match the doc's metadata.
- **Admission-table contradiction (critic must-fix):** dropped the undefined "value-producing evaluation slots" from the "Yes" row so the table matches the "exactly one method" invariant; added a paragraph recording value-producing admission as a deferred, authority-review-gated surface, and aligned the two other references (problem statement, acceptance criterion).
- **Undefined lifetime boundary (critic + skeptic):** added precise definitions of *delivery* vs *turn*, pinned "no retention edge required" to the turn, and showed the worked flow crosses a delivery but stays inside one turn; fixed case-1 wording ("single delivery" → "single turn").
- **`enlivenSturdyRef` attenuation (skeptic):** clarified the bound `locator`/resolver is the real closely-held secret, and stated the attenuation must bind it un-swappably.
- **`@` sigil (skeptic + decomplector):** carved tool-layer handle syntax out of the existing `@`-led special-name grammar (`@self`/`@host`, `pet-name.js:25`), not just pet names.
- **Provide/accept asymmetry + error contract (ergonomist):** stated the asymmetry explicitly (accept is the new surface; provide is carried by the parent work / render map) and gave `lookupBySturdyRef` a reject-on-failure contract matching sibling `lookupBy*`.
- **Discoverability (novice):** glossed "formula", `SturdyRefToken`, and "the sturdyref work" at first use.
- **Prose mechanics (copyeditor/pedant should-fix):** converted in-document section cross-references from code spans to anchor links; fixed the garden-path and wedged-parenthetical sentences.

**Notes:** `designs/` is not covered by the docs-only Prettier lint (it checks only `.github` and `packages`), so the prose changes carry no CI-format risk; CI is green regardless. Per the stage contract I stopped after CI — the driver re-posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr695-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 98 tokens (3971509 cached reads)
- Output: 28582 tokens
- Cost: $3.6952945
- Wall-clock: 566s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
