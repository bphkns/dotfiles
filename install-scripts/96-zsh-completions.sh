#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 96: Generating Zsh Completions"

COMP_DIR="$HOME/.local/share/zsh/completions"
ensure_dir "$COMP_DIR"

generate_completion() {
    local name="$1"
    local cmd="$2"
    local output="$COMP_DIR/_$name"

    if command_exists "$name"; then
        log_info "Generating completion for $name..."
        if [ "$DRY_RUN" = "1" ]; then
            log_info "[DRY-RUN] Would run: $cmd > $output"
        else
            if eval "$cmd" > "$output" 2>/dev/null; then
                log_success "Generated _$name"
            else
                log_warning "Failed to generate completion for $name"
                rm -f "$output"
            fi
        fi
    else
        log_info "Skipping $name (not installed)"
    fi
}

generate_completion "fd" "fd --gen-completions zsh"
generate_completion "rg" "rg --generate complete-zsh"
generate_completion "gh" "gh completion -s zsh"
generate_completion "starship" "starship completions zsh"
generate_completion "docker" "docker completion zsh"
generate_completion "bob" "bob complete zsh"
generate_completion "delta" "delta --generate-completion zsh"
generate_completion "bat" "bat --completion zsh"

# Bun - installs to ~/.bun/_bun
if command_exists bun; then
    log_info "Setting up bun completions..."
    if [ "$DRY_RUN" = "1" ]; then
        log_info "[DRY-RUN] Would run: bun completions"
    else
        bun completions > /dev/null 2>&1 && log_success "Bun completions installed to ~/.bun/_bun"
    fi
fi

log_success "Zsh completions generated"
