import pandas as pd
import requests
from bs4 import BeautifulSoup
import string

names = []
locations = []
cities = []
phones = []
practices = []
permits = []
statuses = []
specialities = []

url = "https://www.cdsab.ca/patients-general-public-protection/dentist-directory/"

page = requests.get(url)

# Parse the HTML content
soup = BeautifulSoup(page.text, "html.parser")

# Find all divs with the class "docs-list-box"
table = soup.find("tbody")

rows = table.find_all("tr")

for row in rows:

	data = row.find_all("td")

	name = data[0].text.strip()
	names.append(name)

	location = data[1].text.strip().replace("\n", ", ")
	locations.append(location)
	print(f"Raw address: {repr(location)}")

	city = data[2].text.strip()
	cities.append(city)

	phone = data[3].text.strip()
	phones.append(phone)

	practice = data[4].text.strip()
	practices.append(practice)

	permit = data[5].text.strip()
	permits.append(permit)

	status = data[6].text.strip()
	statuses.append(status)

	speciality = data[7].text.strip()
	specialities.append(speciality)

	if False:
		for point in data:
			print(point.text.strip())


# Create a DataFrame
df = pd.DataFrame({
   	'Name': names,
    'Location': locations,
    'City': cities,
    'Phone': phones,
    'Practice': practices,
    'Permit': permits,
    'Status': statuses,
    'Specialty': specialities
	})

# Write the DataFrame to a CSV file
df.to_csv('doctors_info_ab.csv', index=False)