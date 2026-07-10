---
role: builder
---

Build the `endopi-stdio-rpc-bridge` M3 design in endojs/endo-but-for-bots (branch off `llm`): implement `endo agent rpc` — a language-agnostic LF-delimited JSON (JSONL) stdio RPC surface that lets a spawned child (IDE plug-in, CI runner, Familiar pane) drive a daemon agent, mirroring the affordances the WebSocket gateway gives the browser, per the design's surface and Pi framing rules (strict `\n` split; logs on stderr).
