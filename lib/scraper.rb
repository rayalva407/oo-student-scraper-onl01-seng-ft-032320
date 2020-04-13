require 'open-uri'
require 'pry'

class Scraper
  
  def self.scrape_index_page(index_url)
    scraped_students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").map do |student|
      hash = {
      :name => student.css("h4.student-name").text,
      :location => student.css("p.student-location").text,
      :profile_url => student.css("a").attribute("href").text
      }
      scraped_students << hash
    end
    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    attributes_hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    
    doc.css(".social-icon-container a").each do |site|
      url = site.attribute("href").text
      attributes_hash[:twitter] = url if url.include? "twitter"
      attributes_hash[:linkedin] = url if url.include? "linkedin"
      attributes_hash[:github] = url if url.include? "github"
      attributes_hash[:blog] = url if url.end_with?(".com/")
    end
    
    attributes_hash[:profile_quote] = doc.css("div.profile-quote").text
    attributes_hash[:bio] = doc.css("div.description-holder p").text
    
    attributes_hash
  end

end

