---
title: Naming Conventions
source: doc/design/package-taxonomy.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, repository-governance]
status: current
---

> Abstract: How CASK packages are named and declared. Package directory names: block structures use simple names (`array`, `map`, `set`, `blob`, `dir`); block backbones suffix `tree` (`hashtree`, `arraytree`); stores suffix `store`; buffers suffix `buffer`; general Go utilities live under `go/` with simple names. Go package **declarations** under `cask/` carry the `cask` prefix (`package caskarray` for `cask/array`, `package caskhashtree` for `cask/hashtree`); packages under `cask/go/` do **not** (`package heap` for `cask/go/heap`). On import, alias to match the declaration (`caskarray "borkshop/cask/array"`), while `go/`-rooted packages need no alias.

## Package Names

- **Block structures**: simple names (`array`, `map`, `set`, `blob`, `dir`).
- **Block backbones**: suffix `tree` (`hashtree`, `arraytree`).
- **Go utilities**: under `go/` with simple names (`go/heap`, `go/swap`).
- **Stores**: suffix `store` (`memstore`, `diskstore`).
- **Buffers**: suffix `buffer` (`sendbuffer`, `recvbuffer`).

## Go Package Declarations

Packages under `cask/` use the `cask` prefix in their declaration; packages under `cask/go/` do not:

```go
package caskarray      // for cask/array
package caskhashtree   // for cask/hashtree
package caskmemstore   // for cask/memstore

package heap    // for cask/go/heap
package swap    // for cask/go/swap
```

## Import Aliases

When importing, use aliases that match the package declaration; `go/`-rooted packages need none:

```go
import (
    "borkshop/cask"
    caskarray "borkshop/cask/array"
    caskhashtree "borkshop/cask/hashtree"
    caskmemstore "borkshop/cask/memstore"
    "borkshop/cask/go/heap"  // no alias needed
)
```

Source: [doc/design/package-taxonomy.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/package-taxonomy.md) at commit `cdb975d8`.
