# CAD projects

A collections of simple projects made with [OpenSCAD](https://openscad.org/).

Projects:

- [jar-lid fly trap](projects/flytrap.scad)
- [aquaponics siphon](projects/siphon.scad)
- some [ShopVac](https://www.printables.com/model/461256-shopvac-50mm-camlock-connectors-with-magnetic-catc) adaptors:
  - [extension (male-male adaptor)](projects/shopvac/extension.scad)
  - [tube adaptor](projects/shopvac/tube_adaptor.scad)
- a [cyclone](projects/shopvac/cyclone/cyclone.scad) to remove dust ahead of a shopvac bac
- an [half-open cable chain](projects/cable-chain/chain.scad), a simple modification on
  [the cable chain project on Printables](https://www.printables.com/model/314922-printable-cable-chain)
  to make it half-open and allow adding it to a plug.

## Dependencies

Some of these projects use the following dependencies:

- [Round-Anything](https://github.com/Irev-Dev/Round-Anything/)
- [BOSL2](https://github.com/BelfrySCAD/BOSL2/)

I personally just `git clone` the relevant project in OpenSCAD's well-known library directory
(`$HOME/Documents/OpenSCAD/libraries` on macOS, `$HOME/.local/share/OpenSCAD/libraries` on Linux)
and call it a day. I checked out the latest release for Round-Anything for good measure.

## Learning OpenSCAD

For all its issues, OpenSCAD is still a powerful tool that is not too hard to use.
There are some good resources out there to help you:

- the [OpenSCAD cheatsheet](https://openscad.org/cheatsheet/) can be very handy, and links
  to the full documentation if need be
- the [CadHub blog](https://learn.cadhub.xyz/docs/definitive-beginners/your-openscad-journey)
  offers a very good introduction
- [Mastering OpenSCAD](https://mastering-openscad.eu/buch/) is an incredibly thourough resource
  for learning to use OpenSCAD the right way through a set of projects of increasing complexity

## Some ready-to-print projects

Some great entries on [Printables](https://www.printables.com):

- [ShopVac](https://www.printables.com/model/461256-shopvac-50mm-camlock-connectors-with-magnetic-catc)
- [Umikot - a planetary gear spirograph for espresso](https://www.printables.com/model/569582-umikot-54mm-version-planetary-gear-spirograph-espr)
- [Cable chain](https://www.printables.com/model/314922-printable-cable-chain)
