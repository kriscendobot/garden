Pushed to `main2`. Job complete.

---

## Completion report

**What happened:** Two garden-owned DRAFT design PRs (`endojs/endo-but-for-bots#1023`, `#1024`, from `groom-endo-designs-readme` and `groom-endo-stale-design-docs`, 2026-08-17) each cited their own PR in the completion report using the shorthand `owner/repo#N` form rather than a full URL. Both `scripts/jobs/auto-gauntlet-handoff.sh` (stager) and `scripts/jobs/assert-design-pr-gauntlet.sh` (gate) scraped reports with a full-URL-only regex, so they found zero matches: no design-panel gauntlet staged, no completion gate — a **silent** re-occurrence of the `garden-design-pr-gauntlet-bypass` class via a new code path.

**What I changed:**
- **`scripts/jobs/common.sh`** — added one shared helper `extract_pr_refs_from_text <file>`, placed next to `parse_pr_ref` (which already parses both citation forms). It scans a text file for every full-URL **and** every `owner/repo#N` match, normalizes each through `parse_pr_ref` to a canonical PR URL, and emits them de-duplicated in first-seen order. A boundary guard keeps URL path segments and comment fragments (e.g. `#discussion_r5`) from being misread as shorthand.
- **`auto-gauntlet-handoff.sh`** — the report scrape and the builder-path job-file citation scrape now call the shared helper instead of the inline full-URL grep.
- **`assert-design-pr-gauntlet.sh`** — the report scrape now calls the shared helper.
- **`scripts/jobs/test/design-pr-gauntlet-bypass-test.sh`** — extended (not duplicated) with a section (c) that drives both the stager and the gate with shorthand-only citations modeled on `#1023`/`#1024`: asserts the shorthand-cited design PR gets a gauntlet record staged, that the gate passes once staged, and that a shorthand-cited design PR with **no** record still **blocks** completion (the exact bug).

**Verification:** the extended bypass test, `auto-gauntlet-handoff-test.sh`, and `gauntlet-test.sh` all pass; the full-URL and builder paths are unchanged. House style (`skills/fully-qualified-github-urls`) is deliberately left as-is — this is the mechanical backstop for when a report doesn't follow it. Committed and pushed directly to `main2` (garden-infra, no PR).

**Follow-ups:** none required. The two grounding-incident gauntlets were already staged by hand (`endojs-endo-but-for-bots-pr1023-gauntlet`, `endojs-endo-but-for-bots-pr1024-gauntlet`) before this job; this fix prevents recurrence.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-gauntlet-shorthand-citation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 32 tokens (1076189 cached reads)
- Output: 13269 tokens
- Cost: $1.4946465000000002 (1 engagement(s) unpriced)
- Wall-clock: 193s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
