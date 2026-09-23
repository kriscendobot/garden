---
title: CLI installation and account sign-in practice
source_kind: web
source_url: https://docs.fireworks.ai/tools-sdks/firectl/firectl.md
source_content_sha256: 40dde30f3d2eb313fb660445f6ecc1f2e90176e918f91f08c7f2a9947418f449
source_authors: [Fireworks AI]
source_date: 2026-07-25
ingested: 2026-07-25
ingested_by: scholar
topics: [fireworks-ai-integration]
status: current
---

Firectl can be installed through Homebrew (`brew tap fw-ai/firectl` then `brew install firectl`), platform-specific compressed binaries for macOS and Linux, or the Windows executable. The docs direct a user to run `firectl signin` for interactive account authentication; for Custom SSO, the form is `firectl signin <ACCOUNT_ID>`. `firectl whoami` confirms the selected account, `firectl version` displays the installed release, and `sudo firectl upgrade` updates it.

This is an interactive credential workflow, not an instruction to place an API key in a command line, file, or library artifact. An unattended harness should avoid invoking sign-in unless its runtime explicitly supplies authorized interactive credentials, and should use `whoami` as the non-secret postcondition when a CLI session is intentionally established.

Source: [Firectl Getting Started](https://docs.fireworks.ai/tools-sdks/firectl/firectl.md).
