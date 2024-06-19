import pandas as pd
import requests
from bs4 import BeautifulSoup
import string

# Load the CSV file into a DataFrame
df = pd.read_csv("doctors_info_on.csv")

members = df[df["Status"] == "Member"]

print(members)

def get_soup(url):

    page = requests.get(url)
    # Parse the HTML content
    soup = BeautifulSoup(page.text, "html.parser")

    return(soup)


names = []
specialties = []
primarypractices = []
addresses = []
links = []

#i=0

# Loop through the values of a specific column
for index, row in members.iterrows():

 #   i += 1
 #   if i > 10:
 #       break

    link = row["Link"]

    soup = get_soup(link)

    try:
        dentistdetails = soup.find("div", id="dentistDetails").header
    except:
        dentistdetails = None

    try:
        name = dentistdetails.h1.text.strip()
    except:
        name = None
    names.append(name)

    try:
        specialty = dentistdetails.find(string = "Specialty:").parent.next_sibling.next_sibling.text.strip()
        print(specialty)
    except:
        specialty = None
    specialties.append(specialty)

    try:
        pp = soup.find("section", id="Practices").find("h3", string="Primary Practice").parent
        primarypractice = pp.h4.text.strip()
    except:
        primarypractice = None
    primarypractices.append(primarypractice)

    try:
        spans = [span.text.strip() for span in pp.address.find_all("span")]
        address = ", ".join(spans)
    except:
        address = None
    addresses.append(address)

    links.append(link)


df = pd.DataFrame({
    'Name': names,
    'Specialty': specialties,
    'PrimaryPractice': primarypractices,
    'PPAddress': addresses,
    'Link': links
    })



# Write the DataFrame to a CSV file
df.to_csv('doctors_info_on_specialties.csv', index=False)

# Display the DataFrame
print(df)   















