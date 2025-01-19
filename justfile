render source output="out.stl":
    openscad --backend=manifold --export-format stl -o {{output}} {{source}}

changes mode="additions" old=".artefacts/old.stl" new=".artefacts/new.stl" outdir=".artefacts":
    openscad --backend=manifold --export-format stl -o {{outdir}}/{{mode}}.stl -D 'mode="{{mode}}"' -D 'old="{{old}}"' -D 'new="{{new}}"' changes.scad
