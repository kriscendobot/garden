# Topic: virtual-filesystems

> Abstract: Injectable and provider-backed filesystem interfaces that let a shell, tool, or agent workspace operate on paths and files outside the host filesystem namespace. Distinct from [file-systems](file-systems.md), which covers on-disk storage structures, and from [sandbox-platforms](sandbox-platforms.md), which covers process isolation rather than filesystem indirection.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [injectable virtual filesystem](../sections/oh-my-pi--crates-pi-vfs-src-lib--injectable-virtual-filesystem.md) | oh-my-pi `pi-vfs` | Async/blocking facades and URL providers let shell files remain wholly virtual instead of materializing on the host. |
| [feature-gated shell builtins](../sections/oh-my-pi--crates-pi-builtins-src-lib--feature-gated-shell-builtins.md) | oh-my-pi `pi-builtins` | In-process utilities run against the shell host view, allowing them to share the injected filesystem. |
| [N-API ripgrep search](../sections/oh-my-pi--crates-pi-natives-src-grep--napi-ripgrep-search.md) | oh-my-pi `pi-natives` grep | Native grep searches host paths and provider URLs through the same injected filesystem. |
| [N-API virtual glob walk](../sections/oh-my-pi--crates-pi-natives-src-glob--napi-virtual-glob-walk.md) | oh-my-pi `pi-natives` glob | Glob walks injected provider URLs without wrapping a host glob process or creating host files. |

## See also

- [agent-workspaces](agent-workspaces.md): work environments presented to agents and tools.
- [file-systems](file-systems.md): durable on-disk structures and namespace implementations.
- [sandbox-platforms](sandbox-platforms.md): operating-system execution and authority boundaries.
