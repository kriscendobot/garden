Panel round 4 on kriscendobot/minion.town#193 (head `9e0533e`) came back **must-fix**: 4 of the 34 seats requested changes (saboteur, breaker, spec-keeper and procurer).

**How it ran:**
- I ran it against an isolated checkout of `build/ocapn-guest-canary`, using `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 193 origin/main-30a4c62`. It exited with `rc=0` and its last line was `code-panel single-round — must-fix`.
- My first attempt died before it finished. I killed it by accident with a `pkill` that also matched my own shell. The panel then ran to completion once, detached, and that is the run reported here.
- The panel's check for repeated problems flagged `ocapn-canary.mjs`/`scrub` again, which forced the decomplector seat to ask whether the mechanism is needed at all. It endorses panel-3's removal of `scrub`.

**Posted reviews:** The full report was about 94 KB, more than GitHub allows in one review. I split it into two reviews, both posted as comments, because GitHub won't let the bot request changes on its own PR. Rounds 1–3 were posted the same way.
- Review 5549002469, posted last: the must-fix verdict header, a summary, and 19 seats' reports. It includes every seat that requested changes, plus the decomplector.
- Review 5549001180, posted just before it: the other 15 seats' reports.
- The `gh` wrapper refused the first post because it contained a bare `#191`. I confirmed that it means kriscendobot/minion.town#191 (the canary design PR) and rewrote every occurrence in full.

**Main must-fix threads for the next fix stage:**
- **Bindings file (`fileLedger` / `bindings.json`):** three failures escape `main`'s error handling, which only catches `NotProvisioned`. Each one exits 1 with no audit record:
  - a corrupt or partly written file, which throws `SyntaxError`;
  - a file holding `null`, which throws `TypeError`;
  - a failed `set` after a successful adopt, which leaves the binding unrecorded.
  The decomplector suggests dropping the file entirely and re-adopting each guest every run under an `ocapn-canary-guest-<label>` name.
- **Pet names:** `runIdentifier` comes from `toISOString()`, so it contains uppercase `T`/`Z`. That breaks the pet-name pattern the canary itself enforces (spec-keeper).
- **Self-deletion:** `NAME_PATTERN` accepts configured names that start with `ocapn-canary-`, and `reconcile` then deletes them (saboteur).
- **Duplicated helper:** the local `isRecord` duplicates the one in `@endo/pass-style` (procurer).

No garden repo changes and no PR edits; I did not fix anything or un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1468137 cached reads)
- Output: 8764 tokens
- Cost: $0.9974913999999999
- Wall-clock: 1563s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
