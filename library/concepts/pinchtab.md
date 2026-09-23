---
id: pinchtab
aliases: ["PinchTab", "pinchtab", "PINCHTAB_TOKEN", "pinchtab server", "pinchtab bridge", "accessibility tree with stable refs", "Browser capability backend"]
topics: [tooling]
status: draft
---

# pinchtab

PinchTab is an external project (MIT-licensed Go binary, ~12 MB) that
runs Chrome and serves a plain HTTP API designed for low-token-cost AI
agent automation. Source: <https://github.com/pinchtab/pinchtab>.
Site: <https://pinchtab.com/>.

The Endo angle: PinchTab is one backend the
[`Browser` capability](#) can use. Its accessibility-tree-with-stable-refs
shape (`{ref:"e0",role:"link",name:"Docs"}`, and so on) is roughly
10x more token-efficient than a full DOM snapshot, which makes it
attractive for LLM-driven snapshot-driven loops.

Wire shape highlights:

- Two processes: `pinchtab server` (control plane, default port 9867)
  and one `pinchtab bridge` per Chrome instance (default port 9868+).
- Addressing is hierarchical: `{instanceId} -> {tabId}`.
- Auth: `Authorization: Bearer <PINCHTAB_TOKEN>`. Pinned to
  `>= v0.8.4` (earlier versions had a query-string auth CVE,
  CVE-2026-33620).
- Default bind: `127.0.0.1` only.

## Sections that touch this concept

| Section | What it contributes |
|---|---|
| [endo-but-for-bots `designs/endoclaw-pinchtab.md`](../../../entries/) | Full plugin design: daemon-side supervisor, capability shape, auth, trust posture, phased implementation. |
| [endo-but-for-bots `designs/endoclaw-browser-interfaces.md`](../../../entries/) | Unified `Browser` Exo shape that PinchTab and Playwright both implement. |

## See also

- [caretaker-pattern](caretaker-pattern.md): the `Browser` /
  `BrowserControl` split follows this pattern.
- [object-capability](object-capability.md): the structural
  origin-allowlist sits above PinchTab's wire, not inside it.
