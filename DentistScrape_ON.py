import pandas as pd
import requests
from bs4 import BeautifulSoup
import string

names = []
reg_ids = []
statuses = []
clinic_names = []
links = []

url = "https://www.rcdso.org/find-a-dentist/search-results?Alpha=&City=&MbrSpecialty=&ConstitID=&AlphaParent=&Address1=&PhoneNum=&SedationType=&SedationProviderType=&GroupCode=&DetailsCode="

page = requests.get(url)

# Parse the HTML content
soup = BeautifulSoup(page.text, "html.parser")

# Find all divs with the class "docs-list-box"
searchresults = soup.find("div", id="dentistSearchResults")

for result in searchresults.find_all("section"):

	#print(result.prettify())

	try:
		name = result.h2.a.text.strip()
	except:
		name = None
	names.append(name)

	try:
		reg_id = result.find(string="Registration Number:").parent.next_sibling.next_sibling.text.strip()
	except:
		reg_id = None
	reg_ids.append(reg_id)

	try:
		status = result.find(string="Status:").parent.next_sibling.next_sibling.text.strip()
	except:
		status = None
	statuses.append(status)

	try:
		clinic_name = result.find("span").text.strip()
	except:
		clinic_name = None
	clinic_names.append(clinic_name)

	try:
		link = "https://www.rcdso.org" + result.h2.a["href"]
	except:
		link = None
	links.append(link)


df = pd.DataFrame({
   	'Name': names,
    'RegID': reg_ids,
    'Status': statuses,
    'ClinicName': clinic_names,
    'Link': links
	})



# Write the DataFrame to a CSV file
df.to_csv('doctors_info_on.csv', index=False)

# Display the DataFrame
print(df)	
