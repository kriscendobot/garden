---
title: UCAN Invocation envelope and authorized tasks
source: README.md
source_repo: ucan-wg/invocation
source_commit: 0f4c11325af6aca298b565cc19e90009d10e0197
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: UCAN Invocation Version 1.0.0 turns a proven delegation chain into a signed request for an executor to perform a command, binding invoker, subject, task arguments, proofs, nonce, and time bounds in the `ucan/inv@1.0.0` envelope.

An invocation is not executable merely as payload: it requires the signature envelope and validated delegation proofs. The invoker is the UCAN issuer and requests the task; the executor performs it. The payload has `iss`, `sub`, command `cmd`, `args`, proof list `prf`, a unique random `nonce`, and expiration `exp`; it can also carry an executor `aud`, issuance time, metadata, and a receipt `cause`. If the executor is the subject, `aud` is omitted; otherwise it must differ from `sub`.

The specification frames invocation as the eager counterpart to passing a reference: delegation establishes authority, invocation exercises it. It admits public resources as a deliberate exception where an executor may accept an invocation without a closed-loop proof chain, but says that should not be the default. Receipts may enqueue later tasks, and the design recommends support for promise pipelines.

Source: [README.md](https://github.com/ucan-wg/invocation/blob/0f4c11325af6aca298b565cc19e90009d10e0197/README.md) at commit `0f4c1132`.
