CI is green. All five must-fix items applied, pushed, CI green.

## Completion report

**Job:** Gauntlet FIX round 4 for endojs/endo-but-for-bots PR #997 (design-doc PR: `design(daemon): reassess worker retention, revocation, and the batch-flush retention root`).

**Panel verdict:** round-4 design panel, disposition must-fix (7 seats, all request-changes). Applied the five must-fix items once, pushed as follow-up commit `78863ae6f`, watched CI to green, stopped (did not re-run the panel).

**Must-fix items addressed:**
1. **README milestone contradiction** (copyeditor/pedant/critic/novice/decomplector): the layered note said M3 but the milestone row, estimate row, and mermaid node all place the design in M4. Corrected the note to M4 (Networking) and "M4 milestone row synced."
2. **Q1 third window mis-trace + concealed fifth retention root** (critic): verified against landed CapTP that `CTP_CALL` resolves an answer-position target from the `answers` map first (`captp.js:773-781`), and `answers` is cleared only by `CTP_DROP`'s last-ref branch (`:767`), never by resolution — and `gcImports` defaults `false` (`:291`), never enabled at `connection.js:166`. So the real failure is a **silent rebind to the resolved value**, not the claimed `Unknown export` hang, until the `answers`/export entry is also gone. Rewrote the "Arrival after collection" bullet accordingly; enumerated the exporter's `answers`/export-table entry as the fifth retention root; added a **third release conjunct** (drop it in the same graph mutation as the `question` edge) to Q4's release condition and Design Decision 6.
3. **Partition-shaped asserted, not argued — row 3 vs row 4** (skeptic): applied Thread 1's discriminator instead of name-dropping it. The post-resolution forcible cross-peer drop is a row-3 single sever of a *settled* import; the design now **owns that tax** and confines it to the withholding (misbehaving) peer, while the pre-resolution lease and admission-cap refusal act on unsettled transients (ordinary promise-level partial failure). Adjusted all four assertion sites (Q4 forcible-drop, Q2 lease (i)/(ii), admission cap, Recommendation headline).
4. **`pinTransient` "every landed call site" false** (skeptic): verified `host.js:2069`/`2090` and `manager.js:6737`/`6757` pin/unpin with no `try`/`finally` across three awaits (leak on error path), while `directory.js:506-510` is the clean form. Corrected to "some, not every" and noted the inherited error-path leak.
5. **"fourth window" ordinal collision** (copyeditor): named Thread 2's hazard the **dependency-hand-off zero-refcount window** rather than reusing the ordinal "fourth" reserved for the cross-peer case.

**Changed:** `designs/worker-retention-and-revocation.md`, `designs/README.md` (+133/−55).

**CI:** rc 0 — 5/5 checks green, 0 failed.

**Follow-ups:** Several should-fix/comment-only items remain for the next panel round (hard-wrap one-sentence-per-line, Latin shorthand, em-dashes, heading levels, worker-discipline content-addressing consequence, missing test catalog/phasing, vocabulary gaps). Not addressed here per the fix-stage's apply-must-fix-once mandate.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr997-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3933766 cached reads)
- Output: 32228 tokens
- Cost: $3.7557099999999997
- Wall-clock: 893s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
