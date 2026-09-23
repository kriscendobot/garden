Job design-endo-inspect complete.

**What I did.** The maintainer's requested follow-up design (kriskowal on endojs/endo-but-for-bots#187, comment 4951950042) turned out to be already covered: draft PR **endojs/endo-but-for-bots#715** (`designs/inspect-package.md`, base `llm`, head `design/inspect-package`) was opened by kriscendobot from another garden instance three minutes before this orchestrated job was promoted. Rather than open a duplicate, I audited #715 against this job's spec and strengthened it with commit `bf8416467`.

**What changed in the strengthening commit.**
- **Per-environment brand-check honesty:** a new "How far each environment can go" table. Node can quarantine proxies today (`util.types.isProxy` is a public native internal-slot check); the browser rich path is faithful by delegation (our code never reads the value); XS and pure SES userland are the irreducible gap the dependencies repair.
- **Trap-free operation inventory:** `typeof`, identity, `Array.isArray`, and WeakMap/WeakSet lookup are safe on any value including proxies (identity-keyed lookup is what makes stamping sound); the reflective reads and even `Object.isFrozen` probes all fire proxy traps (endojs/endo#1912 cited where it bites).
- **Widened, verified dependency set:** added Agoric/agoric-sdk#3905 (twin of endojs/endo#1756), tc39/proposal-stabilize's non-trapping integrity trait (champions include the tagged reviewers) with its in-flight Endo adoption endojs/endo#2673 / #2675 (prep merged as #2679), the Node precedent (nodejs/node#6464 -> #6465, #60964 -> #61029), and SES console prior art (endojs/endo#945, #636, #944, #1530, #2941). Every reference was verified by title/state before citing.
- **Repairs:** repointed a phantom `@endo/console-tools` reference at the real seam (`packages/ses/console-shim.js` + `tame-console.js`), added the missing `designs/README.md` per-design estimate row (M, 2-3 days, M10) and widened its M10 row, and applied the ASCII house style to the design doc.
- Updated the PR body (dependencies + the sharpened substrate question) and posted the completion summary comment (issuecomment-4952027781). **@erights and @mhofman remain tagged** in the PR body, the one authorized external mention.

**Verification.** Mermaid fence parse-validated: `mermaid.parse` returned OK (flowchart-v2). Push accepted (`2d022e1d8..bf8416467` on `design/inspect-package`). Design-only diff; no tests or lint apply. Journal result entry: `entries/2026/07/12/170529Z-result-gardener-81eb08.md`.

**Key open questions for the build (child 3 of orch-endo-inspect):** the SES `setInspector` seam shape (module singleton, `lockdown` option, or console-shim endowment); whether the faithful substrate is the endojs/endo#1756 stamping power or the non-trapping integrity trait, and the endowment shape each implies; browser default return shape (console-arg arrays vs string); XS sink choice (`print`/`trace`) and whether to request a native proxy predicate from Moddable.

**Follow-ups.** Two garden instances answered the same maintainer comment (a watcher-triggered job and this orchestrated one); the duplicate was avoided only by checking for an existing PR first. Lesson noted in the journal result entry for the liaison: search for an existing PR covering the same directive before opening one, and strengthen rather than duplicate.

Self-improvement: candidate designer-role/pr-formation note recorded in the journal result entry (pre-open duplicate-PR check).
