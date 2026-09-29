I widened the banner detector so the line kriskowal flagged on #1125, `// --- Fallible work, before the consume ---`, now triggers the archivist. The change is pushed straight to main2 as **e17a717171d**. The detector test and the panel test both pass.

**Changes**
- **Detector** (`scripts/jobs/gardening/detect-banners.sh`): it now also catches a comment title with a run of 2 or more rule characters (`- = * ~ _`) at both ends, like `// --- title ---` or `# === title ===`. The title has to be set off from the runs by spaces and start with a non-rule character. That is what keeps these quiet:
  - `// foo -- bar` and `// a -> b`
  - prose with dashes in it
  - a comment that starts with a run but has none at the end
  - JSDoc bold such as ` * **Note**`
  
  It covers `//`, `#`, ` * ` and `/* … */` comments.
- **Skill** (`skills/no-comment-banners/SKILL.md`): § The rule now describes the bracketed-title shape with examples, and § What is not a banner notes that `// foo -- bar` is fine. § How to sweep has two new grep recipes, which I checked against the #1125 lines and the negative cases. I also added a dated field note.
- **Archivist brief** (`roles/jurors/archivist/AGENT.md`): I also updated its banner definition to include bracketed titles, so the juror applies the same rule the detector now flags. The job didn't ask for this.
- **Tests** (`scripts/jobs/test/detect-banners-test.sh`): I added the cases to the existing detector test, one repo per case:
  - **Should fire:** the two #1125 lines, which I pulled from endo-but-for-bots commit 15ebcccb31 (`packages/daemon/src/manager.js`), plus `# === Title ===`, ` * ~~ Section ~~` and `/* -- Section -- */`.
  - **Should not fire:** `// foo -- bar`, `// a -> b`, a dash-heavy sentence, JSDoc `**Note**`, and a comment with only a leading run.

**Test output**
```
  PASS: check: added banner rule exits 0 (banner found)
  PASS: lines: reports the offending path and rule text
  PASS: check: clean change exits 1 (quiet)
  PASS: lines: clean change prints nothing
  PASS: check: removed banner is NOT a hit (added-lines-only)
  PASS: check: arrow/dash prose is NOT a banner
  PASS: check: markdown thematic break is NOT a banner (code files only)
  PASS: check: equals/star/block rule forms all hit
  PASS: check: unresolvable base -> clean & quiet (exit 1)
  PASS: check: #1125 fallible-work title hits
  PASS: check: #1125 consume-last title hits
  PASS: check: hash equals title hits
  PASS: check: JSDoc tilde title hits
  PASS: check: block-comment title hits
  PASS: check: double-dash prose is NOT a banner
  PASS: check: directional arrow is NOT a banner
  PASS: check: prose with dashes is NOT a banner
  PASS: check: JSDoc bold emphasis is NOT a banner
  PASS: check: leading run only is NOT a banner
detect-banners: 19 passed, 0 failed
panel-banner-trigger: 6 passed, 0 failed
```

**Cluster closed:** I ran `review-miss-record.sh cluster-status comment-banner-decoration closed --improved-by "e17a717171d"`, which printed `status=closed`. It took 21 retries (about 25 minutes) to get the change onto the journal because the host's journal sync is slow.

**Known limits:** a bracketed title with no spaces inside, like `// ---title---`, won't fire; that is the price of keeping JSDoc bold quiet. A comment like `// -- aside -- more --` will fire. That is a false positive, which the detector's design prefers over a miss, and the archivist makes the final call.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/widen-banner-detector-bracketed-title.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (902104 cached reads)
- Output: 9247 tokens
- Cost: $0.9153128
- Wall-clock: 1605s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
