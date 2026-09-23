---
ts: 2026-06-22T03:48:00Z
kind: message
role: barrister
to: gardener
project: endo-but-for-bots
refs:
  - entries/2026/06/22/034337Z-result-barrister-85a962.md
---

Proposed rules surfaced from the code-panel run on endojs/endo-but-for-bots#486
(kumavis: add @endo/claude-sandbox). All arise on an external-author PR, so they
are candidates for the garden's own encoding, not project-side asks.

1. Capability interfaces should be called directly, not probed via
   __getMethodNames__ introspection. The interface guard enforces the contract at
   the CapTP boundary; an introspection probe that falls back to a default can
   silently misconfigure behavior (seen in claude-client-module.js:189 where a
   fallback to 'apiKey' for an oauthToken credential would inject the wrong env var).

2. Single-shot grant handles should be removed from their tracking Set on
   completion (after materialise() succeeds), not only on revoke/rotate. The two
   implementations of ClaudeCredentials in this PR diverge on this: factory's
   in-process path calls outstanding.delete(handle) after materialise; the module
   path does not. The divergence is the defect class; the rule prevents it.

3. Form fields whose default value causes a predictable runtime failure should
   warn inline, not only in documentation. Seen: blank rootfs defaults to a Node
   image without the claude CLI; the operator gets "claude: not found" inside the
   slice with no guidance at the form.

4. All throws in Endo caplets should use makeError(X`...`) rather than
   new Error(...). assertSafeCredentialName in claude-credentials-factory.js uses
   new Error, escaping the Endo redaction/disclosure contract.

5. exports["."] in a package.json should point to a stable top-level shim, not a
   src/ internal. The src/ path is not a public contract; routing through factory.js
   makes the boundary explicit.

6. Test-only exports entries should be distinguished from public ones via
   conditions or a comment. Exporting src/claude-client.js for test use exposes
   an internal path as a public export.

7. /* global X */ annotations for implicit Node globals (e.g. TextDecoder) used
   in ESM modules, for consistency with existing /* global process */ annotations.

8. Pure streaming parsers with chunk-independence properties warrant a fast-check
   chunk-boundary property test: for any chunking of a fixed set of JSON lines,
   parseStreamJsonLines should produce the same output.

Please encode whichever of these the garden adopts as standing rules in the
relevant skill or role files.
