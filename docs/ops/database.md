# Database Setup (DBUI + Oracle)

## Secure Credential Management

Credentials are stored in **macOS Keychain** and exported as environment variables
via direnv. No plaintext passwords in config files.

### 1. Store credentials in Keychain

```sh
# Pattern: <PREFIX>_USER, <PREFIX>_PASS, <PREFIX>_HOST
security add-generic-password -a "$USER" -s "MY_DB_USER" -w "your_username"
security add-generic-password -a "$USER" -s "MY_DB_PASS" -w "your_password"
security add-generic-password -a "$USER" -s "MY_DB_HOST" -w "db.example.com"
```

### 2. Export via direnv (`~/.config/direnv/envrc`)

```sh
if MY_DB_USER_VALUE="$(security find-generic-password -a "$USER" -s "MY_DB_USER" -w 2>/dev/null)"; then
  export MY_DB_USER="$MY_DB_USER_VALUE"
fi
if MY_DB_PASS_VALUE="$(security find-generic-password -a "$USER" -s "MY_DB_PASS" -w 2>/dev/null)"; then
  export MY_DB_PASS="$MY_DB_PASS_VALUE"
fi
if MY_DB_HOST_VALUE="$(security find-generic-password -a "$USER" -s "MY_DB_HOST" -w 2>/dev/null)"; then
  export MY_DB_HOST="$MY_DB_HOST_VALUE"
fi
# Clean up temporary variables
unset MY_DB_USER_VALUE MY_DB_PASS_VALUE MY_DB_HOST_VALUE
```

### 3. Reference in nvim (`lua/plugins/database.lua`)

```lua
vim.g.dbs = {}
local u, p, h = vim.env.MY_DB_USER, vim.env.MY_DB_PASS, vim.env.MY_DB_HOST
if u and p and h then
  table.insert(vim.g.dbs, {
    name = "my_oracle_db",
    url = "oracle://" .. u .. ":" .. p .. "@" .. h .. ":1521/SERVICE_NAME",
  })
end
```

### Adding more connections

Repeat the pattern with a different prefix (e.g. `STAGING_DB_*`, `DEV_DB_*`).
Each gets its own Keychain entries, envrc block, and `table.insert` call.

### Updating or removing credentials

```sh
# Update
security delete-generic-password -a "$USER" -s "MY_DB_PASS"
security add-generic-password -a "$USER" -s "MY_DB_PASS" -w "new_password"

# Remove
security delete-generic-password -a "$USER" -s "MY_DB_USER"
security delete-generic-password -a "$USER" -s "MY_DB_PASS"
security delete-generic-password -a "$USER" -s "MY_DB_HOST"
```

## SQLcl Setup for Better Output

### Why SQLcl over sqlplus

- `SET SQLFORMAT` for table/csv/json/html output
- Better default column alignment
- Oracle 11.2 compatible (use legacy 24.4.4 if latest has issues)

### Adapter configuration

In `database.lua`, the Oracle adapter uses the `sqlcl-legacy` wrapper script,
which handles Java 11+ selection automatically (default `JAVA_HOME` is Java 8):

```lua
-- Wrapper at ~/.config/bin/sqlcl-legacy resolves Java 11+ and legacy binary
vim.g.dbext_default_ORA_bin = vim.fn.expand("~/.config/bin/sqlcl-legacy")
```

**Why a wrapper?** SQLcl requires Java 11+, but the system default is Java 8
(for Gradle/other tools). The wrapper overrides `JAVA_HOME` to Java 11 before
invoking the SQLcl binary, so DBUI works without changing the global Java version.

### Formatting via `login.sql`

SQLcl reads `$SQLPATH/login.sql` on startup. Located at `~/.config/sqlcl/login.sql`:

```sql
SET LINESIZE 200
SET PAGESIZE 50000
SET TRIMSPOOL ON
SET TAB OFF
SET WRAP OFF
SET COLSEP ' | '
SET UNDERLINE '-'
SET NUMWIDTH 15
SET SQLFORMAT ansiconsole
```

### SQLFORMAT options

| Format         | Use case                              |
|----------------|---------------------------------------|
| `ansiconsole`  | Colored aligned table (terminal)      |
| `table`        | Plain aligned table (safe for buffers)|
| `csv`          | Comma-separated                       |
| `json`         | JSON output                           |
| `html`         | HTML table                            |
| `insert`       | INSERT statements                     |

If `ansiconsole` shows escape codes in the DBUI result buffer, switch to `table`.

### Dual-track SQLcl

| Track    | Path                                         | Use case          |
|----------|----------------------------------------------|-------------------|
| Latest   | Homebrew cask (`$SQLCLPATH`)                 | Modern Oracle     |
| Legacy   | `~/.config/sqlcl/legacy/current/` (`$SQLCL_LEGACY_BIN`) | Oracle 11.2 |

## DBUI Quick Reference

| Key          | Action                    |
|--------------|---------------------------|
| `:DBUI`      | Open database UI          |
| `o` / Enter  | Open/expand item          |
| `A`          | Add connection            |
| `d`          | Delete connection         |
| `R`          | Refresh                   |
| `<leader>S`  | Execute query             |
| `<leader>W`  | Save query                |

Saved queries go to `~/workspace/sql/dadbod_queries/`.
