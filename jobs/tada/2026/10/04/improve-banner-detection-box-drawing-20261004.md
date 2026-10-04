The banner detector now catches the shapes the shepherd had to remove by hand on minion.town#148. The change is on main2 as `59cef5bd7aa`. All 41 cases in `scripts/jobs/test/detect-banners-test.sh` pass, `panel-banner-trigger-test.sh` passes, and shellcheck is clean. Against the old detector, 15 of the new cases fail, which confirms the tests cover the gap the maintainer pointed out.

The detector is `scripts/jobs/gardening/detect-banners.sh`. It runs on added diff lines before a review panel. When it finds a banner it adds the archivist juror to the panel and passes along the offending lines; it never edits code itself.

**Newly flagged:**
- **Unicode box-drawing characters:** any comment containing even one character from U+2500 to U+259F counts as a hit. These characters only ever draw rules, boxes or line art. This covers:
  - `// ── title ──` (U+2500 rules around a title), in JS/TS and as a trailing comment after code.
  - Heavy (`━`) and double (`═`) rule lines, including inside `/* … */` and ` * ` JSDoc lines.
  - Shell boxes (`# ┌──┐`, `# │ Title │`, `# └──┘`).
  - Solid block rules such as `████`.
  - A box character only counts inside a comment: after `//` or `/*` anywhere on the line, or after `#` or `*` at the start of the line.
- **More plain-ASCII rule lines:** `##########`, `//////////` and `# +--------+`.
- **Shell files:** `.sh` and `.bash` files are now scanned along with js/ts/jsx/tsx/mjs/cjs, so `# ----`, `# --- Setup ---` and the box shapes above are caught in shell scripts.
- **Still not flagged (tests confirm):**
  - Box characters inside a string literal.
  - Accented letters in comments.
  - Shebangs and TypeScript `/// <reference>` lines.
  - Prose with `--` in it.
  - `## Usage` headings.
  - Anything in `.md` files.
- **Same results with any awk:** the detector forces byte-wise matching (`LC_ALL=C`), so the host's mawk and gawk give the same results.

**Other files changed:**
- `skills/no-comment-banners/SKILL.md`: the rule now covers Unicode boxes and `#`/`/`/`+` rules, the sweep commands include the new patterns, and there is a dated note crediting minion.town#148 comment 5981444423.
- `roles/jurors/archivist/AGENT.md` and `roles/jurors/pedant/AGENT.md`: the banner rule text is widened to match.
- `typist-friendly-code-points.sh`: a comment pointed at a `no-ascii-banners` probe that doesn't exist; it now points at `detect-banners.sh`.
- The test file had shell banners of its own (`# --- 1: HIT … ---`), which the detector would now flag; I rewrote them as plain comments.

**Not added:** there is still no pre-push check for banners, so the panel step is the only automated enforcement. ASCII boxes with `|` side walls (`# | Title |`) are not matched directly; the `+---+` top and bottom lines are what triggers the review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-banner-detection-box-drawing-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1207016 cached reads)
- Output: 14281 tokens
- Cost: $1.0856552
- Wall-clock: 163s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
