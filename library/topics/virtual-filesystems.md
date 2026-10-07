# Topic: virtual-filesystems

> Abstract: Injectable and provider-backed filesystem interfaces that let a shell, tool, or agent workspace operate on paths and files outside the host filesystem namespace. Distinct from [file-systems](file-systems.md), which covers on-disk storage structures, and from [sandbox-platforms](sandbox-platforms.md), which covers process isolation rather than filesystem indirection.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [injectable virtual filesystem](../sections/oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md) | oh-my-pi `pi-vfs` | Async/blocking facades and URL providers let shell files remain wholly virtual instead of materializing on the host. |
| [feature-gated shell builtins](../sections/oh-my-pi--crates-pi-builtins-src-lib--feature-gated-shell-builtins.md) | oh-my-pi `pi-builtins` | In-process utilities run against the shell host view, allowing them to share the injected filesystem. |
| [N-API ripgrep search](../sections/oh-my-pi--crates-pi-natives-src-grep--napi-ripgrep-search.md) | oh-my-pi `pi-natives` grep | Native grep searches host paths and provider URLs through the same injected filesystem. |
| [N-API virtual glob walk](../sections/oh-my-pi--crates-pi-natives-src-glob--napi-virtual-glob-walk.md) | oh-my-pi `pi-natives` glob | Glob walks injected provider URLs without wrapping a host glob process or creating host files. |
| [N-API shell sessions and filesystem injection](../sections/oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) | oh-my-pi `pi-natives` shell | Persistent and one-shot brush shells reach JavaScript with streamed output, minimizer telemetry, and session- or run-scoped `pi-vfs` filesystems. |
| [ast-grep search over injected filesystems](../sections/oh-my-pi--crates-pi-natives-src-ast--ast-grep-search-over-injected-filesystems.md) | oh-my-pi `pi-natives` ast | Structural search over host paths or `scheme://` URLs through an injected filesystem, or over in-memory source, with deterministic paging and non-fatal diagnostics. |
| [divergence ledger against the oh-my-pi source](../sections/web--oh-my-pi-design-rust-core--divergence-ledger-against-source.md) | third-party explainer vs source | Where the explainer departs from the source: missing `pi-vfs`, minimizer-as-permission-gate, wrong brush path, invented AST and iso APIs. |
| [ShellFilesystem wire protocol](../sections/oh-my-pi--crates-pi-natives-src-shell-vfs--shellfilesystem-wire-protocol.md) | oh-my-pi `pi-natives` shell/vfs | A JavaScript handler implements a 34-op filesystem with positional handles, errno-as-data failures, and host-path (optionally read-only) redirects. |
| [ShellFilesystem routing, lifetime, and consumers](../sections/oh-my-pi--crates-pi-natives-src-shell-vfs--routing-lifetime-and-consumers.md) | oh-my-pi `pi-natives` shell/vfs | `nativeLocalPaths` routes only URL paths to the handler; weak, non-blocking, exactly-once-close lifetime; shell/grep/glob/ast accept it, fuzzyFind does not. |

## See also

- [agent-workspaces](agent-workspaces.md): work environments presented to agents and tools.
- [file-systems](file-systems.md): durable on-disk structures and namespace implementations.
- [sandbox-platforms](sandbox-platforms.md): operating-system execution and authority boundaries.
