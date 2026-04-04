render source output="out.stl":
    openscad --backend=manifold -o {{output}} {{source}}

image source output="out.png":
    openscad --backend=manifold --autocenter --viewall --imgsize 1000,800 --render --colorscheme Tomorrow -o {{output}} {{source}}

changes mode="additions" old=".artefacts/old.stl" new=".artefacts/new.stl" outdir=".artefacts":
    openscad --backend=manifold --export-format stl -o {{outdir}}/{{mode}}.stl -D 'mode="{{mode}}"' -D 'old="{{old}}"' -D 'new="{{new}}"' changes.scad
