---
title: §Seven-cycles-on-confinement-substrates
source-slug: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin
section-id: Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-os-sandbox-plugin.md
authors: [Kris Kowal (prompted), Joshua T Corbin (revised)]
repo: endojs/endo-but-for-bots
path: designs/daemon-os-sandbox-plugin.md
total-lines: 544
status: Superseded by endo-posix-sandbox (2026-05-07)
ingest-cycle: 228
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-os-sandbox-plugin--Status-Superseded-by-named-successor-and-roadmap-calibration-via-git-blame-and-LLM-discoverability-with-help-and-interface-guards-and-two-platform-backends
---

| Cycle | Substrate | Layer |
|-------|-----------|-------|
| 196 | endoclaw | capability framing (parent design) |
| 200 | worker-rust-xs | engine-level (XS native Compartment) |
| 212 | outliner | SES Compartment |
| 218 | familiar-chat-weblet-hosting | iframe sandbox attribute |
| 220 | familiar-localhttp-protocol | six-layer defense-in-depth |
| 226 | endoclaw-cluster | structural-confinement-at-only-call-site |
| 228 | daemon-os-sandbox-plugin | OS-level (SBPL + bwrap + seccomp + Landlock) |

§Seven-confinement-substrates-now-in-library. §From-capability-framing-down-to-OS-syscall-level. §The-stack-spans-the-full-range.
