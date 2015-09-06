require 'rails_helper'

feature 'Admin officials' do

  background do
    @citizen = create(:user, username: "Citizen Kane")
    @official = create(:user, official_position: "Mayor", official_level: 5)
    @admin = create(:administrator)
    login_as(@admin.user)
  end

  scenario 'Index' do
    visit admin_officials_path

    expect(page).to have_content @official.name
    expect(page).to_not have_content @citizen.name
    expect(page).to have_content @official.official_position
    expect(page).to have_content @official.official_level
  end

  scenario 'Edit an official' do
    visit admin_officials_path
    click_link @official.name

    expect(current_path).to eq(edit_admin_official_path(@official))

    expect(page).to_not have_content @citizen.name
    expect(page).to have_content @official.name
    expect(page).to have_content @official.email

    fill_in 'user_official_position', with: 'School Teacher'
    select '3', from: 'user_official_level', exact: false
    click_button 'Update User'

    expect(page).to have_content 'Official position saved!'

    visit admin_officials_path

    expect(page).to have_content @official.name
    expect(page).to have_content 'School Teacher'
    expect(page).to have_content '3'
  end

  scenario 'Create an official' do
    visit admin_officials_path
    fill_in 'name_or_email', with: @citizen.email
    click_button 'Search'

    expect(current_path).to eq(search_admin_officials_path)
    expect(page).to_not have_content @official.name

    click_link @citizen.name

    fill_in 'user_official_position', with: 'Hospital manager'
    select '4', from: 'user_official_level', exact: false
    click_button 'Update User'

    expect(page).to have_content 'Official position saved!'

    visit admin_officials_path

    expect(page).to have_content @official.name
    expect(page).to have_content @citizen.name
    expect(page).to have_content 'Hospital manager'
    expect(page).to have_content '4'
  end

  scenario 'Destroy' do
    visit edit_admin_official_path(@official)

    click_link "Remove 'Official' condition"

    expect(page).to have_content 'User is not an official anymore'
    expect(current_path).to eq(admin_officials_path)
    expect(page).to_not have_content @citizen.name
    expect(page).to_not have_content @official.name
  end
end