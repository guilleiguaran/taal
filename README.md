# Taal
Simple build service on the cloud

## Usage


    curl -X POST -H "Content-Type: application/json" -d '{"build":{"script":"https://gist.github.com/guilleiguaran/8936760/raw/4437b10dc39f6aef52e8d5e75dec4e68f9e032d8/gnugo.sh"}}' http://localhost:9292/builds
