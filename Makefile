build:
	docker build -t ianks/bitcoin-node .

run:
	docker run -p 8333:8333 ianks/bitcoin-node
