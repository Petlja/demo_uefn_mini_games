# Mini games UEFN/VERSE

## Instalacija okruženja za autore

Potrebno je da imate instaliran Python i da je uključen u PATH. 

Instalirajte potrebne dodatne pakete komandom:

```
pip install -r requirements.txt
```

## Bildovanje HTML strana

Koristite komandu:

```
make html
```

Obratite pažnju da li je ispisana neka poruka crvenom bojom i ako jeste ispravite šta treba pa ponovite prethodnu komandu.

Poslednja linija u ispisanim porukama govori gde se nalaze kreirane HTML strane. U datom folderu otvorite index.html iz web browsera.

Ako nakon toga unosite neke promene, ponovite komandu `make html` i osvežite prikaz u brauzeru.

Ne zaboravite da pre početka i na kraju rada na sadržaju sinhronizujete Git repozitorijum.

## Instrukcije za autore

Koristi se Sphinx generator dokumentacije u varijanti sa Markdown sintaksom. To znači da su svi tekstualni sadržaji su u fajlovima sa ekstenzijom `.md`.

Za svaki izvorni Markdown dokument će se na kraju kreirati jedna web strana. Dokumenti su hijerarhijski organizovani. Na vrhu hijerarhije je glavni `index.md`, sledeći u hijerarhiji su `index.md` fajlovi u podfolderima i na kraju su ostali falnovi u podfolderima.

Za više detalja pogledati:

- [Markedly Structured Text](https://myst-parser.readthedocs.io/en/latest/index.html) - Tu je opisano kako se koristi Sphinx sa Markdown-om, mada nisu opisane sve Sphinx komponente
- [Sphinx direktive](https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html), [Sphinx role](https://www.sphinx-doc.org/en/master/usage/restructuredtext/roles.html), [Docutils direktive](https://docutils.sourceforge.io/docs/ref/rst/directives.html) i [Docutils role](https://docutils.sourceforge.io/docs/ref/rst/roles.html) daju detaljnije informacije o osnovnom skupu raspoloživih komponenti, pri čemu se u navedenim dokumentima koristi reStructuredText sintaksa, pa se treba navići kako istu stvar napisati u Markdaun sintaksi. Pošto je Sphinx nadogradnja Docutils-a, u Sphinx dokumentaciji se opisuju samo direktive i role koje je dodao Sphinx, pa treba kombinovati Docutils i Sphinx dokumentaciju.
- [Ekstenzija sphinx-design](https://sphinx-design.readthedocs.io/en/latest/index.html) definiše skup dodatnih komponenti koje koristimo. U dokumentaciji ekstenzije se paralelno prikazuje Markdown i reStructuredText (RST) sintaksa, pa se može uočiti kako se RST prevodi u Markdown. 

Kroz primere iz gore navedene dokumentacije ćete primetiti da i Markdown ima dve varijante sintaksi za direktive: sa višestrukom obrnutim apostrofima i sa višestrukim dvotačkama. Osim retkih izuzetaka, istu stvar možemo da zapišemo i na jedan i na drugi način. 

Mi smo se, za sada, primarno opredelili za sintaksu sa obrnutim apostrofima ali ćemo tu odluku možda promeniti jer je kod takvih izbora najvažnije šta na kraju preovlada i ima bolju podršku alata.




