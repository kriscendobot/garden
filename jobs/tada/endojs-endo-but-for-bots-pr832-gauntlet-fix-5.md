CI is green (rc 0). The fix stage is complete.

## Completion report

**Job:** `endojs-endo-but-for-bots-pr832-gauntlet-fix-5` — gauntlet FIX round 5 for endojs/endo-but-for-bots PR #832 (design doc `designs/readableblob-lines.md`, "ReadableBlob Lines Stream").

**Panel verdict addressed:** design-panel round-5 (must-fix), from the request-changes review the panel-5 stage posted. Applied the panel's must-fix and clear should-fix items in one follow-up commit, then stopped (no panel re-run — the driver posts panel-6).

**Changes applied to `designs/readableblob-lines.md`** (1 commit, `4c25b3d3a`, +124/−15):
- **critic #1 (must-fix):** restated the wide-blast-radius premise as *"every producer can trivially satisfy the adapter's iterator shape"* rather than *"already exposes incremental byte iteration,"* explicitly distinguishing the genuinely-incremental producers from the fully-resident-buffer ones (`BlobRef`, `blobFromBytes`, git whole-object paths).
- **critic #2 (must-fix):** stated the mount **revocation-mid-stream** contract inline — already-buffered lines flush, then the next pull rejects with the mount's `EPERM`-class revocation error across CapTP, never a silent `done`.
- **critic #3 (must-fix):** added an independent on-the-merits weighing/rejection of a terminator-mode-flag unifying alternative (three counts) so the divergence no longer rests solely on the commissioning prompt.
- **skeptic #1:** stated the **growth-mid-stream** (live-log) end-of-stream contract — `lines()` is finite to current EOF; resume via `lines({ startLine })`; tail-follow is deferred.
- **skeptic #2:** named the **unbounded per-line buffering** limitation for an overlong/unterminated line as accepted-and-documented, with the mitigation and a follow-up.
- **ergonomist #1/#2 + novice #3:** added the name-based-discovery risk (shared guard doc-comment must carry the returns-a-reader callout) and the `lines`/`streamBase64` invocation-protocol divergence; glossed what `streamBase64` does.
- **decomplector #1 + novice #1:** named the `BlobRef` guard exception at first mention of "define once, propagate everywhere," and defined "guard" in one clause at first use.
- **copyeditor/pedant (must-fix arrow + 3 should-fix):** ASCII `->` for the `getInfo → contentAddress` arrow; colon for a comma splice; disambiguated a tangled relative clause; resolved the forward reference to the terminator-retention callout.
- Extended the Follow-up section to back the new max-line-length, tail-follow, and `streamBase64`-convergence references.
- Swept every em-dash I introduced (parentheses/period rewrites) so the pedant's "no em-dashes introduced" check still holds; verified zero non-ASCII typist-hostile code points remain in the edits.

**Push & CI:** pushed as a review-feedback follow-up (`safe-push-pr-head.sh`, advance mode, `e8008dc4b..4c25b3d3a`). CI watched to terminal: **GREEN** (5/5 checks, 0 failed, rc 0).

**Follow-ups:** none required by this stage; the driver re-posts the panel (round 6).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr832-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 69 tokens (2883520 cached reads)
- Output: 19909 tokens
- Cost: $2.7441909999999994
- Wall-clock: 668s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
