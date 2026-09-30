## Completion report: book-revise-content

The revised garden book is published, and the new chapters and build changes are on journal2.

**New edition:** https://dajt26qwtcxayo7bbm5sfokdhosqznrmwm7uahtuyxofbggo5nza.ocap.site/
I fetched the live page after publishing: the new `<title>` shows and chapter 10 is present.

**Title:** *The Garden That Tends Code*. Subtitle: "An agent fleet through its metamorphoses: how it is organized, operated, and paid for, and how it remembers what it has learned."

### What changed
All files are in `projects/garden-book/` on journal2, each landed with `land-journal-edit.sh`.

- **`ch9-library-structure.md` (new chapter):**
  - What the library looks like on disk: the three indexing axes, section and concept file shapes, how staleness and contradiction are handled, the variants for each kind of source, and library versus project tree.
  - How material gets in, via the scholar: job-driven, the check against each source's recorded commit that makes re-ingesting cheap and append-only, the 3–5 sources or ~25 sections per cycle budget, follow-on jobs for leftover work, the integrity gate, and the lander.
  - How material is found, via library-lookup: what happens on a hit and on a miss, and the three writebacks that improve the index for the next caller.
  - How the researcher inlines a `## Library and project references` section into a design or build job before it starts.
  - The context-economy argument with measured numbers: the library is about 32 MB (~8M tokens), a typical section is about 500 tokens, and a lookup reads roughly 1–1.5k tokens. The scholar's budgets are presented as the same discipline applied to writing.
- **`ch10-inference-tiers-reference.md` (new chapter):** a reference built from `model-selection`, `model-tier-inventory.tsv`, `model-routing-defaults.tsv` and the functions in `common.sh`. It covers:
  - the four tiers, including myrmidon (the source skill has four, not three);
  - which models sit in each tier, per provider;
  - the worker kinds and which are live. Only monks have slots today; clerics are installed at 0; hermit is retired;
  - how a job gets its tier (automatic, manual mentat, and the Ironhorse exception);
  - the role floors (designer/builder at mentor, everything else at minion);
  - how fallback works;
  - a quick-lookup table at the end.
- **`build/intro.html`:** the new title and subtitle, the edition note, and chapter 9 and 10 entries in the chapter guide.
- **`build/build.py`:** the book title was hardcoded here too, in the `<title>` and the sidebar heading, so I updated both.
- **`build/README.md`:** the Edition line now shows the new URL, and the first edition's URL is kept under "Prior editions."
- **Maintainer:** sent the URL and title with `message-user.sh`.

### Follow-ups
- **Myrmidon roles:** the americanizer and deslopper briefs call them myrmidon-tier, but the model-selection skill says `post-job.sh` rewrites every automatic post to `tier: mentor`. Chapter 10 presents myrmidon as the tier their briefs intend. I did not check whether their posting path keeps myrmidon; that is worth checking.
- **Stale chapter:** the book's "Edition" note says chapters 1–8 are unchanged. If fleet routing changes, chapter 10 will go stale sooner than the rest.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-revise-content.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2139000 cached reads)
- Output: 20703 tokens
- Cost: $1.5882759999999998
- Wall-clock: 252s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
