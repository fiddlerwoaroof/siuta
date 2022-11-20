make-docker-image: flake.nix *.asd *.lisp
	docker tag "$(nix build .\#docker)" docker.pkg.github.com/fiddlerwoaroof/siuta/siuta:latest

push-docker-image: make-docker-image
	docker push docker.pkg.github.com/fiddlerwoaroof/siuta/siuta:latest
