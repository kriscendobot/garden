---
ts: 2026-06-02T21:47:00Z
kind: result
role: liaison
host: endolinbot
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 244
    role: target
  - repo: endojs/endo
    pr: 3263
    role: upstream-source (needs ferry-back)
refs:
  - entries/2026/06/02/214300Z-dispatch-liaison-86c4b9.md
  - entries/2026/06/02/214616Z-result-fixer-a2c583.md
---

# result: #244 rebased + retconned; FERRY-BACK PENDING to endo#3263

User directive: "Please rebase and retcon our mirror of
https://github.com/endojs/endo/pull/3263. Leave a note on the journal
when done that this needs to be ferried back."

Mirror is endo-but-for-bots#244. Per memory rule
`feedback_rebase_on_master_implies_sync.md`, "rebase" decoded to the
compound chain: sync bot-master + rebase + conflict-resolve + retcon.
Dispatched fixer 86c4b9. Complete.

## Fixer outcomes

- **bot-master synced**: `814dfa1f` → `3c5753b6` (force-with-lease with
  the prior bot-master SHA as lease anchor).
- **Conflicts resolved**:
  - `package.json`: upstream bumped `eslint-plugin-jsdoc` ^50.6.1 →
    ^50.8.0 and `prettier` ^3.5.3 → ^3.8.3; PR adds
    `eslint-plugin-unicorn: ^56.0.1` in the same alphabetized block.
    Wove both intents.
  - `yarn.lock`: regenerated via `corepack yarn install`.
- **Retcon shape (2 commits atop new master)**:
  - `876ee33f3` `chore(eslint-plugin): require underscore-delimited
    groups in numeric literals` (45 files, +270/-98, folds 8 of 9
    original non-yarn-lock commits)
  - `e10ba6ba6` `chore: Update yarn.lock` (+182/-3)
- **One convergence**: `packages/evasive-transform/src/index.js`
  dropped from the PR diff because upstream commit `889be5eda` already
  applied the same one-character prettier fix.
- **Push outcomes**: both force-with-lease pushes accepted on first
  try.
- **New #244 head**: `e10ba6ba6` (was `63a1a6068`).

## **FERRY-BACK NEEDED to endojs/endo#3263**

PR endo-but-for-bots#244 at head `e10ba6ba6` is now rebased onto the
current upstream-master tip and retconned to the canonical 2-commit
shape. The content needs to be carried back to upstream
endojs/endo#3263 to keep the mirror and upstream in sync.

**The boatman is the role that ferries upstream.** Per
`roles/boatman/AGENT.md` § Host preconditions and `journal/projects/endo/README.md`
§ Identity and credentials: boatman dispatches require kriskowal
credentials, which live on `kmkmbp2021` (not on `endolinbot`).
A liaison on `endolinbot` refuses to originate a boatman dispatch
per CLAUDE.md's monitoring-safety + identity-switch posture.

**Action required from the credentialed host (`kmkmbp2021`):** dispatch
the boatman to ferry #244's content back to endojs/endo#3263, replacing
the upstream's head with the bot-side's rebased canonical shape (or
opening a follow-up PR upstream if that's the maintainer's preference).
The user prompted this work on `endolinbot`; when they next find
themselves on `kmkmbp2021`, the ferry-back is the open task.

## Cleanup

dispatches/fixer--86c4b9 torn down.
