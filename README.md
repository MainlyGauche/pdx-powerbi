# vic3-sql

Slurp textformat .v3 saves into SQLite.

## Usage

Ensure `~\Documents\Paradox Interactive\Victoria 3` has

```json
game": {
  "save_file_format":	"text"
}
```

Afterwards, save your game, say to `save.v3`, then from Bash,

```bash
world_db.sh save.v3 world.sqlite
sqlite3 world.sqlite
```

## Dependencies

On Windows,

```bash
winget install rustup
cargo install jomini --features json
winget install jq
winget install miller.miller
winget install sqlite.sqlite
```

## Pipeline

1. **save.v3**: PDX textformat
2. **Jomini**: PDX → JSON
3. **jq**: Flattens and filters game databases
4. **Miller (mlr)**: JSON → CSV
5. **SQLite**: CSV → sqlite
