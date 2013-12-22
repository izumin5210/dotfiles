#!/usr/bin/perl
# %O: options
# %D: destination ﬁle (e.g., the name of the postscript ﬁle when converting a dvi ﬁle to postscript).
# %S: source file (e.g., the name of the dvi ﬁle when converting a dvi ﬁle to ps).
$latex = "platex -synctex=1 -interaction=nonstopmode %O %S";
$bibtex = "pbibtex %O %B";
$dvipdf = "dvipdfmx %O -o %D %S";
$pdf_previewer = "open -a /Applications/TeX/TeXShop.app %S";
$makeindex = "makeindex";
# dvi => pdf
$pdf_mode = 3;
# 0 => update is automatic,
$pdf_update_method = 0;
# Equivalent to the -pv option.
$preview_mode = 1;
$out_dir = "./tmp";
