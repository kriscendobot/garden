## Completion report: `book-reader-exposure-copyedit-20261004`

**Result:** draft PR **https://github.com/kriscendobot/garden-book/pull/8** (head `book-reader-exposure-copyedit`, base `main-e6f2790`, a frozen snapshot of current `main`).

**What I did**
- **Reading and ledger.** I read chapters 1–4, 7 and 8 in full, in order, building the ledger as I went. For the reference catalogs (5, 6, 9, 10) I searched for terms and for event-style references, rather than reading every entry. I did the editing myself instead of splitting it across parallel agents.
- **Main problem found.** The book used Endo / `endo-but-for-bots` / `llm`, Ironhorse, and minion.town from chapter 1 onward and never said what any of them were. Chapter 1 § 1.1 now has a short paragraph introducing them, and later mentions point back to it.
- **The worked example (chapter 8).** "The cybernetics audit" no longer appears as something the reader is assumed to know. The intro says a loop-by-loop review shaped the controls and links the design docs for anyone who wants the rationale. Each audit finding is now stated as the past failure plus the rule it produced. I also removed internal job names, compressed the dated history of the foreman's target to one sentence, and replaced "omega rank" with a plain description.
- **Same pattern elsewhere.**
  - Chapter 7 § 7.2.2 was a dated automatic → manual → automatic history. It now opens with how the gauntlet trigger works today and ties each restriction to the failure it prevents.
  - I replaced these with plain descriptions of what they caused:
    - the `#58` incident, the "sparsecap" idea and "two review notes on the design" (chapter 4)
    - dated "maintainer directives", PR #75, `minion.town#41`, and internal job names
    - "As of main2 …" notes about gaps in the documentation
  - I removed the AWS account number and an aside about where earlier editions of the book were stored.
  - I added short explanations of the triager, the thesaurus jury seat, "press", the bulletin, TypeSafe, the conductor, the judicial roles, the foreman's active target and the botanist.
- **Size and checks.** 9 chapter files changed (+183/−170). `npm test` passes (21/21) and the book builds locally.

**The ledger**
- It lives at `editorial/reader-exposure-map.md`. It is for future copy-edit passes only and is never rendered.
- For each term it records where it is first introduced and what was decided for later mentions (rely on the reader remembering it, add a pointer, or replace it). It also has a table of how each internal-event reference was handled.
- The generator only renders files in `chapters/` named like `ch<N>-*.md` (`build/assemble-book.mjs`). I checked a local build and nothing from `editorial/` appears in it.
- The PR body says all of this.

**Left for a human decision (listed in the PR body)**
1. Chapters 5 and 6 still name the incidents and PR numbers that individual rules came from. I kept them on purpose because a catalog may serve readers studying the garden, but this needs a decision.
2. Chapter 8 still shows the original instance's live configuration (pool caps, worker counts and similar) as examples.
3. In chapter 4's AWS section I only removed the account number; the rest of the instance-specific detail is still there.
4. I deliberately kept the stories of how "retcon" and "pin the merge base" were coined, because that passage is about how verbs get coined.

**Follow-ups**
- Chapter 8 § 8.7 says `roles/accountant/` doesn't exist yet, but it now does on `main2`. That's a content refresh, outside this pass.
- The illumination and data productions running in parallel will probably edit the same chapters. Right now the only open PR is #7, which touches `art/` only. Whichever PR merges last will need to resolve the overlaps; the largest hunks are chapter 1 § 1.1, chapter 7 § 7.2.2, and chapter 8's intro and § 8.1.
- Successful completion should stage the gauntlet automatically. Nothing was published.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-reader-exposure-copyedit-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (8191551 cached reads)
- Output: 39164 tokens
- Cost: $4.292918200000001
- Wall-clock: 430s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
