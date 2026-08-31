CI is confirmed GREEN (rc 0, 7/7 checks passed). The fix stage is complete.

## Completion report

**Job:** FIX round 1 of the endojs/endo-but-for-bots PR #264 gauntlet (design PR: "import-attributes propagation proposal for `@endo/compartment-mapper`").

**What I did:** Applied the panel's round-1 request-changes items to the design once, pushed to the PR head, and drove CI to green.

**Root-cause fix for the dangling-link findings (critic, pedant, ergonomist):** The PR's base was a stale `llm` ancestor that predated the merge of its sibling design PR #248 (`ses-import-attributes.md`), so ~13 cross-reference links resolved to 404s. Since #248 has since merged to `llm`, I rebased the head onto current `origin/llm` — the sibling file is now present in the tree and every link resolves. Rebuilt the branch cleanly as a 2-file diff (`designs/compartment-mapper-import-attributes.md` + a `designs/README.md` registry row), resolving the churny design-index merge conflict against current `llm` and adding an explicit landing-order-dependency note.

**Design-content must-fix items applied:**
- **Two wire shapes (decomplector):** reconciled the in-memory `ResolvedImport` and the JSON-schema union into one canonical `PersistedImport` (bare-string legacy collapse), removing the divergence; cross-referenced both sections.
- **Attribute-conflict precedence (critic, ergonomist):** stated the rule — import-site `with` clause wins per key over package `withAttributes` (a default layer); documented `withAttributes` scope across sibling conditions; added a conflict test.
- **Asymmetric backward-compat UX (critic):** added a live-path (`link.js`) upgrade diagnostic symmetric with the archive read path, plus its test.
- **Scope contradiction (skeptic):** reconciled "interprets none of it" with the `link.js` walkthrough — the hook *selects* an existing parser, it does not decode.
- **`tags` undefined (novice):** introduced the pre-existing top-level `tags` field at first use; glossed "deferred error."
- **Test-catalogue gaps (skeptic):** added moduleMapHook priority-case, bundler-rejection, and CJS-require domain-error tests.
- **Prose/pedant/copyeditor:** fixed comma splices, parallel structure, `single-argument`/`two-argument` consistency, `policy evaluation` hyphenation, novelty note for `withAttributes`, and converted all introduced em-dashes to the doc's dash-free style.

**Pushed:** `9aa9efa86` to `design/compartment-mapper-import-attributes` (rewrite-mode safe push). **CI:** 7/7 checks green (build, lint, test, browser-tests, zizmor, copilot-setup-steps, dependabot).

**Follow-ups:** None blocking. The panel driver will re-post panel-2. The design remains design-only (Status: Proposed); the implementation builder dispatch is deferred to a separate PR rooted on `master` per the design's own framing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr264-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 188 tokens (10880587 cached reads)
- Output: 58060 tokens
- Cost: $8.4516835
- Wall-clock: 1006s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
