Changed and pushed `main2` commit `c7f303ca83`.

- Removed `endojs/endo-but-for-bots:master` from clone-keeper defaults, so it is no longer fetched, fast-forwarded, or recreated.
- Preserved frozen `master-<hash>` anchors via the existing frozen-base workflow.
- Removed the integrator’s master-base mirror-PR prompt.
- Updated clone-keeper coverage; `47 passed, 0 failed`.
- Grep found no remaining mutable-fork-master mirror/ref push path.

Branch protection is maintainer-gated: the bot’s GitHub token is invalid. I sent the maintainer the exact admin `gh api` command to require one approving PR review and block direct pushes to `endojs/endo-but-for-bots:master`.
