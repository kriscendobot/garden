---
title: Operations and Usage Pattern
source: doc/design/caskroot-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, networking]
status: current
---

Abstract: The caskhead API and its bootstrap-to-expiry usage cycle. `New(ctx, store)` creates a fresh caskhead0 (empty session table, root block with SchemaV0 and the session-table hash). `Load(ctx, store, root)` loads and validates a root (checks `Links[0] == SchemaV0`, errors otherwise) and returns a `Root` struct exposing the sessions hash. `GetSessionsRoot` / `SetSessionsRoot` read and replace the session table; `GetMembershipRoot` / `SetMembershipRoot` read and replace the **membership set** — a set of 32-byte node_ids that decides who may establish a session, backed by the `membertable` package (Has/Add/Remove/ForEach) and surfaced through `cask member add|rm|ls NODE_ID`. The usage pattern threads the immutable-tree idiom through a mutable root: every session create / lookup / expire produces a new sessions hash, and `SetSessionsRoot` folds it back into a new root hash — the same `(state_hash, args) -> new_state_hash` reducer shape the rest of CASK uses.

## Operations

**New** — create a fresh caskhead0:

```go
func New(ctx context.Context, store cask.Store) (cask.Hash, error)
```

1. Create empty session table.
2. Write root block with SchemaV0 and session-table hash.
3. Return root hash.

**Load** — load and validate a caskhead0:

```go
func Load(ctx context.Context, store cask.Store, root cask.Hash) (*Root, error)
```

1. Load root block.
2. Check `Links[0] == SchemaV0` (error if not).
3. Return `Root` struct with sessions hash.

**GetSessionsRoot / SetSessionsRoot** — access the session table:

```go
func GetSessionsRoot(ctx context.Context, store cask.Store, root cask.Hash) (cask.Hash, error)
func SetSessionsRoot(ctx context.Context, store cask.Store, root cask.Hash, sessions cask.Hash) (cask.Hash, error)
```

**GetMembershipRoot / SetMembershipRoot** — access the membership set (who may establish a session):

```go
func GetMembershipRoot(ctx context.Context, store cask.Store, root cask.Hash) (cask.Hash, error)
func SetMembershipRoot(ctx context.Context, store cask.Store, root cask.Hash, membership cask.Hash) (cask.Hash, error)
```

Membership is a set of 32-byte node_ids using the `membertable` package (caskmembertable: Has, Add, Remove, ForEach). The CLI provides `cask member add NODE_ID`, `cask member rm NODE_ID`, `cask member ls`.

## Usage pattern

```go
// Bootstrap
rootHash, _ := caskhead.New(ctx, store)

// Load root, get sessions
root, _ := caskhead.Load(ctx, store, rootHash)
sessionsHash := root.Sessions

// Create a session
sessionID := generateSessionID()
expiry := time.Now().Add(time.Hour).UnixNano()
stateHash := storeSessionState(ctx, store, sendCtr, recvCtr, key, role, mode)
idx, sessionsHash, _ := sessiontable.Create(ctx, store, sessionsHash, sessionID, expiry, stateHash)

// Update root with new sessions hash
rootHash, _ = caskhead.SetSessionsRoot(ctx, store, rootHash, sessionsHash)

// Lookup session
idx, found, _ := sessiontable.Lookup(ctx, store, sessionsHash, sessionID)
if found {
    session, _ := sessiontable.Get(ctx, store, sessionsHash, idx)
    state := loadSessionState(ctx, store, session.Data)
    // use state.SendCtr, state.RecvCtr, state.SessionKey, etc.
}

// Expire old sessions
for {
    _, _, newHash, expired, _ := sessiontable.PopExpired(ctx, store, sessionsHash, now)
    if !expired {
        break
    }
    sessionsHash = newHash
}
rootHash, _ = caskhead.SetSessionsRoot(ctx, store, rootHash, sessionsHash)
```

Source: [doc/design/caskroot-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/caskroot-design.md) at commit `cdb975d8`.
