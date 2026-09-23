---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/fae/setup.js
source_line_range: 1-45
ingested: 2026-06-19
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 422 chat-lane ingest. 44-line setup.js from
  @endo/fae — the first step of fae's multi-script setup
  flow. Companion to cycle 410's lal/setup.js. Seventieth
  AUTHORED conformant single-body section doc in post-
  refactor era. One-hundred-and-twelve consecutive non-
  garden sources after the pivot (310-422). §one-hundred-
  and-twelve-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  fae-setup-mixes-uppercase-and-at-prefixed-conventions-
  within-one-file — line 2's CLI invocation comment:
  `// endo run --UNCONFINED setup.js --powers AGENT` —
  uses UPPERCASE `AGENT` (no @-prefix). Line 39's actual
  code: `await E(agent).makeUnconfined('@main', ...)` —
  uses lowercase @-PREFIXED `@main`. ONE FILE, TWO
  CONVENTIONS for the same special-name concept. The
  CLI documentation uses uppercase; the code uses
  lowercase @-prefixed. §the-named-intra-file-mixing-
  of-two-naming-conventions as tier-3 meta-pattern; the
  cluster has named intra-document drift (cycle 401
  16-vs-18 tools), intra-function drift (cycle 406
  JSDoc), and now intra-file convention-mixing.

  §the-named-special-name-convention-drift-pervasive-
  across-cluster — full mapping of the drift:
  - lal setup.js comment: `--powers @agent` (lowercase
    @, cycle 410)
  - lal setup.js code: `makeUnconfined('@main', ...)`
    (lowercase @)
  - COMPARISON-FAE-LAL Lal column: `makeUnconfined
    ('MAIN', ...)` (uppercase no @, cycle 415)
  - fae setup.js comment: `--powers AGENT` (uppercase
    no @, this cycle)
  - fae setup.js code: `makeUnconfined('@main', ...)`
    (lowercase @, this cycle)
  - fae CLAUDE.md: uppercase regex
    `/^[A-Z][A-Z0-9-]{0,127}$/` (cycle 415)
  - lal primer capabilities.md: @-prefixed lowercase
    (cycle 411)
  Six artifacts, multiple conventions, no single
  source of truth. §the-named-special-name-drift-
  no-single-source-of-truth as tier-3 meta-pattern;
  the cluster's most-fragmented drift instance.

  §the-named-fae-multi-script-setup-vs-lal-single-
  script-setup — lines 12-17: "After a provider is
  created, use `fae-factory-setup.js` to create a fae-
  factory bound to that provider." Fae splits setup
  into multiple scripts: setup.js (provision factory)
  → submit-provider.js (configure) → fae-factory-
  setup.js (create agent factory). Lal's setup.js
  (cycle 410) combines these in ONE script with an
  inline form-submission loop. §the-named-multi-script-
  setup-with-explicit-handoffs as tier-3 meta-pattern;
  fae's setup is more layered than lal's.

  §the-named-fae-provisioning-decoupled-from-
  configuration — fae's setup.js does NOT read
  ENDO_LLM_* env vars. Cycle 410's lal setup.js did.
  Fae's env-var handling lives in a SEPARATE script.
  §the-named-env-var-handling-in-separate-script as
  tier-3 meta-pattern. Provisioning (creating the
  guest + caplet) is decoupled from configuration
  (submitting provider details). Lal couples them;
  Fae decouples them.

  §the-named-idempotent-provisioning-via-has-check —
  lines 21-25: `if (await E(agent).has('llm-provider-
  factory')) { ... return; }`. Same pattern as cycle
  410's lal setup.js. Confirmed across packages.
  §the-named-has-check-idempotency-shared-across-
  packages as tier-3 meta-pattern.

  §the-named-canonical-introducedNames-idiom — line 34:
  `introducedNames: harden({ '@agent': 'host-agent' })`.
  SAME as cycle 410's lal setup.js. Confirms the
  canonical introducedNames idiom. Uses LOWERCASE @-
  prefixed agent. Consistent with cycle 411's primer.
  §the-named-introducedNames-uniformly-lowercase-at-
  prefixed as tier-3 meta-pattern; an island of
  consistency in the broader convention drift.

  §the-named-harden-main-export — line 44: `harden
  (main)`. Follows the harden convention. Same
  discipline as cycle 410's lal setup.js. §the-named-
  setup-scripts-follow-harden-convention as tier-3
  meta-pattern; setup scripts uniformly follow the
  convention; providers/ files uniformly don't (cycles
  406, 408, 412).

  §the-named-lalProviderFactorySpecifier-as-URL —
  lines 6-9: `const llmProviderFactorySpecifier = new
  URL('llm-provider-factory.js', import.meta.url).
  href`. Same import.meta.url anchor pattern as
  cycle 410's lal setup.js. §the-named-import-meta-
  url-anchor-shared-across-setup-scripts as tier-3
  meta-pattern.

  §the-named-CLI-invocation-as-file-header-comment —
  line 2's CLI invocation comment. Cycle 410 noted
  this pattern for lal setup.js; cycle 422 confirms
  for fae. §the-named-setup-file-self-documents-CLI-
  invocation as tier-3 meta-pattern; consistent
  discipline across setup scripts.

  §the-named-fae-name-pattern-includes-llm-provider-
  factory — lines 28-29: `const name = 'llm-provider-
  factory'; const agentName = \`profile-for-${name}\``.
  The naming convention: `profile-for-X` for the
  agent name; X itself for the guest name. Cycle 410
  noted lal uses `profile-for-lal`. §the-named-
  profile-for-X-as-agent-name-convention as tier-3
  meta-pattern; uniform across setup scripts.

  §the-named-E-from-endo-eventual-send-in-fae-setup —
  line 4: `import { E } from '@endo/eventual-send'`.
  Same import source as cycle 410's lal setup.js.
  Contrast with cycle 420's endopetstore-backend.js
  (`from '@endo/far'`). E import sources differ across
  files. §the-named-E-source-eventual-send-for-setup-
  far-for-storage as tier-3 meta-pattern; pattern
  emerges in the cluster's E-import-source drift —
  setup scripts use eventual-send; storage backends
  use far.

  §the-named-no-await-in-loop-not-needed — fae setup.
  js has NO for-loop awaits — it's purely sequential
  awaits. No eslint-disable comment needed. Contrast
  with conversation-tree files which need the disable.
  §the-named-eslint-disable-genuinely-unneeded as
  tier-3 meta-pattern.

  §the-named-resultName-controller-for-X — line 41:
  `resultName: \`controller-for-${name}\``. The
  controller object is named `controller-for-llm-
  provider-factory`. Cycle 410's lal setup.js used
  `controller-for-lal`. §the-named-controller-for-X-
  naming-convention as tier-3 meta-pattern.

  §the-named-seventy-conformant-cycles-and-counting
  — seventieth AUTHORED conformant single-body
  section doc in post-refactor era — a quiet 70-
  milestone.

  Closes nine citation arcs: cycle 421 (1, adjacent
  forward; conversation-tree picture complete; fae
  picture extending) + cycle 419 (5, fae README's
  three-step-setup confirmed; setup.js is step ONE)
  + cycle 415 (5, special-name-convention-drift
  framing extended with intra-file mixing; the
  cluster's most pervasive drift gets another data
  point) + cycle 411 (3, special-name case
  convention from primer compared with setup.js)
  + cycle 410 (5, lal setup.js compared; multi-
  script vs single-script setup distinction named) +
  cycle 420 (3, E-import-source pattern emerges:
  setup uses eventual-send, storage uses far) +
  cycle 326 (75) + cycle 322 (75) + cycle 387 (3,
  branded-types). Pushes citation-arc-closures-in-
  pivot to SIX-HUNDRED-AND-EIGHTY-FOUR (674 + 10 net
  new — but counting only 9 above; let me recheck —
  actually counting carefully there are 9: 421, 419,
  415, 411, 410, 420, 326, 322, 387). Pushes
  citation-arc-closures-in-pivot to SIX-HUNDRED-AND-
  EIGHTY-THREE (674 + 9 net new).
---

44-line setup.js from @endo/fae — first step of fae's multi-script setup flow; companion to cycle 410's lal/setup.js. Chat-lane after cycle 421 designs-lane conversation-tree/types.js. **Single most structurally interesting move**: §the-named-fae-setup-mixes-uppercase-and-at-prefixed-conventions-within-one-file — *line 2's CLI comment uses uppercase `AGENT` (no @-prefix); line 39's `makeUnconfined('@main', ...)` uses lowercase @-prefixed form. ONE FILE, TWO CONVENTIONS for the same special-name concept. The cluster has named intra-document drift, intra-function drift, and now intra-file convention-mixing.* §the-named-intra-file-mixing-of-two-naming-conventions as tier-3 meta-pattern. §the-named-special-name-convention-drift-pervasive-across-cluster (full mapping across 6 artifacts: lal-comment-lowercase-@ + lal-code-lowercase-@ + COMPARISON-Lal-uppercase-no-@ + fae-setup-comment-uppercase-no-@ + fae-setup-code-lowercase-@ + fae-CLAUDE-uppercase-regex + lal-primer-lowercase-@; cluster's most-fragmented drift instance); §the-named-special-name-drift-no-single-source-of-truth. §the-named-fae-multi-script-setup-vs-lal-single-script-setup (fae splits into setup + submit-provider + fae-factory-setup; lal combines); §the-named-multi-script-setup-with-explicit-handoffs. §the-named-fae-provisioning-decoupled-from-configuration (no ENDO_LLM_* in fae setup.js); §the-named-env-var-handling-in-separate-script. §the-named-idempotent-provisioning-via-has-check (confirmed across packages); §the-named-has-check-idempotency-shared-across-packages. §the-named-canonical-introducedNames-idiom (uniformly lowercase @-prefixed); §the-named-introducedNames-uniformly-lowercase-at-prefixed (island of consistency in broader drift). §the-named-harden-main-export; §the-named-setup-scripts-follow-harden-convention (uniform across setup scripts vs uniformly absent in providers/). §the-named-lalProviderFactorySpecifier-as-URL; §the-named-import-meta-url-anchor-shared-across-setup-scripts. §the-named-CLI-invocation-as-file-header-comment; §the-named-setup-file-self-documents-CLI-invocation. §the-named-fae-name-pattern-includes-llm-provider-factory; §the-named-profile-for-X-as-agent-name-convention. §the-named-E-from-endo-eventual-send-in-fae-setup; §the-named-E-source-eventual-send-for-setup-far-for-storage (pattern emerges in E-import drift: setup uses eventual-send; storage uses far). §the-named-no-await-in-loop-not-needed; §the-named-eslint-disable-genuinely-unneeded. §the-named-resultName-controller-for-X; §the-named-controller-for-X-naming-convention. §the-named-seventy-conformant-cycles-and-counting (quiet 70-milestone). Nine citation arcs closed; pushes citation-arc-closures-in-pivot to SIX-HUNDRED-AND-EIGHTY-THREE.
