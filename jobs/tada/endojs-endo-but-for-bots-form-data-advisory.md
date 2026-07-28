Job complete. Final report:

---

## `endojs/endo-but-for-bots` #880 — form-data advisory closed

**PR:** <https://github.com/endojs/endo-but-for-bots/pull/880> — "fix(deps): raise the form-data floor to 4.0.6", head `0b3f77fb7f`, **22/22 CI checks pass**, MERGEABLE, un-drafted, ready for maintainer review.

### Finding re-confirmed (twice)
Neither #866 nor #870 had landed. On current `llm` (`3b21299246`) the lockfile still resolved `form-data@npm:^4.0.0` → **4.0.0** and `^4.0.4` → **4.0.5**. Verified against `api.osv.dev`: 4.0.0 returns both GHSA-fjxv-7rqg-78g4 (critical) and GHSA-hmw2-7cc7-3qxx (high); 4.0.5 returns the latter; 4.0.6 returns clean. npm `latest` is 4.0.6.

### What changed
Root `resolutions` entry `"form-data": "^4.0.6"` (the lever the file already uses for `ava`) plus the regenerated lockfile, split as `062f23b41e` (fix(deps)) and `0b3f77fb7f` (`chore: Update yarn.lock`). Both descriptors collapse to a single `form-data@npm:4.0.6`. Diff is two files, 18 insertions / 19 deletions.

### Gauntlet
A prior reaped session had opened #880 and un-drafted it **without running the panel** (no run dir existed anywhere). I ran the full 28-seat code panel: disposition **must-fix**, 10 seats requesting changes, converging on real defects I then fixed:

- Subject said "Pin" but `^4.0.6` is a **floor**. Kept the caret (correct for an advisory floor) and fixed the wording.
- **Empty commit bodies.** JSON cannot carry a comment and this repo rebase-merges, so the commit is the only durable record. The body now names both advisories, affected ranges, verification source, why the entry is unscoped, and the retirement condition.
- Bare `fix:` → `fix(deps):` per the repo's precedent.
- PR body's "dev tooling" was **understated**: `openai` is a runtime `dependencies` entry of `packages/lal`. That path is harmless only because `@endo/lal` is `"private": true`, which is the load-bearing reason a workspace-local `resolutions` entry suffices. Now stated, along with the changeset omission.

Declined with reasons (recorded on the PR): scoping the resolution per-edge, tightening to an exact pin, deduping `hasown`, adding an audit CI gate. Summary comment posted: <https://github.com/endojs/endo-but-for-bots/pull/880#issuecomment-5110013020>.

I also caught that `origin/llm` had moved mid-job and that a naive reset would have reverted intervening base commits; redid it as a proper rebase-and-regenerate.

### Local verification — reported honestly
`format`, `build`, `codegen`, `docs` and the codegen-clean gate passed. **Two steps failed for environment reasons**, both diagnosed by experiment, neither caused by this change:

1. **lint** — `Parsing error: <file> was not found by the project service` on files the diff does not touch. Our harness linted *before* building; CI builds first. Re-running `yarn lint:eslint` after the build step on the same worktree: **0 errors**.
2. **test** — 8 `@endo/cli` demo tests fail at `endo start` with `ENOENT ... runtime/endo.sock`. The path is **134 bytes against the 108-byte `sun_path` limit**, because our per-job checkout path is ~90 bytes. CI's own "Move working directory" step exists for exactly this.

### Garden-side fixes (the mandated second half)
- **Landed on `main2`** (`f9f3c20709`): `local-verify.sh` now runs **build before lint**, with the rationale in the script and in `skills/local-verify/SKILL.md`. 20/20 harness tests pass, shellcheck clean.
- **Recorded, not fixed:** the `sun_path` overrun belongs in `ensure-project-worktree.sh`, whose naming must stay stable across a requeue — too risky to change inside this job. Written up in the skill's field notes as an open follow-up.

### Follow-ups for someone else
- Shorten the per-job project worktree path (or provide a short socket dir) so unix-socket tests fit `sun_path`.
- **Panel seats mutate the shared project worktree.** A seat doing regression evidence reverted `package.json`/`yarn.lock` under a concurrently running verification pass. A panel should get a read-only or separate checkout.
- `axios@1.10.0` (dev tooling, via `nx`) carries 29 open advisories including the same-class GHSA-445q-vr5w-6q77. Out of scope here; noted on the PR so this is not mistaken for a complete sweep.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-form-data-advisory.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (1 unmetered)
- Input: 11 tokens (1359091 cached reads)
- Output: 3643 tokens
- Cost: $5.1921755 (1 engagement(s) unpriced)
- Wall-clock: 2480s

<!-- garden-usage-end -->
