## Botanist report: endojs/endo-but-for-bots#1553 (`eslint-plugin-jsdoc` 64.5.4 → 65.3.12)

**Verdict: EMBARGO-2026-10-26.** The PR is not merged. Every diligence check passed, but CI is red, and the auto-merge gate requires green CI. All the red comes from GitHub's Ubuntu 26.04 runner migration, not from this PR.

**Checks:**
- **Still needed:** the `llm` base is uniformly on 64.5.4 at both sites. The head is 1 commit ahead and 0 behind, so the PR is not superseded.
- **Lockfile:** 8 versions moved: the headline plus 7 `@typescript-eslint/*` packages from 8.70.0 to 8.71.2. No packages are new and no licenses changed.
  - All 8 were published by GitHub Actions with a SLSA provenance attestation. None adds an install hook.
  - The install ran with scripts disabled; the provisioning log confirms it.
- **Maturity:** the newest moved version is the headline itself, published 2026-10-18T15:17:50Z. The 7-day floor (2026-10-25T15:17:50Z) has passed.
- **Advisories:** OSV and the GitHub advisory database show nothing for any incoming version or for the outgoing 64.5.4.
- **Source:** I diffed the two npm tarballs (30 files). The changes are rule logic only, with no network, `child_process`, filesystem writes, or text aimed at an AI reviewer. I read no upstream prose, so no content classification was needed.
- **CI:** `lint` is green, so this major version needs no code changes.
  - Also green: zizmor, check-action-pins, viable-release, test-xs, test-hermes, async-hooks, ocapn-python/guile and familiar-bundle.
  - The macOS and ubuntu `test` legs were still running when I stopped.

**Red checks, all from the Ubuntu 26.04 migration:**

| Check | Cause | Fix |
| --- | --- | --- |
| `build` | `tred: command not found` | #1546 (open, not merged) |
| `sandbox-drivers`, `cover` 22.x/24.x | `bwrap` tests fail: `ulimit: Illegal option -u` | #1542 (open) |
| `browser-tests` | Playwright doesn't support chromium on ubuntu26.04 (also red on the `llm` tip) | none existed; I posted a job |

**What I did:**
- Posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1553#issuecomment-6402966822
- Wrote the ledger row with `EMBARGO-2026-10-26`: `journal/entries/2026/10/25/204040Z-message-botanist-3491f2.md`.
- Posted the fixer job `endojs-endo-but-for-bots-ci-ubuntu2604-browser-tests-playwright`. This red blocks every Dependabot auto-merge on the repo, not just this one.
- The daily recheck `dependabotany-recheck-endo-but-for-bots` already exists, so I placed no one-shot recheck: the maturity floor has already passed.

**Follow-ups:**
- Once #1546, #1542 and the Playwright fix land on `llm`, the daily recheck should merge this with `ci-wait-merge.sh --dependabot-auto-merge`, which rebases onto the live base first.
- npm `latest` is now 65.4.2. Dependabot will propose that version only after this PR is merged or closed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1553-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3624633 cached reads)
- Output: 18692 tokens
- Cost: $2.0043426
- Wall-clock: 2006s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
