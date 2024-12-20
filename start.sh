cd gateway && sh bin/run.sh root/conf.yaml &
. .venv/bin/activate
flask --app ib_rest_api/app run --debug -p 5056 -h 0.0.0.0
