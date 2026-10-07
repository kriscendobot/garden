---
title: Opt-in command-output minimization
source: crates/pi-shell/src/minimizer.rs
source_repo: can1357/oh-my-pi
source_commit: 731c051733b0f359ee0de0128ff8e5eec3fa97d2
source_date: 2026-08-08
source_authors: [can1357, David Andrews (LexGenius.ai), metaphorics]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, context-engineering]
status: current
---

> Abstract: The `pi-shell` minimizer is an explicitly enabled, per-program rewrite layer for captured stdout and stderr. It reduces tool-output volume before the text reaches the agent, preserves telemetry, and returns the original text for session-level storage behind an `artifact://` reference when a rewrite occurs.

The engine is inert unless `MinimizerConfig` opts in. Each filter receives the resolved program, optional subcommand, original command string, and effective configuration. Its output records the rewritten text, whether it changed, byte counts before and after, a filter or miss-reason label, and the original capture when changed.

The minimizer itself does not persist the original. The JavaScript session layer is expected to store it through its `ArtifactManager` and add an `artifact://<id>` reference to the minimized text. Panics, disabled minimization, unknown commands, unsafe command shapes, and filters that do not match all fall back to unchanged output.

## Correction to the third-party explainer

This module is an output/context minimizer, not a command-permission safety gate. No `MinimizerWarning` or `PrivilegeEscalation` symbol exists in the repository. Install commands do receive output filters, including npm, pnpm, yarn, pip, brew, apt, and other package tools, but those filters compact progress, notices, and summaries; they do not block unpinned installation.

The repository's `packages/coding-agent/examples/hooks/permission-gate.ts` is a separate JavaScript example hook. It checks patterns including recursive `rm`, `sudo`, and mode or owner changes to `777`, and blocks them in non-interactive sessions. The distinction matters: output reduction is a context-engineering concern, while permission policy is a pre-execution control.

Source: [crates/pi-shell/src/minimizer.rs](https://github.com/can1357/oh-my-pi/blob/731c051733b0f359ee0de0128ff8e5eec3fa97d2/crates/pi-shell/src/minimizer.rs) at commit `731c0517`.
