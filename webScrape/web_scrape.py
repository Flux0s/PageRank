# Title: web_scrape.py
#
# This program scrapes the web for links when given a starting URL
# it then resursively searches and outputs it's findings in a page 
# rank matrix 
#
# run with: python web_scrape.py 
#
# our page rank matrix uses lower case true and false because that is
# what works in chapel. keep that in mind if using with another program
# that is not chapel


from bs4 import BeautifulSoup, SoupStrainer
import urllib.request
import re
import httplib2
import tldextract

MAX_DOMAINS = 20
w, h = MAX_DOMAINS, MAX_DOMAINS
#initializing n x n matrix with False's
global_matrix = [['false' for x in range(w)] for y in range(h)] 

def scrapeLinks(url, domain_capacity, domain_list, page_list, flag):

    http = httplib2.Http()

    #this try block helps avoid errors that might occur from trying to access secured sites
    try:
        status, response = http.request(url)
    except:
        return page_list

    link_list = []
    #soup is the output from the web scrape of the url 
    soup = BeautifulSoup(response, parse_only=SoupStrainer('a'), features="html.parser")

    #parsing the string
    link = tldextract.extract(url)
    subdomain = link.subdomain
    domain = link.domain
    suffix = link.suffix
    page = domain + '.' + suffix

    #this ignores any duplicate domains 
    if domain not in domain_list:
        
        domain_list.append(domain)
        page_list.append(page)
        link_list.append(page)

    # this loop iterates through the scrape and pulls out the links from the html code
    for link in soup:
        if link.has_attr('href') :
            found_link = link['href']
            #we only want absolute links no relative links 
            if (re.match('^https?://', found_link)):
                
                #parsing the string... we don't want paths just domains
                link = tldextract.extract(found_link)
                subdomain = link.subdomain
                domain = link.domain
                suffix = link.suffix
                page = domain + '.' + suffix
                
                #if the domain has not already been scraped and there is room in the list... scrape
                if (domain not in domain_list and len(domain_list) < domain_capacity):
                    
                    domain_list.append(domain)
                    page_list.append(page)
                    link_list.append(page)

                    #recursive call
                    scrapeLinks(found_link, domain_capacity, domain_list, page_list, 1)
                    
                    #iterate through the found domains
                    for i in range(0, len(domain_list) - 1 ):
                        
                        #check to see if current page is in the list of currently found local links
                        if (page_list[i] in link_list ):

                            for j in range (0, len(domain_list) - 1):
                                #find the page index in the final list of pages
                                if page_list[j] == page:

                                    current_index = j
                                    #set value as true in page rnk matrix 
                                    global_matrix[i][current_index] = 'true'
    
    return page_list

pages = scrapeLinks("https://swe.umbc.edu/~hilli1/cmsc483/link.html", MAX_DOMAINS, [], [], 0)

print ('Congratulations: You have won ', len(pages), 'pages')
print (pages)

#write to file in format for our .cpl program
f = open("link.txt", "w")
for k in range(len(pages)):
    f.write(pages[k] + ' ')
f.write('\n')
for i in range(len(global_matrix) ):
    for j in range(len(global_matrix[i]) ):
        f.write(str(global_matrix[i][j]) + ' ')
    f.write('\n')

f.close()
