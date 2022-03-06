import sys, requests, os, time, json
from bs4 import BeautifulSoup as bt

try:
  link = sys.argv[1]
except IndexError:
  print("input valid stfly link:")
  exit()

headers = {
'upgrade-insecure-requests': '1',
'sec-fetch-user': '?1',
'user-agent': 'Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaN8-00/012.002; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.0 Mobile Safari/533.4 3gpp-gba',
'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
'referer': 'https://nbyts.online/5-best-tools-to-check-keyword-rankings-on-different-search-engines'
}
rq = requests.get(link, headers=headers)
ap = rq.cookies["AppSession"]
av = rq.cookies["app_visitor"]
cs = rq.cookies["csrfToken"]
s2p = bt(rq.content, 'html.parser')
ex = s2p.find('form')
e1 = ex.select('input')[0].get('value')
e2 = ex.select('input')[1].get('value')
e3 = ex.select('input')[2].get('value')
e4 = ex.select('input')[3].get('value')
e5 = ex.select('input')[4].get('value')

pd = {
         '_method': e1,
      '_csrfToken': e2,
    'ad_form_data': e3,
  '_Token[fields]': e4,
'_Token[unlocked]': e5
}

hd = {
'accept': 'application/json, text/javascript, */*; q=0.01',
'x-requested-with': 'XMLHttpRequest',
'user-agent': 'Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaN8-00/012.002; Profile/MIDP-2.1 Configuration/CLDC-1.1 ) AppleWebKit/533.4 (KHTML, like Gecko) NokiaBrowser/7.3.0 Mobile Safari/533.4 3gpp-gba',
'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
'referer': 'https://stfly.me/BE3h0ND6',
}

ck = {
'AppSession': ap,
'csrfToken': cs,
'app_visitor': av
}
time.sleep(5)
rq1 = requests.post('https://stfly.me/links/go', data=pd, headers=hd, cookies=ck)
jsn = json.loads(rq1.text)
print(jsn['url'])
