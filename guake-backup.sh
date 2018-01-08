#!/bin/sh

gconftool-2 --dump /apps/guake > apps-guake.xml
gconftool-2 --dump /schemas/apps/guake > schemas-apps-guake.xml
