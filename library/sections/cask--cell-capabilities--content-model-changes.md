---
title: Content Model Changes
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, data-structures]
status: current
---

Abstract: The implementation-level shape of the type system. `cask.go` gains the nine `uint16` type constants and a family of helper predicates (`IsCell`, `IsCellDirect`, `IsCellIndirect`, `IsCellWritable`, `IsBlob`, `IsDir`, `IsExecutable`). A `cellpath` package stores and loads descriptors via `caskio.Writer`/`Reader`: `StoreCellPathDescriptor` emits the cell ID as a link on the first leaf then CBOR-encodes the path segments as data bytes; `LoadCellPathDescriptor` reads the single first-leaf link and decodes the CBOR. The **cell table needs no changes** (it maps cell IDs to value hashes regardless of how the cell is referenced; the type is metadata about the reference, not the cell). **GC needs no new logic**: the mark phase already discovers cell IDs as links in reachable blocks, and a descriptor's first-leaf link is discovered the same way. The caskdir wire format gains new 2-byte mode values for the new types.

### cask.go

```go
const (
    TypeDir             uint16 = 0
    TypeBlob            uint16 = 1
    TypeExecBlob        uint16 = 2
    TypeCompactBlob     uint16 = 3
    TypeExecCompactBlob uint16 = 4
    TypeCell            uint16 = 5
    TypeCellRead        uint16 = 6
    TypeCellPath        uint16 = 8
    TypeCellPathRead    uint16 = 9
)
```

### Helper predicates

```go
// IsCell reports whether the type refers to a cell (direct or indirect).
func IsCell(t uint16) bool {
    switch t {
    case TypeCell, TypeCellRead,
         TypeCellPath, TypeCellPathRead:
        return true
    }
    return false
}

// IsCellDirect reports whether the hash field is a cell ID (direct reference).
func IsCellDirect(t uint16) bool {
    switch t {
    case TypeCell, TypeCellRead:
        return true
    }
    return false
}

// IsCellIndirect reports whether the hash field is a cell path descriptor hash.
func IsCellIndirect(t uint16) bool {
    switch t {
    case TypeCellPath, TypeCellPathRead:
        return true
    }
    return false
}

// IsCellWritable reports whether the type permits writing the cell's content.
func IsCellWritable(t uint16) bool {
    switch t {
    case TypeCell, TypeCellPath:
        return true
    }
    return false
}

// IsBlob reports whether the type refers to a blob (file content).
func IsBlob(t uint16) bool {
    switch t {
    case TypeBlob, TypeExecBlob, TypeCompactBlob, TypeExecCompactBlob:
        return true
    }
    return false
}

// IsDir reports whether the type refers to a directory.
func IsDir(t uint16) bool {
    return t == TypeDir
}

// IsExecutable reports whether the type marks content as executable.
func IsExecutable(t uint16) bool {
    return t == TypeExecBlob || t == TypeExecCompactBlob
}
```

### Cell path descriptor helpers

The descriptor uses `caskio.Writer` to emit the cell ID as a link on the first leaf, then writes the CBOR-encoded path segments as data bytes. The CBOR encoding uses a standard library (e.g., `github.com/fxamacker/cbor/v2`).

```go
// StoreCellPathDescriptor stores a cell path descriptor and returns its
// content hash. The cell ID is stored as a link in the first leaf block;
// the path segments are CBOR-encoded as the data bytes.
func StoreCellPathDescriptor(ctx context.Context, store Store, cellID Hash, path []string) (Hash, error) {
    data, err := cbor.Marshal(path)
    if err != nil {
        return ZeroHash, fmt.Errorf("encode cell path descriptor: %w", err)
    }
    w := caskio.NewWriter(store)
    if err := w.Link(ctx, cellID); err != nil {
        return ZeroHash, err
    }
    if err := w.Copy(ctx, data); err != nil {
        return ZeroHash, err
    }
    return w.Sum(ctx)
}

// LoadCellPathDescriptor loads a cell path descriptor and returns the cell
// ID and path segments. The cell ID is the single link in the first leaf
// block; the path segments are CBOR-decoded from the data bytes.
func LoadCellPathDescriptor(ctx context.Context, store Store, hash Hash) (cellID Hash, path []string, err error) {
    reader := caskio.NewReader(store, hash)

    // Collect the cell ID from the first leaf's link and all data bytes.
    var data []byte
    first := true
    for {
        links, buf, err := reader.Next(ctx)
        if err == io.EOF {
            break
        }
        if err != nil {
            return ZeroHash, nil, err
        }
        if first {
            if len(links) != 1 {
                return ZeroHash, nil, fmt.Errorf("cell path descriptor: expected 1 link in first leaf, got %d", len(links))
            }
            cellID = links[0]
            first = false
        } else if len(links) != 0 {
            return ZeroHash, nil, fmt.Errorf("cell path descriptor: unexpected links in non-first leaf")
        }
        data = append(data, buf...)
    }
    if first {
        return ZeroHash, nil, fmt.Errorf("cell path descriptor: empty")
    }

    if err := cbor.Unmarshal(data, &path); err != nil {
        return ZeroHash, nil, fmt.Errorf("decode cell path descriptor: %w", err)
    }
    return cellID, path, nil
}
```

### Cell table

No changes. The cell table maps cell IDs to value hashes regardless of how the cell is referenced. The type on the directory entry is metadata about the *reference*, not about the cell itself.

### GC

The cell path descriptor is retained by the directory entry that references it (strong reference via content hash), same as any other content block. The GC mark phase walks the descriptor's Merkle tree and discovers the cell ID as a link in the first leaf block. This link retains the cell: the mark phase records it as a referenced cell ID, preventing the cell from being collected in the post-sweep step.

This is the same mechanism by which direct cell entries (`TypeCell`, etc.) retain cells: the cell ID appears as a link in a reachable block, and GC recognizes it as a cell reference. The difference is that for direct entries the cell ID is in the directory block itself, while for indirect entries it is in the descriptor's first leaf. In both cases the cell ID is a link in a reachable block, so GC treats them uniformly. If a descriptor is no longer reachable (its parent directory entry is removed), the descriptor's blocks become eligible for collection, the cell ID link is no longer discovered during the mark phase, and if no other reference to the cell exists, the cell is collected.

### Wire format (caskdir)

The `typeToWire` / `wireToType` functions in `caskdir` need new wire values for the new types. The wire format uses a 2-byte mode field, so there is ample space. New wire values:

| Wire value | Type |
|------------|------|
| 8 | `TypeCellRead` |
| 9 | `TypeCellPath` |
| 10 | `TypeCellPathRead` |

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
