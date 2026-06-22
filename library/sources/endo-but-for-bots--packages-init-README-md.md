---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/init/README.md
source_line_range: 1-53
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 433 designs-lane ingest. 52-line README.md for
  @endo/init — the canonical SES bootstrap entry point.
  Closes the Endo infrastructure stack from the
  triggering side (cycle 432 named pre-lockdown-trust-
  capture; cycle 433 names the LOCKDOWN trigger).
  Eighty-first AUTHORED conformant single-body section
  doc in post-refactor era. One-hundred-and-twenty-third
  consecutive non-garden source after the pivot (310-
  433). §one-hundred-and-twenty-three-cycles-with-named-
  pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  cotenant-as-threat-model-for-SES — line 10: "By
  default, the environment is fully locked down and as
  safe as we can make it for cotenant host and guest
  programs." The cluster's accumulated SES/ocap framings
  — cycle 409's capability-attenuation, cycle 423's
  pass-by-presence-vs-copy, cycle 425's three ocap
  patterns, cycle 429's CapTP-mutual-suspicion-default,
  cycle 432's pre-lockdown-trust-capture — all assume a
  threat model. Cycle 433 names it: COTENANT. Host and
  guest programs sharing a runtime, with the assumption
  that one might be hostile to the other. The
  capability-security primitives the cluster has
  catalogued exist BECAUSE cotenant programs cannot
  trust the runtime to enforce isolation; they must
  enforce it through capabilities. §the-named-host-and-
  guest-as-cotenant-with-mutual-suspicion as tier-3
  meta-pattern. The SES discipline (cycle 432's pre-
  lockdown-capture, harden-discipline across many
  cycles) makes sense only against this threat model.

  §the-named-import-init-as-canonical-bootstrap — line
  13: `import '@endo/init'`. Single side-effecting
  import. The import itself triggers lockdown. Cycle
  432's pre-lockdown-trust-capture-pattern has its
  TRIGGER named: when @endo/init is imported, lockdown
  fires; everything imported BEFORE that point has its
  pre-lockdown opportunity. §the-named-init-import-as-
  lockdown-trigger as tier-3 meta-pattern.

  §the-named-three-init-modes-safe-debug-unsafe-fast —
  lines 13, 42, 50. Three modes:
  - `@endo/init` (default, safe, locked down)
  - `@endo/init/debug.js` (less safe, debugging-friendly)
  - `@endo/init/unsafe-fast.js` ("avoid"; "we hope to
    obviate")
  §the-named-init-mode-spectrum-safe-debug-fast as
  tier-3 meta-pattern.

  §the-named-init-five-bootstrap-tasks — lines 3-7.
  init does FIVE things:
  1. Sets up HardenedJS
  2. Locks it down
  3. Sets up Eventual Send (HandledPromise shim — cycle
     431's eval-twins-mitigation)
  4. Ensures atob/btoa present (platform polyfill)
  5. Ensures promises can be hardened regardless of
     platform
  §the-named-bootstrap-tasks-as-five-step-init as
  tier-3 meta-pattern.

  §the-named-three-lockdown-taming-options-with-trade-
  offs — lines 21-39. Three taming options:
  - errorTaming: 'safe' (default; redacts stack); debug
    disables this
  - stackFiltering: 'concise' (default; reduces noise)
  - overrideTaming: 'moderate' (default; debugger noise);
    'min' is cleaner but breaks some legacy code
  §the-named-lockdown-taming-options-tunable as tier-3
  meta-pattern.

  §the-named-stack-trace-redaction-as-default-security-
  property — lines 21-25. The default 'safe' errorTaming
  "redacts the stack trace from error instances, so that
  it is not available merely by expressing
  errorInstance.stack." A specific security choice —
  hides stack from arbitrary code. §the-named-stack-
  trace-as-leak-vector-redacted-by-default as tier-3
  meta-pattern.

  §the-named-ses-ava-as-test-framework-bridge — line
  26: "The @endo/ses-ava package compensates for the
  case of Ava specifically." So the Endo ecosystem has
  test-framework-specific compensation packages — the
  security-vs-debugging tension is handled per-tool.
  §the-named-tool-specific-SES-compensation-package as
  tier-3 meta-pattern.

  §the-named-code-exists-but-team-wants-it-gone — lines
  47-48: "Avoid using @endo/init/unsafe-fast.js. It is
  an extreme measure we hope to obviate." Strong
  negative guidance: even though it exists, the team
  wishes it didn't. The cluster has many drift framings;
  cycle 433 names a different shape: ASPIRATIONAL
  DELETION. Code that exists but the team has stated
  intent to remove. §the-named-aspirationally-deleted-
  code-path as tier-3 meta-pattern; the cluster's
  framings extend with: drift (unintentional) +
  acknowledgment (TODO, typo) + aspirational deletion
  (wished-gone).

  §the-named-side-effecting-import-for-bootstrap —
  line 13: `import '@endo/init'` with no symbols
  imported. Pure side effect. Relies on module-load
  order. Unusual JS style. §the-named-import-for-side-
  effect-not-binding as tier-3 meta-pattern.

  §the-named-safe-default-with-explicit-opt-out-to-
  less-safe — line 9: "By default, the environment is
  fully locked down and as safe as we can make it."
  The DEFAULT is the safe configuration; less-safe
  modes require explicit alternate imports. §the-named-
  secure-default-opt-in-to-less-secure as tier-3 meta-
  pattern.

  §the-named-init-polyfills-missing-platform-features
  — line 6: "ensures that atob and btoa are present."
  Some JS runtimes lack these. init polyfills. §the-
  named-platform-polyfill-as-init-responsibility as
  tier-3 meta-pattern.

  §the-named-cross-platform-promise-hardening-via-init
  — lines 6-7: "ensures that promises can be hardened
  regardless of the platform." Native Promise
  sometimes can't be hardened (some V8 versions); init
  smooths this over. §the-named-platform-quirk-
  smoothing-via-init as tier-3 meta-pattern.

  §the-named-Endo-realm-as-init-output — line 3:
  "Importing @endo/init sets up an Endo JavaScript
  realm." So init's product is a "realm" — the SES
  primitive for isolated execution. The cluster has
  used "realm" throughout (cycles 411 SES realm,
  cycle 426 cross-realm portability, cycle 431 eval-
  twins); cycle 433 names init as the realm-setup
  entry point. §the-named-realm-as-SES-isolation-unit
  as tier-3 meta-pattern.

  §the-named-eighty-one-conformant-cycles-and-counting.

  Closes ten citation arcs: cycle 432 (5, MAJOR
  PAIRING — pre-lockdown-trust-capture (cycle 432) +
  lockdown-trigger (cycle 433) form the SES lifecycle;
  the discipline cycle 432 named and the trigger
  cycle 433 names together describe the entire SES
  bootstrap protocol) + cycle 429 (3, CapTP-mutual-
  suspicion-default now has its THREAT MODEL named —
  cotenant programs) + cycle 425 (3, three ocap
  patterns are the DEFENSE against cotenant
  hostility) + cycle 423 (3, marshal-requires-frozen-
  input grounded in SES lockdown which init triggers)
  + cycle 431 (5, HandledPromise shim from init is
  the mitigation for eval-twins; init's bootstrap
  task #3 matches cycle 431's shim discussion) +
  cycle 411 (3, SES realm terminology now grounded
  in init's "Endo JavaScript realm" output) + cycle
  326 (75) + cycle 322 (75) + cycle 387 (3, branded-
  types via prototype identity rely on pre-lockdown
  trust capture) + cycle 318 (3, Endo idiom — E and
  init both bootstrap the runtime). Pushes citation-
  arc-closures-in-pivot to SEVEN-HUNDRED-AND-NINETY-
  TWO (782 + 10 net new).
---

52-line README.md for @endo/init — the canonical SES bootstrap entry point. Closes the Endo infrastructure stack from the triggering side. Designs-lane after cycle 432 chat-lane pass-style/src/byteArray.js. **Single most structurally interesting move**: §the-named-cotenant-as-threat-model-for-SES — *line 10: "By default, the environment is fully locked down and as safe as we can make it for cotenant host and guest programs." The cluster's accumulated SES/ocap framings (cycles 409, 423, 425, 429, 432) all assume a threat model. Cycle 433 names it: COTENANT. Host and guest programs sharing a runtime, with the assumption that one might be hostile. The capability-security primitives exist BECAUSE cotenant programs cannot trust the runtime to enforce isolation; they must enforce it through capabilities.* §the-named-host-and-guest-as-cotenant-with-mutual-suspicion as tier-3 meta-pattern. §the-named-import-init-as-canonical-bootstrap (cycle 432's pre-lockdown-trust-capture-pattern now has its TRIGGER named); §the-named-init-import-as-lockdown-trigger. §the-named-three-init-modes-safe-debug-unsafe-fast; §the-named-init-mode-spectrum-safe-debug-fast. §the-named-init-five-bootstrap-tasks (HardenedJS + lockdown + eventual-send shim + atob/btoa polyfill + promise hardening); §the-named-bootstrap-tasks-as-five-step-init. §the-named-three-lockdown-taming-options-with-trade-offs (errorTaming + stackFiltering + overrideTaming); §the-named-lockdown-taming-options-tunable. §the-named-stack-trace-redaction-as-default-security-property (stack hidden from `error.stack`); §the-named-stack-trace-as-leak-vector-redacted-by-default. §the-named-ses-ava-as-test-framework-bridge; §the-named-tool-specific-SES-compensation-package. §the-named-code-exists-but-team-wants-it-gone (aspirational deletion); §the-named-aspirationally-deleted-code-path (drift + acknowledgment + aspirational deletion — three forms of "code that shouldn't be"). §the-named-side-effecting-import-for-bootstrap; §the-named-import-for-side-effect-not-binding. §the-named-safe-default-with-explicit-opt-out-to-less-safe; §the-named-secure-default-opt-in-to-less-secure. §the-named-init-polyfills-missing-platform-features; §the-named-platform-polyfill-as-init-responsibility. §the-named-cross-platform-promise-hardening-via-init; §the-named-platform-quirk-smoothing-via-init. §the-named-Endo-realm-as-init-output; §the-named-realm-as-SES-isolation-unit. §the-named-eighty-one-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to SEVEN-HUNDRED-AND-NINETY-TWO.
