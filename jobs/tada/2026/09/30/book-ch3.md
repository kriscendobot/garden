Chapter 3 was already finished and pushed by the earlier attempt, so this run changed nothing and did not rewrite it.

**What I found**
- The file is `journal/projects/garden-book/ch3-using-the-garden.md`, about 6,000 words. It landed on `origin/journal2` in commit `4d9dd0a7564` at 2026-09-30 04:07Z, through `land-journal-edit.sh`, before the attempt was requeued. The live journal copy is byte-for-byte the same as the committed one.
- It covers all five parts of the spec:
  - **3.1 Who you are talking to:** the session's startup checks, the liaison as a relay rather than a doer, the narrow things it does itself, and how work reaches workers.
  - **3.2 The vocabulary:** grouped by what the person wants to do (getting oriented, starting up, getting work done, the ferry as a special case, managing the queue, fleet operations, and negation).
  - **3.3 Muster:** why it exists, the TypeSafe pilot that now runs by default, and the compact, classify and dispose passes.
  - **3.4 The plan queue.**
  - **3.5 Two worked examples**, "build #1234" and "run the gauntlet #56".
  - It also has a **3.6 Quick reference**.
- It was written against `main2` at `2a5c1991779`, which is one commit behind the current tip. That commit is a skill change unrelated to the liaison or its vocabulary.

**Checks I ran now:** every `blob/main2/...` link in the chapter points to a file that exists on current `main2`, and the chapter has no em-dashes.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-ch3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 52 tokens (1975349 cached reads)
- Output: 24013 tokens
- Cost: $2.0731458
- Wall-clock: 355s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
