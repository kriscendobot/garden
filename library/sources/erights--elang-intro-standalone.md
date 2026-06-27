---
source_kind: web
source_url: https://erights.org/elang/intro/standalone.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/standalone.html
source_fetched_via: mirror
source_content_sha256: 1c864aec758a74878d251b1972dea9a374eef9718b8386efe1fabd8f3b4dd6ac
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Primary erights.org E-language tutorial body chapter ("Standalone E Programs").
  Fetched 2026-06-27 from the erights.github.io GitHub Pages mirror via
  scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses
  sandbox connections). Idempotency anchor is source_content_sha256, not a commit.
  The chapter's GUI-launchable subsection is an unwritten "*** to be written" stub
  in the source. Continues the finding-text example; body chapter of the tutorial
  whose index is [erights--elang-intro](erights--elang-intro.md); grounds the
  secondary-source survey
  [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md).
---

The E tutorial chapter that packages the `findall` text-search example into a **standalone program** runnable from an operating-system shell. It introduces the `rune` interpreter as the E program runner, the `#!/usr/bin/env rune` shebang, command-line-argument access via `interp.getArgs()`, and `throw(...)` for usage validation; it walks running the script under both MS-DOS (`rune findall.e ...`) and bash (directly, via the shebang), and feeding an E program on standard input with `rune - << FOO ... FOO`. The advertised GUI-launchable variant is left as an explicit unwritten stub.

| Section | Topics | Status |
|---------|--------|--------|
| [erights--elang-intro-standalone--walkthrough](../sections/erights--elang-intro-standalone--walkthrough.md) | capability-theory | current |
