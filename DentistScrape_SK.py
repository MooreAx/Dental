import pandas as pd
import requests
from bs4 import BeautifulSoup
import string

names = []
practices = []
addresses = []
phones = []

url0 = "https://members.saskdentists.com/en/dentists-addresses?searchby=1&searchterm="

for letter in string.ascii_lowercase:
	url = url0 + letter


	page = requests.get(url)

	# Parse the HTML content
	soup = BeautifulSoup(page.text, "html.parser")

	# Find all divs with the class "docs-list-box"
	doc_list_boxes = soup.find_all("div", class_= "docs-list-box")

	# Initialize lists to hold the extracted data

	# Iterate over each box and extract the required information
	for box in doc_list_boxes:
	    name = box.find("b").text.strip()
	    names.append(name)
	    
	    info = box.find("p")
	    practice = info.contents[0].text.strip()
	    practices.append(practice)

	    phone = info.find("a").text.strip()
	    phones.append(phone)

	    address = info.decode_contents().replace("<br/>", '/n').strip().split('/n')[1:-1]
	    address = ', '.join(line.strip() for line in address)
	    addresses.append(address)



# Create a DataFrame
df = pd.DataFrame({
   	'Name': names,
    'Practice': practices,
    'Address': addresses,
    'Phone': phones
	})

# Write the DataFrame to a CSV file
df.to_csv('doctors_info_sk.csv', index=False)

# Display the DataFrame
print(df)	