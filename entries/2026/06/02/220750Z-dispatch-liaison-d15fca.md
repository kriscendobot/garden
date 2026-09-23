---
ts: 2026-06-02T22:07:50Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d15fca
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo-but-for-bots/pull/401#pullrequestreview-4414002536
---

# dispatch: fixer — #401 address kriskowal CHANGES_REQUESTED on shellcheck PR

PR endojs/endo-but-for-bots#401 is the kriscendobot-authored DRAFT
adding `yarn shellcheck` script + CI workflow. kriskowal submitted
CHANGES_REQUESTED review `4414002536` at 2026-06-02T22:06:02Z with
two inline asks. Per memory `feedback_builder_pr_auto_run_gauntlet.md`
+ `feedback_commented_review_with_asks_is_actionable.md`, fixer
dispatch is the right shape.

Pre-dispatch sweep done (per memory
`feedback_sweep_mirror_pr_before_carry_dispatch.md`): no other
unaddressed inline or issue comments on #401.

## Asks

### 1. `scripts/shellcheck.sh:21` (comment `3344750572`)

> This is an oversize variable for bash. Consider using
> `HASH=$(git hash-object -w --stdin)` and `git cat-file blob $HASH`
> to ensure we do not run through the maximum command line argument
> length.

Current code:

```sh
files=$(git ls-files -z '*.sh' | tr '\0' '\n')
...
echo "$files" | xargs shellcheck -S warning "$@"
```

Apply kriskowal's specific pattern: pipe the file list into a git
blob, then read the blob back out, eliminating the bash variable.
Sketch:

```sh
HASH=$(git ls-files -z '*.sh' | tr '\0' '\n' | git hash-object -w --stdin)
files=$(git cat-file blob "$HASH")
if [ -z "$files" ]; then
  echo "shellcheck: no .sh files tracked; skipping."
  exit 0
fi
echo "$files" | xargs shellcheck -S warning "$@"
```

…or restructure to pipe directly without the intermediate `$files`
variable check. Use your judgment on the cleanest shape that
honors kriskowal's suggestion. The blob handling is the load-bearing
part.

Update the surrounding comment block accordingly (the existing
"BSD xargs" / "word splitting" comments may want a rewrite given the
new shape).

### 2. `.github/workflows/shellcheck.yml:1` (comment `3344754582`)

> Please verify that this is not duplicative with shellcheck work in
> the lint job. If so, please consolidate. This appears to be more
> effective than whatever's latent.

**Verification already done** in the liaison's pre-dispatch sweep:

- `grep -rn -i shellcheck .github/ package.json` — only matches in
  the new files added by this PR.
- Root `package.json` defines `"lint": "yarn lint:prettier && yarn
  lint:eslint"` — no shellcheck step.
- The CI lint job (ci.yml job `lint`) runs `yarn lint` and does NOT
  invoke shellcheck.

**Conclusion**: the new workflow is NOT duplicative. No
consolidation needed.

Action: post a reply on inline comment `3344754582` explaining the
verification result (e.g., "Confirmed — `yarn lint` only runs
prettier + eslint; no latent shellcheck step in ci.yml. The new
workflow is the only shellcheck gate in CI."). Use the
`pr-review-thread-replies` skill.

## Procedure

1. Edit `scripts/shellcheck.sh` per ask 1.
2. Locally verify the script still runs: `./scripts/shellcheck.sh`
   exits 0 (or with the right exit code if there are actual lint
   issues — should be 0 since CI was green at head `8ae9cf33a`).
3. Commit:
   ```
   git commit -m "fix(scripts): pass shellcheck targets via git blob to avoid argv limit"
   ```
   (or similar — adjust if you restructure differently.)
4. Push (regular append; no force): `git push origin
   HEAD:chore/shellcheck-ci`.
5. Reply on inline thread `3344754582` per ask 2 verification.
6. Optionally react with eyes/+1 on the two comments via the
   `reactji-acknowledgment` skill.

## Per-action authorizations

- Edit `scripts/shellcheck.sh`. Authorized.
- Commit + regular append push to
  `endojs/endo-but-for-bots:chore/shellcheck-ci`. Authorized.
- Reply on inline thread `3344754582` via GraphQL. Authorized.
- Reactji on the two inline comments. Optional.

## Not authorized

- Modifying `.github/workflows/shellcheck.yml` (the verification
  concludes it's NOT duplicative, so no change).
- Modifying ci.yml lint job (would require maintainer-engaged
  scoping).
- Un-drafting / re-drafting the PR.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--d15fca/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--d15fca/garden/roles/fixer/AGENT.md`
3. `garden/skills/pr-review-thread-replies/SKILL.md` (for the inline
   reply on ask 2).
4. `garden/skills/reactji-acknowledgment/SKILL.md` (optional, for
   the comment acks).

Project worktree at `project/` on `chore/shellcheck-ci`
(head `8ae9cf33a`). Base is `master-814dfa1`.

## Report

A `result` journal entry. Include:

- New head SHA after push.
- Brief diff summary for the script change.
- Local verification result (`./scripts/shellcheck.sh` exit code).
- Inline-thread reply IDs posted (or note if not posted).
- Reactji actions taken.
