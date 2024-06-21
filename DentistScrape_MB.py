import pandas as pd
import requests
from bs4 import BeautifulSoup
import string

names = []
clinics = []
adds1 = []
adds2 = []
phones = []
gradyrs = []
regyrs = []
practices = []
specialities = []

url = "https://www.manitobadentist.ca/public-patients/registries-rosters/dentist-registry"

page = requests.get(url)

# Parse the HTML content
soup = BeautifulSoup(page.text, "html.parser")

results = soup.find("div", id="Results")
rows = results.find_all("div", class_="row")

for row in rows:

	dentist = row.find("div", class_= "dentist-name")

	col1divs = dentist.parent.find_all("div")

	try:
		name = col1divs[0].text.strip()
		names.append(name)
	except:
		names.append(None)

	try:
		clinic = col1divs[1].text.strip()
		clinics.append(clinic)
	except:
		clinics.append(None)

	try:
		add1 = col1divs[2].text.strip()
		adds1.append(add1)
	except:
		adds1.append(None)

	try:
		add2 = col1divs[3].text.strip()
		adds2.append(add2)
	except:
		adds2.append(None)


	col2 = dentist.parent.next_sibling.next_sibling

	#placeholder values
	phone = None
	gradyr = None
	regyr = None

	for text in col2.stripped_strings:
		if "Phone:" in text:
			phone = text.split("Phone:")[1].strip()
		elif "Grad Year:" in text:
			gradyr = text.split("Grad Year:")[1].strip()
		elif "Registration Year:" in text:
			regyr = text.split("Registration Year:")[1].strip()

	phones.append(phone)
	gradyrs.append(gradyr)
	regyrs.append(regyr)
	
	col3 = col2.next_sibling.next_sibling

	try:
		practice = list(col3.stripped_strings)[0]
		practices.append(practice)
	except:
		practices.append(None)

	specialty = None
	for text in col3.stripped_strings:
		if "Specialty:" in text:
			specialty = text.split("Specialty:")[1].strip()
			break

	specialities.append(specialty)


# Create a DataFrame
df = pd.DataFrame({
   	'Name': names,
    'Clinic': clinics,
    'add1': adds1,
    'add2': adds2,
    'Phone': phones,
    'GradYr': gradyrs,
    'RegYr': regyrs,
    'Practice': practices,
    'Specialty': specialities
	})

# Write the DataFrame to a CSV file
df.to_csv('doctors_info_mb.csv', index=False)