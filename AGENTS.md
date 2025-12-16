# Agent Guidelines

## Build, Lint, & Test
- **Installation**: Run `./install.sh` or specific scripts in `install-scripts/` (e.g., `bash install-scripts/10-rust.sh`).
- **Testing (Dry Run)**: To safely test scripts, set `DRY_RUN=1` (e.g., `DRY_RUN=1 bash install-scripts/99-finalize.sh`).
- **Formatting**: Run `stylua .` to format Lua files. Configuration is in `stylua.toml` (2 spaces, 120 col).
- **Linting**: Ensure shell scripts are executable and have valid shebangs.

## Code Style & Conventions
- **Shell Scripts**:
  - Always source `install-scripts/lib.sh` for utilities.
  - Use `log_info`, `log_success`, `log_error` for output.
  - Use `execute` or `execute_sudo` wrappers for commands to ensure logging and dry-run support.
  - Indentation: 4 spaces.
- **Lua (Neovim)**: Follow `stylua` rules: 2 spaces indent, single quotes preferred.
- **File Structure**:
  - Dotfiles are managed via `stow`. Keep configs in top-level directories (e.g., `nvim/.config/nvim/`).
  - New install steps go into `install-scripts/` with a numbered prefix (e.g., `93-new-tool.sh`).
