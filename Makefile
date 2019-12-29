
LANG=??

ORIG=_ORIG

all: full

# -----

# az összes lenti lépés egyben :)
full: process_conll convert2json jands

full_diff: process_conll_diff convert2json_diff jands_diff

full_new_orig: process_conll_new_orig convert2json_new_orig jands_new_orig

# -----

result_pVCC_diff:
	for i in result/*pVCC ; do diff $$i result_backup/$$(basename $$i) ; done

# -----

# 3. double-cube-jump-and-stay / impl.py
# input: ./json/$(LANG)_$(VERB).test.json
# output: ./result/$(LANG)_$(VERB).test.out3.pVCC
jands:
	@echo
	@echo "3. Run jump and stay method..."
	@echo
	mkdir -p result
	rm -f result/$(LANG)_*out3*
	for V in `ls json/$(LANG)_*.test.json | sed "s/.*\///;s/\.test\.json//"`; do echo "--- $$V" ; ln json/$$V.test.json . ; make -f Makefile.jands VERB=$$V test ; rm -f $$V.test.json ; mv $$V.test.out3* result ; done > jands.out 2> jands.err

jands_diff:
	diffrvi result$(ORIG) result

jands_tkdiff:
	tkdiff result$(ORIG)/de result/de

jands_new_orig:
	rm -rf result$(ORIG)
	cp -rp result result$(ORIG)

# -----

# 2. convert data from "old Mazsola format" to json
# input: ./mazsdb/$(LANG)
# output: ./json/$(LANG)_$(VERB).test.json
convert2json:
	@echo
	@echo "2. Convert to JSON..."
	@echo
	mkdir -p json
	rm -f json/$(LANG)_*.json json/$(LANG)_*.verbs
	for i in mazsdb/$(LANG) ; do echo "--- $$i" ; ./convert2json.sh $$i ; done

convert2json_diff:
	diffrvi json$(ORIG) json

convert2json_tkdiff:
	tkdiff json$(ORIG)/de json/de

convert2json_new_orig:
	rm -rf json$(ORIG)
	cp -rp json json$(ORIG)

# -----

# 1. process conll to sentence skeletons
# input: ./input/$(LANG)
# output: ./mazsdb/$(LANG)
process_conll:
	@echo
	@echo "1. Process CoNLL..."
	@echo
	mkdir -p mazsdb
	rm -f mazsdb/$(LANG)*
	for i in input/$(LANG) ; do echo "--- $$i" ; ./process_conll.sh $$i ; done

process_conll_diff:
	diffrvi mazsdb$(ORIG) mazsdb

process_conll_tkdiff:
	tkdiff mazsdb$(ORIG)/de mazsdb/de

process_conll_new_orig:
	rm -rf mazsdb$(ORIG)
	cp -rp mazsdb mazsdb$(ORIG)

