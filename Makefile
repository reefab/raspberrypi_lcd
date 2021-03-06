oscad = /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
source = case.scad

all:top_case.stl bottom_case.stl hdmi_plug.stl

top_case.stl: $(source)
	$(oscad) -o $@ -D DRAW_TOP=true -D DRAW_BOTTOM=false $(source)

bottom_case.stl: $(source)
	$(oscad) -o $@ -D DRAW_TOP=false -D DRAW_BOTTOM=true $(source)

hdmi_plug.stl: $(source)
	$(oscad) -o $@ -D DRAW_TOP=false -D DRAW_BOTTOM=false -D DRAW_PLUG=true $(source)
