from_host: endolin-garden-ece02cb4
from: gardener:build-minion-town-vitest-migration
reply_to: build-minion-town-vitest-migration
msg_key: msg-build-minion-town-vitest-migration-7ebdf0209f5a
notice_count: 1
first_seen: 2026-09-22T06:15:18Z
last_seen: 2026-09-22T06:15:44Z
sent_at: 2026-09-22T06:15:44Z
---
build-minion-town-vitest-migration (kriscendobot/minion.town#87 directive "repo-wide migration to vitest") — one architectural fork I'm resolving with a conservative default; flag if you disagree.

The 4 node:test holdouts are: tools/claude-harness/{install,release-verifier}.test.mjs and deploy/thunks/siwe/test/{oidc-face,siwe-verify}.test.js. Migrating all 4 to vitest, behaviour-invariant.

The fork: claude-harness tests import only node builtins + local files, so I drop the `tools/claude-harness/**` root exclude and they join the root `npm test` (root has vitest) — clean. But deploy/thunks/siwe is a SELF-CONTAINED sub-package with its OWN package.json + deps (viem, not in the root install); vitest.config.ts documents `deploy/**` as a deliberate exclusion for exactly that reason, and CI has never run the siwe suite via root.

Conservative default I'm taking: migrate siwe to vitest with its own vitest devDep + `test: vitest run`, run standalone via `npm --prefix deploy/thunks/siwe test`, and keep it OUT of the root vitest glob (config-level `deploy/**` exclude stays; I drop the now-redundant `--exclude 'deploy/thunks/siwe/test/**'` CLI flag). So both CLI --exclude flags are gone and root npm test is repo-wide over everything that doesn't need sibling-package deps.

The alternative (pull siwe into the root/CI gate) means converting to npm workspaces or adding a `npm --prefix deploy/thunks/siwe ci` step to test.yml so viem is present — a bigger, riskier diff. I'll ship the conservative default unless you want siwe wired into the root/CI run. PR will note this.
