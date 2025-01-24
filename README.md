# Dot Draw on the Gameboy Advance

**Note: the binary does not work well with some emulators, but it does work on real hardware (see extra note below).**

Extra note: Sometimes, it can be a bit finicky with loading it on real hardware, so if the background gives you wrong colors, (on version 1.1) you can modify the binary's bytes at 0xC1 and 0xC3 to be 0xFF or (on any version) change the defined `WHITE` to `%1111111111111111` before compiling.

Assembled with [Goldroad 1.7](https://www.gbadev.org/tools.php?showinfo=192): `goldroad.exe dotdraw.asm`

### Controls:
- D-Pad: move the dot
- A: erase
- B: clear screen

I'm sure there are ways this can be optimized more, but I'm proud of where it is for now.
