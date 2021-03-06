require 'spec_helper'
require_relative 'helpers/session'
include SessionHelper

feature "user signs up" do 

	scenario "when signing up" do 
		lambda { sign_up }.should change(User, :count).by(1)    
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")        
  end

  scenario "with a password that doesnt match" do 
    lambda { sign_up('a@a.com', 'pass', 'wrong')}.should change(User, :count).by(0)
    expect(current_path).to eq('/users')   
    expect(page).to have_content("Sorry, your passwords don't match")
  end

  scenario "with an email that is already registered" do    
    lambda { sign_up }.should change(User, :count).by(1)
    lambda { sign_up }.should change(User, :count).by(0)
    expect(page).to have_content("This email is already taken")
  end
end

feature "user signs up with a username" do 

  before(:each) {
    User.create(:id => "2",
                :email => "othertest@test.com",
                :username => "username",
                :password => 'test',
                :password_confirmation => 'test',)
                }

  scenario "with a username that is already registered" do 
    lambda { sign_up }.should change(User, :count).by(1)
    visit 'users/new'
    sign_up 
    expect(page).to have_content("This username is already taken")
  end

end

feature "User signs in" do 

  before(:each) do 
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "with incorrect credentials" do 
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content("Welcome, test@test.com")
  end

   scenario "with correct credentials" do 
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

end

feature "user signs out" do 

  before(:each) do 
    User.create(:email => "test@test.com",
                :password => 'test',
                :password_confirmation => 'test')
  end

  scenario "while being signed in" do 
    sign_in('test@test.com', 'test')
    click_button "Sign out" #methods now extracted into helper module
    expect(page).to have_content("Adios!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end
end







