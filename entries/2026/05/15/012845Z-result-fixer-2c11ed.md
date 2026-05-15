---
ts: 2026-05-15T01:28:45Z
kind: result
role: fixer
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: target
refs:
  - entries/2026/05/15/012011Z-dispatch-understudy-d61999.md
---

# Result: retcon of PR #243 complete

Executed per `skills/retcon/SKILL.md`. The PR's branch
`chore/eslint-numeric-separators-style` is reset to its base
(`e56e9940d`, the PR's declared `baseRefOid`) and restaged as 27
sensibly grouped commits.

## Heads

- Pre-retcon head: `113171427fe0937db63d77bf181d2135c92dbd35`.
- Post-retcon head: `74e0d25db2cd8f8d9e8a605281567fcd54740bdd`.
- Force-pushed with `--force-with-lease=...:113171427` to be sure no
  concurrent push slipped in. The push succeeded; GitHub now reports
  the new head as the PR head.

## Commit shape

One commit for the rule (eslint-plugin + changeset + root devDep), 25
per-package autofix commits (one per affected package), one cross-pkg
SECURITY.md sidecar commit for the two test-only sink packages added
in earlier branches, and the lockfile commit at the tip:

1. `chore(eslint-plugin): require underscore-delimited groups in numeric literals`
2. `chore(base64): apply numeric-separators-style autofix`
3. `chore(benchmark): apply numeric-separators-style autofix`
4. `chore(captp): apply numeric-separators-style autofix`
5. `chore(chat): apply numeric-separators-style autofix`
6. `chore(cjs-module-analyzer): apply numeric-separators-style autofix`
7. `chore(cli): apply numeric-separators-style autofix`
8. `chore(demo): apply numeric-separators-style autofix`
9. `chore(evasive-transform): apply numeric-separators-style autofix`
10. `chore(exo-stream): apply numeric-separators-style autofix`
11. `chore(familiar): apply numeric-separators-style autofix`
12. `chore(genie): apply numeric-separators-style autofix`
13. `chore(goblin-chat): apply numeric-separators-style autofix`
14. `chore(hex): apply numeric-separators-style autofix`
15. `chore(jaine): apply numeric-separators-style autofix`
16. `chore(marshal): apply numeric-separators-style autofix`
17. `chore(nat): apply numeric-separators-style autofix`
18. `chore(netstring): apply numeric-separators-style autofix`
19. `chore(ocapn-noise): apply numeric-separators-style autofix`
20. `chore(patterns): apply numeric-separators-style autofix`
21. `chore(sandbox): apply numeric-separators-style autofix`
22. `chore(ses): apply numeric-separators-style autofix`
23. `chore(zip): apply numeric-separators-style autofix`
24. `chore(daemon): apply numeric-separators-style autofix`
25. `chore(ocapn): apply numeric-separators-style autofix`
26. `chore(harden-test,hex-test): add SECURITY.md sidecars`
27. `chore: Update yarn.lock`

The `daemon` commit's body notes that the autofix's JSDoc-tag pass also
added a few `@param` completions that are kept where genuinely missing
and reverted where spurious (a single net-equivalent point retained as
context for the panel). The `eslint-plugin` commit's body explains the
rule choice and the peer-dep mechanic.

## Net-diff invariance

Both verifications pass:

- `git diff pre-retcon-d61999..HEAD`: empty (the two heads have
  byte-identical trees).
- `git diff e56e9940d..HEAD --stat` matches the pre-retcon stat exactly
  (87 files, 416 insertions, 182 deletions). Saved both stats to
  `/tmp/{pre,post}-retcon-stat.txt`; `diff` reports zero difference.

## Comment

Posted the retcon summary on PR #243:
[issuecomment-4456077564](https://github.com/endojs/endo-but-for-bots/pull/243#issuecomment-4456077564).
Names the retcon, the base SHA, the pre-retcon SHA, the new head SHA,
and the file/line counts as proof of invariance.

## Out-of-scope items honored

- No substance changes.
- No master-base mirror.
- No judge re-dispatch.
- No reviewer re-request.

Self-improvement: nothing this time. The skill anticipated this shape
(pure-autofix sweep across many packages + a non-autofix sidecar +
lockfile); the procedure worked end-to-end without surprises.
