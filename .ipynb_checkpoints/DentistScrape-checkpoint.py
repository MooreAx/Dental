import pandas as pd
import requests
from bs4 import BeautifulSoup

url = 'https://members.saskdentists.com/en/dentists-addresses?searchby=1&searchterm=A'
page = requests.get(url)

print(page)