all: build

build: site
	./site build

site: site.hs
	ghc --make site.hs
	./site clean

publish: build
	git add .
	git stash save
	git checkout publish || git checkout --orphan publish
	find . -maxdepth 1 ! -name '.' ! -name '.git*' ! -name '_site' -exec rm -rf {} +
	find _site -maxdepth 1 -exec mv {} . \;
	rmdir _site
	git add -A && git commit -m "Publish" || true
	git push -f git+ssh://git@push.clever-cloud.com/app_a127c404-0d4d-4841-abfa-d73130d056d1.git publish:master
	git checkout master
	git clean -fdx
	git stash pop || true

preview: site
	./site preview -p 9000

clean: site
	./site clean
