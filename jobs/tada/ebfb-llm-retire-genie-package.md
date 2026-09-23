Inbox is empty. The job is complete. Let me write the completion report.

---

## Completion report

**Job:** Retire the `@endo/genie` package and the `PLAN/`/`TODO/`/`TADA/` design docs; make `@endo/sandbox` stand alone. (`endojs/endo-but-for-bots`, base `llm`)

**Outcome:** Opened **PR #981** → https://github.com/endojs/endo-but-for-bots/pull/981 — OPEN, not draft, base `llm`, head `llm-retire-genie-package`, MERGEABLE. Not merged (per instructions).

**What I did**
- **Deleted `packages/genie/` in full.** Verified nothing imports it (`import`/`require` sweep clean) — it was a leaf, so no dependency rerouting.
- **Deleted `PLAN/` (11), `TODO/` (1), `TADA/` (172)** + markers — 184 tracked files.
- **Made `@endo/sandbox` self-contained.** Removed every genie mention and deleted-doc citation from its README, `bwrap.js`, `path.js`, `limits.js`, `blocked-ranges.js`, `private-egress.nft`, `types.d.ts`, and tests — keeping the *reasoning* and dropping only the dead citation, per the directive. The one surviving pointer is a `blob/a54c3adb` permalink to the archived design.
- **Swept the rest of the tree:** repointed 3 `designs/` broken markdown links to `blob/a54c3adb` permalinks; dropped dead genie source-path / doc-number citations from comments in `host-spawner`, `agent-tools`, `claude-sandbox`, `daemon`, `lal`, `platform`, `9p-server` (reasoning preserved, done via a subagent, verified clean); trimmed genie from `tsconfig.json`/`typedoc.json` exclude lists and from the `pi-0.81.1` changeset frontmatter+prose; dropped the stale genie clause from the `add-endo-host-spawner` changeset; regenerated `yarn.lock`.
- **Deliberately preserved** dated historical prose in `designs/*.md` that merely *names* genie (point-in-time records, not links) — noted this in the PR and offered a follow-up scrub if the maintainer prefers.

**Verification (local):** prettier `--check` on all changed files — clean; eslint on all changed JS/TS — **0 errors** (only pre-existing warnings); `yarn build:types` (workspace-wide composite `tsc --build`) — clean; composite-tsconfig `--check` — no drift; package-uniformity (`.mjs` + 18-test ava suite) — green; **`@endo/sandbox` full suite — 83 tests pass**.

**One caveat (not a regression):** the `@endo/daemon` `endo.test.js` was touched only for a cosmetic test-title reword + comments. It loads/runs under ava, but the daemon suite can't complete in this sandboxed worktree — the daemon fails to bind its unix socket (`ENOENT … endo.sock`) at bootstrap. I confirmed the identical `await start(config)` bootstrap exists on the base commit `a54c3adb`, so this is a pre-existing environment limitation, not caused by my change. CI will exercise the full daemon suite on the PR.

**Follow-ups:** none required. Optional: scrub the historical genie prose from `designs/*.md` if the maintainer wants zero mentions rather than preserved history.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-llm-retire-genie-package.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 208 tokens (10713844 cached reads)
- Output: 67038 tokens
- Cost: $10.304180999999996
- Wall-clock: 1420s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
