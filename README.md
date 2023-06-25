# vitiral's dotfiles

For keyboard configuration, add the following to `/usr/share/X11/xkb/symbols/us`

You can reload it with `setxkbmap -layout us -variant rett`

```
partial alphanumeric_keys
xkb_symbols "rett" {
    include "us(basic)"
    name[Group1]= "English (US, rett)";

    key <TAB>  { [  Tab,    		Escape, Escape, Escape] };

    // remaped to symbols. The key below is mapped to what "shift" would get

    // Top 2 rows
    key <AD01> { [  q,  Q,              parenleft,     parenleft ] };
    key <AD02> { [  w,  W,              parenright,    parenright ] };
    key <AE03> { [  3,  numbersign,     bracketleft,   braceleft ] };
    key <AD03> { [  e,  E,              braceleft,     braceleft ] };
    key <AE04> { [  4,  dollar,         bracketright,  braceright ] };
    key <AD04> { [  r,  R,              braceright,    braceright ] };

    // Bot 2 rows
    key <AC01> { [  a,  A,  		grave,        asciitilde ] };
    key <AB01> { [  z,  Z,  		asciitilde,   asciitilde ] };
    key <AC02> { [  s,  S,  		backslash,    bar ] };
    key <AB02> { [  x,  X,  		bar,          bar ] };
    key <AC03> { [  d,  D,  		minus,        underscore ] };
    key <AB03> { [  c,  C,  		underscore,   underscore ] };
    key <AC04> { [  f,  F,  		equal,        plus ] };
    key <AB04> { [  v,  V,  		plus,         plus ] };

    key <AC06> { [ h, H, Left] };
    key <AC07> { [ j, J, Down] };
    key <AC08> { [ k, K, Up] };
    key <AC09> { [ l, L, Right] };

    key <SPCE> { [  space,  space ] };

    // These keys are voided out so I need to use the regular ones
    key <AE11> { [ VoidSymbol, VoidSymbol ] }; // minus
    key <AE12> { [ VoidSymbol, VoidSymbol ] }; // equal
    key <AD11> { [ VoidSymbol, VoidSymbol ] }; // open brackets
    key <AD12> { [ VoidSymbol, VoidSymbol ] }; // closed brackets
    key <BKSL> { [ VoidSymbol, VoidSymbol ] }; // backslash

    include "level3(alt_switch)"   // alt cause "level 3" (the third item in key lists)
    include "ctrl(nocaps)"         // CAPS -> Ctrl
    // include "shift(both_capslock)" // Both shifts -> CAPSLOCk
};
```

Then add `XKBVARIANT="rett"` to `/etc/default/keyboard`

Print with

```
setxkbmap -layout us -variant rett -print \
 | xkbcomp - - \
 | xkbprint -ll 2 - - \
 | ps2pdf - > ~/Downloads/keys.pdf
```
