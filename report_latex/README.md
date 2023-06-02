# Student thesis skeleton 

This repo contains a sample thesis.
To compile it, try to call  `make` to ``make bib`` to create the bibliography.
The work consists of the main.tex file, which contains basic info like title authors etc.
All chapters are included from `main.tex` and should go in the `src` folder.
Figure sources are to be added to the relevant subfolders of the `support` folder.

### Folders

1. `src` folder contains the text sources corresponding to the chapters or sections of the paper
1. `support` folder contains ##sources## of the figures included in the paper. E.g. `support/dia` contains diagrams, which are automagically converted in eps and then pdf. These are automatically processed and placed in the 
1. `fig` folder, which contains images created from support subfolders. Do not add anything to this folder directly.
1 `submission` folder contains the `pdfs` of the submitted versions, their reviews and revisions.
1. `Mk` folder contains rules which say how the sources in `support` are handled. Do not touch.

### DO NOT

1. Put any text body in the `main.tex` file. All chapters should be in the `src` folder and should be included from the `main.tex`. 
1. Add figures to the `fig` folder. Put the relevant sources to the support folder and let the system handle them.
1. Add binaries in the `support/fig` or `support/dia` subfolders. Only the fig and dia files go there. Binary images go to `support/pic` folder.


