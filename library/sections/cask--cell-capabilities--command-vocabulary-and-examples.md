---
title: Command Vocabulary Changes and Examples
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

Abstract: How the CLI surface realizes the entry-type capabilities. Path resolution (`resolveIsh`/`resolveIshPath`) handles direct types (look up the cell ID in the cell table) and indirect types (load the descriptor, read cell ID + path, navigate to the prefix), and access checks are enforced at the command level, not during resolution: the resolver always navigates to the target, the command decides whether the operation is permitted. Read commands work on all cell types; write commands (`store --to`, `checkin --to`) replace/CAS/navigate-and-CAS or error on read-only types; `cask cas` is permitted only through `TypeCell`; `cask rm` requires a writable path to the parent. **`cask mkroot [--read-only] DEST SOURCE`** creates an attenuated reference, discovering the cell boundary automatically: no subpath yields `TypeCellRead` (the only honest direct attenuation), a subpath yields `TypeCellPath` or `TypeCellPathRead`. `cask typeof` inspects entry types and `cask ls` displays type names. The attenuation lattice and worked tiered-access examples close the section.

## Path resolution

The path walker (`resolveIsh`, `resolveIshPath`) must handle both direct and indirect cell types.

**Direct types** (`TypeCell`, `TypeCellRead`): The hash field is the cell ID. Look it up in the cell table to get the current value hash. Continue resolving any remaining path segments from that value.

**Indirect types** (`TypeCellPath`, `TypeCellPathRead`): The hash field is a descriptor hash. Load the cell path descriptor (read the cell ID from the first leaf's link and the path segments from the CBOR data). Look up the cell ID in the cell table. Navigate the value tree to the path prefix. Then continue resolving any remaining path segments from that location.

Access checks (read/write) are enforced at the command level, not during resolution. The resolver always navigates to the target; the command decides whether the operation is permitted.

## Read commands

`load`, `checkout`, `ls`, `state`, `at`:

- **All cell types**: Work normally. All cell types grant read access (write implies read, and read-only types explicitly grant read).
- **Content-hash types** (`TypeDir`, `TypeBlob`, etc.): Work normally. Content is always readable.

## Write commands

`cask store --to` / `cask checkin --to`:

| Encountered type | Behavior |
|------------------|----------|
| `TypeBlob`, `TypeDir` | Replace entry (current behavior). |
| `TypeCell` | CAS cell value (current behavior). |
| `TypeCellRead` | **Error**: read-only cell. |
| `TypeCellPath` | Load descriptor, navigate to subpath, modify, CAS cell. |
| `TypeCellPathRead` | **Error**: read-only at subpath. |

For indirect writable types, the write is: (1) load the descriptor → (cell ID from link, path from CBOR); (2) load the cell's current value hash; (3) navigate to the path prefix; (4) apply the modification; (5) rebuild the tree from the modification point back to the cell's root; (6) CAS the cell to the new root.

## `cask cas`

`cask cas ISH OLD NEW`, direct CAS on a cell's root value. Only permitted through direct writable types:

| Type | Permitted |
|------|-----------|
| `TypeCell` | Yes |
| `TypeCellRead` | No, read-only |
| `TypeCellPath` | No, indirect; must use `--to` |
| `TypeCellPathRead` | No, read-only |

Indirect types cannot be used with `cask cas` because the CAS operates on the cell's root, not on a subpath. To modify content through an indirect reference, use `cask store --to` or `cask checkin --to`, which handle the load-navigate-modify-rebuild-CAS sequence.

## `cask rm`

`cask rm TARGET` removes an entry from its parent directory. The path to the parent directory must be writable: if it traverses a read-only cell type (`TypeCellRead`, `TypeCellPathRead`), removal fails.

## `cask mkroot`

```
cask mkroot [--read-only] DEST SOURCE
```

Creates an attenuated cell reference. DEST is the name for the new entry. SOURCE is a path to a cell, optionally followed by subpath segments. The command discovers the cell boundary automatically: the first cell entry encountered becomes the target cell, and any remaining path segments become the subpath scope.

**Without a subpath** (SOURCE resolves directly to a cell entry), the result is always `TypeCellRead`. This is the only honest attenuation for a direct cell reference: CAS requires reading, so write access implies read access, and the only direction of attenuation is from read+write down to read-only.

**With a subpath** (SOURCE path continues past the cell entry), the result is `TypeCellPath` (read+write scoped) by default, or `TypeCellPathRead` (read-only scoped) with `--read-only`.

If the source is itself an indirect reference (`TypeCellPath` or `TypeCellPathRead`), the existing path prefix is concatenated with the new subpath segments.

The attenuation lattice:

```
TypeCell (read + write at root)
├── TypeCellRead (read at root)
│   └── TypeCellPathRead (read at subpath)
└── TypeCellPath (read + write at subpath)
    └── TypeCellPathRead (read at subpath)
```

Examples:

```sh
# Read-only view of a cell (no subpath → always read-only)
cask mkroot :photos-bob :photos

# Read+write scoped to a subpath
cask mkroot :carol :photos:vacation

# Read-only scoped to a subpath
cask mkroot --read-only :eve :photos:vacation

# Further attenuate an indirect reference to a deeper subpath
cask mkroot --read-only :carol-summer-read :carol:summer
# :carol is TypeCellPath at ["vacation"]
# :carol-summer-read is TypeCellPathRead at ["vacation", "summer"]
```

## `cask typeof` and `cask ls`

`cask typeof` is a diagnostic command to inspect entry types (and, for indirect types, shows the subpath in brackets):

```sh
cask typeof :photos           # cell
cask typeof :photos-readonly  # cell-read
cask typeof :carol            # cell-path ["vacation"]
cask typeof :docs-viewer      # cell-path-read ["docs"]
cask typeof :readme           # blob
cask typeof :archive          # dir
```

`cask ls` should display the type name alongside each entry: `dir`, `blob`, `exec`, `compact`, `exec-compact`, `cell`, `cell-read`, `cell-path`, `cell-path-read`.

## Examples

### Shared photo album with tiered access

```sh
# Alice creates a cell for photos
cask checkin my-photos --to :photos:

# Alice creates a read-only root for Bob
cask mkroot :photos-bob :photos

# Alice creates a read+write root scoped to "vacation" for Carol
cask mkroot :carol :photos:vacation

# Root tree now contains:
#   photos      cell           <cell-id>                 Alice: full control
#   photos-bob  cell-read      <cell-id>                 Bob: read only
#   carol       cell-path      <descriptor: ["vacation"]> Carol: r+w at vacation

# Bob can read anything — TypeCellRead grants read via cell table lookup
cask ls :photos-bob
cask checkout album :photos-bob:vacation:summer

# Bob cannot write — TypeCellRead prevents CAS
cask store --to :photos-bob:vacation:new < photo.jpg
# error: cannot write through read-only cell

# Carol can read and write within vacation
cask ls :carol
cask checkin new-pics --to :carol:summer

# Carol cannot CAS the cell root directly
cask cas :carol OLD NEW
# error: direct CAS not permitted through indirect cell reference
```

### Fine-grained scoped access

```sh
# Alice has a project cell with src/, docs/, and config/
cask checkin my-project --to :project:

# Create a read+write root for the docs team, scoped to docs/
cask mkroot :docs-team :project:docs

# Create a read-only root for everyone
cask mkroot :project-public :project

# The docs team can update documentation
cask checkin new-docs --to :docs-team:api-reference

# Everyone can read
cask ls :project-public
cask checkout docs :project-public:docs
```

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
