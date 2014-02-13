web: bundle exec puma -t 8:12 -w 2 -p $PORT -e $RACK_ENV
worker: bundle exec rake qc:work
console: bundle exec irb -r ./environment
