---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-05T15:45:08Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/913

# Dependabotany ledger: PR 913 dorny/paths-filter 4.0.1 to 4.0.2 — MERGE-NOW, held at approval gate

Terminal technical verdict **MERGE-NOW** on reviewed head `5879e4634aa3f8d107e83beca2f0f2cd13e81e90`. This is not an embargo row: no maturity recheck or schedule is required. Structured verdict: https://github.com/endojs/endo-but-for-bots/pull/913#issuecomment-5193968887

The base-ref census found the only `dorny/paths-filter` call site on current `llm` still at 4.0.1, so the PR is live rather than superseded. The incoming v4.0.2 tag resolved on 2026-08-05 to the exact proposed pin `7b450fff21473bca461d4b92ce414b9d0420d706`; outgoing v4.0.1 resolved to its current pin `fbd0ab8f3e69293af611ebaee6363fc25e6d187d`. v4.0.2 was published 2026-07-02T17:46:08Z and passed its maturity floor on 2026-07-09T17:46:08Z.

The GitHub Actions ecosystem contributes no project lockfile movement. Upstream's package manifest and lockfile are identical across the tags, so there are no moved bundled dependencies. Source review covered all five commits and the generated bundle: the material change is a container-job dubious-ownership workaround that creates a temporary HOME, preserves existing global Git configuration, invokes `git config --global --add safe.directory` without a shell, retries the original Git command, and removes the temporary directory. No new network endpoint, telemetry, dynamic require, or install hook. A scripts-disabled upstream install completed; TypeScript build, Prettier, ESLint, and 64 Jest tests passed; `ncc build` reproduced `dist/index.js` byte-for-byte.

The GitHub Actions advisory feed and OSV were empty for both versions. `npm audit --omit=dev` on the upstream source exposed the same pre-existing bundled backlog on both tags (`picomatch`, Octokit, `uuid`, `undici`). The verdict comment names every advisory and records the directional unreachability argument: this repository supplies a fixed trusted glob; uuid is only called as v4 without a buffer; and network/header inputs are fixed to the authenticated GitHub API path. Nothing in this bump increases that exposure.

CI was re-read at the head SHA: 23 of 23 check-runs completed successfully. The conductor spine then enforced its independent approval gate and stopped:

```
rollup-terminal repo=endojs/endo-but-for-bots pr=913 total=23 failed=0 → CI GREEN
merge blocked: no maintainer approval repo=endojs/endo-but-for-bots pr=913
```

PR remains OPEN, MERGEABLE, with `reviewDecision` empty and no reviews. One current maintainer approval is the entire remaining distance; no merge was attempted over the gate.

Self-improvement: nothing this time.
