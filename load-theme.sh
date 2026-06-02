#!/bin/bash

# Load Omarchy theme colors into tmux variables.
# Parsing priority: colors.toml → alacritty.toml → hardcoded defaults (aether).

THEME_DIR="$HOME/.config/omarchy/current/theme"
COLORS_TOML="$THEME_DIR/colors.toml"
ALACRITTY_TOML="$THEME_DIR/alacritty.toml"

# Aether defaults
DEFAULT_BG="#0f191c"
DEFAULT_ACTIVE="#82d967"
DEFAULT_INACTIVE="#227358"

bg_color=""
active_color=""
inactive_color=""

# Try colors.toml first (flat key = "value" format)
if [ -f "$COLORS_TOML" ]; then
    bg_color=$(sed -n 's/^background[[:space:]]*=[[:space:]]*"\(#[^"]*\)".*/\1/p' "$COLORS_TOML" | head -1)
    active_color=$(sed -n 's/^color2[[:space:]]*=[[:space:]]*"\(#[^"]*\)".*/\1/p' "$COLORS_TOML" | head -1)
    inactive_color=$(sed -n 's/^color4[[:space:]]*=[[:space:]]*"\(#[^"]*\)".*/\1/p' "$COLORS_TOML" | head -1)
fi

# Fallback to alacritty.toml (TOML with [colors.*] sections)
if [ -f "$ALACRITTY_TOML" ]; then
    if [ -z "$bg_color" ]; then
        bg_color=$(awk '/^\[colors\.primary\]/{found=1; next} /^\[/{found=0} found && /^background/' "$ALACRITTY_TOML" | sed -n 's/.*=[[:space:]]*"\(#[^"]*\)".*/\1/p' | head -1)
    fi
    if [ -z "$active_color" ]; then
        active_color=$(awk '/^\[colors\.normal\]/{found=1; next} /^\[/{found=0} found && /^green/' "$ALACRITTY_TOML" | sed -n 's/.*=[[:space:]]*"\(#[^"]*\)".*/\1/p' | head -1)
    fi
    if [ -z "$inactive_color" ]; then
        inactive_color=$(awk '/^\[colors\.normal\]/{found=1; next} /^\[/{found=0} found && /^blue/' "$ALACRITTY_TOML" | sed -n 's/.*=[[:space:]]*"\(#[^"]*\)".*/\1/p' | head -1)
    fi
fi

# Final fallback to defaults
bg_color="${bg_color:-$DEFAULT_BG}"
active_color="${active_color:-$DEFAULT_ACTIVE}"
inactive_color="${inactive_color:-$DEFAULT_INACTIVE}"

tmux set-option -gq @bg_color "$bg_color"
tmux set-option -gq @active_color "$active_color"
tmux set-option -gq @inactive_color "$inactive_color"
