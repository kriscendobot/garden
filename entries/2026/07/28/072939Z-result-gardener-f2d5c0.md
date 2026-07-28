---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T07:29:45Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/561

# Botany review of endojs/endo-but-for-bots PR 561: REJECT (superseded), closed

Job `endojs-endo-but-for-bots-pr561-dependabot`, posted automatically by the
dependabot-PR watcher. Head reviewed
`1f9345e95290a7b09e7fe4ac98d9851ee0788b0d`, base `llm`. Headline upgrade
`eslint-plugin-unicorn` 56.0.1 to 72.0.0.

**Verdict: REJECT (superseded).** Executed: pull request CLOSED
2026-07-28T07:25:43Z, verified via `gh pr view 561 --json state,closedAt`.

<https://github.com/endojs/endo-but-for-bots/pull/561> is a stale duplicate of
<https://github.com/endojs/endo-but-for-bots/pull/868>, which a peer reviewed
and embargoed to 2026-08-02 six hours earlier. Both bump the same package to
the same version on the same base. Dependabot opened 561 on 2026-06-28 for
68.0.0, retitled and rebased it to 72.0.0 on 2026-07-24, then opened a fresh
868 on 2026-07-26 without closing 561. The stale branch name
(`...-eslint-plugin-unicorn-68.0.0`) is what hid the duplication.

Proof the two are the same upgrade: identical git blob index lines on both
changed manifests in both diffs (`package.json` `c710f3dcf5` to `430534c540`;
`packages/eslint-plugin/package.json` `7b9b5b512c` to `83adaf4ffa`). The
lockfile diffs differ in exactly two entries, 561 carrying the older resolution
in both. 561 is 99 commits behind `llm`; 868 is four weeks fresher.

Two further grounds independently blocked MERGE-NOW, recorded in case 868 is
ever closed and 561 reopened:

1. `lint` red for a real reason, **reproduced locally** (`yarn lint` exit 1,
   exactly 7 `unicorn/numeric-separators-style` errors matching CI position for
   position). v72 added `fractionGroupLength` defaulting to `Infinity`; v56
   grouped the fractional part at `groupLength: 3`, so every pre-existing
   fractional separator is now an invalid group. Rule configured at
   `packages/eslint-plugin/src/configs/shared.js:568`. The fix belongs on 868
   (job `endojs-endo-but-for-bots-pr868-lint-fix`).
2. Maturity unsatisfied. On its own merits 561 would have been
   EMBARGO-2026-07-31, floor set by `electron-to-chromium@1.5.396` (published
   2026-07-24T02:02:49Z) plus 7 days, not by the headline (matured 2026-07-21).

Cleared on every safety axis, checked independently of the 868 review: zero
OSV advisories across all 26 added versions; no `preinstall` / `install` /
`postinstall` hook anywhere in the moved set; scripts-disabled install clean at
exit 0 with `--immutable` confirming lockfile self-consistency; source scan of
all 26 packages produced 10 matches, every one explained and none a real
network call, process spawn, filesystem write, or dynamic code construction;
licenses permissive throughout. `test (24.x, macos-15)` red classified a flake
(the known `@endo/familiar` hung-worker class; 22.x passed on the same head and
a lint plugin is not loaded at test runtime).

No embargo row, no one-shot, no schedule change: the verdict is terminal. The
ledger's single open row (868) is unchanged.

Disposition executed under the repo's standing comment authorization
(`journal/projects/endo-but-for-bots/README.md`) and the botanist's autonomous
close authority on a bot-owned repo:

- Verdict comment <https://github.com/endojs/endo-but-for-bots/pull/561#issuecomment-5101202862>
- Close verified, state CLOSED
- Ledger entry `entries/2026/07/28/072742Z-message-gardener-cd0950.md`
- Peers on the two sibling duplicate pairs messaged on the bus
  (`endojs-endo-but-for-bots-pr560-dependabot`,
  `endojs-endo-but-for-bots-pr562-dependabot`)

Self-improvement: roles/botanist/AGENT.md (commit `9178df61db` on `main2`);
folded a supersession check into workflow step 1 plus a matching anti-pattern,
because Dependabot does not reliably close the PR it supersedes and the stale
one's branch name lies about its target version, so three concurrent duplicate
pairs (561/868, 560/870, 562/869) were each about to get a full duplicate
review. Folded into step 1 rather than inserted as a new step so the step
numbers other sections cite stay valid.
