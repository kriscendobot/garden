Verified — my reply rendered fully intact (all `` `inline-code` `` spans, the `$(…)` examples, and the commit link preserved), demonstrating the file-based posting path works. The review is fully addressed.

## Completion report

**Job:** Review directive on `endojs/endo-but-for-bots#475`, review `4976914415` by @erights.

**Scope (verified):** This review contains exactly **one** inline comment (id `3816859659`, on `packages/bytes/src/compare.js`) — a security question following up on my earlier "the comment body was interpolated into a shell word" explanation. Was it a shell code-injection vulnerability? If so it's an emergency; report on any such flaws in generation logic/guardrails I can't fix. (The sibling "phantom references" comment `3816877676` belongs to a *different* review, `4976935353` — out of scope here.) Preflight returned PROCEED; no prior resolution existed.

**What I found (honest security assessment):**
- **Yes, in mechanism it is the command-injection class**, not a cosmetic quoting issue: backticked identifiers in a body placed literally on a `gh` command line were command-substituted by bash *before gh ran*.
- **Realized impact: nil.** The executed tokens were my own identifiers (`bytesFromText`, `encodeUtf8`, …) → `command not found` → empty → collapsed spans. Only damage was silent text loss; content was self-authored, no exploitation pathway realized.
- **Severity ceiling is high:** the same sink would execute attacker-controlled `` `$(…)` `` if untrusted text (a quoted-in comment, commit message, filename) ever reached a command-line body → RCE on the bot host. erights is right to treat the *class* as emergency-grade.
- **A downstream `gh` wrapper cannot fix it** — the shell evaluates the line before the wrapper sees argv.

**What I changed:**
- Garden commit **`9af1194301`** (pushed to `main2`): new standing rule in `roles/COMMON.md` and rewritten guidance in `skills/pr-review-thread-replies/SKILL.md` — never interpolate a body onto a shell command line; write it to a file and pass the file to `gh` (`--body-file` / `-F body=@file`). This removes the sink at the point of generation.
- Posted the reply (`#discussion_r3816976888`) **via the file-based path**, demonstrating the fix; verified it rendered intact.

**Honesty note surfaced to erights:** I explicitly corrected my prior (2026-08-18) claim on that thread that a "deterministic guard" was added to the gh wrapper — **no such guard exists in deployed code** (the cited commit `745fa908` was only the provenance footer's deployed-sha). I flagged that the real mitigation is disciplinary, that a wrapper symptom-detector wouldn't catch the dangerous case, and offered to design mechanical enforcement (single file-only posting helper) as a follow-up if wanted.

**Follow-ups (offered, not owed):** mechanical enforcement of file-only comment bodies across the fleet — awaiting maintainer interest before designing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-review-60fc33cf.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 50 tokens (1958288 cached reads)
- Output: 27599 tokens
- Cost: $2.468968 (2 engagement(s) unpriced)
- Wall-clock: 525s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
