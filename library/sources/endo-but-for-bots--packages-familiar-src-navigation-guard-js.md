---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/familiar/src/navigation-guard.js
source_line_range: 1-80
ingested: 2026-06-22
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 438 chat-lane ingest. 79-line navigation-guard.js
  from @endo/familiar/src — Layer 4 (navigation delegate)
  of cycle 436's six-layer exfiltration defense.
  Companion to cycle 436's exfiltration-defense.js.
  Eighty-sixth AUTHORED conformant single-body section
  doc in post-refactor era. One-hundred-and-twenty-
  eighth consecutive non-garden source after the pivot
  (310-438). §one-hundred-and-twenty-eight-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  Electron-window-as-trusted-execution-environment-
  external-as-untrusted — lines 49-66. The Electron
  window space is SACROSANCT: external URLs NEVER
  navigate the Electron window; they spawn the system
  browser via `shell.openExternal()`. This expresses
  a security stance distinct from the cluster's prior
  framings:
  - Cotenant (cycle 433): horizontal isolation
    between coexisting programs in a runtime
  - Exfiltration (cycle 436): outbound isolation
    preventing data from leaving the user's machine
  - Execution-context isolation (cycle 438): KEEPING
    UNTRUSTED CONTENT OUT of the trusted Electron
    window
  The Electron window is one trusted execution
  context; the system browser is another (untrusted
  from Familiar's POV); they NEVER share. §the-named-
  execution-context-isolation-via-system-browser-
  handoff as tier-3 meta-pattern. The cluster's
  security vocabulary now spans THREE distinct
  threats: cotenant + exfiltration + context-leak.

  §the-named-two-allowed-protocols-file-and-localhttp
  — line 15: `Set(['file:', 'localhttp:'])`. Only TWO
  protocols allowed for in-window navigation. file:
  for local resources; localhttp: for weblets.
  Everything else is intercepted. §the-named-narrow-
  protocol-allowlist as tier-3 meta-pattern.

  §the-named-two-navigation-interception-hooks —
  lines 49-50, 68-69. Two Electron event handlers:
  `will-navigate` (link clicks, JS location.href
  changes) and `setWindowOpenHandler` (window.open(),
  target="_blank"). Both interception surfaces must
  be guarded. §the-named-comprehensive-navigation-
  interception as tier-3 meta-pattern.

  §the-named-explicit-user-confirmation-for-external-
  nav-with-cancel-default — lines 24-37. Modal dialog
  with two buttons: "Open in Browser" / "Cancel".
  Default and cancel button both = 1 (Cancel). User
  must explicitly approve to escape the trusted
  context. §the-named-modal-confirmation-with-default-
  deny as tier-3 meta-pattern.

  §the-named-default-and-cancel-both-deny — lines 28-
  29. Both `defaultId: 1` and `cancelId: 1` point to
  Cancel. Pressing Enter (default) OR Escape (cancel)
  both result in cancellation. Belt-and-suspenders for
  safe-default. §the-named-keyboard-default-equals-
  cancel as tier-3 meta-pattern.

  §the-named-shell-openExternal-for-system-browser —
  line 35: `shell.openExternal(url)`. External URLs
  open in the system browser, not the Electron
  window. The system browser is a SEPARATE PROCESS;
  Familiar can't observe what happens there. §the-
  named-external-handoff-via-OS-browser as tier-3
  meta-pattern.

  §the-named-Vite-dev-server-exemption-only-in-dev-
  mode — lines 56-59. In dev mode only, allow
  `http://127.0.0.1:{vitePort}` (default 5173). Dev-
  time relaxation of the navigation guard. §the-
  named-dev-vs-prod-security-asymmetry as tier-3
  meta-pattern; sibling to cycle 435's dev-auto-
  config-vs-prod-manual-gateway.

  §the-named-vitePort-default-5173 — line 45. The
  standard Vite default port. Hardcoded but
  parameterizable via options. §the-named-Vite-
  conventional-port as tier-3 meta-pattern.

  §the-named-electron-windowOpenHandler-action-tag —
  lines 72, 75. The setWindowOpenHandler returns
  `{ action: 'allow' }` or `{ action: 'deny' }`.
  Electron's API uses tagged returns. §the-named-
  tagged-return-for-windowOpen-decision as tier-3
  meta-pattern.

  §the-named-JSDoc-const-cast-for-literal-string-type
  — lines 72, 75: `/** @type {const} */ ('allow')`.
  Cast to const-string for type compatibility.
  Needed because the API expects literal string
  types. §the-named-const-cast-via-JSDoc as tier-3
  meta-pattern; sibling to cycles 416/420/432's
  @ts-expect-error patterns.

  §the-named-localhttp-window-open-allowed-external-
  denied — lines 71-76. Even within
  setWindowOpenHandler, behavior differs:
  - localhttp: → { action: 'allow' } (open in
    Electron window)
  - external: → prompt user, return { action:
    'deny' } (open in system browser if approved)
  §the-named-asymmetric-window-open-by-protocol as
  tier-3 meta-pattern.

  §the-named-modal-dialog-blocks-on-user-response —
  line 25: `await dialog.showMessageBox(...)`. The
  prompt is awaited. The user has time to think.
  Modal blocks the calling code. §the-named-await-
  user-decision-via-modal as tier-3 meta-pattern.

  §the-named-layer-4-of-six-now-grounded — cycle
  436 named navigation-guard.js as Layer 4 (navigation
  delegate) of the six-layer exfiltration defense.
  Cycle 438 reads it. The six layers are now mapped
  to source:
  - Layer 1 (CSP): protocol-handler.js (not yet
    read)
  - Layer 2 (request interception): exfiltration-
    defense.js (cycle 436)
  - Layer 3 (DNS poisoning): exfiltration-defense.js
    (cycle 436)
  - Layer 4 (navigation delegate): THIS FILE (cycle
    438)
  - Layer 5 (WebRTC disabled): exfiltration-defense.
    js (cycle 436)
  - Layer 6 (iframe sandbox): applied by Chat (not
    yet read)
  §the-named-six-layer-defense-now-mostly-grounded
  as tier-3 meta-pattern; 4 of 6 layers ingested.

  §the-named-Electron-typed-as-any-via-ts-ignore —
  lines 11-12: `// @ts-ignore Electron is not typed
  in this project`. Bypasses TypeScript checking
  for Electron's imports. §the-named-ts-ignore-for-
  electron-imports as tier-3 meta-pattern; the
  cluster's drift framings extend with "type-system
  bypass" markers.

  §the-named-Set-for-O-1-protocol-lookup — line 15
  uses Set rather than Array for the allowed-
  protocols list. O(1) lookup vs O(n). Minor
  optimization. §the-named-Set-for-allowlist-lookup
  as tier-3 meta-pattern.

  §the-named-narrow-electron-imports — line 12:
  `import { dialog, shell } from 'electron'`. Only
  two named imports. Minimal coupling. §the-named-
  named-imports-over-default as tier-3 meta-pattern.

  §the-named-eighty-six-conformant-cycles-and-
  counting.

  Closes ten citation arcs: cycle 437 (1, adjacent
  forward; user-facing attenuation flow vs window-
  navigation are both about controlling authority —
  one for capabilities, one for execution context) +
  cycle 436 (5, MAJOR COMPLETION — Layer 4 of six-
  layer exfiltration defense now grounded;
  navigation-guard.js completes 4 of 6 layers
  mapped to source) + cycle 433 (5, cotenant +
  exfiltration + execution-context-isolation = THREE
  distinct security threats now named) + cycle 435
  (3, Familiar-as-Electron-shell architecture
  extends with the navigation discipline that
  protects the renderer) + cycle 416 (3, trust-
  boundary-as-error-handling-asymmetry parallels
  trust-boundary-as-protocol-allowlist) + cycle 326
  (75) + cycle 322 (75) + cycle 387 (3, branded-
  types via electron-action-tag as discriminated
  union) + cycle 364 (4, shapes growing with third
  security threat) + cycle 318 (3, Endo idiom —
  Electron event API). Pushes citation-arc-closures-
  in-pivot to EIGHT-HUNDRED-AND-FORTY-TWO (832 + 10
  net new).
---

79-line navigation-guard.js from @endo/familiar/src — Layer 4 (navigation delegate) of cycle 436's six-layer exfiltration defense. Companion to cycle 436's exfiltration-defense.js. Chat-lane after cycle 437 designs-lane howto-capabilities.md. **Single most structurally interesting move**: §the-named-Electron-window-as-trusted-execution-environment-external-as-untrusted — *The Electron window space is SACROSANCT: external URLs NEVER navigate the Electron window; they spawn the system browser via `shell.openExternal()`. The Electron window is one trusted execution context; the system browser is another (untrusted from Familiar's POV); they NEVER share. The cluster's security vocabulary now spans THREE distinct threats: cotenant + exfiltration + context-leak.* §the-named-execution-context-isolation-via-system-browser-handoff as tier-3 meta-pattern. §the-named-two-allowed-protocols-file-and-localhttp; §the-named-narrow-protocol-allowlist. §the-named-two-navigation-interception-hooks (will-navigate + setWindowOpenHandler); §the-named-comprehensive-navigation-interception. §the-named-explicit-user-confirmation-for-external-nav-with-cancel-default; §the-named-modal-confirmation-with-default-deny. §the-named-default-and-cancel-both-deny (belt-and-suspenders); §the-named-keyboard-default-equals-cancel. §the-named-shell-openExternal-for-system-browser; §the-named-external-handoff-via-OS-browser. §the-named-Vite-dev-server-exemption-only-in-dev-mode; §the-named-dev-vs-prod-security-asymmetry (sibling to cycle 435's dev-auto-config-vs-prod-manual). §the-named-vitePort-default-5173. §the-named-electron-windowOpenHandler-action-tag (allow/deny tagged returns); §the-named-tagged-return-for-windowOpen-decision. §the-named-JSDoc-const-cast-for-literal-string-type; §the-named-const-cast-via-JSDoc. §the-named-localhttp-window-open-allowed-external-denied; §the-named-asymmetric-window-open-by-protocol. §the-named-modal-dialog-blocks-on-user-response; §the-named-await-user-decision-via-modal. §the-named-layer-4-of-six-now-grounded (4 of 6 layers mapped to source); §the-named-six-layer-defense-now-mostly-grounded. §the-named-Electron-typed-as-any-via-ts-ignore; §the-named-ts-ignore-for-electron-imports. §the-named-Set-for-O-1-protocol-lookup; §the-named-Set-for-allowlist-lookup. §the-named-narrow-electron-imports; §the-named-named-imports-over-default. §the-named-eighty-six-conformant-cycles-and-counting. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-FORTY-TWO.
