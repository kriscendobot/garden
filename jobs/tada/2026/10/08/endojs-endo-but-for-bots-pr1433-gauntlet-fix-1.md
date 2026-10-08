Fix round 1 for endojs/endo-but-for-bots PR #1433 is done: I applied all three panel must-fix items, pushed them, and CI came back green (28 of 28 checks, 0 failed).

**What changed.** One follow-up commit, `4d7141de5`, pushed to `kriscendobot:design/formula-identifier-indirection` with `safe-push-pr-head.sh` (advance mode, fast-forward from `69e459899`). It edits `designs/daemon-formula-identifier-indirection.md` and `designs/README.md`.

**Must-fix items:**
1. **skeptic 1 (formula ids are moved, not removed):**
   - New subsection "Where formula identifiers still live". It says `formula_reference.target_formula_id` is now the only naming record that holds one, and also lists formula bodies, graph state, daemon-private calls and legacy locators outside the daemon.
   - It names the trust boundary as the daemon process and its manager database, not the pet-store table.
   - The Summary now calls the change a relocation. Acceptance criterion 1 names the one remaining record and says no host or guest facet method returns it.
   - The README index entry no longer says identifiers become "strictly internal"; it says they are moved behind the daemon boundary.
2. **skeptic 2 (rotation is not a full leak response while legacy resolution is on):**
   - The Summary and the rotation section now say rotation always makes the old `r1` locator fail. It only cuts off the target itself after legacy resolution is disabled in stage 5. Until then, a legacy locator or an identifier already disclosed by `identify` or the inspector still reaches it.
   - The threat model lists that case.
   - New acceptance test: with legacy resolution on, a legacy locator still reaches a rotated target. With it off, both the legacy locator and the old `r1` locator fail and only the successor resolves.
3. **pedant (em-dash):** the heading is now "### 4. Stateful opaque reference registry (recommended)". There are no other em-dashes in the design.

**One extra should-fix item, because it was cheap:** the retention edge label now uses a row number (`reference:<kind>:<row-ordinal>`) instead of a prefix of the reference number. That was critic finding 6: the prefix leaked part of the bearer secret into retention-path output.

**Left for the next panel round** (all should-fix, none must-fix):
- `locate()` creating permanent GC roots that can never be revoked.
- Justifying `binding` rows against the pet store holding the identifier directly.
- What a control facet does after rotate, after revoke, and when a stale copy is used.
- A list of `identify` callers and the order in which they get a replacement.
- Which peer resolves an `r1` reference and how failures cross CapTP.
- The gaps in the test list.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (830497 cached reads)
- Output: 6826 tokens
- Cost: $0.8298114000000001
- Wall-clock: 830s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
