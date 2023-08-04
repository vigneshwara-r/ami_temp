import requests

url = "https://awspolicygen.s3.amazonaws.com/js/policies.js"

req = requests.get(url)

if req.status_code in [200]:
    html = req.text
else:
    print 'Could not retrieve: %s, err: %s - status code: %s' % (url, req.text, req.status_code)
    html = None
