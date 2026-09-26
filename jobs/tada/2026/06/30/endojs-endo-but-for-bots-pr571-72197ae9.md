The lint jobs re-triggered on the push and are now pending against the fixed commit. Work complete.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #571 — erights asked kriscendobot to "correct these CI lint errors."

**Diagnosis:** Both failing CI jobs (`lint` running `yarn lint`, and `yarn lint:prettier`) failed at the Prettier formatting stage on a single file, `packages/genie/main.js`. The PR's intra-package import re-pointing (`#544` follow-up) produced two `import { ... } from '...'` statements that exceeded Prettier's print width:
- `import { formatHelpLines, makeBuiltinSpecials } from './src/loop/builtin-specials.js';`
- `import { buildGenieTools, PLUGIN_DEFAULT_INCLUDE } from './src/tools/registry.js';`

**Fix:** Re-wrapped both onto multiple lines via `prettier@3.5.3 --write` using the repo's `.prettierrc.json`. Formatting-only; no source or behavior change. Verified `prettier --check` now passes on `main.js` and on every other file the PR touches (base64 atob/btoa, genie dev-repl, ocapn cbor index).

**Pushed:** commit `5e89449a3` to `intra-package-plain-re-exports-followup` (PR head was `8aa397cc4`). The two lint jobs re-triggered and are pending against the new SHA.

**Communication:** Posted a top-level summary comment on PR #571 (per the completion-summary norm; endo-but-for-bots carries standing comment authorization) addressing erights with the SHA, what changed, and verification status.

**Follow-ups:** None. CI should converge green once the pending lint jobs finish (all other 20+ checks were already passing). Verifying the re-run to fully green is left to the normal comment-watcher / CI surveillance loop.

**Self-improvement:** nothing this time — the directive routed cleanly to a deterministic prettier fix; no role/skill gap surfaced.
