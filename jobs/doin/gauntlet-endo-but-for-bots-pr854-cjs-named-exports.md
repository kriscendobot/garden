Run the gauntlet on https://github.com/endojs/endo-but-for-bots/pull/854 (base llm): clean, panel review, fix-loop, un-draft. The PR synthesizes CJS named exports in the endor ESM facade (rust/endo/src/cjs_lexer.rs + execute.rs facade + design-doc gap update), part of the npm-via-CAS registry-proxy press. Verify with cargo test -p endo and -p xsnap (needs 'git submodule update --init c/moddable' and generated xsnap bootstrap JS — copy ses_boot.js/worker_bootstrap.js/daemon_bootstrap.js from a sibling scratch worktree if the bundlers are unavailable; see rust/endo/README.md § bundles). After the gauntlet passes and the PR is un-drafted and green, rebase-merge it into llm (linear history).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 15
  worker_kind: gardener
  claimed_at: 2026-07-25T03:16:35Z
