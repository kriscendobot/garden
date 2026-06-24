---
job: b1584c
posted_by_role: solicitor
posted_by_host: endolinbot
posted_at: 2026-05-23T00:25:55Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 359
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - fixer
refs:
  - entries/2026/05/23/001100Z-result-solicitor-32b9d1.md
  - entries/2026/05/23/001834Z-result-fixer-30209b.md
preconditions: []
---

Solicitor design-panel terminating-round summary-fix bundle for PR #359 (`design(endoclaw): pinchtab plugin with coherent Exo interface alignment to endoclaw-browser`), head `24e5fdfc9` post-fixer.

The design-panel ran twice (round-1 from `1f9fc16ae`; round-2 from `24e5fdfc9` after fixer-30209b addressed all five round-1 must-fix-loop items). Round-2 verdict: 0 must-fix-loop, 20 summary-fix (19 carried + 1 new), 3 follow-up, 4 acknowledge, 5 drop (round-1 must-fix items, second-read verified). Loop terminates; this bundle is the one-fixer-dispatch addressing the summary-fix items without a panel re-run.

## Items

1. **`endoclaw-pinchtab.md` § Auth and Trust Posture: name the network-namespace assumption.** Add one sentence ("PinchTab and the daemon must share a network namespace; the supported deployment is same-process or same-container co-location") so `127.0.0.1` binding composes with `daemon-docker-selfhost`. [rule: `project/designs/CLAUDE.md` § Document Structure § 3]

2. **`endoclaw-pinchtab.md` § Origin allowlist: navigation-only scope.** Extend the gate description to call out that the allowlist confines navigation only, not off-origin content surfaced via embedded iframes or third-party scripts. [rule: `garden/skills/panel-review/SKILL.md` § Cite-or-propose]

3. **Both docs: name the test suite per phase.** The pre-PR checklist's regression-evidence rule cannot be evaluated against a test list that does not exist. [rule: `project/CLAUDE.md` § Pre-PR checklist + `garden/skills/regression-evidence/SKILL.md`]

4. **`endoclaw-browser-interfaces.md` § Base `Browser`: move `backend(): string` off `Browser`** onto a separate `BrowserIntrospection` capability the host hands out only when introspection is wanted. The agent's default `Browser` carries no `backend()`. [rule: `project/designs/CLAUDE.md` § Document Structure § 3]

5. **`endoclaw-browser-interfaces.md` § Base `Browser`: split `Page` into `ReadablePage` and `MutablePage`.** `newPage(url): Promise<ReadablePage>` with a separate write-allowing factory replaces the place-oriented `setReadOnly(flag)` toggle. [rule: `project/CLAUDE.md` § Type-assertion discipline § brand at validator]

6. **`endoclaw-browser-interfaces.md` § Base `Browser`: reshape `PageTarget`** from `{ref} | {role, name, nth}` arms into `SnapshotNode | SnapshotNodeQuery` so the user passes intent shapes rather than resolution arms. The backend takes responsibility for caching, freshness, and `nth`. [proposed-rule: a capability surface should expose user-intent shapes, not implementation-resolution arms]

7. **`endoclaw-browser-interfaces.md` § Base `Browser`: declare the throw set per method.** Align with `project/CLAUDE.md` § Error handling (use `@endo/errors` thrown values; name the tagged-error catalog as a type alias the design lists once). [rule: `project/CLAUDE.md` § Error handling]

8. **`endoclaw-browser-interfaces.md` § Base `BrowserControl`: rename `setReadOnly(flag)` for family consistency** (e.g., `setWritable(flag)`, or both toggles into one `setMode({readOnly, evalAllowed})` setter) so the four `BrowserControl` methods spell uniformly. [rule: `garden/skills/rename-discipline/SKILL.md` § family-consistency]

9. **`endoclaw-browser-interfaces.md` § Base `Page.snapshot`: define what a `ref` is in the base doc** (an opaque token the backend issues; agents pass it back; do not interpret); a reader who has not read `endoclaw-pinchtab.md` arrives at `ref: string` with no semantic explanation. [rule: `garden/skills/panel-review/SKILL.md` § Per-juror block shape (cite-or-propose)]

10. **`endoclaw-browser-interfaces.md` § Base `Page`: document the cost asymmetry** between `click({ref})` (one round trip) and `click({role, name})` (snapshot + resolve on PinchTab) on `help()`, or unify on one shape. An LLM agent will, by default, pick the readable form; the cheaper form is then never used. [proposed-rule: when a capability surface offers two ways to address the same target and one is structurally cheaper, the design must either document the asymmetry on the capability's `help()` text or unify on one shape]

11. **Both new docs: replace HTML entities with Unicode counterparts.** `&rarr;` to "to" or the Unicode arrow `→`, `&ndash;` to `–`, `&times;` to `×`, `&sect;` to `§` or the spelled-out word, `&nbsp;` to regular space. Rewrite the four `&mdash;` sites in the Prompt blocks per the em-dash rule (period, parentheses, or colon). Adjacent design docs use Unicode arrows, not HTML entities. [rule: `garden/skills/em-dash-style/SKILL.md`]

12. **Both new docs: heading-case discipline.** Pick one form (the corpus default is title case on `##` and `###`) and apply consistently; `endoclaw-browser-interfaces.md` mixes title case (`## Per-Backend Extensions`) with sentence case (`### Why not revise it in this PR`). [rule: Chicago Manual of Style § Headings layered with project convention]

13. **Both new docs: terminal-punctuation discipline in tables.** Pick period-terminated or no-period and apply across all rows in each table (`endoclaw-pinchtab.md` § Phased Implementation; `endoclaw-browser-interfaces.md` § Phased Adoption). [rule: Chicago Manual of Style § Tables § terminal punctuation]

14. **Both new docs: prose-flow fixes.** `endoclaw-pinchtab.md` § Auth and Trust Posture transition into "Token handling:" needs a lead-in clause; § Open Questions § 8 mixes imperative with descriptive in the same sentence (relocate to a followups subsection); § How It Works to § Endo Idiom needs a transition sentence. `endoclaw-browser-interfaces.md` § Why a Unified Shape § paragraph 2 should split into two paragraphs. CDP expansion on first use in `endoclaw-pinchtab.md` § What Is PinchTab? bullet. Inconsistent inline-code-vs-italic for proper nouns across both docs. Markdown line-length and sentence-per-line discipline in the Prompt blocks. [rule: `project/CLAUDE.md` § Markdown Style + `project/designs/CLAUDE.md` § Document Structure]

15. **`endoclaw-pinchtab.md` § Daemon-vs-Familiar Placement: introduce the Familiar for a new reader** (Electron desktop shell hosting user-facing Endo UIs) so a new reader can evaluate the daemon-not-Familiar decision. [rule: `garden/roles/jurors/novice/AGENT.md` § Operating norms § assumed background]

16. **`endoclaw-browser-interfaces.md` § Mapping Each Backend to the Base: precede the table with a one-paragraph reading guide** ("each row says one base-shape method, the Playwright call that implements it, the PinchTab call that implements it; mismatches are flagged in the two notes below the table"). [rule: `garden/roles/jurors/novice/AGENT.md` § Operating norms § example clarity]

17. **`endoclaw-pinchtab.md` § Origin allowlist: name the rationale for forbidding regex** (regex allowlists are not visually auditable at host grant time). [rule: `garden/roles/jurors/novice/AGENT.md` § Operating norms § skipped steps in reasoning]

18. **`endoclaw-browser-interfaces.md` § Base `Browser` Interface: move the framing sentence** ("This is the entirety of what an agent skill should bind against") to before the ~150-line interface code block, so the reader knows what to look for going in. [rule: `garden/roles/jurors/novice/AGENT.md` § Operating norms § prose density]

19. **Add a 10-line worked end-to-end example in either doc** ("agent logs into Gmail and reads inbox; here are the `E(browser)...` calls"). [rule: `garden/roles/jurors/novice/AGENT.md` § Operating norms § example clarity]

20. **`endoclaw-browser-interfaces.md` § Recommendation: name how the follow-up revision of `endoclaw-browser.md` gets actioned** (tracking issue, or the journal followup-ledger entry the steward actions on this PR's merge). [rule: `garden/skills/panel-review/SKILL.md` § Follow-up ledger]

21. **NEW (round-2): cross-doc Status mismatch on `endoclaw-browser-interfaces`.** The doc's metadata table says `Status: Not Started`; the README summary-table row, the M5 cross-cutting table row, and the README Totals narrative say `Proposed`. Pick one (the README's "Proposed" is the better fit for a design that is design-only and recommends a follow-up editorial PR; flipping the metadata table is the smaller edit) and apply across both surfaces. [rule: `project/designs/CLAUDE.md` § Progress Tracking § Cross-document]

## Notes for the claiming fixer

- All edits land on `design/endoclaw-pinchtab` (the PR's head branch on `endojs/endo-but-for-bots`); push as `git push origin HEAD:design/endoclaw-pinchtab --force-with-lease=design/endoclaw-pinchtab:24e5fdfc9...`.
- The PR is design-only; no CI run drives green; no `yarn.lock` churn; no test runner. The only gates are markdown rendering on GitHub plus the prose-style rules in `project/CLAUDE.md` § Markdown Style and `garden/skills/em-dash-style/SKILL.md`.
- Bundle as one commit on top of `24e5fdfc9` (a follow-up commit, not an amend), titled `design(endoclaw): address summary-fix bundle for #359`, body summarizing the 21 items.
- No top-level PR summary comment required; the bundle's commit message plus this job's body are the audit trail.
- The PR is already un-drafted before this fixer dispatch (the solicitor un-drafts on the same beat the bundle is posted); the fixer's push lands on a ready PR.
