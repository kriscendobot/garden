FIX round 2 complete. Applied the panel-2 must-fix items to design PR #1102, pushed as a review-feedback follow-up commit, and CI is green.

**What I did**

Read the panel-2 request-changes verdict (complecting seat, ergonomist, copyeditor, pedant, novice) on the narrowed design `designs/introduced-special-names.md` (a pure design-doc PR) and applied the must-fix items in one commit (`5f79ac9ff`), pushed to the PR head `kriscendobot:design/claude-agents-capability` via `safe-push-pr-head.sh`.

**What changed**

Substantive design fixes:
- **Reserved set named + forward-compat contract**: named the daemon's closed owned special-name set (`guest.js:94-104`, `host.js:504-524`) and added a **statically disjoint introduction sub-namespace** (reserved `@x-` prefix) so collision-freedom is structural rather than a point-in-time check against a set the daemon may extend later. Added as § and design decision 5, and folded into the security invariants.
- **Get-or-create existing-agent branch specified** (new § Provisioning against an existing agent): identical `introducedSpecialNames` map is idempotent; a differing map rejects.
- **Revocation stated** (new §): the name is indelible for the agent lifetime; a revocable endowment is a caretaker/attenuating forwarder behind the name, not name removal; formula-id removal is unsupported.
- **Key grammar** restricted to single local names, matching the `introducedNames` sibling resolver (`identifyLocal`).
- Added a receiving-side lookup/remove/rebind example; named `help()`/CLI (`--introduce-special`) deliverables and the inverted existing `introducedNames` help entry.

Prose/citation fixes: `**Revised**`→`**Updated**`; sentence-per-line per CONTRIBUTING.md § Markdown Style; dropped `e.g.`/`i.e.`; fixed dangling modifiers and non-parallel series; corrected drifted citations (`types.d.ts:1444`, `host.js:83`/`1867-1869`, `manager.js:717`/`734-761`/`1162-1165`, `formula-record.js:55`/`80`); README terminology drift at line 1011 and mermaid node id `cagents`→`isn` (consistent rename).

**CI**: all 5 checks (browser-tests, build, lint, test, zizmor) green on head `5f79ac9ff` — `ci-wait-merge.sh` rc 0.

**Follow-ups**: none for this stage. Per the gauntlet, I did not re-run the panel; the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 100 tokens (3436086 cached reads)
- Output: 26042 tokens
- Cost: $4.46299575
- Wall-clock: 1042s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
