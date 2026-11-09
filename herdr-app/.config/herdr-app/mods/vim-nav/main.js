// ctrl+h/j/k/l across Neovim splits and Herdr panes (port of vim-herdr-navigation).
// keys.json binds them to vim-nav.<left|down|up|right>. Vim/Neovim focused: the key goes
// to it (its own mapping crosses into Herdr at a split edge); otherwise focus moves pane.
// Hosted by a 0px block in layouts/mine.json; draws nothing.

import { View, div } from "gpui-kit";
import { focused, terminals, run, hc, nextCommand } from "herdr";

const VIM = new Set(["nvim", "vim"]);
const KEYS = { left: "ctrl+h", down: "ctrl+j", up: "ctrl+k", right: "ctrl+l" };

function focusedVimTerminal() {
  const address = focused()?.terminal;
  if (!address) return null;
  const terminal = terminals().find((t) => t.address === address);
  if (!terminal || !VIM.has(terminal.program?.key)) return null;
  return address;
}

export default class VimNav extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      for (;;) {
        const direction = await nextCommand();
        await this.navigate(direction);
      }
    });
  }

  async navigate(direction) {
    const key = KEYS[direction];
    if (!key) return;
    const vim = focusedVimTerminal();
    if (!vim) {
      run("pane.go", { direction });
      return;
    }
    try {
      const result = await hc(["keys", vim, key]);
      if (result.code !== 0) console.log(`vim-nav: hc keys ${vim} ${key}: ${result.stderr.trim()}`);
    } catch (error) {
      console.log(`vim-nav: hc keys ${vim} ${key} failed: ${error}`);
    }
  }

  render() {
    return div();
  }
}
