The re-export deprecation policy automation is built and on `main2` in commit **`b499967687`**. The probe and seat-gate tests pass after rebasing onto the latest `main2`. Nothing had been committed by earlier attempts, so all of it is new in this commit. No PR was opened and no gauntlet was staged, as the job asked.

**What changed** (all five Decisions are applied):
1. **`skills/re-export-deprecation-policy/`** is the one place the rule lives: the `export … from` forms, what a compliant `@deprecated` shim looks like, the exemptions, and the `reexport-policy-exempt` marker.
   - **Running Babel without fetching anything (Decision 4):** I copied `@babel/parser` 7.29.7 into the skill as `vendor/babel-parser.cjs`, a single file with no external `require()`. Its MIT `LICENSE` and a README on how to refresh it sit alongside.
   - **`reexport-parse.cjs`** is a small helper that reads a file on stdin and lists each value re-export with an ID that doesn't depend on its line number. It also says whether a `@deprecated` JSDoc sits directly above it.
2. **`no-plain-reexport.sh`** is the pre-push probe:
   - A cheap grep for `export` on added lines decides whether the file gets a full Babel parse. The parse compares the before and after versions, so only newly added re-exports without `@deprecated` are flagged.
   - Barrels are flagged. Type-only re-exports and `.d.ts` files are skipped. It can't auto-fix, so it fails the push gate.
   - It also has `check` and `report` modes, so the jury seat reuses it as its first pass and there is only one detector.
3. **`reexport-auditor` jury seat** (the brief plus `seat-gate-reexport-auditor.sh`) copies the orthographer gate's structure. It spends a `claude -p` only when the probe finds a candidate.
   - I added it to `GARDEN_CODE_SEATS`.
   - I also mapped it to haiku in `seat-model-tiers.tsv` (Decision 3 asks for a low-tier model). That wasn't in the job spec, but `panel-seat-tiering-test` fails for any seat left unmapped.
4. **Norm lines** in the builder, fixer and web-builder roles, in the same provenance style as the existing rules. I also added a row and a changelog entry in `skills/pre-push-gates/SKILL.md`, and listed the new seat and skill in `CLAUDE.md`'s inventory.
5. **Tests:**
   - `no-plain-reexport-probe-test.sh`: 19 pass. It covers a bare re-export, a deprecated shim, each of the five forms, the exempt marker, re-export text inside a string or comment, a removed line, a barrel, type-only and `.d.ts`, the before/after comparison, and the `check`/`report` exit codes.
   - `seat-gate-reexport-auditor-test.sh`: 10 pass, using a stub `claude`. It covers approve, cannot-determine, spending the model call (with the candidates passed as data), the fallback when `claude` returns nothing, the shim not being flagged, and the `panel.sh` wiring.
   - The existing `pre-push-gates-test`, `review-convention-probes-test` and `panel-seat-tiering-test` also pass.

**Follow-ups:**
- If `node` is missing on a host, the push gate skips this check with a warning instead of blocking every push. On such a host the jury seat also can't run the check, so it reports "could not be checked" rather than approving.
- This job doesn't fix the re-export in `compare.js` on endo-but-for-bots #475. That's still a separate fixer job for the maintainer to send.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-reexport-deprecation-policy-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 242 tokens (14159331 cached reads)
- Output: 120347 tokens
- Cost: $19.151871299999996
- Wall-clock: 1630s
- Model(s): claude-opus-4-8 ×2, claude-opus-5-5 ×1

<!-- garden-usage-end -->
