---
section: stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
source: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge
topics: [agent-conventions]
status: current
title: Auth — *you can spawn the process, so you are authorized*
parent: endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui
---

The §Open questions paragraph names the auth posture:

> *Where does auth live? Stdio's local: by default, "you can spawn
> the process, so you are authorized". For network-tunneled stdio
> (an `ssh` invocation of `endo agent rpc` on a remote host), the
> daemon's existing bearer-token mechanism applies.*

The §spawn-implies-authorization discipline is the *local-trust-
boundary* shape. The ssh-tunneled-stdio case falls back to the
existing `gateway-bearer-token-auth` design's mechanism — *same
auth surface as the WebSocket gateway, or none when stdio is local*.
