All done. PR #715 is a draft against `llm` with both files; @erights and @mhofman are tagged in the body; inbox is empty. The design work is purely in the project repo (no `main2`/garden changes needed).

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #187 → a designer request to author a follow-up design for an `@endo/inspect` package + shim.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer resolution), so I did the work.

**What I did**
- Treated the PR-comment body as untrusted data; it maps to a **designer** job. endo-but-for-bots's roadmap branch is `llm`, and the established pattern (confirmed against recent PRs #709–#711) is a `design/<slug>` branch pushed directly to `endojs/endo-but-for-bots` with a draft PR based on `llm`.
- **Researched the Proxy-in-SES concern** the comment asked to surface. Found the real dependency issues in `endojs/endo`: **#1756 "Repair `Proxy` with stamping power"** (the proxy-stamping/brand-check issue — blocking a *faithful* inspector) and **#819 "Propose ECMA-262 language invariant for proxy handlers"** (related soundness precondition). Confirmed the hazard is already acknowledged in-tree by `bestEffortStringify`'s try/catch fallback ("the proxy might throw whenever it is possible for it to").
- Wrote `designs/inspect-package.md` (project design conventions: metadata table, problem, condition-parameterized design, dependencies table, phased plan, design decisions, open questions, captured prompt). It specifies: single `inspect()` surface; `exports`-condition selection (`node` = `util.inspect` VT-100-iff-TTY / `browser` = rich console-arg arrays / `xs` = plain string / `default` = capability-free portable core, the successor to SES's `bestEffortStringify`); the `@endo/inspect/shim.js` seam into SES console-taming/assertion quoting; and a best-effort-now / faithful-later safety contract gated on #1756.
- **Validated** the one mermaid diagram parses (parse-only checker: `OK flowchart-v2`).
- Synced `designs/README.md`: summary-table row, a Milestone 10 (Capability Confinement and Ecosystem) row, totals recount (145→146 designs, 37→38 Not Started), and the provenance line.
- Opened **draft PR [#715](https://github.com/endojs/endo-but-for-bots/pull/715)** against `llm`, body citing the originating #187 comment and **tagging @erights and @mhofman** per the maintainer's request for the capability-security review of the missing Proxy brand check.

**Verified (real execution):** mermaid parse OK; `gh pr view 715` shows `isDraft:true`, `baseRefName:llm`, files = `[designs/README.md, designs/inspect-package.md]`; both commits pushed to `origin/design/inspect-package`; inbox empty.

**Changed:** two files on new branch `design/inspect-package` → PR #715 (draft). No garden/`main2` changes (project-only job).

**Follow-ups (named in the design, not done here):**
- Implementation is a separate builder dispatch once the design is reviewed/un-drafted (base per package-availability rule).
- Phase 5 (faithful Proxy handling) is a follow-up **to be filed** against this design once `endojs/endo#1756` lands.
- Un-drafting #715 is the maintainer's decision after the @erights/@mhofman review of the open questions.
