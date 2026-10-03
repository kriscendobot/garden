I redesigned the garden book's look, rebuilt it and republished it. The chapter text is unchanged.

**New edition:** https://h3ioeqplnvm5cbrxgifjjliisdzanhokdinysv3wuae2ia2xzopq.ocap.site/

**Where the work sits.** The copy-edit (kriscendobot/garden-book#1) is still a draft and not merged. So I based this work on top of it: draft PR kriscendobot/garden-book#2. Its base is a frozen copy of the copy-edit branch, `book-copyedit-913c8a7`. The published book therefore includes the copy-edits, and #2 will need to be retargeted onto `main` once #1 merges. I also sent this summary to the maintainer inbox.

**Checks.**
- All 551 links within the book resolve, and no heading id is duplicated.
- I took screenshots at desktop (1440 px), tablet (1024 px) and phone (390 px) widths, in light and dark. Nothing scrolls sideways.
- The published files match the build byte for byte, and the page renders correctly under the site's real security policy, which bans external assets.
- One limit: this machine only has DejaVu and Liberation fonts, so the screenshots used fallback faces. Palatino, Iowan, Gill Sans and Candara were not seen rendered.

**Design decisions:**
- **Tufte margin notes.** The body is a serif text column about 65 characters wide, with a margin column beside it on wide screens (76em and up; narrower, the notes drop inline). The margin carries:
  - each chapter's provenance (who wrote it, which commit it was grounded on);
  - each catalog entry's source file;
  - each chapter's own contents list.
- **Source links fixed.** In chapters 5 and 6, the 134 "Source:" lines used to link back to their own entry. They now link to the real file on `main2` and sit beside the entry heading.
- **Gardening-book structure.** The ten chapters are grouped into five parts, each marked by a small line drawing of a growth stage:

  | Part | Chapters | Drawing |
  | --- | --- | --- |
  | Roots | 1–2 | seed |
  | Planting | 3–4 | seedling |
  | Catalog | 5–6 | leafy stem |
  | Tending | 7–8 | bloom |
  | Almanac | 9–10 | seed head |

  The drawings show where you are in the book, which is how they pass Tufte's "earns its place" test. They appear in a row on the title page, in the sidebar, in the contents and above each chapter. They are inline SVG, so no external files.
- **Palette.** Paper, soil and leaf colours instead of tech-docs blue. Links and drawings are leaf green. A clay accent is used only for chapter numbers, section numbers and entry labels. A matching dark scheme is included.
- **Restraint.** Tables have horizontal rules only and can widen into the margin. Inline code has no background boxes. Headings and the old double rule between chapters are replaced with whitespace.
- **Type.** System font stacks only: Iowan or Palatino for the body, Gill Sans or Candara for headings, labels and navigation. Chapter titles are a regular-weight serif, and body text uses old-style figures.
- **Phones.** The sidebar becomes a slim sticky bar with the book title and a link to the contents.
- **Title page and history.** The edition note is now a margin note. Earlier editions are still listed there, and in full in `build/README.md`. I dropped the list of included files, since each chapter's margin note already names its file.

**Files changed:** `styles.css` (rewritten), `intro.html`, `build.py` (the hooks for parts, drawings and margin notes), `publish.py` and `build/README.md`.

**Things to decide or follow up:**
- **Publishing fix.** `publish.py` used to pass `powers: "sites"`, which hands every visitor the publishing capability. It now passes an empty, inert pet name.
- **The copy-edit edition is affected by the same issue.** It was published with `powers: "sites"`, so that clip may still be handing its visitors that power. Whether to unpublish it is your call.
- **Part names.** Roots, Planting, Catalog, Tending and Almanac are an editorial choice, set in `PARTS` in `build.py`, which needs updating if chapters change.
- **A link not fixed.** Some cross-chapter role links, such as the "builder" link in a chapter 2 table, still go to GitHub instead of the chapter 5 entry. I didn't fix it here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-design-pass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (5816697 cached reads)
- Output: 54162 tokens
- Cost: $3.5924994000000003
- Wall-clock: 595s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
