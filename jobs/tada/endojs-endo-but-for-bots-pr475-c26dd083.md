The comment posted cleanly with the `garden-reply:5321203329` dedup marker and the provenance footer. The job is an "attention/answer-a-question" directive — no code change was required, and the deliverable is the factual reply.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #475 — erights (comment 5321203329) challenged a prior kriscendobot claim ("`@endo/bytes` / `@endo/pass-style` distinguish an emulated wrapper from a genuine view via the `immutable` accessor on `.buffer`") with "Where are these uses of `.buffer` in this PR head?"

**Preflight:** exit 2 (HINT). Corroborated — the only correlated artifact was kriscendobot's own "On it — posted a job" acknowledgment (garden-reply:5321203329), **not** a peer resolution. So I did the work.

**Investigation (head `b4a8175f52`, isolated project worktree):** Located every `.buffer` / `immutable`-accessor read across the two packages:
- `@endo/pass-style` `byteArray.js`: captures `immutableGetter` (22-32) and applies it to `.buffer` at lines 285 (`confirmCanBeByteArray` brand check), 172, and 102.
- `@endo/bytes`: inline `(view.buffer).immutable === true` copy-gates at `compare.js:38`, `concat.js:40`, `to-string.js:52`.
- Noted `genuine-uint8-array.js` (referenced in older review threads) no longer exists on this head.

**Key finding — the claim was imprecise, and I said so honestly.** `.buffer.immutable` reports whether the *backing ArrayBuffer is immutable* (true for **both** the emulated shim wrapper **and** a native Stage-3 immutable view; false for an ordinary mutable view). It therefore distinguishes *immutable-backed vs mutable* — the `byteArray` brand and the must-copy trigger — **not** "emulated wrapper vs genuine view." The emulated-vs-genuine distinction is actually drawn separately: by own integer-indexed-key count in pass-style, and (in bytes) the immutable branch copies because the emulated wrapper isn't integer-indexable, though the trigger would also harmlessly copy a native immutable view.

**Deliverable:** Posted the answer as PR comment https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5321257057 — lists the exact `.buffer` sites and corrects the original wording. Carries the `garden-reply:5321203329` dedup marker and auto-injected provenance footer.

**Changes:** none to any repo (question-answering job). **Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-c26dd083.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (1645505 cached reads)
- Output: 16961 tokens
- Cost: $1.9745344999999996
- Wall-clock: 270s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
