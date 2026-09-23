Ledger posted. The job is complete.

## Completion report

**Job:** botanist (auto, preflight-INCOMPATIBLE) on `endojs/endo-but-for-bots` PR #1321 — `@babel/parser` 7.28.6 → 8.0.5.

**Re-verification (live head `b139496a0caf1d0d569c55f6f7920288b2f71cd4`):** The preflight proof holds exactly.
- Project `engines.node = "^20.17.0 || >=22.9.0"` (supported floor **20.17.0**), read from the PR-head root `package.json`.
- `@babel/parser@8.0.5` `engines.node = "^22.18.0 || >=24.11.0"`, read from the npm registry.
- The dependency's supported range **excludes** the project floor (all Node 20.x, plus 22.9.0–22.17.x). No CVE motivates the bump. Terminal at the declaration level — lockfile/source/advisory/test chain deliberately not run, per the job.

The live diff moves the four consuming manifests from `~7.29.3`/`~7.28.3` to `~8.0.5`; target version and the engine mismatch are unchanged from the proof.

**Verdict:** REJECT (incompatible).

**Executed** (bot-owned repo, job authorized the close):
- Posted structured verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1321#issuecomment-5752317629
- Closed the PR (`state: CLOSED`).
- Recorded the dependabotany ledger entry on the journal bus (`20260920T200450Z-b9252c`, `# Dependabotany` / `project: endojs-endo-but-for-bots`).

**No garden-repo changes; no commits/pushes to main2.** Nothing left open.

**Follow-up (maintainer-facing, in the verdict + ledger):** adopting `@babel/parser` 8.x requires first raising the project's own `engines.node` floor to at least `^22.18.0 || >=24.11.0` — a maintainer decision. Reopen if that floor is raised, or if a later `@babel/parser` 8.x relaxes its Node floor below 20.17.0.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1321-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (566710 cached reads)
- Output: 6137 tokens
- Cost: $1.2775419999999997
- Wall-clock: 108s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
