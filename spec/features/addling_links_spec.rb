require 'spec_helper'
require_relative 'helpers/session'
include SessionHelper

	feature "User adds a new link" do 

    before(:each) do 
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

    scenario "user cannot add links without an account" do 
      visit "/links/new"
      page.should have_css("#screen_messages", :text => "You need to register an account or login .")
    end
    
		scenario "when browsing the homepage" do 
      visit "/sessions/new"
      sign_in('test@test.com', 'test')
			expect(Link.count).to eq(0)
			visit "/links/new" 
			add_link("http://www.makersacademy.com/", 
                "Makers Academy", 
                ['education', 'ruby'])
			expect(Link.count).to eq(1)
			link = Link.first 
			expect(link.url).to eq("http://www.makersacademy.com/")
			expect(link.title).to eq("Makers Academy")
		end

	scenario "with a few tags" do
    visit "/sessions/new"
    sign_in('test@test.com', 'test')
    visit "/links/new"
    add_link("http://www.makersacademy.com/", 
                "Makers Academy", 
                ['education', 'ruby'])    
    link = Link.first
    expect(link.tags.map(&:text)).to include("education")
    expect(link.tags.map(&:text)).to include("ruby")
  end

  scenario "and generates a time tag" do
    visit "/sessions/new"
    sign_in('test@test.com', 'test')
    visit "/links/new"
    add_link("http://www.makersacademy.com/", 
                "Makers Academy", 
                ['education', 'ruby'])    
    link = Link.first   
    expect(link.time.strftime("%T on %d-%m-%Y")).to eq(time_gen)
  end
	
end