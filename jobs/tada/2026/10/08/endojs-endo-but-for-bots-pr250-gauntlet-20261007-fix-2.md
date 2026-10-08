The round-2 must-fix item is done and CI is green on PR #250 (17 checks, 0 failed). I edited only the PR body and pushed no commits, so the head is still `a31662b49f`.

**What the panel asked for**
- **Blocking (pruner):** trim "None for downstream users. The change affects CI only." in *Documentation Considerations*. It now reads "The change affects CI only."
- **Non-blocking (corner-prober, coverage-auditor and others):**
  - *Testing Considerations* now says a PR run cannot exercise the `yarn install --immutable` step in `release.yml` and `typedoc-gh-pages.yml` before merge. `release.yml` runs only on push to `master`; `typedoc-gh-pages.yml` runs on push to `master` or by manual dispatch.
  - The switch to `yarn install --immutable` was already named in the *Description*, so I left that alone.
- **Summary comment (scribe):** posted at https://github.com/endojs/endo-but-for-bots/pull/250#issuecomment-6065883618. It lists what was done, what was not, and the CI status.

**CI:** `ci-wait-merge.sh --no-merge` returned 0 (green).

**Not done (non-blocking):** I did not squash the two empty "nudge" commits (`805b64aa4e`, `6029ba736a`) or fold the duplicate-`env:` fix into its original commit. Both need a history rewrite and the panel did not mark them blocking; a retcon could do them if wanted. The lint that would enforce the env block in every workflow stays deferred, as the PR body says.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr250-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (424867 cached reads)
- Output: 3074 tokens
- Cost: $0.5678614
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
