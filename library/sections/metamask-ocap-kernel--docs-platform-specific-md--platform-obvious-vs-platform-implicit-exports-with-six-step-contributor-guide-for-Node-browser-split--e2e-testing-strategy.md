---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_path: docs/platform-specific.md
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
section_kind: doc
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - getting-started
genre: §sibling-implementation-comparison
cycle: 165
lane: comments
status: current
title: §E2E-testing-strategy
parent: metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split
---

> *Browser platform: Tested through the `extension`
> package. Node.js platform: Tested through the
> `kernel-test` package.*

§Per-platform-e2e-package. §Each-platform-has-a-canonical-
test-home.

§Why-not-co-locate-tests-with-the-feature: e2e tests
require platform setup (browser harness for one, Node
harness for the other). Putting them in a dedicated
package keeps the platform setup §amortized-across-all-
e2e-tests-for-that-platform.

§Synthesis-target: Endo has package-local tests but no
canonical per-platform e2e home. The slot machine work
will need both Node-side and browser-side e2e harnesses;
§canonical-per-platform-test-package is borrowable.
