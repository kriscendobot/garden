Job complete.

## Botany review: endojs/endo-but-for-bots PR #561 — REJECT (superseded), closed

**Verdict: REJECT.** PR #561 closed 2026-07-28T07:25:43Z (verified: `gh pr view 561 --json state` returns `CLOSED`).

### The finding

#561 is a **stale duplicate** of [#868](https://github.com/endojs/endo-but-for-bots/pull/868) — same `eslint-plugin-unicorn` 56.0.1→72.0.0 bump, same `llm` base. A peer reviewed and embargoed #868 six hours before I claimed this job. Dependabot opened #561 on 2026-06-28 for 68.0.0, retitled/rebased it to 72.0.0 on 07-24, then opened a fresh #868 on 07-26 **without closing #561**. The stale branch name (`...-unicorn-68.0.0`) is what hid the pairing.

Proof they're the same upgrade: both diffs carry **identical git blob index lines** on both changed manifests (`c710f3dcf5`→`430534c540`, `7b9b5b512c`→`83adaf4ffa`). Lockfile diffs differ in exactly two entries, #561 carrying the older resolution in both. #561 is 99 commits behind `llm`; #868 is four weeks fresher.

### Full review performed anyway (independent of #868's)

- **Advisories**: all 26 added versions queried individually against OSV — **0 advisories**, none withdrawn.
- **Install, scripts disabled**: `YARN_ENABLE_SCRIPTS=false corepack yarn install --immutable --mode=skip-build` → exit 0; `--immutable` also confirms lockfile self-consistency.
- **Install hooks**: all 26 resolved in the store and inspected — **zero** `preinstall`/`install`/`postinstall`. One `prepare` (`web-worker`, inert for registry tarballs).
- **Source scan** of all 26 for network/spawn/eval/credential/fs-write primitives: 10 matches, every one explained (6 are `eslint-plugin-unicorn` rule sources whose *subject* is the primitive; 1 `caniuse-lite` data file; 1 `.d.ts` doc example; 2 `web-worker` `data:`-URL decode).
- **Licenses**: permissive throughout, no regression. `quote-js-string@0.1.0` flagged as a first-ever release; all 13 new packages are sindresorhus/ESLint-org deps of the headline package.

Two further grounds independently blocked MERGE-NOW: `lint` is red for a real reason, and the maturity window is unsatisfied (would have been EMBARGO-2026-07-31, floor set by `electron-to-chromium@1.5.396`, not the headline).

### Verification status

- **Verified by local execution**: `yarn lint` exits 1 with exactly 7 `unicorn/numeric-separators-style` errors, matching CI position-for-position (ocapn `passable.test.js` 317:27/327:27; `random/src/random.js` 10:18; `random/test/random.test.js` 130:5/130:31/131:5/131:31). Root cause confirmed at `packages/eslint-plugin/src/configs/shared.js:568`: v72 added `fractionGroupLength` defaulting to `Infinity`.
- **Not re-run**: the `test (24.x, macos-15)` failure. I classified it a flake from the log signature (`@endo/familiar`, 27 passed then `Exiting due to SIGINT`, the known hung-worker class), the fact that 22.x passed on the same head, and causal impossibility (a lint plugin isn't loaded at test runtime). I did not re-trigger the macOS job.

### Also done

- Verdict comment: [#561 comment](https://github.com/endojs/endo-but-for-bots/pull/561#issuecomment-5101202862)
- Ledger + result journal entries posted. **No embargo row, no one-shot, no schedule change** — the verdict is terminal; #868's single open row is untouched.
- **Two sibling duplicate pairs found and peers messaged**: #560/#870 (openai, *same* target — literal duplicate) and #562/#869 (happy-dom, 20.10.6 vs 20.11.0 — superseded by newer target, so I told that peer to treat the version difference as material rather than assume).

### Follow-up for you

Three more 2026-06-28 Dependabot PRs are open on this repo with no 07-26 counterpart (#556, #557, #558 GitHub-Actions bumps) plus #268/#269. Those aren't duplicates, but the board currently holds botanist jobs for all of them — worth a glance at whether the watcher is backfilling old PRs.

Self-improvement: `roles/botanist/AGENT.md` (commit `9178df61db`, pushed to `main2`) — folded a supersession check into workflow step 1 plus a matching anti-pattern. Folded rather than inserted as a new step so the step numbers other sections cite (3, 6, 10) stay valid.
