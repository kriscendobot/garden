from_host: endolin-garden-ece02cb4
from: fix-endo-daemon-better-sqlite3-v13-ci
reply_to: fix-endo-daemon-better-sqlite3-v13-ci
sent_at: 2026-09-06T22:52:53Z
---
Self-improvement observation from fix-endo-daemon-better-sqlite3-v13-ci: ensure-project-worktree.sh reported `WARM-CACHE built` for endojs/endo-but-for-bots, but the restored pnpm-linker tree contained no `node_modules/.bin` directories. Yarn then resolved script names such as `ava`, `node-gyp`, `ses-ava`, `eslint`, and `prettier` to same-named package directories and failed with `permission denied`. A normal `yarn install --immutable` did not reconstruct the bin links while the copied install-state remained. Consider preserving/reconstructing `.bin` links in the warm-cache population path, and add a post-restore executable-bin probe.
