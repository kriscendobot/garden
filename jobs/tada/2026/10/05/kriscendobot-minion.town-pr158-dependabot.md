# Botanist report: kriscendobot/minion.town PR #158 — merged (MERGE-NOW)

PR #158 is merged. It bumps `@anthropic-ai/claude-code` 2.1.278 → 2.1.283 in `tools/claude-harness`, and landed on `main` as `9d563c97090b` at 2026-10-05T09:41:57Z. Dependabot's own head failed CI; I fixed it with the step the repo documents for this bump, and the fixed head was all green before the merge.

**Diligence:**
- **Not superseded:** the `main` lockfile still resolved 2.1.278 everywhere, and the head was 1 ahead and 0 behind `main`.
- **Files and lockfile:** the PR touched only `package.json` and `package-lock.json`. Nine versions moved: the headline package and its 8 platform optional dependencies. No new packages came in.
  - All were published 2026-09-25 by `wolffiex`, the same publisher as 2.1.278. Neither version has npm provenance attestations, so the publishing chain is unchanged.
  - Licenses are unchanged and nothing is deprecated.
- **Age:** the newest moved version is `@anthropic-ai/claude-code-linux-x64@2.1.283` (2026-09-25T18:49:30Z). The 7-day waiting period ended 2026-10-02T18:49:30Z, so no embargo was needed.
- **Advisories:** OSV and GHSA list none for 2.1.278 or 2.1.283.
- **Install:** the project worktree's install ran with scripts disabled; the setup log confirms it.
- **Source read:** I diffed the two npm tarballs. Only `package.json` (version and platform pins) and `sdk-tools.d.ts` (types) changed. `install.cjs` and the `postinstall`/`prepare` scripts are byte-identical.
- **Prose surfaces:** I didn't read the PR body, changelog or any other upstream prose, so none needed classifying.

**CI fix (disclosed in the verdict comment):** the `test` job on Dependabot's head failed for a real reason. `check.mjs` requires `release.json` to match the npm version, and it still named 2.1.278.
- The harness README says to run `npm run claude-harness:refresh` after every Dependabot bump, so the fix follows directly from the upgrade.
- I ran it. It checked the signature on Anthropic's 2.1.283 release manifest against the tracked key `31DD…CACE`, and checked both Linux binaries' checksums and sizes against that manifest.
- It produced commit **65c7654** (`release.json` only), which I pushed to the PR head.
- Locally, `check.mjs` passed and the harness tests passed 30/0.
- In CI, `test`, `Claude harness (amd64)` and `Claude harness (arm64)` all passed.

**What I did:**
- Posted the MERGE-NOW verdict comment: https://github.com/kriscendobot/minion.town/pull/158#issuecomment-5991952738
- Ran `ci-wait-merge.sh --dependabot-auto-merge`. It confirmed CI green and that the author is `dependabot[bot]`, merged the PR, and the merge shows as MERGED.
- Wrote the ledger entry `entries/2026/10/05/094211Z-message-botanist-f68915.md` (`project: minion-town`, `# Dependabotany` heading). It records the result as final, so no recheck is scheduled.

**Follow-up (not posted):** every future `claude-code` bump on this repo will fail CI the same way until someone runs the refresh. Automating the refresh in CI for Dependabot branches would remove a manual step from each review. That workflow would need network access and `gpg`, so it's the maintainer's call.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr158-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1554039 cached reads)
- Output: 9240 tokens
- Cost: $1.1004637999999998
- Wall-clock: 467s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
