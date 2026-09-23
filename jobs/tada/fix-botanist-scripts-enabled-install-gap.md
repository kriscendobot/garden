All work is complete and pushed. Here is my completion report.

---

## Completion report: `fix-botanist-scripts-enabled-install-gap`

### What I found

The gap was real and I reproduced it. But **while I was building my fix, a peer worker landed an independent fix for the exact same gap** — commit `71ff9cb89b fix(botanist): disable dependency install scripts` (2026-07-29 01:46Z), which hit `origin/main2` and collided with my rebase.

I built a complete competing fix first (base-suffix `*-dependabot` detection + `GARDEN_DEP_DISABLE_SCRIPTS`, `--mode=skip-builds`/`--ignore-scripts` + env, `-noscripts` cache key, role-file rewrite, watcher-body update, and a sentinel test — all green, 10/10). On discovering the landed work, I **assessed it as complete and arguably superior and dropped my competing spine changes rather than re-fight it** (the peer-collision discipline). The landed design keys off `GARDEN_JOB_ROLE=botanist`, exported deterministically by the worker spine (`gardener-claude.sh`, `cleric-codex.sh`), so it covers *every* botanist job with no agent in the loop and no reliance on a base-name convention — more robust than my base-suffix approach.

### The one thing the landed fix was missing — which I contributed

The incident report explicitly asked for a test that proves **a lifecycle script did not execute (a sentinel it would have written)**, noting that is "worth more than one asserting a flag was passed." The landed regression (in `project-worktree-isolation-test.sh`) asserts exactly the weaker form: it uses a stub that *records* the policy env, proving the env is plumbed but never proving a real package manager honors it.

I added `scripts/jobs/test/botany-worktree-scripts-disabled-test.sh` (pushed in `e30fa588f2`): it seeds a real `package.json` `preinstall`/`postinstall` that appends to a `LIFECYCLE_RAN` sentinel, drives a **real `npm`**, and asserts the sentinel is **absent** for a `GARDEN_JOB_ROLE=botanist` worktree and **present** for an ordinary one. It also verifies the two policies' caches are disjoint (`<lockhash>-scripts-disabled` vs `-native-builds`) and that a later ordinary job on the same lockfile still runs scripts (no poison). I confirmed it **fails against the pre-fix helper** (sentinel appears; 4 pass/3 fail) and **passes against the landed fix** (7/7) — a genuine regression, and the real-npm end-to-end proof the stub test cannot give. Verified along the way that the landed env-only mechanism (`npm_config_ignore_scripts=true npm ci`) does in fact suppress real npm scripts.

Checks run before pushing: `bash -n`, the pre-dispatch grep-gates (all 5 clean), and the existing isolation test (38/38, untouched).

### Exposure window (recoverable from the board)

- **Gap opened 2026-07-22** — commit `2cf29eae82` added the warm-cache provisioning that runs a scripts-enabled install before the botanist gets control (~7 days open).
- **Auto-posted dependabot botany began 2026-07-25** — commit `73180090a5` (the dependabot watcher). Before that, botanist jobs were hand-posted and rare.
- **Fixed 2026-07-29 01:46Z.**
- **14 completed dependabot botany jobs** exist on `journal2` (`jobs/tada/*-pr<N>-dependabot.md`), **all on `endojs/endo-but-for-bots`** (a bot-owned fork).

The truly-exposed subset is smaller than 14 and I did not pin it exactly: `github-actions`-ecosystem PRs do no lockfile install (e.g. #268/#556/#558), and superseded-close jobs skip the full install chain (#268/#560/#561/#562/#869) — neither triggers a scripts-enabled npm install. The npm-ecosystem full reviews (#557, #866, #867, #868, #870, and similar) are the exposed set, on the order of ~6–9. Exact per-PR classification is recoverable by reading each `tada` report; I bounded it rather than reading all 14. The maintainer was already told the gap existed; this quantifies the window.

### Follow-ups

- None blocking. The fix and both tests are on `main2`.
- Optional: the landed step-3 role text and the dependabot-watcher's full-review body still say "install with scripts disabled" in the imperative — accurate enough given the landed step-3 addendum explains the spine mechanism, so I left them to avoid re-touching a peer's just-landed prose.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-botanist-scripts-enabled-install-gap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 136 tokens (11378220 cached reads)
- Output: 83706 tokens
- Cost: $9.806329
- Wall-clock: 1231s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
